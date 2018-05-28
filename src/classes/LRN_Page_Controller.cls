public with sharing class LRN_Page_Controller {

	/** getters, setters and instanciation of variables */
	public Id idGoToQuestion {get; set;}
	public Id idGoToAnswer {get; set;}
	public Id idLastExam {get; set;}
	public String idExamShow {get; set;}
	public String idTemplate {get; set;}
	public String idAreaTemplate {get; set;}
	public String examSize {get; set;}
	public String reviewDetail {get; set;}
    public String myFile {get; set;}
    public String idExam {get; set;}
    public Boolean allowReviewMarked {get; set;}
    public Boolean isExamRunning {get; set;}
    public Boolean showInitialInfoPanel {get; set;}
    public Boolean showSummaryPanel {get; set;}
    public Boolean showEvaluationPanel {get; set;}
    public Boolean showExamBodyPanel {get; set;}
    public Boolean showHeaderPanel {get; set;}
    public Boolean showResultPanel {get; set;}
    public Boolean showExamTemplateTablePanel {get; set;}
    public Boolean showViewTemplatePanel {get; set;}
    public Boolean showEditTemplatePanel {get; set;}
    public Boolean isEditTemplate {get; set;}
    public Boolean isEditAreaTemplate {get; set;}
    public Boolean isAddAreaTemplate {get; set;}
    public Boolean forceEnded {get; set;} 
    public Boolean userMayDelete {get; set;}
    public Integer totalQuestion {get; set;}
	public DateTime timerCount {get; set;}
	public LRN_Exam_Template__c currExamTemplate {get; set;}
	public LRN_Exam__c currExam {get; set;}
	public LRN_Utils.FinalScoreWrapper finalScore {get; set;}
	public LRN_Utils.FinalScoreWrapper finalScoreTemplate {get; set;}
	public LRN_Utils.QuestionWrapper currQuestion {get; set;}
	public List<List<LRN_Utils.QuestionWrapper>>lstQuestionWrapperlst {get; set;}
    public List<LRN_Utils.QuestionWrapper> lstQuestionWrapper {get; set;}
	public List<LRN_Exam_Template__c> lstExamTemplates {get; set;}
	public List<LRN_Exam_Area_Template__c> lstTemplateAreas {get; set;}
	public List<LRN_Result__c> lstPreviousExams {get; set;}
	public Map<Id, Id[]> mapFlowIds {get; set;} 
	public List<LRN_Utils.FinalScoreWrapper> lstTopExams {get; set;}
    
	private Boolean needEvaluate = true;

	/** constructor */
    public LRN_Page_Controller () {
    	String tmpTemplate = ApexPages.currentPage().getParameters().get( LRN_Utils.PARAM_TEMPLATE_ID );
    	String tmpExame = ApexPages.currentPage().getParameters().get( LRN_Utils.PARAM_EXAM_ID );

    	if ( tmpExame != null && !tmpExame.equals( LRN_Utils.EMPTY_STRING ) ) {
    		this.idExam = tmpExame;
			this.currExam = LRN_Utils.getTestExamById( idExam );
			this.idTemplate = currExam.LRN_Exam_Template__c;
			this.currExamTemplate = LRN_Utils.getTestTemplateById( idTemplate );
		} else if ( tmpTemplate != null && !tmpTemplate.equals( LRN_Utils.EMPTY_STRING) ) {
    		this.idTemplate = tmpTemplate;
			this.currExamTemplate = LRN_Utils.getTestTemplateById( idTemplate );

			lstTemplateAreas = LRN_Utils.getAreaTemplateByIdTemplate( idTemplate );
		}

		Schema.DescribeSObjectResult drSObj = Schema.sObjectType.LRN_Exam_Template__c;
		userMayDelete = drSObj.isDeletable();
    }

    /** onLoad actions */
	public void page_load() {
		this.showExamTemplateTablePanel = true;
    	this.showViewTemplatePanel = false;
    	this.showEditTemplatePanel = false;

    	this.lstExamTemplates = LRN_Utils.getListExamTemplates();
    	this.lstExamTemplates.add( new LRN_Exam_Template__c() );
    	this.lstTopExams = LRN_Utils.getTopExams();
	}

	public void page_exam_load() {
		this.currExam = LRN_Utils.getTestExamById( idExam );
		this.examSize = String.valueOf( Integer.valueOf( currExam.Size__c ) );
		List<LRN_Exam_Detail__c> lstQuestions; 
		if ( currExam.Review_Detail__c != null && currExam.Review_Detail__c.equals( LRN_Utils.EXAM_REVIEW_DETAIL_PARTIAL ) && currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_REVIEW ) ) {
			lstQuestions = LRN_Utils.getListTestExamQuestionsByIdExamMarkedUnanswered( idExam );
		} else{
			lstQuestions = LRN_Utils.getListTestExamQuestionsByIdExam( idExam );	
		}
		this.mapFlowIds = LRN_Utils.getMapFlowIds(lstQuestions);
		if ( currExam.Review_Detail__c != null && currExam.Review_Detail__c.equals( LRN_Utils.EXAM_REVIEW_DETAIL_PARTIAL ) && currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_REVIEW )
			&& currExam.Status_Detail__c != null && this.mapFlowIds.get( currExam.Status_Detail__c ) == null ) {
			lstQuestions = LRN_Utils.getListTestExamQuestionsByIdExam( idExam );
			this.mapFlowIds = LRN_Utils.getMapFlowIds(lstQuestions);
		}
		this.totalQuestion = Integer.valueOf(currExam.Number_Questions__c);
		this.reviewDetail = currExam.Review_Detail__c;

		if ( currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_PENDING ) ) {
			this.idGoToQuestion = lstQuestions.get(0).Id;
			this.isExamRunning = false;
			this.managePanel( true, true, false, false, false, false );
		} else if ( currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_STARTED ) ) {
			this.isExamRunning = true;
			this.idGoToQuestion = currExam.Status_Detail__c;
			if ( this.idGoToQuestion == null ) {
				this.callReview();
			} else {
				this.callQuestion();
			}
		} else if ( currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_REVIEW ) ) {
			this.isExamRunning = true;
			this.idGoToQuestion = currExam.Status_Detail__c;
			this.callQuestion();	
		} else if ( currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_ENDED ) ) {
			this.needEvaluate = false;
			this.callFinalResult();	
		} else if ( currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_VALID ) ) {
			this.callFinalEvaluation();
		}
	}

	/** ActionFunction methods */
	public PageReference createExam() {
		this.idExam = LRN_Utils.createExameStructure( currExamTemplate, Integer.valueOf( 100/Decimal.valueOf( examSize ) ), false );

		return null;
	}

	public PageReference showExameTemplate(){
		if ( idTemplate != null && !idTemplate.equals( LRN_Utils.EMPTY_STRING ) ) {
			this.currExamTemplate = LRN_Utils.getTestTemplateById( idTemplate );
			this.idExam = LRN_Utils.getLastExamByTemplateId( idTemplate );
			this.showViewTemplatePanel = true;
			this.showExamTemplateTablePanel = false;
		}

		this.lstPreviousExams = LRN_Utils.getPreviousExamList( idTemplate );
		this.finalScoreTemplate = null;

		//validate if there are exams with more than 24h and delete them
		List<LRN_Exam__c> lstExams = LRN_Utils.getOldTests();
		if ( lstExams!= null && !lstExams.isEmpty() ) {
			LRN_Utils.deleteOldExams();
		}

		return null;
	}

	public PageReference callScoreExam(){
		LRN_Result__c result = LRN_Utils.getResultById( idExamShow );
		List<LRN_Result_Detail__c> lstResultDetail = LRN_Utils.getResultDetailByIdResult( idExamShow );

		this.finalScoreTemplate = new LRN_Utils.FinalScoreWrapper( result, lstResultDetail );

		return null;
	}

	public PageReference editExameTemplate(){
		if ( idTemplate != null && !idTemplate.equals( LRN_Utils.EMPTY_STRING ) ) {
			this.currExamTemplate = LRN_Utils.getTestTemplateById( idTemplate );

			this.lstTemplateAreas = LRN_Utils.getAreaTemplateByIdTemplate( idTemplate );
			this.lstTemplateAreas.add( new LRN_Exam_Area_Template__c() );

			this.isEditTemplate = false;
			this.isEditAreaTemplate = false;
			this.isAddAreaTemplate = false;
		} else {
			this.currExamTemplate = new LRN_Exam_Template__c();

			this.lstTemplateAreas = new List<LRN_Exam_Area_Template__c>();
			this.lstTemplateAreas.add( new LRN_Exam_Area_Template__c() );

			this.isEditTemplate = true;
			this.isEditAreaTemplate = false;
			this.isAddAreaTemplate = false;
		}

		this.showEditTemplatePanel = true;
		this.showExamTemplateTablePanel = false;
		
		return null;
	}

	public PageReference cancelExameTemplate(){
		if ( idTemplate != null && !idTemplate.equals( LRN_Utils.EMPTY_STRING ) ) {
			this.currExamTemplate = LRN_Utils.getTestTemplateById( idTemplate );
			this.isEditTemplate = false;
			this.isEditAreaTemplate = false;
			this.isAddAreaTemplate = false;
		} else {
			this.isEditTemplate = false;
			this.page_load();
			this.showExamTemplateTablePanel = true;
			this.showEditTemplatePanel = false;
			this.isEditAreaTemplate = false;
			this.isAddAreaTemplate = false;
		}
		
		return null;
	}

	public PageReference saveExameTemplate(){
		upsert this.currExamTemplate;

		this.idTemplate = currExamTemplate.Id;
		this.showEditTemplatePanel = true;
		this.showExamTemplateTablePanel = false;
		this.isEditTemplate = false;
		this.isEditAreaTemplate = false;
		this.isAddAreaTemplate = false;
		return null;
	}

	public PageReference saveExameTemplateAreas(){
		List<LRN_Exam_Area_Template__c> lstTmpArea = new List<LRN_Exam_Area_Template__c>();
		for ( LRN_Exam_Area_Template__c tempArea : lstTemplateAreas ) {
			if ( tempArea.Id != null ) {
				lstTmpArea.add( tempArea );
			} else if ( tempArea.Knowledge_Area__c != null ) {
				tempArea.Order__c = lstTemplateAreas.size();
				tempArea.LRN_Exam_Template__c = this.idTemplate;
				lstTmpArea.add( tempArea );
			}
		}
		upsert lstTmpArea;

		this.lstTemplateAreas = LRN_Utils.getAreaTemplateByIdTemplate( idTemplate );
		this.lstTemplateAreas.add( new LRN_Exam_Area_Template__c() );

		this.showEditTemplatePanel = true;
		this.showExamTemplateTablePanel = false;
		this.isEditTemplate = false;
		this.isEditAreaTemplate = false;
		this.isAddAreaTemplate = false;
		return null;
	}

	public PageReference editTemplate(){
		this.isEditTemplate = true;

		return null;
	}

	public PageReference editAreaTemplate(){
		this.isEditAreaTemplate = true;

		return null;
	}

	public PageReference addExameTemplateArea() {
		this.isAddAreaTemplate = true;

		return null;
	}

	public PageReference backTemplateList(){
		this.idTemplate = null;
		
		this.page_load();
		
		this.showExamTemplateTablePanel = true;
		this.showEditTemplatePanel = false;

		return null;
	}

	public PageReference deleteExameTemplate(){
		LRN_Utils.deleteTestTemplateById( idTemplate );
		this.idTemplate = null;
		this.page_load();
		this.showExamTemplateTablePanel = true;
		this.showEditTemplatePanel = false;
		return null;
	}

	public PageReference deleteExameAreaTemplate(){
		LRN_Utils.deleteTestAreaTemplateById( idAreaTemplate );
		this.idAreaTemplate = null;
		this.lstTemplateAreas = LRN_Utils.getAreaTemplateByIdTemplate( idTemplate );
		this.lstTemplateAreas.add( new LRN_Exam_Area_Template__c() );
		
		return null;
	}

	public PageReference startExame() {
		LRN_Exam_Detail__c questionnow = LRN_Utils.getTestExamQuestionsById( this.idExam, this.idGoToQuestion );
		this.currQuestion = new LRN_Utils.QuestionWrapper( questionnow, mapFlowIds );
		this.isExamRunning = true;
		this.managePanel( true, false, true, false, false, false );
		this.showtime();
		return null;
	}

	public PageReference callReview() {
		List<LRN_Exam_Detail__c> lstQuestions;
		if ( this.reviewDetail.equals( LRN_Utils.EXAM_REVIEW_DETAIL_FULL ) ){
			lstQuestions = LRN_Utils.getListTestExamQuestionsByIdExam( idExam );
		} else if ( this.reviewDetail.equals( LRN_Utils.EXAM_REVIEW_DETAIL_PARTIAL ) ){
			lstQuestions = LRN_Utils.getListTestExamQuestionsByIdExamMarkedUnanswered( idExam );
		} 
		this.mapFlowIds = LRN_Utils.getMapFlowIds(lstQuestions);
		this.idGoToQuestion = null;
		this.currQuestion = new LRN_Utils.QuestionWrapper( lstQuestions.get(0) , mapFlowIds );
		this.isExamRunning = true;
		this.managePanel( true, false, true, false, false, false );

		return null;
	}

	public PageReference markUnmarkQuestion() {
		this.currQuestion.isMarked = !this.currQuestion.isMarked;

		return null;
	}

	public PageReference strikethroughAnswer() {
		for ( LRN_Utils.AnswerWrapper answers : currQuestion.lstAnswers ) {
			if ( answers.idAnswer == idGoToAnswer ) {
				answers.isMarked = !answers.isMarked;
			}
		}

		return null;
	}

	public PageReference selectValue() {
		currQuestion.numAnswered = 0;
		for ( LRN_Utils.AnswerWrapper answers : currQuestion.lstAnswers ) {
			if ( answers.idAnswer == idGoToAnswer ) {
				answers.value = !answers.value;
			} else if( currQuestion.numCorrectAnswers == 1 ) {
				answers.value = false;
			}
			if ( answers.value ) {
				currQuestion.numAnswered++; 
			}
		}
		currQuestion.isAnswered = ( currQuestion.numCorrectAnswers == currQuestion.numAnswered );

		return null;
	}
	
	public PageReference callQuestion() {
		if ( this.isExamRunning && currQuestion != null ){
			LRN_Utils.saveQuestion( currQuestion );
		}

		LRN_Exam_Detail__c questionnow = LRN_Utils.getTestExamQuestionsById( idExam, idGoToQuestion );
		this.currQuestion = new LRN_Utils.QuestionWrapper( questionnow, mapFlowIds );
		if ( !currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_VALID ) ) {
			this.managePanel( true, false, true, false, false, false );
		}
		return null;
	}

	public PageReference callSummaryPage() {
		if ( this.isExamRunning && currQuestion != null ) {
			LRN_Utils.saveQuestion( currQuestion );
		}

		List<LRN_Exam_Detail__c> lstQuest = LRN_Utils.getListTestExamQuestionsByIdExam( idExam );

		this.allowReviewMarked = false;
		for ( LRN_Exam_Detail__c det : lstQuest ) {
			if ( det.Is_Marked__c || !det.is_Answered__c ) {
				this.allowReviewMarked = true;
			}
		}

		this.lstQuestionWrapperlst = LRN_Utils.prepareReviewLists( lstQuest, null );

		this.isExamRunning = false;
		this.managePanel( true, false, false, true, false, false );
		return null;
	}

	public PageReference callFinalResult() {
		this.finalScore = LRN_Utils.getValidatedListQuestion( idExam, currExamTemplate, Integer.valueOf( 100/Decimal.valueOf( examSize ) ), needEvaluate, currExam.Started_Datetime__c );

		this.isExamRunning = false;
		this.managePanel( true, false, false, false, true, false );

		return null;
	}

	public PageReference callFinalEvaluation() {
		this.currQuestion = new LRN_Utils.QuestionWrapper();
		
		List<LRN_Exam_Detail__c> lstAnswers = LRN_Utils.getListTestExamAnswersByIdExam( idExam );
		List<LRN_Exam_Detail__c> lstQuest = LRN_Utils.getListTestExamQuestionsByIdExam( idExam );

		this.lstQuestionWrapperlst = LRN_Utils.prepareReviewLists( lstQuest, lstAnswers );

		this.isExamRunning = false;
		this.idGoToQuestion = null;
		this.managePanel( true, false, false, false, false, true );

		return null;
	}

	public PageReference callGetExcelTemplate() {
		PageReference pr = Page.LRN_Template2Excel;
		
		pr.getParameters().put( 'idTemplate', idTemplate );
	    pr.setRedirect(false);
		    
	    return pr;
	}

	public PageReference uploadFile(){
		String result = '';
		try {
			result = LRN_Utils.uploadFile( currExamTemplate.Id, myFile );
		} catch (Exception e) {
			result = e.getMessage();
		}

		if ( result == '' || result == null ) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Data uploaded correctly.'));
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result ));
		}
		return null;
	}

	public PageReference showtime() {
		if( currExam.Started_Datetime__c != null && currExam.Ended_Datetime__c == null ) {
			Integer timesize = Integer.valueOf(currExamTemplate.Time_To_Execute__c / ( 100 / currExam.Size__c));
			this.timerCount = Datetime.newInstance(currExam.Started_Datetime__c.addMinutes(timesize).getTime() - Datetime.now().getTime() );
			if ( Datetime.now() >= currExam.Started_Datetime__c.addMinutes(timesize) ) {
				currExam.Status__c = LRN_Utils.EXAM_STATUS_ENDED;
				currExam.Ended_Datetime__c = currExam.Started_Datetime__c.addMinutes(timesize);
				upsert currExam;
				forceEnded = true;
			}
		} else {
			this.timerCount = null;
		}
		return null;
	}

	/** private methods */
	private void managePanel( Boolean sHeader, Boolean sInitial, Boolean sBody, Boolean sSummary, Boolean sResult, Boolean sEvaluation ) {
		this.showSummaryPanel = sSummary;
		this.showInitialInfoPanel = sInitial;
		this.showEvaluationPanel = sEvaluation;
		this.showExamBodyPanel = sBody;
		this.showHeaderPanel = sHeader;
		this.showResultPanel = sResult;

		if ( showInitialInfoPanel ){
			currExam.Status__c = LRN_Utils.EXAM_STATUS_PENDING;
		}
		if ( showExamBodyPanel ) {
			if (currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_PENDING ) ) {
				currExam.Status__c = LRN_Utils.EXAM_STATUS_STARTED;
				currExam.Started_Datetime__c = Datetime.now();
			}
		}
		if ( showResultPanel ) {
			if (currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_REVIEW ) ) {
				currExam.Status__c = LRN_Utils.EXAM_STATUS_ENDED;
				currExam.Ended_Datetime__c = Datetime.now();
			}
		}
		if ( showSummaryPanel ) {
			if (currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_STARTED ) )
				currExam.Status__c = LRN_Utils.EXAM_STATUS_REVIEW;
		}
		if ( showEvaluationPanel ) {
			if (currExam.Status__c.equals( LRN_Utils.EXAM_STATUS_ENDED ) )
				currExam.Status__c = LRN_Utils.EXAM_STATUS_VALID;
		}
		
		if ( idGoToQuestion != null )
			currExam.Status_Detail__c = this.idGoToQuestion;
		if ( reviewDetail != null && !reviewDetail.equals( LRN_Utils.EMPTY_STRING ) )
			currExam.Review_Detail__c = this.reviewDetail;

		upsert currExam;
	}

    @RemoteAction
    public static List<LRN_Utils.ChartDataWrapper> getRemoteGraphData(String templateId) {
        return LRN_Utils.generateGraphData(templateId);
    }
}