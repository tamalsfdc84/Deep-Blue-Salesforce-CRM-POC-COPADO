public with sharing class CZIRAAddBeneficiaryExtension {

  public static Boolean invokeApiCall(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    List<tffa__Beneficiary__c> beneficiaryList,
    tffa__Application__c applicationObj
  ) {
    CZIRAAddBeneficiaryResponseDTO response;

    try {
      FISCCRequestBaseDTO fisccRequestBaseDTO = createBeneficiaryRequest(beneficiaryList, applicationObj);
      Object result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);

      response = isFISCCAPICallSuccess(result); 

      if(response != null){
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.IRA_NEW_BENEFICIARY);
        return true;
      } else {
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.IRA_NEW_BENEFICIARY);
        return false;
      }
      
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZIRAAddBeneficiaryExtension.invokeApiCall ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.IRA_NEW_BENEFICIARY);
      return false;
    }
  }

  public static FISCCRequestBaseDTO createBeneficiaryRequest(
    List<tffa__Beneficiary__c> beneficiaryList,
    tffa__Application__c applicationObj
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    CZIRAAddBeneficiaryReqDTO request = new CZIRAAddBeneficiaryReqDTO();
    
    try {

      request.planBeneficiary.PlnNbr = applicationObj.tffa__InvestmentPlanNumber__c;

      for(tffa__Beneficiary__c benef: beneficiaryList){
        CZIRAAddBeneficiaryReqDTO.PlanBeneficiariesDataLst addList = new CZIRAAddBeneficiaryReqDTO.PlanBeneficiariesDataLst();

        if(benef.tffa__PartyType__c == FISCCIntegrationConstants.ORGANIZATION){
          addList.Nme = CZWTFCCommonHelper.trimString(benef.tffa__LegalName__c, FISCCIntegrationConstants.FULL_NAME_LENGTH);
        } else {
          addList.Nme = CZWTFCCommonHelper.getFormattedFullName(
          benef.tffa__FirstName__c,
          benef.tffa__MiddleName__c,
          benef.tffa__LastName__c,
          benef.tffa__Suffix__c,
          FISCCIntegrationConstants.FULL_NAME_LENGTH
        );
        }

        if(String.isNotBlank(benef.tffa__NationalIdentifierType__c))
          addList.TaxId = CZWTFCCommonHelper.getTaxIdType(benef.tffa__NationalIdentifierType__c);
        if(String.isNotBlank(benef.tffa__NationalIdentifierValue__c) && String.isNotBlank(addList.TaxId) && addList.TaxId != 'T')
          addList.TxpyrNbr= String.valueOf(benef.tffa__NationalIdentifierValue__c);
        if(String.isNotBlank(benef.tffa__PrimaryPhone__c)){
          addList.Phn = benef.tffa__PrimaryPhone__c.right(10);
        }

        // If NationalIdentifierType is ITIN send N to FIS
        if(String.isNotBlank(addList.TaxId) && addList.TaxId == 'T'){
          addList.TaxId = 'N';
        }   

        addList.SpseNonSpseInd = benef.tffa__RelationCodeName__c == 'SPOUSE' ? 'S' : 'N';
        addList.PrmyCntgInd = benef.tffa__Type__c == 'PRIMARY' ? 'P' : 'C';
        addList.Perc = String.valueOf(benef.tffa__SharePercentage__c);

        if(benef.tffa__BirthDate__c != null){
          Datetime birthDate = Datetime.newInstance(benef.tffa__BirthDate__c, Time.newInstance(0,0,0,0));
          addList.Birthdate = birthDate.format('yyyy-MM-dd');
        }

        request.planBeneficiariesDataLst.add(addList);
      }

      fisccRequestBaseDTO = request;

      tffa.Logger.debug('fisccRequestBaseDTO::'+ fisccRequestBaseDTO);

      return fisccRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in CZIRAAddBeneficiaryExtension createBeneficiaryRequest : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
    }
    return fisccRequestBaseDTO;
  }

  public static CZIRAAddBeneficiaryResponseDTO isFISCCAPICallSuccess(Object response) {
    CZIRAAddBeneficiaryResponseDTO objCZIRAAddBeneficiaryResponseDTO;
    if (response instanceof CZIRAAddBeneficiaryResponseDTO) {
      objCZIRAAddBeneficiaryResponseDTO = (CZIRAAddBeneficiaryResponseDTO) response;
    }
    
    return objCZIRAAddBeneficiaryResponseDTO;
  }
}