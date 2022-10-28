public inherited sharing class FISIDVProvider {
  public static FISIDVResponseDTO doIdentityVerification(tffa__Party__c partyObj) {
    FISIDVResponseDTO result = null;

    String strDeveloperName = 'IdentityVerification';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);

      tffa.logger.debug('partyObj' + partyObj);
      if (partyObj != null) {
        result = (FISIDVResponseDTO) FISIDVServiceExtension.doIDVApiCall(partyObj, adapterConfig, charterConfig);
        tffa.logger.debug('result from doIdentityVerification provider :: ' + result);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in doIdentityVerification : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result from doIdentityVerification provider :: ' + result);
    return result;
  }
}