trigger ProductMatrix on tffa__ProductMatrix__c(before insert, before update) {
  for (tffa__ProductMatrix__c ProdMatObj : Trigger.new) {
    tffa__Product__c product = CZWTFCProductRepository.fetchProductById(ProdMatObj.tffa__Product__c);
    String externalId = product.tffa__Code__c + '_' + ProdMatObj.tffa__SortOrder__c;
    tffa__ProductMatrix__c prodMatObject = CZWTFCHelperRepository.fetchProdMatById(
      externalId,
      ProdMatObj.tffa__Product__c,
      ProdMatObj.tffa__SortOrder__c
    );
    if (prodMatObject == null) {
      ProdMatObj.tffa__ExternalId__c = externalId;
    } else {
      ProdMatObj.addError('Combination of bundle code and related product should be unique.');
    }
  }
}