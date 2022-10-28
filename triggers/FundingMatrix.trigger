trigger FundingMatrix on tffa__FundingMatrix__c(before insert, before update) {
  for (tffa__FundingMatrix__c fundMatrix : Trigger.new) {
    tffa__Product__c product = CZWTFCHelperRepository.fetchProductById(fundMatrix.tffa__Product__c);
    String externalId = null;
    if (fundMatrix.tffa__ChannelSet__c == null) {
      externalId = product.tffa__Code__c + '_' + fundMatrix.tffa__Type__c;
    } else {
      externalId = product.tffa__Code__c + '_' + fundMatrix.tffa__Type__c + '_' + fundMatrix.tffa__ChannelSet__c;
    }
    tffa__FundingMatrix__c fundMat = CZWTFCHelperRepository.fetchfundMatByextId(
      externalId,
      fundMatrix.tffa__Type__c,
      fundMatrix.tffa__ChannelSet__c
    );
    if (fundMat == null) {
      fundMatrix.tffa__ExternalId__c = externalId;
    } else {
      fundMatrix.addError('Combination of product, funding type and channelset should be Unique');
    }
  }
}