public with sharing class FISCCCDDepositCreationExtension {
  @TestVisible
  private static boolean testConfigFlow = false;
  public static Boolean invokeApiCall(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;
    try {
      fisccRequestBaseDTO = FISCCCDDepositCreationExtension.generateRequest(appObj);

      String dpAcctNbr = adapterConfig.IsEncrypted__c
        ? FISCCCommonHelper.encrypt(appObj.tffa__AccountNumber__c)
        : appObj.tffa__AccountNumber__c;

      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{AcctNbr}', dpAcctNbr);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      isSuccess = FISCCCDDepositCreationExtension.parseCDDepositResponse(result, appObj);

      if (isSuccess) {
        appObj.tffa__Status__c = CZWTFCConstants.FUNDED;
        if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
          appObj.tffa__LinkedFundingRequests__r[0].IsCoreEntryComplete__c = true;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCFundingHoldExtension ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }

  public static FISCCDOCertificateDepositDTO generateRequest(tffa__Application__c appObj) {
    tffa.Logger.debug('Generate CD Deposit Request');
    FISCCDOCertificateDepositDTO requestDto = new FISCCDOCertificateDepositDTO();
    FundingAccountDetails__mdt fundingAccDetail;
    if (appObj != null) {
      if (Test.isRunningTest() && testConfigFlow) {
        fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails('ACH', '118');
      }
      String reqType;
      if (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c == CZWTFCConstants.INTERNAL_TRANSFER) {
        if (appObj.tffa__Brand__c == appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c) {
          reqType = 'INTERNAL_TRANSFER_CD';
        } else {
          reqType = CZWTFCConstants.INTERNAL_TRANSFER_DESTINATION;
        }
      } else {
        reqType = appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c;
      }
      if (!Test.isRunningTest()) {
        fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails(reqType, appObj.tffa__Brand__c);
      }
      requestDto.account.DPTDTxnTyp = FISCCIntegrationConstants.DPTDTxnTyp;
      requestDto.account.DPTDIssAmt = String.valueof(appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c);
      requestDto.account.DPTDTerm = String.valueof(appObj.tffa__Term__c);
      if (appObj.InterestPlanCode__c != null && !String.isBlank(appObj.InterestPlanCode__c)) {
        tffa.Logger.debug('Interest Plan Code ' + appObj.InterestPlanCode__c);
        requestDto.account.DPTDIntPln = appObj.InterestPlanCode__c;
      }
      requestDto.account.DPTDTermInd = FISCCIntegrationConstants.DPTDTermInd;
      requestDto.account.DPTDGLAcctNbrOfst = Integer.valueOf(fundingAccDetail.GLAccountNumber__c);
      requestDto.account.DPTDGLCstCntrOfst = Integer.valueOf(Integer.valueOf(fundingAccDetail.GLCostCenter__c));
      //requestDto.account.DLTNCOvrideErrLvlInd = '3';
    }
    return requestDto;
  }

  public static Boolean parseCDDepositResponse(Object response, tffa__Application__c appObj) {
    tffa.Logger.debug('parseCDDepositResponse----> ' + response);
    try {
      if (response instanceof FISCCDepositCreationResponseDTO) {
        FISCCDepositCreationResponseDTO fundResponse = (FISCCDepositCreationResponseDTO) response;
        appObj.DPTDId__c = String.valueOf(fundResponse.entity.newCertificateDeposit.DPTDId);
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseCDDepositResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }
}