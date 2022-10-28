trigger RecommendationConfiguration on tffa__RecommendationConfiguration__c(before insert, before update) {
  for (tffa__RecommendationConfiguration__c recommendationConfig : Trigger.new) {
    tffa__RecommendationConfiguration__c recommendObj = CZWTFCHelperRepository.fetchRecommendConfigByName(
      recommendationConfig.Name,
      recommendationConfig.tffa__ExternalId__c
    );
    if (recommendObj == null) {
      recommendationConfig.tffa__ExternalId__c = recommendationConfig.Name;
    } else {
      recommendationConfig.addError('Name should be unique.');
    }
  }
}