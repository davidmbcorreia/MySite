@isTest
private class LRN_Test {
	@isTest static void testSplitCsvSimple(){
		String line = 'abc,efg'; 
		String[] splitted = new LRN_Utils(line).readLine();
		System.assertEquals(2, splitted.size()); 

		System.assertEquals('efg', splitted[1]);
		System.assertEquals('abc', splitted[0]);
	}

	@isTest static void testSplitCsvEOL(){
		String line = 'abc,';
		String[] splitted = new LRN_Utils(line,',').readLine();
		System.assertEquals(2, splitted.size()); 

		System.assertEquals('', splitted[1]);
		System.assertEquals('abc', splitted[0]);
	}

	@isTest static void testSplitCsvQuotedSimple(){
		String line = '"abc,def"';
		String[] splitted = new LRN_Utils(line).readLine();
		System.assertEquals('abc,def', splitted[0]);
	}

	@isTest static void testSplitCsvQuoted(){
		String line = '"abc,def",gh"i,"jk""l",""';
		String[] splitted = new LRN_Utils(line).readLine();
		System.assertEquals(4, splitted.size()); 
		
		System.assertEquals('gh"i', splitted[1]);
		System.assertEquals('abc,def', splitted[0]);
		System.assertEquals('jk"l', splitted[2]);
		System.assertEquals('', splitted[3]);       
	}
	
	@isTest static void testSplitCsvQuotedWithNewLine(){
		String line = '"abc,def\nBoo\nBoo",Test';
		LRN_Utils reader = new LRN_Utils(line);
		String[] splitted = reader.readLine();
		System.assertEquals('abc,def\nBoo\nBoo', splitted[0]);
		System.assertEquals('Test', splitted[1]);
		System.assertEquals(null, reader.readLine());
	}
	
	@isTest static void testSplitCsvQuotedWithEOT(){
		String line = '"abc,def\nBoo';
		LRN_Utils reader = new LRN_Utils(line);
		String[] splitted = reader.readLine();
		System.assertEquals('abc,def\nBoo', splitted[0]);       
		System.assertEquals(null, reader.readLine());       
	}

	@isTest static void testTabDelim(){
		String line = 'abc\tdef';
		LRN_Utils reader = new LRN_Utils(line, '\t');
		String[] splitted = reader.readLine();
		System.assertEquals('abc', splitted[0]);
	}

	@isTest static void testEmptyStrings(){
		String line = ',,,,';
		LRN_Utils reader = new LRN_Utils(line);
		String[] splitted = reader.readLine();
		System.assertEquals(5, splitted.size());
		for(String s: splitted){
			System.assertEquals('', s);
		}
	}

	@isTest static void testEmptyString(){
		String line = '';
		LRN_Utils reader = new LRN_Utils(line);
		String[] splitted = reader.readLine();
		System.assertEquals(1, splitted.size());
		System.assertEquals('', splitted[0]);
	}

