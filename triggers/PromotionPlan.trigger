trigger PromotionPlan on tffa__PromotionPlan__c(before insert, before update) {
  for (tffa__PromotionPlan__c promoPlan : Trigger.new) {
    tffa__Promotion__c promoObj = CZWTFCHelperRepository.fetchpromoById(promoPlan.tffa__Promotion__c);

    String externalId = promoObj.tffa__Code__c + '_' + promoPlan.Name;
    tffa__PromotionPlan__c promoPlanobj = CZWTFCHelperRepository.fetchPromoPlan(promoObj.Id, externalId, promoPlan.Name);
    if (promoPlanobj == null) {
      promoPlan.tffa__ExternalId__c = externalId;
    } else {
      promoPlan.addError('Promotion Plan name should be unique within promotion.');
    }
  }

}