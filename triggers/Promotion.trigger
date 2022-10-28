trigger Promotion on tffa__Promotion__c(before insert, before update) {
  for (tffa__Promotion__c promoObj : Trigger.new) {
    promoObj.tffa__ExternalId__c = promoObj.tffa__Code__c;

    // if(Trigger.isUpdate){
    //   tffa__Promotion__c promotionObj= CZWTFCHelperRepository.fetchpromoById(promoObj.Id);

    //   if(!(promotionObj.tffa__Code__c).equals(promoObj.tffa__Code__c)){
    //     List<tffa__PromotionPlan__c> promoPlanList =CZWTFCHelperRepository.fetchPromoPlanByPromo(promoObj.Id);
    //     List<tffa__PromotionPlan__c> promoPlanUpdatedList = new List<tffa__PromotionPlan__c>();
    //     for(tffa__PromotionPlan__c promoPlanObj:promoPlanList){
    //       promoPlanObj.ExternalId__c = promoObj.tffa__Code__c+'_'+promoPlanObj.Name;
    //       promoPlanUpdatedList.add(promoPlanObj);
    //     }
    //     CZWTFCHelperRepository.savePromoPlan(promoPlanUpdatedList);
    //   }
    // }
  }
}