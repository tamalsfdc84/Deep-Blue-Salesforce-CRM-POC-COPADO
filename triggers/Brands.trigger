trigger Brands on tffa__Brand__c(before insert, before update) {
  for (tffa__Brand__c brandObj : Trigger.new) {
    brandObj.tffa__ExternalId__c = brandObj.tffa__Code__c;

    // if(Trigger.isUpdate){
    //   tffa__Brand__c brandObjOld = CZWTFCHelperRepository.fetchBrandById(brandObj.Id);

    //   if(!(brandObj.tffa__Code__c).equals(brandObjOld.tffa__Code__c)){
    //     List<SubBrand__c> subbrandObjList =CZWTFCHelperRepository.fetchSubBrandByBrand(brandObj.Id);
    //     List<SubBrand__c> subBrandUpdatedList = new List<SubBrand__c>();
    //     for(SubBrand__c subBrandObj:subbrandObjList){
    //       subBrandObj.tffa__ExternalId__c = brandObj.tffa__Code__c+'_'+subBrand.Name;
    //       subBrandUpdatedList.add(subBrandObj);
    //     }
    //     CZWTFCHelperRepository.savesubBrand(subBrandUpdatedList);

    //     List<tffa__BrandLocation__c> brandLocObjList =CZWTFCHelperRepository.fetchBrandLocByBrand(brandObj.Id);
    //     tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationById(brandLoc.tffa__Location__c);
    //     List<tffa__BrandLocation__c> brandLocUpdatedList = new List<tffa__BrandLocation__c>();
    //     for(tffa__BrandLocation__c brandLocObj:brandLocObjList){
    //       brandLocObj.tffa__ExternalId__c = brandObj.tffa__Code__c+'_'+locObj.tffa__Code__c;
    //       brandLocUpdatedList.add(brandLocObj);
    //     }

    //     CZWTFCHelperRepository.saveBrandLoc(brandLocUpdatedList);
    //   }
    // }
  }
}