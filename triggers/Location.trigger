trigger Location on tffa__Location__c(before insert, before update) {
  for (tffa__Location__c locObj : Trigger.new) {
    Boolean reject = false;
    locObj.tffa__ExternalId__c = locObj.tffa__Code__c;
    //if(Trigger.IsInsert){
    List<tffa__Location__c> locationObjLst = CZWTFCHelperRepository.fetchLocationByAddAndCode(
      locObj.tffa__Address__c,
      locObj.tffa__Code__c
    ); //code location ignore
    if (locationObjLst != null && locationObjLst.size() > 0) {
      locObj.addError('Address already in use. It should be unique for each location');
    } else if (locObj.tffa__Address__c != null) {
      tffa__Address__c addObj = CZWTFCHelperRepository.fetchAddById(locObj.tffa__Address__c);
      tffa__Address__c addObjByExtId = CZWTFCHelperRepository.fetchAddByExtId(locObj.tffa__Code__c);
      if (
        addObj != null &&
        addObj.tffa__ExternalId__c != null &&
        addObjByExtId != null &&
        String.isNotBlank(locObj.tffa__Code__c) &&
        !(addObj.tffa__ExternalId__c).equalsIgnoreCase(locObj.tffa__Code__c)
      ) {
        addObj.tffa__ExternalId__c = locObj.tffa__Code__c;
      } else if (addObj != null && addObjByExtId == null) {
        addObj.tffa__ExternalId__c = locObj.tffa__Code__c;
      }
      CZWTFCHelperRepository.saveAddress(new List<tffa__Address__c>{ addObj });
    }
  }
  //}

  //     if(Trigger.isUpdate){
  //       tffa__Location__c locationObj = CZWTFCHelperRepository.fetchLocationById(locObj.Id);
  //       if(!locationObj.tffa__Code__c.equals(locObj.tffa__Code__c)){
  //         tffa__Address__c addObj = CZWTFCHelperRepository.fetchAddById(locObj.tffa__Address__c);
  //         tffa__Address__c addObjByExtId = CZWTFCHelperRepository.fetchAddByExtId(locationObj.tffa__Code__c);
  //         if(addObjByExtId == null){
  //           addObj.tffa__ExternalId__c = locObj.tffa__Code__c;
  //           CZWTFCHelperRepository.saveAddress(new List<tffa__Address__c>{addObj});
  //        }else{
  //         addObjByExtId.tffa__ExternalId__c ='';
  //         addObj.tffa__ExternalId__c = locObj.tffa__Code__c;
  //         CZWTFCHelperRepository.saveAddress(new List<tffa__Address__c>{addObjByExtId,addObj});
  //        }

  //        List<tffa__BrandLocation__c> brandLocObjList = CZWTFCHelperRepository.fetchBrandLocByLoc(locObj.Id);
  //        tffa__Brand__c brandObj = CZWTFCHelperRepository.fetchBrandById(brandLoc.tffa__Brand__c);
  //        List<tffa__BrandLocation__c> brandLocUpdatedList = new List<tffa__BrandLocation__c>();
  //       for(tffa__BrandLocation__c brandLocObj:brandLocObjList){
  //         brandLocObj.tffa__ExternalId__c = brandObj.tffa__Code__c+'_'+locObj.tffa__Code__c;
  //         brandLocUpdatedList.add(brandLocObj);
  //       }
  //     CZWTFCHelperRepository.saveBrandLoc(brandLocUpdatedList);

  //     }
  //   }
}