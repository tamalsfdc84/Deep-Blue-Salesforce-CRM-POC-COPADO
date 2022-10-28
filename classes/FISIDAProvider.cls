public inherited sharing class FISIDAProvider {
  public static FISIDAResponseDTO fetchOOWQuestions(tffa__Party__c partyObj) {
    FISIDAResponseDTO result = null;

    String strDeveloperName = 'IDAFetchOOWQ';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);

      tffa.logger.debug('partyObj' + partyObj);
      if (partyObj != null) {
        result = (FISIDAResponseDTO) FISIDAServiceExtension.getOOWQuestions(partyObj, adapterConfig, charterConfig);
        tffa.logger.debug('result from fetchOOWQuestions provider :: ' + result);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in fetchOOWQuestions : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result from fetchOOWQuestions provider :: ' + result);
    return result;
  }

  public static FISIDAResponseDTO verifyOOWQuestions(tffa__Party__c partyObj, tffa__DueDiligence__c dd) {
    FISIDAResponseDTO result = null;

    String strDeveloperName = 'IDAVerifyOOWQ';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);

      tffa.logger.debug('partyObj' + partyObj);
      if (partyObj != null) {
        result = (FISIDAResponseDTO) FISIDAServiceExtension.verifyOOWAnswers(partyObj, adapterConfig, charterConfig, dd);
        tffa.logger.debug('result from fetchOOWQuestions provider :: ' + result);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in fetchOOWQuestions : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result from fetchOOWQuestions provider :: ' + result);
    return result;
  }
}