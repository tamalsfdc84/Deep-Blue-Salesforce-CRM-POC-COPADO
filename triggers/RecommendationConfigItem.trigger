trigger RecommendationConfigItem on tffa__RecommendationConfigurationItem__c(before insert, before update) {
  for (tffa__RecommendationConfigurationItem__c recommendItem : Trigger.new) {
    tffa__RecommendationConfiguration__c recommendObj = CZWTFCHelperRepository.fetchRecommendConfigById(
      recommendItem.tffa__Configuration__c
    );

    tffa__Product__c product = CZWTFCHelperRepository.fetchProductById(recommendItem.tffa__Product__c);

    String externalId = recommendObj.Name + '_' + product.tffa__Code__c;

    tffa__RecommendationConfigurationItem__c recObj = CZWTFCHelperRepository.fetchRecommendItemByExtId(
      externalId,
      recommendItem.tffa__Configuration__c
    );

    if (recObj == null) {
      recommendItem.tffa__ExternalId__c = externalId;
    } else {
      recommendItem.addError('Combination of RecommendationConfiguration Name and Recommeneded Product should be unique');
    }
  }
}