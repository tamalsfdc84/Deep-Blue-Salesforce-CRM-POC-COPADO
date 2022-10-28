trigger DisclosureTemplate on tffa__DisclosureTemplate__c(before insert, before update) {
  for (tffa__DisclosureTemplate__c disclosureTemp : Trigger.new) {
    disclosureTemp.tffa__ExternalId__c = disclosureTemp.tffa__Code__c;
  }
}