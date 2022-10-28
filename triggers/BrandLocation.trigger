trigger BrandLocation on tffa__BrandLocation__c(before insert, before update) {
  for (tffa__BrandLocation__c brandLoc : Trigger.new) {
    tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationById(brandLoc.tffa__Location__c);
    tffa__Brand__c brandObj = CZWTFCHelperRepository.fetchBrandById(brandLoc.tffa__Brand__c);

    if (locObj != null && brandObj != null) {
      brandLoc.tffa__ExternalId__c = brandObj.tffa__Code__c + '_' + locObj.tffa__Code__c;
    }
  }
}