public with sharing class FISCCImmediateTransferExtension {
  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

  public static boolean InvokeApiCall(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;
    FISCCImmediateTransResponseDTO respDTO;
    Boolean isFisProcessIssue = false;
    Boolean containsFisErrorCode = false;
    Integer counter = 0;
    String FMOvrideInfo = null;
    Boolean processImmediateTrans = true;
    String TxnSecurityInd = null;
    try {
      String fisErrorCode = wintrustEnvConfig.FISImmediateTransErrorCode__c;
      List<String> fisErrorCodeList = fisErrorCode != null ? fisErrorCode.split(',') : new List<String>();

      while (processImmediateTrans) {
        fisccRequestBaseDTO = FISCCImmediateTransferExtension.generateRequest(appObj, FMOvrideInfo, TxnSecurityInd);

        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
        respDTO = FISCCImmediateTransferExtension.parseImmediateTransResponse(result);

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
          respDTO.entity.immediatetransfers.FMOvrideInfo != null &&
          counter < FISCCIntegrationConstants.IMMEDIATE_TRANSFER_RETRY
        ) {
          FMOvrideInfo = respDTO.entity.immediatetransfers.FMOvrideInfo;
          if (respDTO.entity.immediatetransfers.TxnSecurityInd != null) {
            TxnSecurityInd = String.valueOf(respDTO.entity.immediatetransfers.TxnSecurityInd);
          }
          counter++;
          processImmediateTrans = true;
        } else {
          processImmediateTrans = false;
        }
      }

      if (isSuccess) {
        tffa.Logger.debug(appObj.Id + ' | isSuccess for parseImmediateTransResponse : ' + isSuccess);
        appObj.tffa__Status__c = CZWTFCConstants.FUNDED;
        if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
          appObj.tffa__LinkedFundingRequests__r[0].IsCoreEntryComplete__c = true;
          appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FUNDED;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCImmediateTransferExtension ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }

    return isSuccess;
  }

  public static FISCCDODepositOnlineImmediateTransDTO generateRequest(
    tffa__Application__c appObject,
    String FMOvrideInfo,
    String TxnSecurityInd
  ) {
    FISCCDODepositOnlineImmediateTransDTO requestDTO = new FISCCDODepositOnlineImmediateTransDTO();
    tffa.Logger.debug('Generate Immediate Transfer Transaction Request');
    requestDTO.immediatetransfers.FMTrsfrFromSys = 'DP';
    requestDTO.immediatetransfers.FMTrsfrFromAcct = appObject.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c;
    requestDTO.immediatetransfers.FMTrsfrToSys = 'DP';
    requestDTO.immediatetransfers.FMTrsfrToAcct = appObject.tffa__AccountNumber__c;
    requestDTO.immediatetransfers.FMTrsfrAmt = appObject.tffa__LinkedFundingRequests__r[0].tffa__Amount__c;
    if (FMOvrideInfo != null) {
      requestDTO.immediatetransfers.FMOvrideInfo = FMOvrideInfo;
      if (TxnSecurityInd != null) {
        requestDTO.immediatetransfers.TxnSecurityInd = TxnSecurityInd;
      } else {
        requestDTO.immediatetransfers.TxnSecurityInd = '2';
      }
    }

    Datetime startDate = appObject.CZAccountOpeningDate__c;
    String dayOfWeek = appObject.CZAccountOpeningDate__c.format('EEEE');
    if (dayOfWeek.equalsIgnoreCase('Saturday')) {
      startDate = appObject.CZAccountOpeningDate__c + 2;
    } else if (dayOfWeek.equalsIgnoreCase('Sunday')) {
      startDate = appObject.CZAccountOpeningDate__c + 1;
    }

    requestDTO.immediatetransfers.FMTrsfrDte = startDate.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    requestDTO.immediatetransfers.FMLogTyp = 'L';
    return requestDTO;
    //Check if existing Constants in IntConst Class
  }

  public static FISCCImmediateTransResponseDTO parseImmediateTransResponse(Object response) {
    tffa.Logger.debug('parseImmediateTransResponse----> ' + response);
    try {
      if (response instanceof FISCCImmediateTransResponseDTO) {
        FISCCImmediateTransResponseDTO fundResp = (FISCCImmediateTransResponseDTO) response;
        return fundResp;
      } else {
        return null;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseImmediateTransResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
  }
}