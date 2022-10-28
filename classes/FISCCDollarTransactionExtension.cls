public with sharing class FISCCDollarTransactionExtension {
  @TestVisible
  private static boolean testConfigFlow = false;
  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  public static Boolean invokeApiCall(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    String reqType
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;
    FISCCDollarTransResponseDTO respDTO;
    Boolean isFisProcessIssue = false;
    Boolean containsFisErrorCode = false;
    Integer counter = 0;
    String DPOverrideCode = null;
    Integer txnInd = 0;
    Boolean processDlrTrans = true;
    try {
      String fisErrorCode = wintrustEnvConfig.FISDLRTransErrorCode__c;
      List<String> fisErrorCodeList = fisErrorCode != null ? fisErrorCode.split(',') : new List<String>();

      while (processDlrTrans) {
        fisccRequestBaseDTO = FISCCDollarTransactionExtension.generateRequest(appObj, reqType, DPOverrideCode, txnInd);
        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
        respDTO = FISCCDollarTransactionExtension.parseDollarTransResponse(result);
        if (respDTO != null) {
          if ((respDTO.Metadata.MsgLst[0].Severity).equalsIgnoreCase('Error')) {
            isSuccess = false;
            isFisProcessIssue = true;
            for (FISCCMsgListDTO msg : respDTO.Metadata.MsgLst) {
              if (fisErrorCodeList.contains(msg.Code)) {
                containsFisErrorCode = true;
              }
            }
          } else {
            isSuccess = true;
          }
        } else {
          isSuccess = false;
        }

        if (
          !isSuccess &&
          !containsFisErrorCode &&
          isFisProcessIssue &&
          respDTO != null &&
          respDTO.entity.depositOnlineDollarTransResp.DPOvrideInfo != null &&
          counter < FISCCIntegrationConstants.DLR_TRANSACTION_RETRY
        ) {
          DPOverrideCode = respDTO.entity.depositOnlineDollarTransResp.DPOvrideInfo;
          if (respDTO.entity.depositOnlineDollarTransResp.TxnSecurityInd != null) {
            txnInd = respDTO.entity.depositOnlineDollarTransResp.TxnSecurityInd;
          }
          counter++;
          processDlrTrans = true;
        } else {
          processDlrTrans = false;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCFundingHoldExtension ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }

  public static FISCCDODepositOnlineDlrTransDTO generateRequest(
    tffa__Application__c appObject,
    String reqType,
    String dpOverrideCode,
    Integer txnInd
  ) {
    FISCCDODepositOnlineDlrTransDTO requestDto = new FISCCDODepositOnlineDlrTransDTO();
    tffa.Logger.debug('Generate Dollar Transaction Request');
    FundingAccountDetails__mdt fundingAccDetail;
    if (appObject != null) {
      if (Test.isRunningTest() && testConfigFlow) {
        //TODO Jitendra
        fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails(reqType, '118');
      }
      if (!Test.isRunningTest()) {
        if (reqType.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER_SOURCE)) {
          fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails(
            reqType,
            appObject.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c
          );
        } else {
          fundingAccDetail = FISCCIntegrationLogRepository.findFundingAccDetails(reqType, appObject.tffa__Brand__c);
        }
      }
      requestDto.depositOnlineDollarTrans.DPAcctNbr = appObject.tffa__AccountNumber__c;
      requestDto.depositOnlineDollarTrans.DPGLAcctNbr = Integer.valueOf(fundingAccDetail.GLAccountNumber__c);
      requestDto.depositOnlineDollarTrans.DPGLCstCntr = Integer.valueOf(fundingAccDetail.GLCostCenter__c);
      requestDto.depositOnlineDollarTrans.DPTxnCde = Integer.valueOf(fundingAccDetail.TransactionCode__c);

      if (reqType.equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)) {
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc1 = CZWTFCConstants.DEBIT_CARD_DESC_ONE;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc2 = appObject.tffa__LinkedFundingRequests__r[0].tffa__TraceNumber__c;
      } else if (
        reqType.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER_SOURCE) || reqType.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER_CD)
      ) {
        FundingAccountDetails__mdt fundingAccDest = FISCCIntegrationLogRepository.findFundingAccDetails(
          CZWTFCConstants.INTERNAL_TRANSFER_DESTINATION,
          appObject.tffa__Brand__c
        );
        requestDto.depositOnlineDollarTrans.DPAcctNbr = appObject.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c;
        String desc1 = 'To ' + fundingAccDest.BrandName__c;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc1 = desc1.length() > 18 ? desc1.substring(0, 17) : desc1;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc2 = maskString(appObject.tffa__AccountNumber__c);
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc3 = fundingAccDest.BrandCode__c;
        if (reqType.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER_CD)) {
          requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc1 = CZWTFCConstants.CD_SAME_CHARTER_DESC;
          requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc3 = '';
        }
      } else if (reqType.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER_DESTINATION)) {
        FundingAccountDetails__mdt fundingAccSource = FISCCIntegrationLogRepository.findFundingAccDetails(
          CZWTFCConstants.INTERNAL_TRANSFER_SOURCE,
          appObject.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c
        );
        String desc1 = 'From ' + fundingAccSource.BrandName__c;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc1 = desc1.length() > 18 ? desc1.substring(0, 17) : desc1;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc2 = maskString(appObject.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c);
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc3 = fundingAccSource.BrandCode__c;
      } else if (reqType == CZWTFCConstants.FUNDING_TYPE_ACH) {
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc1 = CZWTFCConstants.ACH_FUND_DESC_ONE;
        requestDto.depositOnlineDollarTrans.DPTxnTrlrDesc2 = maskString(appObject.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c);
      }

      requestDto.depositOnlineDollarTrans.DPLogTyp = FISCCIntegrationConstants.DPLogTyp;
      requestDto.depositOnlineDollarTrans.DPDolrTxnAmt = appObject.tffa__LinkedFundingRequests__r[0].tffa__Amount__c;

      if (fundingAccDetail.TransactionType__c == 'CREDIT') {
        requestDto.depositOnlineDollarTrans.AutoOvrideInd = '3';
      } else if (fundingAccDetail.TransactionType__c == 'DEBIT' && dpOverrideCode != null) {
        requestDto.depositOnlineDollarTrans.DPOvrideInfo = dpOverrideCode;
        if (txnInd != 0) {
          requestDto.depositOnlineDollarTrans.TxnSecurityInd = String.valueOf(txnInd);
        } else {
          requestDto.depositOnlineDollarTrans.TxnSecurityInd = '2';
        }
      }
    }
    return requestDto;
  }

  public static FISCCDollarTransResponseDTO parseDollarTransResponse(Object response) {
    tffa.Logger.debug('parseDollarTransResponse----> ' + response);
    try {
      if (response instanceof FISCCDollarTransResponseDTO) {
        FISCCDollarTransResponseDTO fundResp = (FISCCDollarTransResponseDTO) response;
        return fundResp;
      } else {
        return null;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseDollarTransResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
  }

  public static String maskString(String value) {
    try {
      if (value.length() > 4) {
        String valueToMask = value.substring(0, value.length() - 4);
        String mask = 'X'.repeat(valueToMask.length());
        String masked = value.replaceFirst(valueToMask, mask);
        return masked;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in maskString ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return value;
  }
}