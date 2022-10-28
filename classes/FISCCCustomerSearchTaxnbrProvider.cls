public with sharing class FISCCCustomerSearchTaxnbrProvider {
  //Search by Taxbr
  private static void buildData(String submissionId) {
    FISCCIntegrationLogService.setSubmissionObj(submissionId);
    if (FISCCIntegrationLogService.submissionObj == null) {
      throw new tffa.ApplicationException(FISCCIntegrationConstants.INVALID_SUBMISSION);
    }

    FISCCIntegrationLogService.setPartyObjs();
    FISCCIntegrationLogService.setIntegrationLog(submissionId);
  }

  public static tffa__Party__c processSearchByTaxbr(String submissionId, tffa__Party__c partyObj) {
    tffa.logger.debug('inside processSearchByTaxbr');
    Map<String, Object> customerNumberMap = new Map<String, Object>();
    try {
      tffa.logger.debug('after buildData');

      tffa.logger.debug('partyObjs in provider==>' + partyObj);
      if (true) {
        String custAddKey = null;
        List<tffa__Party__c> result = new List<tffa__Party__c>();
        Boolean isAPICallFailed = false;
        Boolean isSuccess = false;
        String strDeveloperName = 'SearchCustomerTaxnbr';
        FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
        tffa.logger.debug('partyObjs[0].BrandCode__c:' + partyObj.tffa__BrandCode__c);
        FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);

        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
        if (!Test.isRunningTest()) {
          FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(
            partyObj.tffa__BrandCode__c,
            true
          );

          charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
        }
        partyObj = FISCCCustomerSearchTaxnbrExtension.invokeFindByTaxbr(partyObj, adapterConfig, charterConfig);

        tffa.logger.debug('partyObjs in provider ==>' + partyObj);
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());

      tffa.logger.debug(FISCCIntegrationConstants.CUSTOMER_SEARCHTAXNBR_FAILED);
    }
    tffa.logger.debug('before return :' + partyObj.Customer_Number__c);
    return partyObj;
  }
}