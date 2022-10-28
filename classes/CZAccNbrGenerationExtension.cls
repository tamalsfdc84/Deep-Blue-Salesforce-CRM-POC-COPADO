public with sharing class CZAccNbrGenerationExtension {
  @TestVisible
  private static boolean testException = false;
  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  public static boolean invokeApiCall(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    List<tffa__Application__c> appObjLst
  ) {
    tffa.Logger.debug('In CZAccNbrGenerationExtension.invokeApiCall');
    FISCCRequestBaseDTO fisccRequestBaseDTO;
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    Object result = null;
    boolean isSuccess;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      lstFISCCDepositOriginationRequestBaseDTO = CZAccNbrGenerationExtension.generateRequest(appObjLst);
      objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
      fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      isSuccess = CZAccNbrGenerationExtension.parseResponse(result, appObjLst);
      if (isSuccess) {
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION);
        FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION_COMPLETED);

        return isSuccess;
      } else {
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION);
        FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZAccNbrGenerationExtension.invokeApiCall ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION);
      FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
    }
    return isSuccess;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> generateRequest(List<tffa__Application__c> appObjLst) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      for (tffa__Application__c appObj : appObjLst) {
        if (
          String.isBlank(appObj.tffa__AccountNumber__c) &&
          appObj.tffa__KYCDecisionOutcome__c != 'DECLINED' &&
          !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
          FISCCDOGenerateDepositAccNumberRequest objFISCCDOGenerateDepositAccNumberRequest = new FISCCDOGenerateDepositAccNumberRequest();
          objFISCCDOGenerateDepositAccNumberRequest.depositAccountNumber.DPAcctBrnch = wintrustEnvConfig.IsTestEnv__c
            ? '1'
            : FISCCIntegrationLogService.brandObj.DefaultLocation__r.FISBranchCode__c;
          objFISCCDOGenerateDepositAccNumberRequest.depositAccountNumber.DPAcctTyp = appObj.tffa__Product__r.tffa__Code__c;
          objFISCCDOGenerateDepositAccNumberRequest.depositAccountNumber.GenDPApplID = FISCCIntegrationConstants.GenDPApplID;
          objFISCCDOGenerateDepositAccNumberRequest.SvcID = FISCCIntegrationConstants.SVCID_DepositAccountNumber;
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) objFISCCDOGenerateDepositAccNumberRequest;
          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZAccNbrGenerationExtension.generateRequest ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static boolean parseResponse(Object resp, List<tffa__Application__c> appObjLst) {
    tffa.Logger.debug('Generate Account Nbr Response ' + resp);
    if (resp == null || !(resp instanceof FISCCDepositOriginationEntityResponse)) {
      return false;
    }
    FISCCDepositOriginationEntityResponse fisccDepositOriginationEntityResponse = (FISCCDepositOriginationEntityResponse) resp;
    for (
      FISCCDepositOriginationResponse fisccResponseDepositOrigination : fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst
    ) {
      for (tffa__Application__c appObj : appObjLst) {
        if (
          String.isBlank(appObj.tffa__AccountNumber__c) &&
          appObj.tffa__Product__r.tffa__Code__c == fisccResponseDepositOrigination.depositAccountNumber.DPAcctTyp &&
          appObj.tffa__KYCDecisionOutcome__c != 'DECLINED' &&
          !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c)&&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          appObj.tffa__AccountNumber__c = fisccResponseDepositOrigination.depositAccountNumber.GenDPAcctNbr.leftPad(10, '0');
          break;
        }
      }
    }
    return true;
  }
}