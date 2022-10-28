trigger ProductProductXref on tffa__ProductProductXref__c(before insert, before update) {
  for (tffa__ProductProductXref__c prodProdObj : Trigger.new) {
    tffa__Product__c product = CZWTFCProductRepository.fetchProductById(prodProdObj.tffa__Product__c);
    String externalId = product.tffa__Code__c + '_' + prodProdObj.tffa__RelatedProductCode__c;
    tffa__ProductProductXref__c prodProdObject = CZWTFCHelperRepository.fetchProdXrefById(externalId, prodProdObj.Name);
    if (prodProdObject == null) {
      prodProdObj.tffa__ExternalId__c = externalId;
    } else {
      prodProdObj.addError('Combination of bundle code and related product should be unique.');
    }
  }
}