trigger ProductTerm on tffa__ProductTerm__c(before insert, before update) {
  for (tffa__ProductTerm__c term : Trigger.new) {
    tffa__Product__c product = CZWTFCProductRepository.fetchProductById(term.tffa__Product__c);
    term.tffa__ExternalId__c = product.tffa__Code__c + '_' + term.tffa__Code__c;
  }
}