	@isTest static void test_createExam_1() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id,
																		   Percent_of_Area_Questions__c = 100 );
		upsert aTempl;

		List<LRN_Exam_Detail_Template__c> lstQTemplates = new List<LRN_Exam_Detail_Template__c>();

		LRN_Exam_Detail_Template__c dTemplQ1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Easy',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ1 );

		LRN_Exam_Detail_Template__c dTemplQ2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Medium',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ2 );

		LRN_Exam_Detail_Template__c dTemplQ3 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Hard',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ3 );
		upsert lstQTemplates;

		List<LRN_Exam_Detail_Template__c> lstATemplates = new List<LRN_Exam_Detail_Template__c>();

		LRN_Exam_Detail_Template__c dTemplA1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ1.Id,
																				Dificult__c = 'Easy',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA1 );

		LRN_Exam_Detail_Template__c dTemplA2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ2.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA2 );

		LRN_Exam_Detail_Template__c dTemplA3 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ3.Id,
																				Dificult__c = 'Hard',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA3 );
		upsert lstATemplates;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.examSize = '100';

		PageReference pageRef = obj.createExam();
		System.assertNotEquals( null, obj.idExam ); 
	}

	@isTest static void test_createExam_2() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = false,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id,
																		   Percent_of_Area_Questions__c = 100 );
		upsert aTempl;

		List<LRN_Exam_Detail_Template__c> lstQTemplates = new List<LRN_Exam_Detail_Template__c>();

		LRN_Exam_Detail_Template__c dTemplQ1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Easy',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ1 );

		LRN_Exam_Detail_Template__c dTemplQ2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Medium',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ2 );

		LRN_Exam_Detail_Template__c dTemplQ3 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				 Dificult__c = 'Hard',
																				 Question_Answer__c = 'q' );
		lstQTemplates.add( dTemplQ3 );
		upsert lstQTemplates;

		List<LRN_Exam_Detail_Template__c> lstATemplates = new List<LRN_Exam_Detail_Template__c>();

		LRN_Exam_Detail_Template__c dTemplA1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ1.Id,
																				Dificult__c = 'Easy',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA1 );

		LRN_Exam_Detail_Template__c dTemplA2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ2.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA2 );

		LRN_Exam_Detail_Template__c dTemplA3 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtemplQ3.Id,
																				Dificult__c = 'Hard',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		lstATemplates.add( dTemplA3 );
		upsert lstATemplates;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.examSize = '100';

		PageReference pageRef = obj.createExam();
		System.assertNotEquals( null, obj.idExam ); 
	}

	@isTest static void test_showExameTemplate() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idTemplate = eTempl.Id;

		//test method
		PageReference pageRef = obj.showExameTemplate();
		System.assertEquals( true, obj.showViewTemplatePanel );
		System.assertEquals( false, obj.showExamTemplateTablePanel );
		System.assertNotEquals( null, obj.currExamTemplate );
		System.assertEquals( 'testTemplate', obj.currExamTemplate.Name ); 
	}

	@isTest static void test_editExameTemplate_1() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idTemplate = eTempl.Id;

		PageReference pageRef = obj.editExameTemplate();
		System.assertEquals( false, obj.isEditTemplate );
		System.assertEquals( false, obj.isEditAreaTemplate );
		System.assertEquals( false, obj.isAddAreaTemplate );
		System.assertEquals( 1, obj.lstTemplateAreas.size() ); 
	}

	@isTest static void test_editExameTemplate_2() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.editExameTemplate();
		System.assertEquals( true, obj.isEditTemplate );
		System.assertEquals( false, obj.isEditAreaTemplate );
		System.assertEquals( false, obj.isAddAreaTemplate );
		System.assertEquals( true, obj.showEditTemplatePanel );
		System.assertEquals( false, obj.showExamTemplateTablePanel );
	}

	@isTest static void test_cancelExameTemplate_1() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idTemplate = eTempl.Id;

		//test method
		PageReference pageRef = obj.cancelExameTemplate();
		System.assertEquals( false, obj.isEditTemplate );
		System.assertEquals( false, obj.isEditAreaTemplate );
		System.assertEquals( false, obj.isAddAreaTemplate );
	}

	@isTest static void test_cancelExameTemplate_2() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.cancelExameTemplate();
		System.assertEquals( false, obj.isEditTemplate );
		System.assertEquals( false, obj.isEditAreaTemplate );
		System.assertEquals( false, obj.isAddAreaTemplate );
		System.assertEquals( true, obj.showExamTemplateTablePanel );
		System.assertEquals( false, obj.showEditTemplatePanel );
	}

	@isTest static void test_saveExameTemplate() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;

		//test method
		PageReference pageRef = obj.saveExameTemplate();
		System.assertEquals( 'testTemplate', obj.currExamTemplate.Name ); 
	}

	@isTest static void test_saveExameTemplateAreas_1() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																			LRN_Exam_Template__c = eTempl.Id );

		List<LRN_Exam_Area_Template__c> lstTemplateAreas1 = new List<LRN_Exam_Area_Template__c>();
		lstTemplateAreas1.add( aTempl );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.lstTemplateAreas = lstTemplateAreas1;
		obj.currExamTemplate = eTempl;
		obj.idTemplate = eTempl.Id;

		//test method
		PageReference pageRef = obj.saveExameTemplateAreas();

		System.assertEquals( true, obj.showEditTemplatePanel ); 
		System.assertEquals( false, obj.showExamTemplateTablePanel ); 
		System.assertEquals( false, obj.isEditTemplate ); 
		System.assertEquals( false, obj.isEditAreaTemplate ); 
		System.assertEquals( false, obj.isAddAreaTemplate ); 
	}

	@isTest static void test_saveExameTemplateAreas_2() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																			LRN_Exam_Template__c = eTempl.Id );

		List<LRN_Exam_Area_Template__c> lstTemplateAreas1 = new List<LRN_Exam_Area_Template__c>();
		lstTemplateAreas1.add( aTempl );

		upsert aTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.lstTemplateAreas = lstTemplateAreas1;
		obj.currExamTemplate = eTempl;
		obj.idTemplate = eTempl.Id;

		//test method
		PageReference pageRef = obj.saveExameTemplateAreas();

		System.assertEquals( true, obj.showEditTemplatePanel ); 
		System.assertEquals( false, obj.showExamTemplateTablePanel ); 
		System.assertEquals( false, obj.isEditTemplate ); 
		System.assertEquals( false, obj.isEditAreaTemplate ); 
		System.assertEquals( false, obj.isAddAreaTemplate ); 
	}

	@isTest static void test_editTemplate() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.editTemplate();
		System.assertEquals( true, obj.isEditTemplate );
	}

	@isTest static void test_editAreaTemplate() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.editAreaTemplate();
		System.assertEquals( true, obj.isEditAreaTemplate );
	}

	@isTest static void test_addExameTemplateArea() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.addExameTemplateArea();
		System.assertEquals( true, obj.isAddAreaTemplate );
	}

	@isTest static void test_backTemplateList() {
		LRN_Page_Controller obj = new LRN_Page_Controller();
		PageReference pageRef = obj.backTemplateList();
		System.assertEquals( null, obj.idTemplate );
		System.assertEquals( true, obj.showExamTemplateTablePanel );
		System.assertEquals( false, obj.showEditTemplatePanel );
	}
	
	@isTest static void test_deleteExameTemplate() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idTemplate = eTempl.Id;

		PageReference pageRef = obj.deleteExameTemplate();
		System.assertEquals( null, obj.idTemplate );
		System.assertEquals( true, obj.showExamTemplateTablePanel );
		System.assertEquals( false, obj.showEditTemplatePanel );
	}

	@isTest static void test_deleteExameAreaTemplate() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idTemplate = eTempl.Id;
		obj.idAreaTemplate = aTempl.Id;

		//test method
		PageReference pageRef = obj.deleteExameAreaTemplate();
		System.assertEquals( null, obj.idAreaTemplate ); 
		System.assertEquals( 1, obj.lstTemplateAreas.size() ); 
	}

	@isTest static void test_startExame() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate',
																 Time_To_Execute__c = 100 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Size__c = 100,
											 Status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds1 = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds1.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds1 );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExam = exam;
		obj.currExamTemplate = eTempl;
		obj.mapFlowIds = mapFlowIds1;
		obj.currQuestion = currQuestion1;
		obj.idExam = exam.Id;
		obj.idGoToQuestion = examQuestion.Id;

		PageReference pageRef = obj.startExame();
		System.assertEquals( true, obj.isExamRunning ); 
	}

	@isTest static void test_callReview_1() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;
		obj.reviewDetail = LRN_Utils.EXAM_REVIEW_DETAIL_FULL;
		obj.currExam = exam;

		PageReference pageRef = obj.callReview();
		System.assertEquals( true, obj.isExamRunning );
	}

	@isTest static void test_callReview_2() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;
		obj.reviewDetail = LRN_Utils.EXAM_REVIEW_DETAIL_PARTIAL;
		obj.currExam = exam;

		PageReference pageRef = obj.callReview();
		System.assertEquals( true, obj.isExamRunning );
	}

	@isTest static void test_markUnmarkQuestion() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currQuestion = currQuestion1;

		PageReference pageRef = obj.markUnmarkQuestion();
		System.assertEquals( false, obj.currQuestion.isMarked ); 
	}

	@isTest static void test_strikethroughAnswer() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currQuestion = currQuestion1;
		obj.idGoToAnswer = examAnswer.Id;

		PageReference pageRef = obj.strikethroughAnswer();
		for ( LRN_Utils.AnswerWrapper answers : obj.currQuestion.lstAnswers ) {
			if ( answers.idAnswer == obj.idGoToAnswer ) {
				System.assertEquals( false, answers.isMarked ); 
			}
		}
	}

	@isTest static void test_selectValue() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Value__c = true,
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Is_Answered__c = false,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Value__c = true,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currQuestion = currQuestion1;
		obj.idGoToAnswer = examAnswer.Id;

		PageReference pageRef = obj.selectValue();
		System.assertNotEquals( true, obj.currQuestion.isAnswered ); 
	}

	@isTest static void test_callQuestion() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds1 = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds1.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds1 );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currQuestion = currQuestion1;
		obj.idExam = exam.Id;
		obj.idGoToQuestion = examQuestion.Id;
		obj.isExamRunning = true;
		obj.mapFlowIds = mapFlowIds1;
		obj.currExam = exam;
		
		PageReference pageRef = obj.callQuestion();
		System.assertNotEquals( null, obj.currQuestion ); 
	}

	@isTest static void test_callSummaryPage() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1q = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1q;

		LRN_Exam_Detail_Template__c dTempl1a = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1q.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl1a;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Status__c = LRN_Utils.EXAM_STATUS_STARTED );
		upsert exam;

		LRN_Exam_Detail__c examQuestion1 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																   Exam__c = exam.Id,
																   Question__c = dtempl1q.Id );
		upsert examQuestion1;

		LRN_Exam_Detail__c examAnswer1 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																 Exam__c = exam.Id,
																 Order__c = 1,
																 Question__c = dtempl1a.Id );
		upsert examAnswer1;

		LRN_Exam_Detail__c examQuestion2 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																   Exam__c = exam.Id,
																   Question__c = dtempl1q.Id );
		upsert examQuestion2;

		LRN_Exam_Detail__c examAnswer2 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																 Exam__c = exam.Id,
																 Order__c = 1,
																 Question__c = dtempl1a.Id );
		upsert examAnswer2;

		LRN_Exam_Detail__c examQuestion3 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																   Exam__c = exam.Id,
																   Question__c = dtempl1q.Id );
		upsert examQuestion3;

		LRN_Exam_Detail__c examAnswer3 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																 Exam__c = exam.Id,
																 Order__c = 1,
																 Question__c = dtempl1a.Id );
		upsert examAnswer3;

		LRN_Exam_Detail__c examQuestion4 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																   Exam__c = exam.Id,
																   Question__c = dtempl1q.Id );
		upsert examQuestion4;

		LRN_Exam_Detail__c examAnswer4 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																 Exam__c = exam.Id,
																 Order__c = 1,
																 Question__c = dtempl1a.Id );
		upsert examAnswer4;

		LRN_Exam_Detail__c examQuestion5 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																   Exam__c = exam.Id,
																   Question__c = dtempl1q.Id );
		upsert examQuestion5;

		LRN_Exam_Detail__c examAnswer5 = new LRN_Exam_Detail__c( Is_Marked__c = true,
																 Exam__c = exam.Id,
																 Order__c = 1,
																 Question__c = dtempl1a.Id );
		upsert examAnswer5;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion1.Id, idVals);
		mapFlowIds.put(examQuestion2.Id, idVals);
		mapFlowIds.put(examQuestion3.Id, idVals);
		mapFlowIds.put(examQuestion4.Id, idVals);
		mapFlowIds.put(examQuestion5.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion1, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.isExamRunning = true;
		obj.currQuestion = currQuestion1;
		obj.currExam = exam;
		obj.idExam = exam.Id;

		PageReference pageRef = obj.callSummaryPage();
		System.assertNotEquals( null, obj.lstQuestionWrapperlst );
		System.assertEquals( false, obj.isExamRunning );
	}

	@isTest static void test_callFinalResult() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate',
																 Number_of_Questions__c = 1,
																 Number_of_Questions_to_Validate__c = 1,
																 Approval__c = 50 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Status__c = LRN_Utils.EXAM_STATUS_REVIEW );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		Id[] idVals = new Id[2];

		mapFlowIds.put(examQuestion.Id, idVals);

		LRN_Utils.QuestionWrapper currQuestion1 = new LRN_Utils.QuestionWrapper( examQuestion, mapFlowIds );

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExam = exam;
		obj.examSize = '100';
		obj.currExamTemplate = eTempl;
		obj.idExam = exam.Id;

		PageReference pageRef = obj.callFinalResult();
		System.assertNotEquals( null, obj.finalScore );
		System.assertEquals( false, obj.isExamRunning );
	}

	@isTest static void test_callFinalEvaluation() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Value__c = true,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_ENDED );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExam = exam;
		obj.idExam = exam.Id;

		PageReference pageRef = obj.callFinalEvaluation();
		System.assertEquals( null, obj.idGoToQuestion );
		System.assertEquals( false, obj.isExamRunning ); 
	}

	@isTest static void test_uploadFile_1() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,q,generic,,d,Medium\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,generic,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Data uploaded correctly.', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_2() {	
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdentity,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,q,generic,,d,Medium\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,generic,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Wrong template.', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_3() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n,Q,q,generic,,d,Medium\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,generic,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Problem with answer identifier ( question 1 ).', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_4() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,q,generic,,d,\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,generic,FALSE,,\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Data uploaded correctly.', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_5() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,q,generic,,d,Medium\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Data uploaded correctly.', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_6() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,,generic,,d,Medium\n1,A,a1,generic,TRUE,,Medium\n1,A,a2,,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Question is mandatory ( question 1 ).', msg.getDetail() );
	    }
	}

	@isTest static void test_uploadFile_7() {
		//create data
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		insert eTempl;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.currExamTemplate = eTempl;
		obj.myFile = 'Sheet[]\nIdent,Q/A,Question/Answer,Area,Value,Description,Difficulty\n1,Q,q,generic,,d,Medium\n1,A,,generic,TRUE,,Medium\n1,A,a2,,FALSE,,Medium\n1,A,a3,generic,FALSE,,Medium\n1,A,a4,generic,FALSE,,Medium\n';

		PageReference pageRef = obj.uploadFile();
		for(Apexpages.Message msg : ApexPages.getMessages()){
			System.assertEquals( 'Answer is mandatory ( question 1 ).', msg.getDetail() );
	    }
	}

	@isTest static void test_showtime() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Started_Datetime__c = Datetime.now(),
											 Size__c = 100,
											 Status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;
		obj.currExam = exam;
		obj.currExamTemplate = eTempl;
		PageReference pageRef = obj.showtime();

		System.assertNotEquals( null, obj.timerCount );
	}

	@isTest static void test_changeArea() {
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate' );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl1 = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate1',
																			LRN_Exam_Template__c = eTempl.Id );

		LRN_Exam_Area_Template__c aTempl2 = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate2',
																			LRN_Exam_Template__c = eTempl.Id );

		List<LRN_Exam_Area_Template__c> lstTemplateAreas = new List<LRN_Exam_Area_Template__c>();
		lstTemplateAreas.add( aTempl1 );
		lstTemplateAreas.add( aTempl2 );

		upsert lstTemplateAreas;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl1.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl1.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		dTempl1.LRN_Exam_Area_Template__c = aTempl2.Id;
		upsert dTempl1;

		List<LRN_Exam_Detail_Template__c> lstTemp = [ select LRN_Exam_Area_Template__r.Knowledge_Area__c from LRN_Exam_Detail_Template__c where Id = :dTempl2.Id ];

		System.assertEquals( 'testAreaTemplate2', lstTemp.get(0).LRN_Exam_Area_Template__r.Knowledge_Area__c ); 
	}

	@isTest static void test_page_exam_load_1() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		//questiontemplate

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 status__c = LRN_Utils.EXAM_STATUS_PENDING );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;

		obj.page_exam_load();
		//System.assertEquals( false, obj.currQuestion.isMarked ); 
	}

	@isTest static void test_page_exam_load_2() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Status__c = LRN_Utils.EXAM_STATUS_STARTED,
											 Status_Detail__c = null );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		exam.Status_Detail__c = examQuestion.Id;
		upsert exam;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;
		obj.reviewDetail = LRN_Utils.EXAM_REVIEW_DETAIL_PARTIAL;

		obj.page_exam_load();
		//System.assertEquals( false, obj.currQuestion.isMarked ); 
	}

	@isTest static void test_page_exam_load_3() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Status__c = LRN_Utils.EXAM_STATUS_VALID );
		upsert exam;

		LRN_Exam_Detail__c examQuestion = new LRN_Exam_Detail__c( Is_Marked__c = true,
																  Exam__c = exam.Id,
																  Question__c = dtempl1.Id );
		upsert examQuestion;

		LRN_Exam_Detail__c examAnswer = new LRN_Exam_Detail__c( Is_Marked__c = true,
																Exam__c = exam.Id,
																Order__c = 1,
																Question__c = dtempl2.Id );
		upsert examAnswer;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExam = exam.Id;

		obj.page_exam_load();
		//System.assertEquals( false, obj.currQuestion.isMarked ); 
	}

	@isTest static void test_callScoreExam() {
		//template 
		LRN_Exam_Template__c eTempl = new LRN_Exam_Template__c ( Name = 'testTemplate', 
																 Approval__c = 50,
																 Easy_Questions__c = 33,
																 Hard_Questions__c = 33,
																 Medium_Questions__c = 33,
																 Allow_25_Exam__c = false,
																 Allow_50_Exam__c = false,
																 Allow_Free_Text_Answer__c = false,
																 Allow_Go_Previous__c = false,
																 Allow_Multiple_Answer__c = false,
																 Allow_Random_Order_of_Answers__c = true,
																 Allow_Strikethrough__c = true,
																 Allow_Unanswered__c = true,
																 Description__c = 'description',
																 Number_of_Questions__c = 3,
																 Number_of_Questions_to_Validate__c = 3,
																 Time_To_Execute__c = 180 );
		upsert eTempl;

		LRN_Exam_Area_Template__c aTempl = new LRN_Exam_Area_Template__c ( Knowledge_Area__c = 'testAreaTemplate',
																		   LRN_Exam_Template__c = eTempl.Id );
		upsert aTempl;

		LRN_Exam_Detail_Template__c dTempl1 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Dificult__c = 'Medium',
																				Question_Answer__c = 'q' );
		upsert dtempl1;

		LRN_Exam_Detail_Template__c dTempl2 = new LRN_Exam_Detail_Template__c ( LRN_Exam_Area_Template__c = aTempl.Id,
																				Question__c = dtempl1.Id,
																				Dificult__c = 'Medium',
																				Order__c = 1,
																				Question_Answer__c = 'a' );
		upsert dtempl2;

		LRN_Exam__c exam = new LRN_Exam__c ( LRN_Exam_Template__c = eTempl.Id,
											 Status__c = LRN_Utils.EXAM_STATUS_VALID );
		upsert exam;

		LRN_Result__c eResult = new LRN_Result__c( Result__c = 'PASS',
												   Exam_Size__c = '50%',
												   LRN_Exam_Template__c = eTempl.Id,
												   User__c = UserInfo.getUserId(),
												   Exam_Id__c = exam.Id );
		upsert eResult;

		LRN_Result_Detail__c eRDetail = new LRN_Result_Detail__c( Knowledge_Area__c = 'area',
																  LRN_Result__c = eResult.Id,
																  Num_Correct_Evaluated__c = 75,
																  Num_Correct_Questions__c = 83,
																  Num_Questions_Evaluated__c = 100,
																  Num_Questions__c = 100,
																  Proficiency__c = 'Proficient' );
		upsert eRDetail;

		LRN_Page_Controller obj = new LRN_Page_Controller();
		obj.idExamShow = eResult.Id;

		obj.callScoreExam();

		System.assertEquals( 'PASS', obj.finalScoreTemplate.examinationResult ); 
	}
}