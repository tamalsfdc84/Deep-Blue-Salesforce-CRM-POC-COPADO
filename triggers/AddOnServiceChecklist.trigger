trigger AddOnServiceChecklist on tffa__AddOnServiceChecklist__c(before insert, before update) {
  for (tffa__AddOnServiceChecklist__c addonServChecklistObj : Trigger.new) {
    tffa__AddOnServiceChecklist__c addonServCheckObj = CZWTFCHelperRepository.fetchAddOnServListByName(
      addonServChecklistObj.Name,
      addonServChecklistObj.tffa__ExternalId__c
    );
    if (addonServCheckObj == null) {
      addonServChecklistObj.tffa__ExternalId__c = addonServChecklistObj.Name;
    } else {
      addonServChecklistObj.addError('Name should be unique.');
    }
  }
}