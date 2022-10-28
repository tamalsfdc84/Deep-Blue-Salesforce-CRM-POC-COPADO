public with sharing class FISCCFetchContactInfoExtension {
  public static tffa__Party__c fetchContactInfo(tffa__Party__c partyObj, FISCC_Adapter_Configs__mdt adapterConfig) {
    tffa.Logger.debug('In fetchContactInfo Ext');
    try {
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
        '{custNbr}',
        FISCCCommonHelper.encrypt(partyObj.Customer_Number__c)
      );

      Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);

      if (result != null) {
        partyObj = parsefetchContactInfoResp(result, adapterConfig, partyObj);
        FISCCIntegrationLogService.setLogItemOk('SUCCESS');
        return partyObj;
      } else {
        FISCCIntegrationLogService.setLogItemFailed('FAILURE');
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in fetchContactInfo ' + ex.getLineNumber() + ' ' + ex.getMessage());
      FISCCIntegrationLogService.setLogItemFailed('FAILURE');
    }
    return partyObj;
  }

  public static tffa__Party__c parsefetchContactInfoResp(Object result, FISCC_Adapter_Configs__mdt adapterConfig, tffa__Party__c partyObj) {
    tffa.Logger.debug('In parsefetchContactInfoResp');
    if ('FetchPhoneNbr' == adapterConfig.DeveloperName && result instanceof CZFetchPhoneNbrResponseDTO) {
      CZFetchPhoneNbrResponseDTO respDto = (CZFetchPhoneNbrResponseDTO) result;
      for (CZFetchPhoneNbrResponseDTO.PhnNbrDetails phndetails : respDto.entity.custPhoneNumberLst) {
        if (phndetails.ResnCde == 'HME' || phndetails.ResnCde == 'PRI') {
          partyObj.CZFisHomeNbr__c = phndetails.AreaCde + phndetails.LocalNbr;
          partyObj.CZFisHomeNbrEffDt__c = phndetails.EffDte;
        } else if (phndetails.ResnCde == 'WRK' || phndetails.ResnCde == 'SEC') {
          partyObj.CZFisWorkNbr__c = phndetails.AreaCde + phndetails.LocalNbr;
          partyObj.CZFisWorkNbrEffDt__c = phndetails.EffDte;
        } else if (phndetails.ResnCde == 'MBL') {
          partyObj.CZFisCellNbr__c = phndetails.AreaCde + phndetails.LocalNbr;
          partyObj.CZFisCellNbrEffDt__c = phndetails.EffDte;
        }
      }
    }

    if ('FetchEmailAddress' == adapterConfig.DeveloperName && result instanceof CZFetchEmailAddressResponseDTO) {
      CZFetchEmailAddressResponseDTO respDto = (CZFetchEmailAddressResponseDTO) result;
      for (CZFetchEmailAddressResponseDTO.EmailAddDetails emaildetails : respDto.entity.emailaddressesLst) {
        if (emaildetails.ResnCde == 'PRI') {
          partyObj.CZFisEmail__c = emaildetails.EmailAddr;
          partyObj.CZFisEmailEffDt__c = emaildetails.EffDte;
        }
      }
    }
    return partyObj;
  }

  public static tffa__Party__c getProfile(tffa__Party__c partyObj, FISCC_Adapter_Configs__mdt adapterConfig) {
    try {
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
        '{CIApplNbr}',
        FISCCCommonHelper.encrypt(partyObj.Customer_Number__c)
      );

      Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);
      if (result != null) {
        parseFetchProfileResp(partyObj, result);
        FISCCIntegrationLogService.setLogItemOk('SUCCESS');
        return partyObj;
      } else {
        FISCCIntegrationLogService.setLogItemFailed('FAILURE');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getProfile ' + ex.getMessage());
      FISCCIntegrationLogService.setLogItemFailed('FAILURE');
    }
    return partyObj;
  }

  public static tffa__Party__c parseFetchProfileResp(tffa__Party__c partyObj, Object result) {
    if (result instanceof FISCCGetCustomerProfileResponse) {
      FISCCGetCustomerProfileResponse response = (FISCCGetCustomerProfileResponse) result;
      List<String> customCodeLst = new List<String>();
      String customCodes = '';
      tffa.Logger.debug('Here  ' + response.entity.customer.CICustCde1);
      if (response.entity.customer.CICustCde1 != 0) {
        customCodes = String.valueOf(response.entity.customer.CICustCde1);
      }
      if (response.entity.customer.CICustCde2 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde2);
      }
      if (response.entity.customer.CICustCde3 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde3);
      }
      if (response.entity.customer.CICustCde4 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde4);
      }
      if (response.entity.customer.CICustCde5 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde5);
      }
      if (response.entity.customer.CICustCde6 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde6);
      }
      if (response.entity.customer.CICustCde7 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde7);
      }
      if (response.entity.customer.CICustCde8 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde8);
      }
      if (response.entity.customer.CICustCde9 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde9);
      }
      if (response.entity.customer.CICustCde10 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde10);
      }
      if (response.entity.customer.CICustCde11 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde11);
      }
      if (response.entity.customer.CICustCde12 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde12);
      }
      if (response.entity.customer.CICustCde13 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde13);
      }
      if (response.entity.customer.CICustCde14 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde14);
      }
      if (response.entity.customer.CICustCde15 != 0) {
        customCodes = customCodes + ',' + String.valueOf(response.entity.customer.CICustCde15);
      }

      tffa.Logger.debug('Here customCodeLst11 ' + customCodes);

      partyObj.CZFisCustCodes__c = customCodes;
    }
    tffa.Logger.debug('Here CZFisCustCodes__c ' + partyObj.CZFisCustCodes__c);
    return partyObj;
  }
}