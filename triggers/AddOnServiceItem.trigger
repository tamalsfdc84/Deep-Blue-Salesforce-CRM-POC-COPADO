trigger AddOnServiceItem on tffa__AddOnServiceItem__c(before insert, before update) {
  for (tffa__AddOnServiceItem__c addOnService : Trigger.new) {
    tffa__AddOnServiceChecklist__c addonServCheckObj = CZWTFCHelperRepository.fetchAddOnServListById(addOnService.tffa__Checklist__c);

    tffa__AddOnService__c AddOnServiceObj = CZWTFCHelperRepository.fetchAddOnServById(addOnService.tffa__Service__c);

    String externalId = addonServCheckObj.Name + '_' + AddOnServiceObj.tffa__Code__c;

    tffa__AddOnServiceItem__c addOnServItemObj = CZWTFCHelperRepository.fetchAddOnServiceItemByExtId(
      externalId,
      addOnService.tffa__Service__c
    );

    if (addOnServItemObj == null) {
      addOnService.tffa__ExternalId__c = externalId;
    } else {
      addOnService.addError('Combination of addOnServiceChecklist Name and addOnService Code should be unique');
    }
  }
}