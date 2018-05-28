public without sharing class StellaxiusWebCandidateApplController {
	public String firstName {
		get; set;
	}

	public String lastName {
		get; set;
	}

	public String email {
		get; set;
	}

	public String mobilePhone {
		get; set;
	}

	public String comments {
		get; set;
	}
    
    public String cssStyling_fn {
		get; set;
	}
    public String cssStyling_ln {
		get; set;
	}
    public String cssStyling_email {
		get; set;
	}
    public String cssStyling_mphone {
		get; set;
	}
    
    private static Map<String,Website_Table__c> staticContactMap = getContactMap();
    
    public String contactMap {
        get {
            Website_Table__c mapRecord = staticContactMap.get('map');
            
            if (mapRecord != null) {
                return mapRecord.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactAddress {
        get {
            Website_Table__c address = staticContactMap.get('address');
            
            if (address != null) {
                return address.Description__c;
            } else {
                return null;
            }
        }
    }
    
     public String contactEmail {
        get {
            Website_Table__c email = staticContactMap.get('email');
            
            if (email != null) {
                return email.Description__c;
            } else {
                return null;
            }
        }
    }
    
    public String contactPhone {
        get {
            Website_Table__c phone = staticContactMap.get('phone');
            
            if (phone != null) {
                return phone.Description__c;
            } else {
                return null;
            }
        }
    }
    
      @TestVisible private static Map<String,Website_Table__c> getContactMap() {
        Map<String,Website_Table__c> resultMap = new Map<String,Website_Table__c>();
        
        List<Website_Table__c> contactRecords = getTableRecords('Contact');
        
        for (Website_Table__c contact : contactRecords) {
            resultMap.put(contact.Value__c, contact);
        }
        
        return resultMap;
    }
    
     
    @TestVisible private static List<Website_Table__c> getTableRecords(String tableName) {
        return [
            SELECT
            Id,
            Name,
            Table__c,
            Display_Order__c,
            Value__c,
            Description__c,
            Icon_Class__c
            FROM
            Website_Table__c
            WHERE
            Table__c = :tableName
            ORDER BY
            Display_Order__c
        ];
    }
    
    
    
	public Attachment leadAttachment {
		get {
			if (leadAttachment == null) {
				leadAttachment = new Attachment();
			}

			return leadAttachment;
		}

		set;
	}

	public Job__c job {
		get {
			Job__c job = null;

			if (refJobId != null) {
				job = StellaxiusSiteController.getJobByReference(refJobId);
			}

			return job;
		}

		set;
	}

	public String jobJSON {
		get {
			String job = null;

			if (refJobId != null) {
				job = StellaxiusSiteController.getJobByReferenceJSON(refJobId);
			}

			return job;
		}

		set;
	}

/** obtain retURL from QueryParams **/
	public String retURL {
		get {
			return ApexPages.currentPage().getParameters().get('retURL');
		}
		set;
	}

	public String leadSource = 'Website';
	public String leadType = 'Candidate Application';
	public String leadCompany = 'Stellaxius RH';
	public String leadAttachmentDescription = 'Uploaded CV';
	public String refJobId;
	
	public StellaxiusWebCandidateApplController() {
		refJobId = ApexPages.currentPage().getParameters().get('ref');
        cssStyling_fn = 'form-control';
        cssStyling_ln = 'form-control';
        cssStyling_email = 'form-control';
        cssStyling_mphone = 'form-control';
	}

	public PageReference upload() {
		Id leadId = null;

		System.debug(
			'FirstName=' + firstName + ', LastName=' + lastName + ', Email=' + email + ', MobilePhone=' + mobilePhone + ', LeadSource=' + leadSource + ', LeadType=' + leadType + ', Company=' + leadCompany + ', Comments=' + comments
		);
        
        if(String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email) || String.isBlank(mobilePhone)){
            if(String.isBlank(firstName)){
               cssStyling_fn = 'form-control form-control_Req';
            }else{
              cssStyling_fn = 'form-control';
             }
             if(String.isBlank(lastName)){
               cssStyling_ln = 'form-control form-control_Req';
            }else{
              cssStyling_ln = 'form-control';
            }
            if(String.isBlank(email)){
               cssStyling_email = 'form-control form-control_Req';
            }else{
              cssStyling_email = 'form-control';
            }
            if(String.isBlank(mobilePhone)){
               cssStyling_mphone = 'form-control form-control_Req';
            }else{
              cssStyling_mphone = 'form-control';
            }
            ApexPages.addMessage(
				new ApexPages.message(
					ApexPages.Severity.ERROR,
					'Please fill in all required fields'
				));
                return null;
          
        }else{
            
        

		Site_Candidate_Lead__c lead = new Site_Candidate_Lead__c(
			FirstName__c 		= firstName,
			LastName__c 		= lastName,
			Email__c 			= email,
			MobilePhone__c 		= mobilePhone,
			LeadSource__c 		= leadSource,
			LeadType__c 		= leadType,
			Company__c 			= leadCompany,
			Job_Reference__c	= refJobId,
			Comments__c			= comments
		);

		Boolean candidateApplicationCreated = false;

		Savepoint uploadSavepoint = Database.setSavepoint();

		try {
			insert lead;

			leadId = lead.Id;

			leadAttachment.Description = leadAttachmentDescription;
			leadAttachment.ParentId = leadId;
			leadAttachment.IsPrivate = true;
			leadAttachment.OwnerId = UserInfo.getUserId();

			insert leadAttachment;

			candidateApplicationCreated = true;
		} catch (DMLException e) {
			Database.rollback(uploadSavepoint);

			ApexPages.addMessage(
				new ApexPages.message(
					ApexPages.Severity.ERROR,
					'Error uploading candidate form.'
				)
			);

/*
			Integer numErrors = e.getNumDml();

			ApexPages.addMessage(
				new ApexPages.message(
					ApexPages.Severity.ERROR,
					'Error uploading candidate form. ' +
					'Message: ' + e.getMessage() +
					', Cause: ' + e.getCause() +
					', LineNumber: ' + e.getLineNumber() +
					', StackTrace: ' + e.getStackTraceString()
				)
			);

			for (Integer i = 0; i < numErrors; i++) {
				ApexPages.addMessage(
					new ApexPages.message(
						ApexPages.Severity.ERROR,
						'Error: ' + i + 
						', FieldNames: ' + e.getDmlFieldNames(i) + 
						', Message: ' + e.getDmlMessage(i) +
						', Id: ' + e.getDmlId(i)
					)
				);
			}
*/
		} finally {
			leadAttachment = new Attachment();
		}

		if (candidateApplicationCreated == true) {
			return new PageReference('javascript:alert(\'Thank you for submiting your application. We will come back to you shortly!\');window.location = \'' + siteBase + '\';');
		} else {
			return null;
		}
        }
	}

	/**
		Is this site in Production ?

	**/
	public Boolean isProduction {
		get {
			Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];

			return (org.isSandbox == false);
		}
	}

	/**
		The Site Prefix.

	*/
	public String siteBase {
		get {
			return StellaxiusSiteController.getSiteBase();
		}
	}

	/**

		Get the Site Prefix from current page URL.

	**/
	public static String getSiteBase() {
		return Site.getBaseUrl();
	}
}