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

  public static Object invokeGenerateDepositOrigination(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getDepositOriginationRequest(partyObj, accPref, appObj, charterConfig);
    tffa.Logger.debug('getDepositOriginationRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeGenerateDepositOrigination ==>' + result);
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

  public static Object invokeExpediteCardShipping(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = FISCCCardBaseIntegrationHelper.getExpediteDeliveryRequest(partyObj, accPref, appObj, charterConfig);
    tffa.Logger.debug('getExpediteDeliveryRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokeExpediteCardShipping ==>' + result);
    return result;
  }
}