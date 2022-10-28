public with sharing class FISCCUpdateCustInfoProvider {
  public static boolean updateCustInfo(List<tffa__Party__c> partyObjList) {
    Object result = null;
    Boolean isSuccess = true;
    String strDeveloperName = 'CreateDueDiligence';
    Boolean isIntegrationLogSet = false;

    // try{
    List<tffa__Party__c> partyUpdatedList = new List<tffa__Party__c>();
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
    //null check auth
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
    }
    for (tffa__Party__c partyObj : partyObjList) {
      boolean partySuccess = true;
      if (!partyObj.tffa__IsExistingCustomer__c) {
        if (!isIntegrationLogSet) {
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FLOW);
          isIntegrationLogSet = true;
        }
        partySuccess = FISCCCreateDueDiligenceExtension.invokeApiCall(partyObj, adapterConfig, charterConfig);
      }
      if (
        partyObj.IsAuthenticatedCustomer__c &&
        partyObj.tffa__IsExistingCustomer__c &&
        (partyObj.IsEmailIdMissing__c || partyObj.IsPhoneNumberMissing__c)
      ) {
        boolean dueDiligencefailed = false;
        if (!partySuccess) {
          dueDiligencefailed = true;
        }
        if (!isIntegrationLogSet) {
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FLOW);
          isIntegrationLogSet = true;
        }
        partySuccess = FISCCDepositOriginationProvider.updateCustomerInformation(partyObj);
        if (dueDiligencefailed) {
          partySuccess = false;
        }
      }

      if (!partySuccess) {
        isSuccess = false;
      }
    }
    if (isIntegrationLogSet) {
      if (isSuccess) {
        FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_COMPLETED);
      } else {
        FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FAILURE);
      }
    }
    return isSuccess;
  }
}