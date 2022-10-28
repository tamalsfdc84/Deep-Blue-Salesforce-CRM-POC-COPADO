trigger AddOnService on tffa__AddOnService__c(before insert, before update) {
  for (tffa__AddOnService__c addOnService : Trigger.new) {
    addOnService.tffa__ExternalId__c = addOnService.tffa__Code__c;
  }
}