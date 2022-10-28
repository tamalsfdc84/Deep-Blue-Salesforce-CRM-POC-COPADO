trigger ApplicationDecisionMat on tffa__ApplicationDecisionMatrix__c(before insert, before update) {
  for (tffa__ApplicationDecisionMatrix__c appDecisionMatrix : Trigger.new) {
    tffa__ApplicationDecisionMatrix__c appDecObj = CZWTFCHelperRepository.fetchAppDecMatBySort(
      appDecisionMatrix.tffa__SortOrder__c,
      appDecisionMatrix.tffa__ExternalId__c
    );
    if (appDecObj == null) {
      appDecisionMatrix.tffa__ExternalId__c = String.valueOf(appDecisionMatrix.tffa__SortOrder__c);
    } else {
      appDecisionMatrix.addError('Sort order should be Unique');
    }
  }
}