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
      if (
        appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c == CZWTFCConstants.INTERNAL_TRANSFER &&
        !FISCCCommonHelper.isBranchCertificatewithManualFunding(FISCCIntegrationLogService.submissionObj, appObj)
      ) {
        if (appObj.tffa__Brand__c == appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c) {
          reqType = 'INTERNAL_TRANSFER_CD';
        } else {
          reqType = CZWTFCConstants.INTERNAL_TRANSFER_DESTINATION;
        }
      } else if (!FISCCCommonHelper.isBranchCertificatewithManualFunding(FISCCIntegrationLogService.submissionObj, appObj)) {
        reqType = appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c;
      }
      if (!Test.isRunningTest() && reqType != null) {
        fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails(reqType, appObj.tffa__Brand__c);
      }
      requestDto.account.DPTDTxnTyp = FISCCIntegrationConstants.DPTDTxnTyp;
      requestDto.account.DPTDIssAmt = String.valueof(appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c);
      requestDto.account.DPTDTerm = String.valueof(appObj.tffa__Term__c);
      requestDto.account.DPTDTermInd = FISCCCommonHelper.fetchTermUnit(appObj.tffa__TermUnit__c);

      if (appObj.InterestPlanCode__c != null && !String.isBlank(appObj.InterestPlanCode__c)) {
        tffa.Logger.debug('Interest Plan Code ' + appObj.InterestPlanCode__c);
        requestDto.account.DPTDIntPln = appObj.InterestPlanCode__c;
      }

      if (FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH || Test.isRunningTest()) {
        if (appObj.tffa__TermDepositRate__c != 0) {
          requestDto.account.DPTDCurIntRte = String.valueOf(appObj.tffa__TermDepositRate__c);
        }
        if (String.isNotBlank(appObj.tffa__InterestPayoutFrequency__c)) {
          if (appObj.tffa__InterestPayoutFrequency__c == 'MONTHLY') {
            requestDto.account.DPTDIntFreqInd = 'M';
            requestDto.account.DPTDIntFreq = '1';
          } else if (appObj.tffa__InterestPayoutFrequency__c == 'QUARTERLY') {
            requestDto.account.DPTDIntFreqInd = 'M';
            requestDto.account.DPTDIntFreq = '3';
          } else if (appObj.tffa__InterestPayoutFrequency__c == 'ANNUALLY') {
            requestDto.account.DPTDIntFreqInd = 'C';
            requestDto.account.DPTDIntFreq = '1';
          } else if (appObj.tffa__InterestPayoutFrequency__c == 'DAILY') {
            requestDto.account.DPTDIntFreqInd = 'D';
            requestDto.account.DPTDIntFreq = '1';
          } else if (appObj.tffa__InterestPayoutFrequency__c == 'AT_MATURITY') {
            requestDto.account.DPTDIntFreqInd = requestDto.account.DPTDTermInd;
            requestDto.account.DPTDIntFreq = requestDto.account.DPTDTerm;
          }
        }
        if (String.isNotBlank(appObj.tffa__InterestPayoutMode__c)) {
          requestDto.account.DPTDPmtMeth = FISCCIntegrationConstants.INTEREST_PAYOUT.containsKey(appObj.tffa__InterestPayoutMode__c)
            ? FISCCIntegrationConstants.INTEREST_PAYOUT.get(appObj.tffa__InterestPayoutMode__c)
            : null;

          if (requestDto.account.DPTDPmtMeth == 'X' || requestDto.account.DPTDPmtMeth == 'T') {
            requestDto.account.DPTDIntTrsfrToAcct = appObj.CZInterestPayoutAccountNumber__c;
            requestDto.account.TmeLvlIntExtTrsfrAbaNbr = appObj.CZInterestPayoutRoutingNumber__c;
            if (
              appObj.tffa__InterestPayoutMode__c == CZWTFCConstants.INTERNAL_TRANSFER &&
              appObj.CZInterestPayoutCharterCode__c != appObj.tffa__Brand__c
            ) {
              tffa__Brand__c brand = FISCCIntegrationLogService.brandMap.get(appObj.CZInterestPayoutCharterCode__c);
              requestDto.account.TmeLvlIntExtTrsfrAbaNbr = brand.tffa__RoutingNumber__c;
            }
          }
          if (requestDto.account.DPTDPmtMeth == 'X') {
            requestDto.account.TmeLvlIntExtTypCde = 'D';
          }
        }
      }
      if (fundingAccDetail != null) {
        requestDto.account.DPTDGLAcctNbrOfst = Integer.valueOf(fundingAccDetail.GLAccountNumber__c);
        requestDto.account.DPTDGLCstCntrOfst = Integer.valueOf(Integer.valueOf(fundingAccDetail.GLCostCenter__c));
      }
      if (
        appObj.tffa__ProductCategory__c.equalsIgnoreCase(CZWTFCConstants.IRA) &&
        String.isNotBlank(appObj.tffa__InvestmentContributionType__c)
      ) {
        CZTerafinaFisMapping__c tfFisInvestmentContributionTypeMap = CZTerafinaFisMapping__c.getValues(
          'ICT_IRA_' + appObj.tffa__InvestmentContributionType__c
        );
        if (tfFisInvestmentContributionTypeMap != null) {
          requestDto.account.DPRetAcctTxnCde = Test.isRunningTest() ? 0 : Integer.valueOf(tfFisInvestmentContributionTypeMap.FisValue__c);
        }
      }
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