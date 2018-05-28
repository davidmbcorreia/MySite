global class ImportSiteCandidatesBatch implements Schedulable, Database.Batchable<sObject> {
	public static final Integer DEFAULT_BATCH_SIZE = 50;

	private static Integer batchSize;
	private static Id candidateQueueId = getQueueId();

	global String query;

	// Map from Job Reference to Job ID
	global Map<String,Id> relatedJobMap = new Map<String,Id>();

	public ImportSiteCandidatesBatch() {
		runOnce();
	}

	public ImportSiteCandidatesBatch(String query) {
		this.query = query;
	}

	global void execute(SchedulableContext schedulableContext) {
		runOnce();
	}

	private static String getBatchQuery() {
		String query = 'SELECT Id, FirstName__c, LastName__c, Email__c, MobilePhone__c, LeadSource__c, LeadType__c, Company__c, Job_Reference__c, Comments__c FROM Site_Candidate_Lead__c WHERE IsImported__c = FALSE';

		System.debug('Query: ' + query);

		return query;
	}

	public static void runOnce() {
		batchSize = DEFAULT_BATCH_SIZE;

		ImportSiteCandidatesBatch batch = new ImportSiteCandidatesBatch(getBatchQuery());

		Database.executeBatch(batch, batchSize);
	}
	
	global Database.QueryLocator start(Database.BatchableContext batchableContext) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext batchableContext, Site_Candidate_Lead__c[] candidateLeadList) {
		List<Lead> insertLeadList = new List<Lead>();
		List<Site_Candidate_Lead__c> updateCandidateLeadList = new List<Site_Candidate_Lead__c>();
		Set<Id> siteCandidateLeadIdSet = new Set<Id>();
		List<Attachment> attachmentList = new List<Attachment>();
		Map<Id,Id> leadIdMap = new Map<Id,Id>();
		Integer counter = 0;
		List<Attachment> insertAttachmentList = new List<Attachment>();

		if (candidateLeadList != null && candidateLeadList.size() > 0) {
			Set<String> jobReferenceSet = new Set<String>();

			for (Site_Candidate_Lead__c candidateLead : candidateLeadList) {
				if (candidateLead.Job_Reference__c != null) {
					jobReferenceSet.add(candidateLead.Job_Reference__c);
				}
			}

			for (Job__c job : [SELECT Id, Name FROM Job__c WHERE Name IN :jobReferenceSet]) {
				relatedJobMap.put(job.Name, job.Id);

				System.debug('Job Reference: ' + job.Name + ', JobId: ' + job.Id);
			}

			for (Site_Candidate_Lead__c candidateLead : candidateLeadList) {
				insertLeadList.add(getLead(candidateLead));

				candidateLead.IsImported__c = TRUE;

				updateCandidateLeadList.add(candidateLead);

				siteCandidateLeadIdSet.add(candidateLead.Id);
			}
		}

		if (insertLeadList.isEmpty() == false) {
			Database.insert(insertLeadList, false);

			counter = 0;
			for (Lead insertLead : insertLeadList) {
				Site_Candidate_Lead__c candidateLead = candidateLeadList[counter];

				leadIdMap.put(candidateLead.Id, insertLead.Id);

				counter++;
			}
		}

		if (updateCandidateLeadList.isEmpty() == false) {
			update updateCandidateLeadList;
		}

		if (siteCandidateLeadIdSet.isEmpty() == false) {
			Id siteCandidateId;
			Id leadId;

			attachmentList = [
				SELECT
					Id,
					ParentId,
					SystemModstamp,
					OwnerId,
					Name,
					LastModifiedDate,
					LastModifiedById,
					IsPrivate,
					IsDeleted,
					Description,
					CreatedDate,
					CreatedById,
					ContentType,
					BodyLength,
					Body
				FROM
					Attachment
				WHERE
					ParentId IN :siteCandidateLeadIdSet
			];

			for (Attachment attachment : attachmentList) {
				Attachment clonedAttachment;

				siteCandidateId = attachment.ParentId;
				leadId = leadIdMap.get(siteCandidateId);

				if (leadId != null) {
					clonedAttachment = attachment.clone(false, false);
					clonedAttachment.ParentId = leadId;

					insertAttachmentList.add(clonedAttachment);
				}
			}
		}

		if (insertAttachmentList.isEmpty() == false) {
			Database.insert(insertAttachmentList, false);
		}

		if (insertLeadList.isEmpty() == false) {
			Id orgWideEmailId = getOrgWideEmailAddressForContactEmail();
			List<String> queueEmailList = getQueueMembersEmailList();
			String[] emailArray;
			
			if (queueEmailList != null && ! queueEmailList.isEmpty()) {
				integer emailIndex = -1;
				emailArray = new String[queueEmailList.size()];

				for (String queueEmail : queueEmailList) {
					emailIndex++;

					emailarray[emailIndex] = queueEmail;
				}
			}
			
            List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
			for (Lead existingLead : insertLeadList) {
				System.debug('Sending email to ' + existingLead.Email + ' for Lead with Id: ' + existingLead.Id);

				try {
					if (orgWideEmailId != null) {
						sendTemplateEmail(
							new String[] { existingLead.Email },
							new String[] { },
							'Job_Submission_Received',
							existingLead.Id,
							null,
							orgWideEmailId
						);
					}
				} catch (Exception e) {
					// Ignore exceptions
					System.debug('Error sending email: ' + e.getMessage());
				}

				System.debug('Sending queue email for existing Lead with Id: ' + existingLead.Id);

				try {
					if (orgWideEmailId != null) {
						sendTemplateEmail(
							emailArray,
							new String[] { },
							'New_Job_Submission_Received',
							existingLead.Id,
							null,
							orgWideEmailId
						);
					}
				} catch (Exception e) {
					// Ignore exceptions
					System.debug('Error sending email: ' + e.getMessage());
				}
			}

			/*
			Database.DMLOptions dmo = new Database.DMLOptions();

			dmo.assignmentRuleHeader.useDefaultRule = true;

			update insertLeadList;
			*/
		}
	}

	@TestVisible private Lead getLead(Site_Candidate_Lead__c candidateLead) {
		Lead lead = new Lead(
            FirstName       = candidateLead.FirstName__c,
            LastName        = candidateLead.LastName__c,
            Email           = candidateLead.Email__c,
            MobilePhone     = candidateLead.MobilePhone__c,
            LeadSource      = candidateLead.LeadSource__c,
            Lead_Type__c    = candidateLead.LeadType__c,
            Company         = candidateLead.Company__c,
			Related_Job__c	= relatedJobMap.get(candidateLead.Job_Reference__c),
			Description		= candidateLead.Comments__c,
			OwnerId			= candidateQueueId
		);

		//lead.setOptions(dmo);

		return lead;
	}

	global void finish(Database.BatchableContext batchableContext) {
		
	}

	public static void defaultSchedule() {
		// Every hour
		//String scheduleTimeString = '0 0 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * ?';
		//System.schedule('ImportSiteCandidatesBatch every Hour', scheduleTimeString, new ImportSiteCandidatesBatch());

		// Every 5 min
		System.schedule('ImportSiteCandidatesBatch *:00', '0 00 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:05', '0 05 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:10', '0 10 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:15', '0 15 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:20', '0 20 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:25', '0 25 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:30', '0 30 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:35', '0 35 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:40', '0 40 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:45', '0 45 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:50', '0 50 * * * ?', new ImportSiteCandidatesBatch());
		System.schedule('ImportSiteCandidatesBatch *:55', '0 55 * * * ?', new ImportSiteCandidatesBatch());
	}

	public static void sendTemplateEmail(
		String[] toRecipients,
		String[] ccRecipients,
		String templateDeveloperName,
		Id targetObjectId,
		Id whatId,
		Id orgWideEmailId
	) {
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		Id templateId;
		
		if (orgWideEmailId != null) {
			templateId = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName=:templateDeveloperName].Id;

			email.setToAddresses(toRecipients);
			email.setCcAddresses(ccRecipients);
			email.setTargetObjectId(targetObjectId);
			email.setWhatId(whatId);
			email.setOrgWideEmailAddressId(orgWideEmailId);
			email.setTemplateId(templateId);
			email.setSaveAsActivity(false);

			Messaging.sendEmail(
				new Messaging.SingleEmailMessage[] {
					email
				}
			);
		}
	}

	public static Id getOrgWideEmailAddressForContactEmail() {
		Website_Table__c contactEmailDescription = [SELECT Id, Table__c, Value__c, Description__c FROM Website_Table__c WHERE Table__c = 'Contact' AND Value__c = 'email' LIMIT 1];
		String contactEmail = contactEmailDescription.Description__c;
		OrgWideEmailAddress emailAddress;

		for (OrgWideEmailAddress addr : [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :contactEmail]) {
			emailAddress = addr;
		}
		
		if (emailAddress != null) {
			return emailAddress.Id;
		} else {
			return null;
		}
	}

	public static Id getQueueId() {
		QueueSObject queueSObject = [SELECT Id, SObjectType, Queue.Id, Queue.Name FROM QueueSObject WHERE Queue.Name='Candidate Application Queue' LIMIT 1];
		Id queueId = queueSObject.Queue.Id;

		return queueId;
	}

	public static List<String> getQueueMembersEmailList() {
		List<String> emailList = new List<String>();
		Group queueGroup = [SELECT Id FROM Group WHERE Type='Queue' AND Name = 'Candidate Application Queue' LIMIT 1];
		List<GroupMember> queueGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :queueGroup.Id];
		List<User> queueGroupMemberUsers;
		Set<Id> queueGroupMemberSet = new Set<Id>();

		for (GroupMember member : queueGroupMembers) {
			queueGroupMemberSet.add(member.UserOrGroupId);
		}

		queueGroupMemberUsers = [SELECT Id, Email FROM User WHERE Id IN :queueGroupMemberSet];

		for (User user : queueGroupMemberUsers) {
			emailList.add(user.Email);
		}

		return emailList;
	}
}