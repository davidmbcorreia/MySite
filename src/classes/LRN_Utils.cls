public with sharing class LRN_Utils {
	
	// static constants
	public static String LRN_EXAM_PAGE = '/apex/LRN_Exam';
	public static String PARAM_TEMPLATE_ID = 'iT';
	public static String PARAM_EXAM_ID = 'iE';
	public static String PARAM_QUESTION_ID = 'iQ';
	public static String EMPTY_STRING = '';
	public static String POINT_STRING = '.';
	private static String TRUE_STRING = 'true';
	public static String PERCENT_SYMBOL_STRING = '%';
	public static String EXAM_STATUS_PENDING = 'pending';
	public static String EXAM_STATUS_STARTED = 'started';
	public static String EXAM_STATUS_REVIEW = 'reviewing';
	public static String EXAM_STATUS_ENDED = 'ended';
	public static String EXAM_STATUS_VALID = 'validating';
	public static String EXAM_REVIEW_DETAIL_PARTIAL = 'partial';
	public static String EXAM_REVIEW_DETAIL_FULL = 'full';
	public static String GENERIC_AREA = 'generic';
	private static String MSG_PROBLEM_ANSWER = 'Problem with answer identifier ( question {0} ).';
	private static String MSG_PROBLEM_QUESTION = 'Problem with question {0}.';
	private static String MSG_ANSWER_MANDATORY = 'Answer is mandatory ( question {0} ).';
	private static String MSG_QUESTION_MANDATORY = 'Question is mandatory ( question {0} ).';
	private static String MSG_INEXISTENT_AREA = 'Inexistent Knowledge Area - {0}.';
	private static String MSG_WRONG_TEMPLATE = 'Wrong template.';
	private static String EXAM_RESULT_PASS = 'PASS';
	private static String EXAM_RESULT_FAIL = 'FAIL';
	private static String DOMAIN_RESULT_PROFICIENT = 'Proficient';
	private static String DOMAIN_RESULT_MODER_PROFICIENT = 'Moderately Proficient';
	private static String DOMAIN_RESULT_BELLOW_PROFICIENT = 'Below Proficient';
	private static String DIFICULT_EASY = 'Easy';
	private static String DIFICULT_MEDIUM = 'Medium';
	private static String DIFICULT_HARD = 'Hard';
	private static String FILE_QUESTION_SYMBOL = 'q';
	private static String FILE_ANSWER_SYMBOL = 'a';
	private static Pattern QUOTE_PATTERN = Pattern.compile('(?<!")"(?!")');
	private static String HEADER_IDENT = 'Ident';
	private static String HEADER_QA = 'Q/A';
	private static String HEADER_QUEST_ANS = 'Question/Answer';
	private static String HEADER_AREA = 'Area';
	private static String HEADER_VALUE = 'Value';
	private static String HEADER_DESC = 'Description';
	private static String HEADER_DIFFIC = 'Difficulty';
	private static Integer HEADER_COL_IDENT = 0;
	private static Integer HEADER_COL_QA = 1;
	private static Integer HEADER_COL_QUEST_ANS = 2;
	private static Integer HEADER_COL_AREA = 3;
	private static Integer HEADER_COL_VALUE = 4;
	private static Integer HEADER_COL_DESC = 5;
	private static Integer HEADER_COL_DIFFIC = 6;

	// variables
	private String delim = ',';
	private String[] buffer;
	

	/** Constructors */
	public LRN_Utils(String data) {
		this.buffer = data.split('\n'); 
	}

	public LRN_Utils(String data, String delim) {
		this.buffer = data.split('\n'); 
		this.delim = delim;
	}

	/** CRUD Methods */
	public static List<LRN_Result__c> getMyExamList( Id idTemplate ) {
		Id userId = UserInfo.getUserId();
		List<LRN_Result__c> lstTemplates = [ SELECT Score_Evaluated__c,Start_Date__c
											   FROM LRN_Result__c
											  WHERE IsDeleted = false 
												AND LRN_Exam_Template__c = :idTemplate
												AND User__c = :userId
											  ORDER BY Start_Date__c ];
		return lstTemplates;
	}

	public static List<LRN_Result__c> getPreviousExamList( Id idTemplate ) {
		Id userId = UserInfo.getUserId();
		List<LRN_Result__c> lstTemplates = [ SELECT Score_Evaluated__c,Start_Date__c, Exam_Size__c, Id
											   FROM LRN_Result__c
											  WHERE IsDeleted = false 
												AND LRN_Exam_Template__c = :idTemplate
												AND User__c = :userId
											  ORDER BY Start_Date__c desc ];
		return lstTemplates;
	}

	public static LRN_Result__c getResultById( Id idResult ) {
		
		List<LRN_Result__c> lstResult = [ SELECT Exam_Size__c, Num_Correct_Evaluated__c, Num_Correct_Questions__c, Num_Questions_Evaluated__c,
												 Num_Questions__c, Result__c, Score_Evaluated__c, Score_Total__c 
											FROM LRN_Result__c 
										   WHERE IsDeleted = false
										   	 AND Id = :idResult	];

		return lstResult.get(0);
	}

	public static List<LRN_Result_Detail__c> getResultDetailByIdResult ( Id idResult ) {

		List<LRN_Result_Detail__c> lstResultDetail = [ SELECT Knowledge_Area__c, Num_Correct_Evaluated__c, Num_Correct_Questions__c, Score_Total__c,
															  Num_Questions_Evaluated__c, Num_Questions__c, Proficiency__c, Score_Evaluated__c
														 FROM LRN_Result_Detail__c
														WHERE IsDeleted = false
														  AND LRN_Result__c = :idResult ];
		return lstResultDetail;
	}

	public static List<LRN_Exam_Template__c> getListExamTemplates() {
		List<LRN_Exam_Template__c> lstTemplates = [ SELECT Id,Name,Description__c
													  FROM LRN_Exam_Template__c 
													 WHERE IsDeleted = false 
													 ORDER BY Name ];
		return lstTemplates;
	}

	public static LRN_Exam_Template__c getTestTemplateById( Id idTemplate ) {
		List<LRN_Exam_Template__c> lstTempls = [ SELECT Allow_25_Exam__c,Allow_50_Exam__c,Allow_Free_Text_Answer__c,Allow_Multiple_Answer__c,Allow_Go_Previous__c,
														Allow_Random_Order_of_Answers__c,Allow_Strikethrough__c,Allow_Unanswered__c,Approval__c,
														Easy_Questions__c,Hard_Questions__c,Id,Medium_Questions__c,Name,Number_of_Answers_per_Question__c,
														Number_of_Questions_to_Validate__c,Number_of_Questions__c,Time_To_Execute__c,Description__c
												   FROM LRN_Exam_Template__c
												  WHERE Id = :idTemplate
													AND IsDeleted = false ];

		return lstTempls == null? null : lstTempls.get(0);
	}

	public static List<LRN_Exam_Area_Template__c> getAreaTemplateByIdTemplate( Id idTemplate ) {
		List<LRN_Exam_Area_Template__c> lstAreasTemplate = [ SELECT Id,Knowledge_Area__c,LRN_Exam_Template__c,Name,Order__c,Percent_of_Area_Questions__c 
															   FROM LRN_Exam_Area_Template__c
															  WHERE LRN_Exam_Template__c =  :idTemplate 
																AND Is_Generic_Area__c = false
																AND IsDeleted = false
															  ORDER BY Order__c ];
		return lstAreasTemplate;
	}

	public static void deleteTestTemplateById( Id idTemplate ) {
		LRN_Exam_Template__c templ = new LRN_Exam_Template__c( Id = idTemplate );
		delete templ;
	}

	public static void deleteTestAreaTemplateById( Id idAreaTemplate ) {
		LRN_Exam_Area_Template__c arTempl = new LRN_Exam_Area_Template__c( Id = idAreaTemplate );
		delete arTempl;
	}

	public static List<FinalScoreWrapper> getTopExams () {
		List<FinalScoreWrapper> lstRes = new List<FinalScoreWrapper>();

		AggregateResult[] lstResults = [ SELECT max(Score_Evaluated__c) maxScore,LRN_Exam_Template__r.Name tempName, Exam_Size__c eSize, User__r.Name student
										   FROM LRN_Result__c
										  WHERE IsDeleted = false
										  GROUP BY LRN_Exam_Template__r.Name, Exam_Size__c, User__r.Name
										  ORDER BY LRN_Exam_Template__r.Name ];
		

		for (AggregateResult nameDefinition : lstResults) {
			lstRes.add( new FinalScoreWrapper( Double.valueOf(nameDefinition.get('maxScore') ), 
											   String.valueOf(nameDefinition.get('tempName') ), 
											   String.valueOf(nameDefinition.get('eSize') ),
											   String.valueOf(nameDefinition.get('student') ) ) );
		}

		return lstRes;
	}

	public static Id getLastExamByTemplateId( Id templateId ) {
		List<LRN_Exam__c> lstExam = [ SELECT Id 
										FROM LRN_Exam__c 
									   WHERE LRN_Exam_Template__c = :templateId
									   ORDER BY CreatedDate desc
									   LIMIT 1 ];
		return lstExam.isEmpty() ? null : lstExam.get(0).Id; 
	}

	public static List<LRN_Exam__c> getOldTests( ) {
		Date d = System.today().addDays(-7);
		List<LRN_Exam__c> lstExam = [ SELECT Id 
										FROM LRN_Exam__c 
									   WHERE ( CreatedDate < :d )  ];
		return lstExam;
	}

	@future
	public static void deleteOldExams() {
		List<LRN_Exam__c> lstExams = LRN_Utils.getOldTests();
		delete lstExams;
	}

	public static LRN_Exam__c getTestExamById( Id idExam ) {
		List<LRN_Exam__c> lstTempls = [ SELECT Id,LRN_Exam_Template__c,Name,Number_Answered__c,Size__c, Started_Datetime__c, Ended_Datetime__c, 
											   Status__c, Status_Detail__c, Review_Detail__c, Number_Questions__c
										  FROM LRN_Exam__c
										 WHERE Id = :idExam 
										   AND IsDeleted = false ];

		return lstTempls == null? null : lstTempls.get(0);
	}

	public static List<LRN_Exam_Detail__c> getListTestExamQuestionsByIdExamMarkedUnanswered( Id idExam ) {
		List<LRN_Exam_Detail__c> lstQuestions = new List<LRN_Exam_Detail__c>();

		for( LRN_Exam_Detail__c question : getListTestExamQuestionsByIdExam( idExam ) ){
			if ( question.Is_Marked__c || !question.Is_Answered__c )
				lstQuestions.add( question );
		}
		
		return lstQuestions;
	}

	public static List<LRN_Exam_Detail__c> getListTestExamQuestionsByIdExam( Id idExam ) {
		List<LRN_Exam_Detail__c> lstQuestions = [ SELECT Exam__c,Id,Is_Marked__c,Name,Order__c,Question__c,Value__c,
														 Question__r.Question_Answer__c, Question__r.Question_Image__c,
														 Question__r.Has_Image_Question__c, Is_Answered__c, Is_Evaluated__c
													FROM LRN_Exam_Detail__c
												   WHERE Exam__c = :idExam 
													 AND IsDeleted = false 
													 AND Question__r.Question__c = null
												   ORDER BY Order__c ];

		return lstQuestions;
	}

	public static List<LRN_Exam_Detail__c> getListTestExamQuestionsByIdExamOrderByArea( Id idExam ) {
		List<LRN_Exam_Detail__c> lstQuestions = [ SELECT Exam__c,Id,Is_Marked__c,Name,Order__c,Question__c,Value__c,
														 Question__r.Question_Answer__c, Question__r.Question_Image__c,
														 Question__r.Has_Image_Question__c, Is_Answered__c, Is_Evaluated__c,
														 Question__r.LRN_Exam_Area_Template__c, Question__r.LRN_Exam_Area_Template__r.Knowledge_Area__c
													FROM LRN_Exam_Detail__c
												   WHERE Exam__c = :idExam 
													 AND IsDeleted = false 
													 AND Question__r.Question__c = null
												   ORDER BY Question__r.LRN_Exam_Area_Template__c, Order__c ];

		return lstQuestions;
	}

	public static LRN_Exam_Detail__c getTestExamQuestionsById( Id idExam, Id idQuestion ) {
		List<LRN_Exam_Detail__c> lstQuestions = [ SELECT Exam__c,Id,Is_Marked__c,Name,Order__c,Question__c,Value__c,
														 Question__r.Question_Answer__c, Question__r.Question_Image__c,
														 Question__r.Has_Image_Question__c, Is_Answered__c, Is_Evaluated__c
													FROM LRN_Exam_Detail__c
												   WHERE Exam__c = :idExam 
													 AND IsDeleted = false 
													 AND Id = :idQuestion
													 AND Question__r.Question__c = null
												   ORDER BY Order__c ];

		return lstQuestions.get(0);
	}

	public static List<LRN_Exam_Detail__c> getListTestExamAnswersByIdExam( Id idExam ) {
		List<LRN_Exam_Detail__c> lstAnswers = [ SELECT Exam__c,Id,Order__c,Question__c,Value__c, Question__r.Dificult__c, Question__r.LRN_Exam_Area_Template__c,
														 Question__r.Value__c, Question__r.Question__c
													FROM LRN_Exam_Detail__c
												   WHERE Exam__c = :idExam 
													 AND IsDeleted = false 
													 AND Question__r.Question__c != null
												   ORDER BY Question__r.Question__c ];

		return lstAnswers;
	}

	public static List<LRN_Exam_Detail__c> getTestExamAnswersByIdQuestion( Id idExam, Id idQuestion ) {
		List<LRN_Exam_Detail__c> lstAnswers = [ SELECT Exam__c,Id,Is_Marked__c,Name,Order__c,Question__c,Value__c,
													   Question__r.Question_Answer__c, Question__r.Question_Image__c,
													   Question__r.Has_Image_Question__c, Question__r.Value__c
												  FROM LRN_Exam_Detail__c
												 WHERE Exam__c = :idExam 
												   AND Question__r.Question__c = :idQuestion 
												   AND IsDeleted = false 
												 ORDER BY Order__c ];

		return lstAnswers;
	}

	public static List<LRN_Exam_Detail__c> getTestExamCorrectAnswersByIdQuestion( Id idExam, Id idQuestion ) {
		List<LRN_Exam_Detail__c> lstAnswers = [ SELECT Exam__c,Id,Is_Marked__c,Name,Order__c,Question__c,Value__c,
													   Question__r.Question_Answer__c, Question__r.Value__c,
													   Question__r.Description__c, Question__r.Question__c
												  FROM LRN_Exam_Detail__c
												 WHERE Exam__c = :idExam 
												   AND ( Question__r.Question__c = :idQuestion OR Question__r.Id = :idQuestion )
												   AND IsDeleted = false 
												 ORDER BY Question__r.Question__c NULLS LAST, Question__r.Value__c desc, Order__c ];

		return lstAnswers;
	}

	public static void saveQuestion ( QuestionWrapper currQuestion ) {
		List<LRN_Exam_Detail__c> lstDetailsTmp = new List<LRN_Exam_Detail__c>();
		Boolean alreadyAnswered = false;
		for ( AnswerWrapper answers : currQuestion.lstAnswers ) {
			LRN_Exam_Detail__c newDetail = new LRN_Exam_Detail__c ( id = answers.idAnswer,
																	Is_Marked__c = answers.isMarked,
																	Value__c = answers.value );
			lstDetailsTmp.add( newDetail );

			if ( alreadyAnswered || answers.value )
				alreadyAnswered = true;
		}

		LRN_Exam_Detail__c newDetail = new LRN_Exam_Detail__c ( id = currQuestion.idQuestion,
																Is_Marked__c = currQuestion.isMarked,
																Is_Answered__c = alreadyAnswered );
		lstDetailsTmp.add( newDetail );

		update lstDetailsTmp;
	}

	/** Support Methods */
	public static FinalScoreWrapper getValidatedListQuestion( Id idExam, LRN_Exam_Template__c currExamTemplate, Integer fraction, Boolean needEvaluate, Datetime startDate ) {
		// get list ordered by area, order
		List<LRN_Exam_Detail__c> lstQuestions = getListTestExamQuestionsByIdExamOrderByArea( idExam );  

		// mark the questions that will be evaluated
		Decimal numQuestion = currExamTemplate.Number_of_Questions__c / fraction;
		Decimal numQuestionToValidate = currExamTemplate.Number_of_Questions_to_Validate__c / fraction;

		Integer notEvaluated = Integer.valueOf( numQuestion - numQuestionToValidate);

		if ( notEvaluated > 0 && needEvaluate ) {
			for( Integer valOrder : randomWithLimit( lstQuestions.size(), notEvaluated ) ) {
				lstQuestions.get( valOrder ).Is_Evaluated__c = false;
			}
			upsert lstQuestions;
		}

		// get list answers
		List<LRN_Exam_Detail__c> lstAnswers = LRN_Utils.getListTestExamAnswersByIdExam( idExam );

		// make a map with the results per question
		Boolean withResults = false;
		Map<Id,Boolean> mapResult = new Map<Id,Boolean>();

		if ( lstAnswers != null && !lstAnswers.isEmpty() ) {
			Id currId = null;
			Boolean resBool = true;
			for ( LRN_Exam_Detail__c ans : lstAnswers ) {
				if ( ans.Question__r.Question__c != currId ) {
					if (currId != null) {
						mapResult.put( currId, resBool );
					}
					resBool = true;
					currId = ans.Question__r.Question__c;
				}
				resBool = resBool && (ans.Value__c == ans.Question__r.Value__c);
			}
			mapResult.put( currId, resBool );
			withResults = true;
		}

		FinalScoreWrapper finalScore = new FinalScoreWrapper( lstQuestions, mapResult, currExamTemplate );

		//persist information of test
		
		List<LRN_Result__c> lstResult = [ SELECT Id FROM LRN_Result__c WHERE Exam_Id__c = :idExam ];
		if ( lstResult.isEmpty() ) {
			LRN_Result__c result = new LRN_Result__c ( LRN_Exam_Template__c = currExamTemplate.Id,
													   Exam_Id__c = idExam,
													   Start_Date__c = startDate,
													   End_Date__c = Datetime.now(),
													   Result__c = finalScore.examinationResult,
													   User__c = UserInfo.getUserId(),
													   Exam_Size__c = ( fraction == 1 ? '100%': ( fraction == 2 ? '50%' : '25%' ) )
													 );
			insert result;

			List<LRN_Result_Detail__c> lstResultDetail = new List<LRN_Result_Detail__c>();
			for ( FinalScoreDetailWrapper scoreDetail : finalScore.lstDomainScore ) {
				LRN_Result_Detail__c detail = new LRN_Result_Detail__c( Knowledge_Area__c = scoreDetail.domainName,
																		LRN_Result__c = result.Id,
																		Num_Correct_Evaluated__c = scoreDetail.totalCorrectEvaluated,
																		Num_Correct_Questions__c = scoreDetail.totalCorrect,
																		Num_Questions__c = scoreDetail.total,
																		Num_Questions_Evaluated__c = scoreDetail.totalEvaluated,
																		Proficiency__c = scoreDetail.domainResult );

				lstResultDetail.add( detail );
			}
			insert lstResultDetail;
		}

		return finalScore;
	}

	public static Map<Id, Id[]> getMapFlowIds( List<LRN_Exam_Detail__c> lstQuestions ) {
		Id currId = null;
		Id previousId = null;
		Id nextId = null;
		Map<Id, Id[]> mapFlowIds = new Map<Id, Id[]>();
		for ( LRN_Exam_Detail__c question : lstQuestions ) {
			previousId = currId;
			currId = nextId;
			nextId = question.Id;
			if ( previousId != null || nextId != null ) {
				Id[] flowId = new Id[2];
				flowId[0] = previousId;
				flowId[1] = nextId; 
				mapFlowIds.put( currId, flowId );
			}
		}
		Id[] flowId = new Id[2];
		flowId[0] = currId;
		flowId[1] = null; 
		mapFlowIds.put( nextId, flowId );

		return mapFlowIds;
	}

	public static Id createExameStructure( LRN_Exam_Template__c currExamTemplate, Integer fraction, Boolean isPDF ) {
		Decimal numQuestion = ( isPDF ? currExamTemplate.Number_of_Questions_to_Validate__c : currExamTemplate.Number_of_Questions__c) / fraction;
		Decimal numQuestionToValidate = currExamTemplate.Number_of_Questions_to_Validate__c / fraction;
		Decimal numEasyQuestions = ( currExamTemplate.Easy_Questions__c == null ? 0 : currExamTemplate.Easy_Questions__c ) * numQuestion / 100;
		Decimal numMediumQuestions = ( currExamTemplate.Medium_Questions__c == null ? 0 : currExamTemplate.Medium_Questions__c ) * numQuestion / 100;
		Decimal numHardQuestions = ( currExamTemplate.Hard_Questions__c == null ? 0 : currExamTemplate.Hard_Questions__c ) * numQuestion / 100;
		Decimal numNonDificultQuestion = numQuestion - ( numEasyQuestions + numMediumQuestions + numHardQuestions );
		Boolean allowRandomAnswers = currExamTemplate.Allow_Random_Order_of_Answers__c;

		Set<Id> setAreas = new Set<Id>();
		Map<Id,LRN_Exam_Area_Template__c> mapKnowledges = new Map<Id,LRN_Exam_Area_Template__c>();

		LRN_Exam__c newExam = new LRN_Exam__c ( LRN_Exam_Template__c = currExamTemplate.Id,
												Size__c = Integer.valueOf( 100 / fraction ),
												Status__c = EXAM_STATUS_PENDING,
												Number_Questions__c = numQuestion
											  );
		insert newExam;

		// get template area details 
		List<LRN_Exam_Area_Template__c> lstAreaTemplates = [ SELECT Id, Percent_of_Area_Questions__c, Is_Generic_Area__c, Knowledge_Area__c, 
																	LRN_Exam_Template__c, Name, Order__c
															   FROM LRN_Exam_Area_Template__c 
															  WHERE LRN_Exam_Template__c = :currExamTemplate.Id
																AND IsDeleted = false
															  ORDER BY Is_Generic_Area__c, Order__c, Id ];
		
		for ( LRN_Exam_Area_Template__c area : lstAreaTemplates ) {
			mapKnowledges.put( area.Id, area );
			setAreas.add( area.Id );
		}

		String oldKnowledge = EMPTY_STRING;
		List<LRN_Exam_Detail_Template__c> lstKnowledge = new List<LRN_Exam_Detail_Template__c>();
		List<LRN_Exam_Detail_Template__c> lstAnswers = new List<LRN_Exam_Detail_Template__c>();
		Map<String,List<LRN_Exam_Detail_Template__c>> mapQuestionPerKnowledge = new Map<String,List<LRN_Exam_Detail_Template__c>>();
		Map<Id,List<LRN_Exam_Detail_Template__c>> mapAnswerPerQuestion = new Map<Id,List<LRN_Exam_Detail_Template__c>>();
		Id questionId = null;

		for ( LRN_Exam_Detail_Template__c examDetailTemplate : [ SELECT Id, Dificult__c, Has_Image_Question__c, Question__c, Question_Answer__c, Order__c,
																		Name, Value__c, LRN_Exam_Area_Template__c, LRN_Exam_Area_Template__r.Knowledge_Area__c
																   FROM LRN_Exam_Detail_Template__c
																  WHERE LRN_Exam_Area_Template__c IN :setAreas
																	AND IsDeleted = false
																  ORDER BY LRN_Exam_Area_Template__c,
																		   Question__c,
																		   Dificult__c,
																		   Order__c ] ) {
			if ( examDetailTemplate.Question__c == null ) {		// manage questions
				if ( !oldKnowledge.Equals( examDetailTemplate.LRN_Exam_Area_Template__r.Knowledge_Area__c + examDetailTemplate.Dificult__c ) ) {
					if ( !oldKnowledge.equals( EMPTY_STRING ) ) {
						mapQuestionPerKnowledge.put( oldKnowledge, lstKnowledge );
						lstKnowledge = new List<LRN_Exam_Detail_Template__c>();
					}
					oldKnowledge = examDetailTemplate.LRN_Exam_Area_Template__r.Knowledge_Area__c + examDetailTemplate.Dificult__c;
				}
				lstKnowledge.add( examDetailTemplate );
			} else {											// manage answers
				if ( questionId == null || questionId != examDetailTemplate.Question__c ) {
					if ( questionId != null ) {
						mapAnswerPerQuestion.put( questionId, lstAnswers );
						lstAnswers = new List<LRN_Exam_Detail_Template__c>();
					}
					questionId = examDetailTemplate.Question__c;
				}
				lstAnswers.add( examDetailTemplate );
			}
		}

		if ( !lstKnowledge.isEmpty() ) {
			mapQuestionPerKnowledge.put( oldKnowledge, lstKnowledge );
		}

		if ( !lstAnswers.isEmpty() ) {
			mapAnswerPerQuestion.put( questionId, lstAnswers);
		}

		List<LRN_Exam_Detail__c> questionsFinal = new List<LRN_Exam_Detail__c>();
		Integer orderQuestions = 1;
		Integer orderAnswers = 1;

		for ( LRN_Exam_Area_Template__c area : lstAreaTemplates ) {
			List<LRN_Exam_Detail_Template__c> questions = new List<LRN_Exam_Detail_Template__c>();		

			Integer numAreaQuestions = Math.round( numQuestion * area.Percent_of_Area_Questions__c / 100 );
			Integer numAreaEasyQuestions = Math.round( numEasyQuestions * area.Percent_of_Area_Questions__c / 100 );
			Integer numAreaHardQuestions = Math.round( numHardQuestions * area.Percent_of_Area_Questions__c / 100 );
			Integer numAreaMediumQuestions = Math.round( numMediumQuestions * area.Percent_of_Area_Questions__c / 100 );

			Integer missValue = (numAreaQuestions - (numAreaEasyQuestions + numAreaHardQuestions + numAreaMediumQuestions )) > 0 ? 1 : 0;

			//easy
			List<LRN_Exam_Detail_Template__c> questionsTMP = mapQuestionPerKnowledge.get( area.Knowledge_Area__c + DIFICULT_EASY );
			if ( questionsTMP != null && !questionsTMP.isEmpty() ) {
				for ( Integer valOrder : randomWithLimit( questionsTMP.size(), numAreaEasyQuestions + missValue ) ){
					questions.add( questionsTMP.get( valOrder ) );
				}
			}

			//medium
			questionsTMP = mapQuestionPerKnowledge.get( area.Knowledge_Area__c + DIFICULT_MEDIUM );
			if ( questionsTMP != null && !questionsTMP.isEmpty() ) {
				for ( Integer valOrder : randomWithLimit( questionsTMP.size(), numAreaMediumQuestions + missValue ) ){
					questions.add( questionsTMP.get( valOrder ) );
				}
			}

			//hard
			questionsTMP = mapQuestionPerKnowledge.get( area.Knowledge_Area__c + DIFICULT_HARD );
			if ( questionsTMP != null && !questionsTMP.isEmpty() ) {
				for ( Integer valOrder : randomWithLimit( questionsTMP.size(), numAreaHardQuestions + missValue ) ){
					questions.add( questionsTMP.get( valOrder ) );
				}
			}

			for ( Integer valOrder : randomWithLimit( questions.size(), numAreaQuestions ) ) {
				// insert question
				LRN_Exam_Detail_Template__c detailTMP = questions.get( valOrder );

				LRN_Exam_Detail__c newDetail = new LRN_Exam_Detail__c ( Exam__c = newExam.Id,
																		Question__c = detailTMP.Id,
																		Order__c = orderQuestions
																	  );
				questionsFinal.add( newDetail );

				// insert answers
				List<LRN_Exam_Detail_Template__c> lstDetail2TMP = mapAnswerPerQuestion.get( detailTMP.Id );

				orderAnswers = 1;
				if ( allowRandomAnswers ) {
					for ( Integer valOrder2 : randomWithLimit( lstDetail2TMP.size(), lstDetail2TMP.size() ) ) {
						LRN_Exam_Detail_Template__c detailTMP2 = lstDetail2TMP.get( valOrder2 ); 

						LRN_Exam_Detail__c newDetail2 = new LRN_Exam_Detail__c ( Exam__c = newExam.Id,
																				 Question__c = detailTMP2.Id,
																				 Order__c = orderAnswers
																			   );
						questionsFinal.add( newDetail2 );

						orderAnswers++;
					}
				} else {
					for ( LRN_Exam_Detail_Template__c detailTMP2 : lstDetail2TMP ) {
						LRN_Exam_Detail__c newDetail2 = new LRN_Exam_Detail__c ( Exam__c = newExam.Id,
																				 Question__c = detailTMP2.Id,
																				 Order__c = orderAnswers
																			   );
						questionsFinal.add( newDetail2 );

						orderAnswers++;
					}
				}

				orderQuestions++;
			}
		}
		
		upsert questionsFinal;

		return newExam.Id;
	}

	public static String uploadFile( Id currTemplateId, String csvBody) {
		Map<String,String> mapKnowledges = new Map<String,String>();
		List <String> lines = new List<String>();
		String returnValue = MSG_WRONG_TEMPLATE;

		// get template area details 
		List<LRN_Exam_Area_Template__c> lstAreaTemplates = [ SELECT Id, Knowledge_Area__c
															   FROM LRN_Exam_Area_Template__c 
															  WHERE LRN_Exam_Template__c = :currTemplateId
																AND IsDeleted = false
															  ORDER BY Is_Generic_Area__c, Order__c, Id ];
		
		for ( LRN_Exam_Area_Template__c area : lstAreaTemplates ) {
			mapKnowledges.put( area.Knowledge_Area__c, area.Id );
		}
	
		List<LRN_Exam_Detail_template__c> lstDetailTemplateQuestion  = new List<LRN_Exam_Detail_template__c>();
		Map<String,LRN_Exam_Detail_template__c> mapQuestionInsert = new Map<String,LRN_Exam_Detail_template__c>();

		LRN_Utils cvsReader = new LRN_Utils( csvBody );
		//Sheet
		String[] columns = cvsReader.readLine();
		//Header
		columns = cvsReader.readLine();

		if ( columns.size() > 6 && columns[HEADER_COL_IDENT] == HEADER_IDENT && columns[HEADER_COL_QA] == HEADER_QA && columns[HEADER_COL_QUEST_ANS] == HEADER_QUEST_ANS 
		  && columns[HEADER_COL_AREA] == HEADER_AREA && columns[HEADER_COL_VALUE] == HEADER_VALUE && columns[HEADER_COL_DESC] == HEADER_DESC 
		  && columns[HEADER_COL_DIFFIC] == HEADER_DIFFIC ) {	
			//body
			columns = cvsReader.readLine();

			String diffic = EMPTY_STRING;
			String area = EMPTY_STRING;
			while ( columns != null ) {
				if ( columns.size() > 6 ){	
					if (String.valueOf( columns[HEADER_COL_QA] ).equalsIgnoreCase( FILE_QUESTION_SYMBOL ) ) {

						area = ( columns[HEADER_COL_AREA] != null && columns[HEADER_COL_AREA] != EMPTY_STRING ) ? mapKnowledges.get( columns[HEADER_COL_AREA] ) : mapKnowledges.get( GENERIC_AREA ) ;
						if ( area == null || area == EMPTY_STRING ) {
							String message = String.format( MSG_INEXISTENT_AREA, new String[]{ columns[HEADER_COL_AREA] } );
							return message;
						} else if ( columns[HEADER_COL_QUEST_ANS] == null || columns[HEADER_COL_QUEST_ANS] == EMPTY_STRING ) {
							String message = String.format( MSG_QUESTION_MANDATORY, new String[]{ columns[HEADER_COL_IDENT] } );
							return message;
						} else if ( columns[HEADER_COL_DIFFIC] == null || columns[HEADER_COL_DIFFIC] == EMPTY_STRING ) {
							diffic = DIFICULT_MEDIUM;
						} else if ( columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_EASY ) || columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_MEDIUM ) || columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_HARD ) ) {
							diffic = columns[HEADER_COL_DIFFIC];
						} else {
							String message = String.format( MSG_PROBLEM_QUESTION, new String[]{ columns[HEADER_COL_IDENT] } );
							return message; 
						}

						LRN_Exam_Detail_template__c template = new LRN_Exam_Detail_template__c ( Id = null,
																								 Question_Answer__c = columns[HEADER_COL_QUEST_ANS],
																								 LRN_Exam_Area_Template__c = area,
																								 Value__c = false,
																								 Description__c = columns[HEADER_COL_DESC],
																								 Question__c = null,
																								 Dificult__c = diffic,
																								 Order__c = 0
																							   );
						mapQuestionInsert.put( columns[HEADER_COL_IDENT] , template);				
						lstDetailTemplateQuestion.add( template );
					}
				}
				columns = cvsReader.readLine();
			}
			try {
				upsert lstDetailTemplateQuestion;		
			} catch (Exception e) {
				return e.getMessage();
			}

			List<LRN_Exam_Detail_template__c> lstDetailTemplateAnswer  = new List<LRN_Exam_Detail_template__c>();
			String identifier = EMPTY_STRING;
			Integer counter=0;

			cvsReader = new LRN_Utils( csvBody );
			//sheet
			columns = cvsReader.readLine();
			//header
			columns = cvsReader.readLine();
			//body
			columns = cvsReader.readLine();
			while ( columns != null ) {
				if ( columns.size() > 6 ) {	
					if (String.valueOf( columns[HEADER_COL_QA] ).equalsIgnoreCase( FILE_ANSWER_SYMBOL ) ) {
						if ( !identifier.equalsIgnoreCase(columns[HEADER_COL_IDENT]) ){
							counter = 0;
							identifier = columns[HEADER_COL_IDENT];
						} 
						counter++;

						if( mapQuestionInsert.get(columns[HEADER_COL_IDENT]) == null ) {
							String message = String.format( MSG_PROBLEM_ANSWER, new String[]{ columns[HEADER_COL_IDENT] } );
							return message;
						} else if ( columns[HEADER_COL_QUEST_ANS] == null || columns[HEADER_COL_QUEST_ANS] == EMPTY_STRING ) {
							String message = String.format( MSG_ANSWER_MANDATORY, new String[]{ columns[HEADER_COL_IDENT] } );
							return message;
						} else if ( columns[HEADER_COL_DIFFIC] == null || columns[HEADER_COL_DIFFIC] == EMPTY_STRING ) {
							diffic = DIFICULT_MEDIUM;
						} else if ( columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_EASY ) || columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_MEDIUM ) 
								 || columns[HEADER_COL_DIFFIC].equalsIgnoreCase( DIFICULT_HARD ) ) {
							diffic = columns[HEADER_COL_DIFFIC];
						} else {
							String message = String.format( MSG_PROBLEM_QUESTION, new String[]{ columns[HEADER_COL_IDENT] } );
							return message; 
						}

						LRN_Exam_Detail_template__c template = new LRN_Exam_Detail_template__c ( Id = null,
																								 Question_Answer__c = columns[HEADER_COL_QUEST_ANS],
																								 LRN_Exam_Area_Template__c = mapQuestionInsert.get(columns[HEADER_COL_IDENT]).LRN_Exam_Area_Template__c,
																								 Value__c = columns[HEADER_COL_VALUE].equalsIgnoreCase( TRUE_STRING )? true: false,
																								 Description__c = columns[HEADER_COL_DESC],
																								 Question__c = mapQuestionInsert.get(columns[HEADER_COL_IDENT]).Id,
																								 Dificult__c = diffic,
																								 Order__c = counter
																							   );
						lstDetailTemplateAnswer.add( template );
					}
				}
				columns = cvsReader.readLine();
			}
			try {
				upsert lstDetailTemplateAnswer;
				returnValue = EMPTY_STRING;
			} catch (Exception e) {
				return e.getMessage();
			}
		} else {
			return MSG_WRONG_TEMPLATE;
		}
		return returnValue;
	}

	public static List<List<QuestionWrapper>> prepareReviewLists( List<LRN_Exam_Detail__c> lstQuest, List<LRN_Exam_Detail__c> lstAnswers ) {

		Map<Id, Boolean> mapResult = new Map<Id, Boolean>();
		List<QuestionWrapper> lstQuestionWrapper1 = new List<QuestionWrapper>();
		List<QuestionWrapper> lstQuestionWrapper2 = new List<QuestionWrapper>();
		List<QuestionWrapper> lstQuestionWrapper3 = new List<QuestionWrapper>();
		List<QuestionWrapper> lstQuestionWrapper4 = new List<QuestionWrapper>();
		List<QuestionWrapper> lstQuestionWrapper5 = new List<QuestionWrapper>();
		List<List<QuestionWrapper>> lstQuestionWrapperlst = new List<List<QuestionWrapper>>();
		Boolean withResults = false;

		if ( lstAnswers != null && !lstAnswers.isEmpty() ) {
			Id currId = null;
			Boolean resBool = true;
			for ( LRN_Exam_Detail__c ans : lstAnswers ) {
				if ( ans.Question__r.Question__c != currId ) {
					if (currId != null) {
						mapResult.put( currId, resBool );
					}
					resBool = true;
					currId = ans.Question__r.Question__c;
				}
				resBool = resBool && (ans.Value__c == ans.Question__r.Value__c);
			}
			mapResult.put( currId, resBool );
			withResults = true;
		}
		
		Integer totalQuestion = ( lstQuest == null || lstQuest.isEmpty() ) ? 0 : lstQuest.size();
		Integer quoci = Integer.valueOf( Math.floor( totalQuestion / 5 ));
		Integer resto = Math.mod( totalQuestion, 5 );
		Integer counter = 0;
		Integer counter2 = 0;
		Integer c1 = 0;
		Integer c2 = quoci + ( resto >= 1 ? 1 : 0 );
		Integer c3 = c2 + quoci + ( resto >= 2 ? 1 : 0 );
		Integer c4 = c3 + quoci + ( resto >= 3 ? 1 : 0 );
		Integer c5 = c4 + quoci + ( resto >= 4 ? 1 : 0 );

		while ( counter < totalQuestion && totalQuestion > 0 ) {
			if ( withResults ) 
				lstQuestionWrapper1.add( new QuestionWrapper( lstQuest.get(c1 + counter2 ), mapResult ) );
			else
				lstQuestionWrapper1.add( new QuestionWrapper( lstQuest.get(c1 + counter2 ) ) );
			counter++;
			if ( counter < totalQuestion )
				if ( withResults ) 
					lstQuestionWrapper2.add( new QuestionWrapper( lstQuest.get(c2 + counter2 ), mapResult ) );
				else
					lstQuestionWrapper2.add( new QuestionWrapper( lstQuest.get(c2 + counter2 ) ) );
			counter++;
			if ( counter < totalQuestion )
				if ( withResults ) 
					lstQuestionWrapper3.add( new QuestionWrapper( lstQuest.get(c3 + counter2 ), mapResult ) );
				else
					lstQuestionWrapper3.add( new QuestionWrapper( lstQuest.get(c3 + counter2 ) ) );
			counter++;
			if ( counter < totalQuestion )
				if ( withResults ) 
					lstQuestionWrapper4.add( new QuestionWrapper( lstQuest.get(c4 + counter2 ), mapResult ) );
				else
					lstQuestionWrapper4.add( new QuestionWrapper( lstQuest.get(c4 + counter2 ) ) );
			counter++;
			if ( counter < totalQuestion )
				if ( withResults ) 
					lstQuestionWrapper5.add( new QuestionWrapper( lstQuest.get(c5 + counter2 ), mapResult ) );
				else
					lstQuestionWrapper5.add( new QuestionWrapper( lstQuest.get(c5 + counter2 ) ) );
			counter++;
			counter2++;
		}
		
		lstQuestionWrapperlst.add( lstQuestionWrapper1 );
		lstQuestionWrapperlst.add( lstQuestionWrapper2 );
		lstQuestionWrapperlst.add( lstQuestionWrapper3 );
		lstQuestionWrapperlst.add( lstQuestionWrapper4 );
		lstQuestionWrapperlst.add( lstQuestionWrapper5 );

		return lstQuestionWrapperlst;
	}

	public String[] readLine() {
		if(buffer.size() == 0)
			return null;
		String line = this.buffer.remove(0);
		String[] parts = new String[] {};

		while(line != ''){
			Integer next = 0;
			if(line.startsWith('"')){
				line = line.substring(1);
				Integer quoteIndex = findQuote(line, 0);
				while(quoteIndex == -1){
					if(buffer.size() == 0){
						// EOT!
						quoteIndex = line.length();
					} else { 
						// grab the next line
						Integer skip = line.length();
						line += '\n' + this.buffer.remove(0);
						quoteIndex = findQuote(line, skip);
					}
				}
				// advance to comma
				next = quoteIndex + 1;
				parts.add(line.substring(0, quoteIndex).replace('""', '"'));
			} else {
				next = line.indexOf(this.delim, next);
				if(next == -1)
					next = line.length();
				parts.add(line.substring(0, next));
			}       
			if(next == line.length() - 1)
				parts.add('');
			line = next < line.length() ? line.substring(next+1) : '';
		}
		if(parts.size() == 0)
			parts.add('');
		return parts;
	}

	public static List<ChartDataWrapper> generateGraphData(String templateId) {
        List<ChartDataWrapper> data = new List<ChartDataWrapper>();

        List<LRN_Result__c> myListExam = LRN_Utils.getMyExamList( templateId );
        if ( !myListExam.isEmpty() ) {
	        for ( LRN_Result__c dt : myListExam ) {
	            data.add(new ChartDataWrapper(String.valueOf(dt.Start_Date__c), Double.valueOf(dt.Score_Evaluated__c)));
	        }
		}
        return data;
    }

	/** private Support Methods */
	private static Integer findQuote(String line, Integer skip) {
		Matcher m = QUOTE_PATTERN.matcher(line);
		m.region(skip, m.regionEnd());
		if(!m.find())
			return -1;
		return m.start();
	}

	private static List<Integer> randomWithLimit( Integer upperLimit, Integer numberOfRands ) {
		List<Integer> selected = new List<Integer>();
		Set<Integer> setSelected = new Set<Integer>();
		if ( upperLimit > 0 && numberOfRands > 0 ) {
			Integer count = 0;
			Integer count2 = 0;
			while ( count < numberOfRands && count2 < 1000 ){
				Integer rand = Math.mod( Math.round( Math.random() * 1000 ), upperLimit);
				if (!setSelected.contains( rand )) {
					selected.add( rand );
					setSelected.add( rand );
					count++;
				}
				count2++;
			}
		}

		return selected;
	}
 
	/** wrapper classes */
    public class ChartDataWrapper {
        public String name { get; set; }
        public Double data { get; set; }

        public ChartDataWrapper(String name, Double data) {
            this.name = name;
            this.data = data;
        }
    }

	public class QuestionWrapper {
		public Id idExame {get; set;}
		public Id idQuestion {get; set;}
		public Id idQuestionTemplate {get; set;}
		public Id idNextQuestion {get; set;}
		public Id idPreviousQuestion {get; set;}
		public Boolean isMarked {get; set;}
		public Boolean isAnswered {get; set;}
		public Boolean hasImage {get; set;}
		public String question {get; set;}
		public Integer questionNumber {get; set;}
		public Integer numCorrectAnswers {get; set;}
		public Integer numAnswered {get; set;}
		public List<AnswerWrapper> lstAnswers {get; set;}
		public Boolean isCorrect {get; set;}
		public List<AnswerWrapper> lstCorrectAnswers {get; set;}
		public Boolean isEvaluated {get; set;}

		public QuestionWrapper() {}

		public QuestionWrapper( LRN_Exam_Detail__c examQuestion, Map<Id, Id[]> mapFlowIds ) {
			this.idExame = examQuestion.Exam__c;
			this.idQuestion = examQuestion.Id;
			this.idQuestionTemplate = examQuestion.Question__c;
			this.idNextQuestion = mapFlowIds.get( examQuestion.Id )[1];
			this.idPreviousQuestion = mapFlowIds.get( examQuestion.Id )[0]; 
			this.isMarked = examQuestion.Is_Marked__c;
			this.question = examQuestion.Question__r.Question_Answer__c;
			this.questionNumber = Integer.valueOf(examQuestion.Order__c);
			this.lstAnswers = new List<AnswerWrapper>();
			this.lstCorrectAnswers = new List<AnswerWrapper>();
			this.numAnswered = 0;
			this.numCorrectAnswers = 0;
			this.isAnswered = examQuestion.is_Answered__c;
			this.isEvaluated = examQuestion.Is_Evaluated__c;

			for ( LRN_Exam_Detail__c answer : LRN_Utils.getTestExamAnswersByIdQuestion( idExame, idQuestionTemplate ) ) {
				AnswerWrapper var = new AnswerWrapper( answer, false );

				if ( answer.Value__c ) {
					this.numAnswered++;
				}
				if ( answer.Question__r.Value__c ) { 
					this.numCorrectAnswers++;
				}	
				this.lstAnswers.add( var );
			}

			for ( LRN_Exam_Detail__c correctAnswer : LRN_Utils.getTestExamCorrectAnswersByIdQuestion( idExame, idQuestionTemplate ) ) {
				if ( correctAnswer.Question__r.Description__c != null || correctAnswer.Question__r.Value__c ) {
					AnswerWrapper var = new AnswerWrapper( correctAnswer, true );				
					this.lstCorrectAnswers.add( var );
				}
			}
		}

		public QuestionWrapper( LRN_Exam_Detail__c examQuestion ) {
			this.idExame = examQuestion.Exam__c;
			this.idQuestion = examQuestion.Id;
			this.idQuestionTemplate = examQuestion.Question__c;
			this.isMarked = examQuestion.Is_Marked__c;
			this.question = examQuestion.Question__r.Question_Answer__c;
			this.questionNumber = Integer.valueOf(examQuestion.Order__c);
			this.isAnswered = examQuestion.is_Answered__c;
			this.isEvaluated = examQuestion.Is_Evaluated__c;
		}

		public QuestionWrapper( LRN_Exam_Detail__c examQuestion, Map<Id, Boolean> mapResult ) {
			this.idExame = examQuestion.Exam__c;
			this.idQuestion = examQuestion.Id;
			this.idQuestionTemplate = examQuestion.Question__c;
			this.questionNumber = Integer.valueOf(examQuestion.Order__c);
			this.isCorrect = mapResult.get( examQuestion.Question__c );
			this.isEvaluated = examQuestion.Is_Evaluated__c;
		}
	}
	
	public class AnswerWrapper {
		public Id idAnswer {get; set;}
		public Id idAnswerTemplate {get; set;}
		public Boolean isMarked {get; set;}
		public Boolean value {get; set;}
		public String answer {get; set;}
		public String labelAnswer {get; set;}
		public String description {get; set;}

		public AnswerWrapper( LRN_Exam_Detail__c examAnswer, Boolean withCorrectAns ) {
			this.idAnswer = examAnswer.Id;
			this.idAnswerTemplate = examAnswer.Question__c;
			this.isMarked = examAnswer.Is_Marked__c;
			this.answer = examAnswer.Question__r.Question_Answer__c;
			this.labelAnswer = String.fromCharArray( new List<Integer> { Integer.valueOf(64 + examAnswer.Order__c) } ) + POINT_STRING; 
			this.value = examAnswer.Value__c;
			if ( withCorrectAns ) {
				this.value = examAnswer.Question__r.Value__c;
				this.description = examAnswer.Question__r.Description__c;
				if ( this.description == null || this.description.Equals(EMPTY_STRING) ) {
					this.description = examAnswer.Question__r.Question_Answer__c;
				}
				if ( examAnswer.Question__r.Question__c == null ) {
					this.labelAnswer = EMPTY_STRING;
				}
			}
		}
	}

	public class FinalScoreWrapper {
		public String examinationResult {get; set;}
		public Integer totalCorrectEvaluated {get; set;}
		public Integer totalCorrect {get; set;}
		public Integer totalEvaluated {get; set;}
		public Integer total {get; set;}
		public Double percScore {get; set;}
		public Double percScoreEvaluated {get; set;}
		public List<FinalScoreDetailWrapper> lstDomainScore {get; set;}
		public String studentName {get; set;}
		public String examSize {get; set;}
		public String examName {get; set;}

		public FinalScoreWrapper( List<LRN_Exam_Detail__c> lstQuestions, Map<Id, Boolean> mapResult, LRN_Exam_Template__c currExamTemplate ) {
			//break list in sublists by area
			Id areaId = null;
			List<LRN_Exam_Detail__c> lstArea = new List<LRN_Exam_Detail__c> ();
			lstDomainScore = new List<FinalScoreDetailWrapper>();
			for ( LRN_Exam_Detail__c question : lstQuestions ){
				if ( question.Question__r.LRN_Exam_Area_Template__c != areaId ) {
					if ( !lstArea.isEmpty() ) {
						lstDomainScore.add( new FinalScoreDetailWrapper( lstArea, mapResult, currExamTemplate ) );
					}
					lstArea = new List<LRN_Exam_Detail__c>();
					areaId = question.Question__r.LRN_Exam_Area_Template__c;
				}
				lstArea.add( question );
			}
			if ( !lstArea.isEmpty() ) {
				lstDomainScore.add( new FinalScoreDetailWrapper( lstArea, mapResult, currExamTemplate ) );
			}

			// calculate final values based on partial ones
			this.total = 0 ;
			this.totalCorrect = 0;
			this.totalEvaluated = 0;
			this.totalCorrectEvaluated = 0;
			for ( FinalScoreDetailWrapper wrappDetail : lstDomainScore ) {
				this.total += wrappDetail.total ;
				this.totalCorrect += wrappDetail.totalCorrect;
				this.totalEvaluated += wrappDetail.totalEvaluated;
				this.totalCorrectEvaluated += wrappDetail.totalCorrectEvaluated;
			}
			this.percScore = Double.valueOf(this.totalCorrect) / Double.valueOf( this.total == 0? 0.01 : this.total ) * 100;
			this.percScoreEvaluated = Double.valueOf(this.totalCorrectEvaluated) / Double.valueOf( this.totalEvaluated == 0? 0.01 : this.totalEvaluated ) * 100;

			this.examinationResult = this.percScoreEvaluated >= currExamTemplate.Approval__c ? EXAM_RESULT_PASS : EXAM_RESULT_FAIL;
		}

		public FinalScoreWrapper( Double score, String examName, String eSize, String name ) {
			this.percScore = score;
			this.studentName = name;
			this.examSize = eSize;
			this.examName = examName;
		}

		public FinalScoreWrapper( LRN_Result__c result, List<LRN_Result_Detail__c> lstResultDetail ) {


			this.examinationResult = result.Result__c;
			this.totalCorrectEvaluated = Integer.valueOf(result.Num_Correct_Evaluated__c);
			this.totalCorrect = Integer.valueOf(result.Num_Correct_Questions__c);
			this.totalEvaluated = Integer.valueOf(result.Num_Questions_Evaluated__c);
			this.total = Integer.valueOf(result.Num_Questions__c);
			this.percScore = result.Score_Total__c;
			this.percScoreEvaluated = result.Score_Evaluated__c;
			this.examSize = result.Exam_Size__c;
			this.lstDomainScore = new List<FinalScoreDetailWrapper>(); 

			if (!lstResultDetail.isEmpty() && lstResultDetail != null ) {
				for ( LRN_Result_Detail__c resDetail : lstResultDetail ) {
					this.lstDomainScore.add( new FinalScoreDetailWrapper( resDetail ) );
				}
			}
		}
	}

	public class FinalScoreDetailWrapper {
		public String domainResult {get; set;}
		public String domainName {get; set;}
		public Integer totalCorrectEvaluated {get; set;}
		public Integer totalCorrect {get; set;}
		public Integer totalEvaluated {get; set;}
		public Integer total {get; set;}
		public Double percScore {get; set;}
		public Double percScoreEvaluated {get; set;}

		public FinalScoreDetailWrapper( List<LRN_Exam_Detail__c> lstQuestions, Map<Id, Boolean> mapResult, LRN_Exam_Template__c currExamTemplate ) {
			this.total = 0 ;
			this.totalCorrect = 0;
			this.totalEvaluated = 0;
			this.totalCorrectEvaluated = 0;
			this.domainName = EMPTY_STRING;
			for ( LRN_Exam_Detail__c question : lstQuestions ) {
				if ( domainName.equals( EMPTY_STRING ) ) {
					this.domainName = question.Question__r.LRN_Exam_Area_Template__r.Knowledge_Area__c;
				}
				this.total++;
				if ( question.Is_Evaluated__c ) {
					this.totalEvaluated++;
				}

				if( mapResult.get( question.Question__c ) ) {
					this.totalCorrect++;
					if ( question.Is_Evaluated__c ) {
						this.totalCorrectEvaluated++;
					}
				}
			}
			this.percScore = Double.valueOf( this.totalCorrect ) / Double.valueOf( this.total == 0? 0.01 : this.total ) * 100;
			this.percScoreEvaluated = Double.valueOf( this.totalCorrectEvaluated ) / Double.valueOf( this.totalEvaluated == 0? 0.01 : this.totalEvaluated ) * 100;
			if( this.percScoreEvaluated >= currExamTemplate.Approval__c + 10 ) {
				this.domainResult = DOMAIN_RESULT_PROFICIENT;
			} else if( this.percScoreEvaluated <= currExamTemplate.Approval__c - 10 ) {
				this.domainResult = DOMAIN_RESULT_BELLOW_PROFICIENT;
			} else {
				this.domainResult = DOMAIN_RESULT_MODER_PROFICIENT; 
			}
		}

		public FinalScoreDetailWrapper( LRN_Result_Detail__c resultDetail ) {

			this.domainResult = resultDetail.Proficiency__c;
			this.domainName = resultDetail.Knowledge_Area__c;
			this.totalCorrectEvaluated = Integer.valueOf(resultDetail.Num_Correct_Evaluated__c);
			this.totalCorrect = Integer.valueOf(resultDetail.Num_Correct_Questions__c);
			this.totalEvaluated = Integer.valueOf(resultDetail.Num_Questions_Evaluated__c);
			this.total = Integer.valueOf(resultDetail.Num_Questions__c);
			this.percScore = resultDetail.Score_Total__c;
			this.percScoreEvaluated = resultDetail.Score_Evaluated__c;
		}
	}
}