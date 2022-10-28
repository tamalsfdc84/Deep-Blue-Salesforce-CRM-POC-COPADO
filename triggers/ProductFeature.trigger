trigger ProductFeature on tffa__ProductFeature__c(before insert, before update) {
  for (tffa__ProductFeature__c feature : Trigger.new) {
    tffa__Product__c product = CZWTFCProductRepository.fetchProductById(feature.tffa__Product__c);
    String externalID = product.tffa__Code__c + '_' + feature.name;
    tffa__ProductFeature__c prodFeat = CZWTFCProductRepository.fetchProductFeatByExternalId(externalID, feature.Name);
    if (prodFeat == null) {
      feature.tffa__ExternalId__c = externalID;
    } else {
      feature.addError('Feature Name should be Unique within a product.');
    }
  }
}