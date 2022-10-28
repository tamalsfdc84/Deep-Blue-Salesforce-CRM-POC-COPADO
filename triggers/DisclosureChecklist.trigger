trigger DisclosureChecklist on tffa__DisclosureChecklist__c(before insert, before update) {
  for (tffa__DisclosureChecklist__c DisclosureChecklistObj : Trigger.new) {
    tffa__DisclosureChecklist__c disclosureObj = CZWTFCHelperRepository.fetchdiscCheckListByName(
      DisclosureChecklistObj.Name,
      DisclosureChecklistObj.tffa__ExternalId__c
    );
    if (disclosureObj == null) {
      DisclosureChecklistObj.tffa__ExternalId__c = DisclosureChecklistObj.Name;
    } else {
      DisclosureChecklistObj.addError('Name should be unique.');
    }
  }
}