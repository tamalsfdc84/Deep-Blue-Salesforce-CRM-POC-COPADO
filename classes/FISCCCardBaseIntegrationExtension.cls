public inherited sharing class FISCCCardBaseIntegrationExtension {
  public FISCCCardBaseIntegrationExtension() {
  }

  public static Object invokeGenerateCardNo(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getGenerateCardNoRequest(partyObj, accPref, charterConfig);
    tffa.Logger.debug('getGenerateCardNoRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeGenerateCardNo ==>' + result);
    return result;
  }

  public static Object invokeCardCreation(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getCardCreationRequest(partyObj, accPref, appObj, charterConfig);
    tffa.Logger.debug('getCardCreationRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeCardCreation ==>' + result);
    return result;
  }

  public static Object invokeCardToAccRelation(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getCardToCustRelationRequest(partyObj, accPref, appObj);
    tffa.Logger.debug('getCardToAccRelationRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeCardToAccRelation ==>' + result);
    return result;
  }

  public static Object invokeupdateCustomerDemographics(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getUpdateCustDemographicsRequest(partyObj, accPref, appObj);
    tffa.Logger.debug('getUpdateCustDemographicsRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeupdateCustomerDemographics ==>' + result);
    return result;
  }
}