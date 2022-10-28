trigger Product on tffa__Product__c(before insert, before update) {
  for (tffa__Product__c product : Trigger.new) {
    product.tffa__ExternalId__c = product.tffa__Code__c;
  }
}