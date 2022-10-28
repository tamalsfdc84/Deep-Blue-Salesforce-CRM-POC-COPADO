trigger SubBrand on SubBrand__c(before update) {
  for (SubBrand__c subBrand : Trigger.new) {
    tffa__Brand__c brandObj = CZWTFCHelperRepository.fetchBrandById(subBrand.Brand__c);
    String externalId = brandObj.tffa__Code__c + '_' + subBrand.Name;
    SubBrand__c fetchedSubBrand = CZWTFCHelperRepository.fetchSubBrandByextId(externalId, subBrand.Name);
    if (fetchedSubBrand == null) {
      subBrand.ExternalId__c = externalId;
    } else {
      subBrand.addError('Sub Brand Name should be Unique');
    }
  }
}