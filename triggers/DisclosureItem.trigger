trigger DisclosureItem on tffa__DisclosureItem__c(before insert, before update) {
  for (tffa__DisclosureItem__c disclosureItemObj : Trigger.new) {
    String externalId;

    tffa__DisclosureChecklist__c disclosureCheckListObj = CZWTFCHelperRepository.fetchdiscCheckListById(
      disclosureItemObj.tffa__Checklist__c
    );

    externalId = disclosureCheckListObj.Name + '_' + disclosureItemObj.Name;

    tffa__DisclosureItem__c disclosureItemObject = CZWTFCHelperRepository.fetchdiscTempByExtId(externalId, disclosureItemObj.Name);

    if (disclosureItemObject == null) {
      disclosureItemObj.tffa__ExternalId__c = externalId;
    } else {
      disclosureItemObj.addError('Combination of Disclosure Checklist Name and Disclosure Item Name should be unique.');
    }
  }
}