public with sharing class FISCCDemographicsProvider {
  static List<Id> partyObjInternationalPhnLst = new List<Id>();
  public static boolean processIntPhoneNbr(List<tffa__Party__c> partyObjLst) {
    tffa.Logger.debug('In FISCCDemographicsProvider.processIntPhoneNbr');
    boolean isSuccess = false;
    try {
      FISCCRequestBaseDTO fisccRequestBaseDTO;
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
        FISCCIntegrationConstants.DeveloperName_Deposit_Originate
      );
      //FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_INFORMATION);
      List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = generateDemoGraphicsReq(partyObjLst);

      FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
      objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
      tffa.logger.debug(
        'objFISCCDepositOriginationRequest.DepositOriginationLst in processIntPhoneNbr DO build Request ==>' +
        objFISCCDepositOriginationRequest.DepositOriginationLst
      );
      fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
      Object result = null;
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CUST, FISCCIntegrationConstants.INT_PHN_NBR, true);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

      if (parseDemogrphicsResp(result)) {
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_INDIVIDUAL_DEMOGRAPHICS);
        isSuccess = true;
      } else {
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_INDIVIDUAL_DEMOGRAPHICS);
        isSuccess = false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCDemographicsProvider.processIntPhoneNbr ' + ex.getLineNumber() + ' ' + ex.getMessage());
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_INDIVIDUAL_DEMOGRAPHICS);
      isSuccess = false;
    }
    FISCCDemographicsProvider.partyObjInternationalPhnLst = new List<Id>();
    return isSuccess;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> generateDemoGraphicsReq(List<tffa__Party__c> partyObjLst) {
    tffa.Logger.debug('In FISCCDemographicsProvider.generateDemoGraphicsReq');
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();

    for (tffa__Party__c partyObj : partyObjLst) {
      if (
        !partyObj.CZIntPhnNbrCreated__c &&
        String.isNotBlank(partyObj.CZInternationalPhoneNumber__c) &&
        partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL &&
        String.isNotBlank(partyObj.Customer_Number__c)
      ) {
        objFISCCDepositOriginationRequestBaseDTO = FISCCCustomerIndDemoExtension.generateCustomerIndDemoRequest(partyObj);
        FISCCDemographicsProvider.partyObjInternationalPhnLst.add(partyObj.Id);
        lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
      }
    }
    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static boolean parseDemogrphicsResp(Object response) {
    if (response == null || !(response instanceof FISCCDepositOriginationEntityResponse)) {
      return false;
    }
    for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjMap.values()) {
      if (FISCCDemographicsProvider.partyObjInternationalPhnLst.contains(partyObj.Id)) {
        partyObj.CZIntPhnNbrCreated__c = true;
      }
    }
    return true;
  }
}