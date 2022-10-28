public with sharing class FISCCApplicationFundingProvider {
  @TestVisible
  private static boolean testFlow = false;

  public static Boolean processFunding(tffa__Application__c appObj) {
    Object result = null;
    Boolean isSuccess = false;
    String strDeveloperName;
    boolean isElavonFundingSuccess = false;
    boolean isSourceInternalTransferSuccess = false;

    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
    }

    if (Test.isRunningTest() && testFlow) {
      isSuccess = true;
    }
    if (
      (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) ||
      (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_ACH)
    ) {
      try {
        if ((appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)) {
          String elavonfunding = CZWTFCIntegrationLogService.setCurrentLogItem(
            FISCCIntegrationConstants.APPROVAL_CCCOMPLETE,
            appObj.Id,
            false
          );

          try {
            if (FISCCIntegrationLogService.isLogItemNewOrFailed(elavonfunding)) {
              Map<String, Object> params = new Map<String, Object>();
              String doMultiPartComp = getMultiPartialFlag(FISCCIntegrationLogService.applicationObjs, appObj.Id);
              tffa.Logger.debug('doMultiPartComp ' + doMultiPartComp);
              params.put('txnId', appObj.tffa__LinkedFundingRequests__r[0].tffa__TransactionReferenceId__c);
              params.put('amount', appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c);
              params.put('multiPartialComplete', doMultiPartComp);
              params.put('brandCode', appObj.tffa__Brand__c);
              appObj.tffa__LinkedFundingRequests__r[0].MultiPartialFlag__c = doMultiPartComp;
              isElavonFundingSuccess = CZWTFCConvergeService.ccCompleteConvergeTrans(params, appObj.tffa__LinkedFundingRequests__r[0]);
              if (isElavonFundingSuccess) {
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.APPROVAL;
              } else {
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FAILED;
              }
            } else {
              isElavonFundingSuccess = true;
            }
          } catch (Exception ex) {
            tffa.Logger.error('Exception in ConvergeComplete ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
          }
        }

        if (
          !isElavonFundingSuccess && (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)
        ) {
          return false;
        }

        if (!Test.isRunningTest()) {
          FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ACCOUNT_FUNDING, appObj.Name, true);
        }

        if (appObj.tffa__ProductCategory__c.equalsIgnoreCase('CHECKING') || appObj.tffa__ProductCategory__c.equalsIgnoreCase('SAVINGS')) {
          strDeveloperName = 'DollarTransaction';
          FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
          String reqType = appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c;
          isSuccess = FISCCDollarTransactionExtension.invokeApiCall(appObj, adapterConfig, charterConfig, reqType);
        } else if (appObj.tffa__ProductCategory__c.equalsIgnoreCase('CERTIFICATE')) {
          strDeveloperName = 'CDDeposit';
          FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
          isSuccess = FISCCCDDepositCreationExtension.invokeApiCall(appObj, adapterConfig, charterConfig);
        }
        if (isSuccess) {
          FISCCIntegrationLogService.setLogItemOk(
            FISCCIntegrationConstants.ACCOUNT_FUNDING,
            FISCCIntegrationConstants.ACCOUNT_FUNDING_COMPLETED
          );
          appObj.tffa__Status__c = CZWTFCConstants.FUNDED;
          if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
            appObj.tffa__LinkedFundingRequests__r[0].IsCoreEntryComplete__c = true;
            if ((appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_ACH)) {
              appObj.tffa__LinkedFundingRequests__r[0].RecordTypeId =  Schema.SObjectType.tffa__FundingRequest__c.getRecordTypeInfosByDeveloperName().get('ACH').getRecordTypeId();
              appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = ACHConstants.FUNDING_IN_PROGRESS;
            }
          }
        } else {
          if (!(appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)) {
            appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FAILED;
          }
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING);
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in FISCCFundingProvider ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      }
    }

    //cross charter
    if (
      ((appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER) &&
      (!(appObj.tffa__Brand__c).equalsIgnoreCase(appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c) ||
      appObj.tffa__ProductCategory__c == CZWTFCConstants.CERTIFICATE))
    ) {
      strDeveloperName = 'DollarTransaction';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      String internalSourceFunding = CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.INTERNAL_SOURCE_FUNDING,
        appObj.Id,
        false
      );
      try {
        if (FISCCIntegrationLogService.isLogItemNewOrFailed(internalSourceFunding)) {
          FISCCIntegrationLogService.setCharterConfig(appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c);
          FISCCIntegrationLogService.tempAuth = FISCCIntegrationLogService.auth;
          try {
            FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
            String reqType;
            if (
              appObj.tffa__ProductCategory__c == CZWTFCConstants.CERTIFICATE &&
              appObj.tffa__Brand__c == appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c
            ) {
              reqType = 'INTERNAL_TRANSFER_CD';
            } else {
              reqType = 'INTERNAL_TRANSFER_SOURCE';
            }
            isSourceInternalTransferSuccess = FISCCDollarTransactionExtension.invokeApiCall(
              appObj,
              adapterConfig,
              FISCCIntegrationLogService.charterConfig,
              reqType
            );
          } finally {
            FISCCIntegrationLogService.setCharterConfig(appObj.tffa__Brand__c);
            FISCCIntegrationLogService.auth = FISCCIntegrationLogService.tempAuth;
            CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.INTERNAL_SOURCE_FUNDING);
          }
          if (isSourceInternalTransferSuccess) {
            CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.INTERNAL_SOURCE_FUNDING);
          } else {
            appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FAILED;
            CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.INTERNAL_SOURCE_FUNDING);
            return false;
          }
        }
      } catch (Exception ex) {
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.INTERNAL_SOURCE_FUNDING);
        tffa.Logger.error('Exception in Internal Source funding ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      }
      String internalDestinationFunding = CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.INTERNAL_DESTINATION_FUNDING,
        appObj.Id,
        false
      );
      if (
        (FISCCIntegrationLogService.isLogItemNewOrFailed(internalDestinationFunding) &&
        FISCCIntegrationLogService.isLogItemOk(internalSourceFunding))
      ) {
        try {
          FISCCIntegrationLogService.setCharterConfig(appObj.tffa__Brand__c);
          FISCCIntegrationLogService.auth = FISCCIntegrationLogService.tempAuth != null
            ? FISCCIntegrationLogService.tempAuth
            : FISCCIntegrationLogService.auth;
          if (appObj.tffa__ProductCategory__c.equalsIgnoreCase('CHECKING') || appObj.tffa__ProductCategory__c.equalsIgnoreCase('SAVINGS')) {
            String reqType = 'INTERNAL_TRANSFER_DESTINATION';
            isSuccess = FISCCDollarTransactionExtension.invokeApiCall(
              appObj,
              adapterConfig,
              FISCCIntegrationLogService.charterConfig,
              reqType
            );
          } else if (appObj.tffa__ProductCategory__c.equalsIgnoreCase('CERTIFICATE')) {
            strDeveloperName = 'CDDeposit';
            FISCC_Adapter_Configs__mdt adapterConfig_Cert = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
            isSuccess = FISCCCDDepositCreationExtension.invokeApiCall(appObj, adapterConfig_Cert, charterConfig);
          }

          if (isSuccess) {
            appObj.tffa__Status__c = CZWTFCConstants.FUNDED;
            if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
              appObj.tffa__LinkedFundingRequests__r[0].IsCoreEntryComplete__c = true;
              appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FUNDED;
            }
            FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.INTERNAL_DESTINATION_FUNDING);
          } else {
            appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FAILED;
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.INTERNAL_DESTINATION_FUNDING);
          }
        } catch (Exception exp) {
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.INTERNAL_DESTINATION_FUNDING);
          tffa.Logger.error('Exception in Internal Destination funding ' + exp.getMessage() + ' Exception :::' + exp.getStackTraceString());
          return false;
        }
      } else if (
        FISCCIntegrationLogService.isLogItemOk(internalSourceFunding) && FISCCIntegrationLogService.isLogItemOk(internalDestinationFunding)
      ) {
        return true;
      }
    }

    if (
      (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER) &&
      (appObj.tffa__Brand__c).equalsIgnoreCase(appObj.tffa__LinkedFundingRequests__r[0].CZSourceAccountBrand__c) &&
      appObj.tffa__ProductCategory__c != CZWTFCConstants.CERTIFICATE
    ) {
      try {
        String immediateTransFunding = CZWTFCIntegrationLogService.setCurrentLogItem(
          FISCCIntegrationConstants.IMMEDIATE_TRANSFER,
          appObj.Id,
          false
        );
        if (FISCCIntegrationLogService.isLogItemNewOrFailed(immediateTransFunding)) {
          strDeveloperName = 'ImmediateTransfer';
          FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
          isSuccess = FISCCImmediateTransferExtension.invokeApiCall(appObj, adapterConfig, charterConfig);
          if (isSuccess) {
            FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.IMMEDIATE_TRANSFER);
          } else {
            appObj.tffa__LinkedFundingRequests__r[0].tffa__Status__c = CZWTFCConstants.FAILED;
            CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.IMMEDIATE_TRANSFER);
          }
        } else {
          isSuccess = true;
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in Immediate Transfer funding ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.IMMEDIATE_TRANSFER);
      }
    }
    return isSuccess;
  }

  public static String getMultiPartialFlag(List<tffa__Application__c> appObjs, String currentAppId) {
    List<String> fundingStatusLst = new List<String>{ CZWTFCConstants.APPROVAL };
    List<String> appStatusLst = new List<String>{ CZWTFCConstants.DECLINED, CZWTFCConstants.FUNDED };

    if (FISCCIntegrationLogService.reviewApps != null && !FISCCIntegrationLogService.reviewApps.isEmpty()) {
      for (tffa__Application__c app : FISCCIntegrationLogService.reviewApps) {
        if (
          app.tffa__LinkedFundingRequests__r != null &&
          !app.tffa__LinkedFundingRequests__r.isEmpty() &&
          (app.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) &&
          !fundingStatusLst.contains(app.tffa__LinkedFundingRequests__r[0].tffa__Status__c) &&
          !appStatusLst.contains(app.tffa__Status__c) &&
          !(String.valueOf(app.Id)).equalsIgnoreCase(currentAppId)
        ) {
          return 'Y';
        }
      }
    }

    for (tffa__Application__c app : appObjs) {
      if (
        app.tffa__LinkedFundingRequests__r != null &&
        !app.tffa__LinkedFundingRequests__r.isEmpty() &&
        (app.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) &&
        !fundingStatusLst.contains(app.tffa__LinkedFundingRequests__r[0].tffa__Status__c) &&
        !appStatusLst.contains(app.tffa__Status__c) &&
        !(String.valueOf(app.Id)).equalsIgnoreCase(currentAppId)
      ) {
        return 'Y';
      }
    }
    return 'N';
  }
}