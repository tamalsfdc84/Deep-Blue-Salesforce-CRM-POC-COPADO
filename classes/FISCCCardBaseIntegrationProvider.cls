public inherited sharing class FISCCCardBaseIntegrationProvider {
  public FISCCCardBaseIntegrationProvider() {
  }

  public static Boolean generateCardNo(tffa__AccountPreference__c accPref, tffa__Party__c partyObj) {
    Object result;
    Boolean isSuccess = false;
    try {
      String strDeveloperName = 'DebitCardNoGen';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);
      //FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      if (!Test.isRunningTest()) {
        FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(partyObj.tffa__BrandCode__c, true);
        charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      }

      tffa.logger.debug('partyObj' + partyObj);
      result = FISCCCardBaseIntegrationExtension.invokeGenerateCardNo(partyObj, accPref, adapterConfig, charterConfig);
      isSuccess = isCardBaseAPISuccess(result, FISCCIntegrationConstants.DEBIT_CARDNO_GEN);
      if (isSuccess) {
        FISCCDebitCardNoGenResponseDTO cardNoGenResult = (FISCCDebitCardNoGenResponseDTO) result;
        FISCCCardBaseIntegrationHelper.cardNumber = cardNoGenResult.Entity.CardNumber.CBCrdNbr;
      }
      tffa.logger.debug('result in generateCardNo :: ' + result);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in generateCardNo : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }

  public static Boolean createDebitCard(tffa__AccountPreference__c accPref, tffa__Party__c partyObj, tffa__Application__c appObj) {
    Object result;
    Boolean isSuccess = false;
    try {
      String strDeveloperName = 'DebitCardCreation';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);
      //FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(partyObj.tffa__BrandCode__c, true);
      charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      tffa.logger.debug('partyObj' + partyObj);
      result = FISCCCardBaseIntegrationExtension.invokeCardCreation(partyObj, accPref, appObj, adapterConfig, charterConfig);
      isSuccess = isCardBaseAPISuccess(result, FISCCIntegrationConstants.DEBIT_CARD_CREATION);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createDebitCard : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result in createDebitCard :: ' + result);

    return isSuccess;
  }

  public static Boolean relateCustomerToAccount(tffa__AccountPreference__c accPref, tffa__Party__c partyObj, tffa__Application__c appObj) {
    Object result;
    Boolean isSuccess = false;
    try {
      String strDeveloperName = 'DebitCardAccRel';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);
      //FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(partyObj.tffa__BrandCode__c, true);
      charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      tffa.logger.debug('partyObj' + partyObj);
      result = FISCCCardBaseIntegrationExtension.invokeCardToAccRelation(partyObj, accPref, appObj, adapterConfig, charterConfig);
      isSuccess = isCardBaseAPISuccess(result, FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in relateCustomerToAccount : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result in relateCustomerToAccount :: ' + result);
    return isSuccess;
  }

  public static Boolean updateCustomerDemographics(
    tffa__AccountPreference__c accPref,
    tffa__Party__c partyObj,
    tffa__Application__c appObj
  ) {
    Object result;
    Boolean isSuccess = false;
    try {
      String strDeveloperName = 'DebitCardCustDetails';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      /*if (Test.isRunningTest()) {
        accPref.tffa__CardNumber__c = '4411090000000089';
      }*/

      String cardNumber = adapterConfig.IsEncrypted__c
        ? FISCCCommonHelper.encrypt(accPref.tffa__CardNumber__c)
        : accPref.tffa__CardNumber__c;

      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{CrdNbr}', cardNumber);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);
      //FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(partyObj.tffa__BrandCode__c, true);
      charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      tffa.logger.debug('partyObj' + partyObj);
      result = FISCCCardBaseIntegrationExtension.invokeupdateCustomerDemographics(partyObj, accPref, appObj, adapterConfig, charterConfig);
      isSuccess = isCardBaseAPISuccess(result, FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in updateCustomerDemographics : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result in updateCustomerDemographics is :: ' + result);

    return isSuccess;
  }

  public static boolean isCardBaseAPISuccess(Object result, String cardAPIName) {
    Boolean isSuccess = false;

    if (result == null) {
      return isSuccess;
    }

    if (FISCCIntegrationConstants.DEBIT_CARDNO_GEN.equals(cardAPIName)) {
      if (result instanceof FISCCDebitCardNoGenResponseDTO) {
        FISCCDebitCardNoGenResponseDTO res = (FISCCDebitCardNoGenResponseDTO) result;
        isSuccess = FISCCCardBaseIntegrationHelper.isAPICallSuccess(res.Metadata.MsgLst);
      }
    } else if (FISCCIntegrationConstants.DEBIT_CARD_CREATION.equals(cardAPIName)) {
      if (result instanceof FISCCDebitCardCreationResponseDTO) {
        FISCCDebitCardCreationResponseDTO res = (FISCCDebitCardCreationResponseDTO) result;
        isSuccess = FISCCCardBaseIntegrationHelper.isAPICallSuccess(res.Metadata.MsgLst);
      }
    } else if (FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION.equals(cardAPIName)) {
      if (result instanceof FISCCDebitCardAccRelResponseDTO) {
        FISCCDebitCardAccRelResponseDTO res = (FISCCDebitCardAccRelResponseDTO) result;
        isSuccess = FISCCCardBaseIntegrationHelper.isAPICallSuccess(res.Metadata.MsgLst);
      }
    } else if (FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS.equals(cardAPIName)) {
      if (result instanceof FISCCDebitCardCustDetailsResponseDTO) {
        FISCCDebitCardCustDetailsResponseDTO res = (FISCCDebitCardCustDetailsResponseDTO) result;
        isSuccess = FISCCCardBaseIntegrationHelper.isAPICallSuccess(res.Metadata.MsgLst);
      }
    }
    return isSuccess;
  }
}