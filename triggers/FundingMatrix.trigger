trigger FundingMatrix on tffa__FundingMatrix__c(before insert, before update) {
  for (tffa__FundingMatrix__c fundMatrix : Trigger.new) {
    tffa__Product__c product = null;
    if (fundMatrix.tffa__Product__c != null) {
      product = CZWTFCHelperRepository.fetchProductById(fundMatrix.tffa__Product__c);
    }
    String externalId = fundMatrix.tffa__Type__c;

    if (product != null) {
      externalId = externalId + '_' + product.tffa__Code__c;
    }
    if (fundMatrix.tffa__ChannelSet__c != null) {
      externalId = externalId + '_' + fundMatrix.tffa__ChannelSet__c;
    }

    externalId = externalId + '_' + String.valueOf(fundMatrix.tffa__SortOrder__c);

    tffa__FundingMatrix__c fundMat = CZWTFCHelperRepository.fetchfundMatByextId(
      externalId,
      fundMatrix.tffa__Type__c,
      fundMatrix.tffa__ChannelSet__c,
      fundMatrix.tffa__SortOrder__c
    );
    if (fundMat == null) {
      fundMatrix.tffa__ExternalId__c = externalId;
    } else {
      fundMatrix.addError('Combination of product, funding type, channelset and sort order should be Unique');
    }
  }
}