trigger LRN_Exam_Detail_Template_Before on LRN_Exam_Detail_Template__c ( before insert, before update, before delete) {

	if(Trigger.isUpdate){
		Map<Id, Id> mapQuestionIdChange = new Map<Id, Id>();
		Set<Id> setQuestionIdChange = new Set<Id>();

		for ( LRN_Exam_Detail_Template__c newDetailTemplate : Trigger.new ) {
			if ( newDetailTemplate.Question__c == null ) {
				LRN_Exam_Detail_Template__c oldDetailTemplate = Trigger.oldMap.get( newDetailTemplate.id ); 
				if ( oldDetailTemplate.LRN_Exam_Area_Template__c != newDetailTemplate.LRN_Exam_Area_Template__c ) {
					mapQuestionIdChange.put( oldDetailTemplate.Id, newDetailTemplate.LRN_Exam_Area_Template__c );
					setQuestionIdChange.add( oldDetailTemplate.Id );
				}
			}
		}

		if ( !setQuestionIdChange.isEmpty() ) {
			List<LRN_Exam_Detail_Template__c> lstAnswerTemplate = [ SELECT Id, Question__c, LRN_Exam_Area_Template__c
																	  FROM LRN_Exam_Detail_Template__c
																	 WHERE Question__c IN :setQuestionIdChange 
																	 ORDER BY Question__c ];
																	 
			if ( lstAnswerTemplate != null && !lstAnswerTemplate.isEmpty() ) {
				for ( LRN_Exam_Detail_Template__c answerTemplate : lstAnswerTemplate ) {
					answerTemplate.LRN_Exam_Area_Template__c = mapQuestionIdChange.get( answerTemplate.Question__c );
				}
				update lstAnswerTemplate;
			}
		}
	}
}