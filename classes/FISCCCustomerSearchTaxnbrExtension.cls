public with sharing class FISCCCustomerSearchTaxnbrExtension {
  public static tffa__Party__c invokeFindByTaxbr(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    String custAddKey = null;
    tffa__Party__c objParty = new tffa__Party__c();
    boolean isFindByTaxbrSuccess = null;
    FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);
    try {
      tffa.logger.debug('createCustomerSearchRequest is called');
      // create a class and method to check if response is valid
      String ssnValue = adapterConfigInput.IsEncrypted__c
        ? FISCCCommonHelper.encrypt(partyObj.tffa__NationalIdentifierValue__c)
        : partyObj.tffa__NationalIdentifierValue__c;

      adapterConfigInput.ServiceURL__c = adapterConfig.ServiceURL__c + '?CIKeySSN=' + ssnValue + '&CICustEntityFilter=C&CICustTypInd=I';

      result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
      tffa.logger.debug('result in CustomerSearchTaxBrExtension ==>' + result);
      objParty = isFISCCAPICallSuccess(result, partyObj);
      tffa.logger.debug('result sfter isFISCCAPICallSuccess call==>' + objParty);
      return objParty;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeFindByTaxbr : ' + ex.getMessage() + ex.getStackTraceString());
      return objParty;
    }
  }
  public static tffa__Party__c isFISCCAPICallSuccess(Object response, tffa__Party__c partyObj) {
    tffa.logger.debug('CustomerSearchTaxnbrExtension :response inside isFISCCAPICallSuccess ==>' + response);
    Boolean result = null;
    FISCCCustomerIndividualResponse lstCustomerIndividualResponse = new FISCCCustomerIndividualResponse();

    try {
      if (response == null) {
        tffa.logger.debug('inside if response null');
        result = false;
        return partyObj;
      }
      FISCCCustomerSearchTaxnbrResponse objFISCCCustomerSearchTaxnbrResponse = new FISCCCustomerSearchTaxnbrResponse();
      if (response instanceof FISCCCustomerSearchTaxnbrResponse) {
        objFISCCCustomerSearchTaxnbrResponse = (FISCCCustomerSearchTaxnbrResponse) response;
      } else {
        return partyObj;
      }

      tffa.logger.debug('fisccCustomerDTO ==> ' + objFISCCCustomerSearchTaxnbrResponse);
      if (
        objFISCCCustomerSearchTaxnbrResponse != null &&
        objFISCCCustomerSearchTaxnbrResponse.customersLst != null &&
        objFISCCCustomerSearchTaxnbrResponse.customersLst.size() > 0
      ) {
        partyObj.Customer_Number__c = objFISCCCustomerSearchTaxnbrResponse.customersLst[0].CICustRtnNbr;

        if (partyObj.Customer_Number__c != null) {
          partyObj.tffa__IsExistingCustomer__c = true;
        }

        if (objFISCCCustomerSearchTaxnbrResponse.customersLst[0].SurNme != null) {
          partyObj.FISLastName__c = objFISCCCustomerSearchTaxnbrResponse.customersLst[0].SurNme;
        }

        if (objFISCCCustomerSearchTaxnbrResponse.customersLst[0].CIBirthdate != null) {
          partyObj.FISDob__c = objFISCCCustomerSearchTaxnbrResponse.customersLst[0].CIBirthdate;
        }
      }
      tffa.logger.debug('partyObj updated ==>' + partyObj);
      //  result = true;
      return partyObj;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Search customer : ' + +ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return partyObj;
    }
  }
}