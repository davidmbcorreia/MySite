trigger LRN_Exam_Template_After on LRN_Exam_Template__c (after insert) {
	if(Trigger.isInsert){
		List<LRN_Exam_Area_Template__c> lstAreas = new List<LRN_Exam_Area_Template__c>();

		for ( LRN_Exam_Template__c newTemplate : Trigger.new ) {
			LRN_Exam_Area_Template__c area = new LRN_Exam_Area_Template__c( Knowledge_Area__c = LRN_Utils.GENERIC_AREA,
																			LRN_Exam_Template__c = newTemplate.Id,
																			Percent_of_Area_Questions__c = 0,
																			Is_Generic_Area__c = true,
																			Order__c = 0 );
			lstAreas.add( area );
		}

		if ( !lstAreas.isEmpty() ) {
			insert lstAreas;
		}
	}
}