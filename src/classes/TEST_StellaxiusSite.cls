@isTest
global class TEST_StellaxiusSite {
	@isTest static void testSiteController() {
		setupReferenceData();

		StellaxiusSiteController controller = new StellaxiusSiteController();

		List<Website_Table__c> tableList = StellaxiusSiteController.getTableRecords('any');
		Map<String,Website_Table__c> tableMap = StellaxiusSiteController.getContactMap();
		List<Job__c> jobList = StellaxiusSiteController.getJobRecords();
		String str = controller.ourMissionJSON;
		Job__c job = StellaxiusSiteController.getJobByReference('JOB/000X');

		tableList = controller.ourMission;
		tableList = controller.ourValues;

		str = controller.ourValuesJSON;
		tableList = controller.services;
		str = controller.contactHeader;
		str = controller.contactEmail;
		str = controller.contactPhone;
		str = controller.contactAddress;
		str = controller.contactMap;
		jobList = controller.jobs;

		str = StellaxiusSiteController.getJobByReferenceJSON('JOB/000X');
	}

	@isTest static void testTeamComponentController() {
		setupReferenceData();

		StellaxiusTeamComponentController controller = new StellaxiusTeamComponentController();

		List<Employee__c> employeeList = controller.publishedTeamMembers;
	}

	@isTest static void testTestimonialComponentController() {
		setupReferenceData();

		StellaxiusTestimonialComponentController controller = new StellaxiusTestimonialComponentController();

		List<Testimonial__c> testimonialList = controller.publishedTestimonials;
	}

	@isTest static void testWebCandidateApplController() {
		setupReferenceData();

		StellaxiusWebCandidateApplController controller = new StellaxiusWebCandidateApplController();

		String str = controller.firstName;
		str = controller.lastName;
		str = controller.email;
		str = controller.mobilePhone;
		Attachment attachment = controller.leadAttachment;
		Job__c job = controller.job;
		str = controller.jobJSON;
		str = controller.retURL;
		PageReference pageReference = controller.upload();
	}

	@isTest static void testImportSiteCandidatesBatch() {
		setupReferenceData();

		ImportSiteCandidatesBatch zbatch = new ImportSiteCandidatesBatch();

		Site_Candidate_Lead__c candidateLead = new Site_Candidate_Lead__c(
			FirstName__c = 'First',
			LastName__c = 'Last',
			Email__c = 'abc@def.com',
			MobilePhone__c = '+351210000001',
			LeadSource__c = 'Website',
			LeadType__c = 'Candidate Application',
			Company__c = 'Stellaxius RH'
		);

		insert candidateLead;

		ImportSiteCandidatesBatch.runOnce();

		//ImportSiteCandidatesBatch.defaultSchedule();

		Lead zlead = zbatch.getLead(candidateLead);

		insert zlead;

		ImportSiteCandidatesBatch.sendTemplateEmail(
			new String[] { 'a.santos@gmail.com' },
			new String[] { },
			'Job_Submission_Received',
			zlead.Id,
			null,
			null
		);

		zbatch.execute(null, new List<Site_Candidate_Lead__c> { candidateLead });
	}

	private static void setupReferenceData() {
		List<Website_Table__c> tableList = new List<Website_Table__c>();
		List<Employee__c> employeeList = new List<Employee__c>();
		List<Job__c> jobList = new List<Job__c>();

		tableList.add(
			new Website_Table__c(
				Table__c = 'Services',
				Display_Order__c = 1,
				Value__c = 'Test',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Values',
				Display_Order__c = 1,
				Value__c = 'Test',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Mission',
				Display_Order__c = 1,
				Value__c = 'Test',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Contact',
				Display_Order__c = 1,
				Value__c = 'header',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Contact',
				Display_Order__c = 2,
				Value__c = 'email',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Contact',
				Display_Order__c = 3,
				Value__c = 'phone',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Contact',
				Display_Order__c = 4,
				Value__c = 'address',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		tableList.add(
			new Website_Table__c(
				Table__c = 'Contact',
				Display_Order__c = 5,
				Value__c = 'map',
				Description__c = 'Test',
				Icon_Class__c = 'xpto'
			)
		);

		insert tableList;

		/*
		employeeList.add(
			new Employee__c (
				
			)
		);

		insert employeeList;
		*/

		jobList.add(
			new Job__c(
				Job_Title__c = 'General Application',
				Icon_Class__c = 'xpto',
				Sort_Order__c = 1,
				Is_Active__c = true,
				Job_Position__c = 'Sample Job Position',
				Job_Specification__c = 'Sample Job Specification'
			)
		);

		jobList.add(
			new Job__c(
				Custom_Job_Title__c = 'Sample Custom Job Title',
				Icon_Class__c = 'xpto',
				Sort_Order__c = 1,
				Is_Active__c = true,
				Job_Position__c = 'Sample Job Position',
				Job_Specification__c = 'Sample Job Specification'
			)
		);

		insert jobList;

	}
}