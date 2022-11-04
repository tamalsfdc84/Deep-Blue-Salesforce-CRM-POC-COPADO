public with sharing class CZHSAAddBeneficiaryExtension {
  public static Boolean invokeApiCall(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    List<tffa__Beneficiary__c> beneficiaryList,
    tffa__Application__c applicationObj
  ) {
    Boolean finalResult = false;

    try {
      FISCCRequestBaseDTO fisccRequestBaseDTO = createBeneficiaryRequest(beneficiaryList, applicationObj);
      Object result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);

      finalResult = isFISCCAPICallSuccess(result);
      if (finalResult) {
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.HSA_NEW_BENEFICIARY);
        return true;
      } else {
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.HSA_NEW_BENEFICIARY);
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZHSAAddBeneficiaryExtension.invokeApiCall ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.HSA_NEW_BENEFICIARY);
      return false;
    }
  }

  public static FISCCRequestBaseDTO createBeneficiaryRequest(
    List<tffa__Beneficiary__c> beneficiaryList,
    tffa__Application__c applicationObj
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    CZHSAAddBeneficiaryReqDTO request = new CZHSAAddBeneficiaryReqDTO();

    try {
      request.acctInfo.ApplCde = 'DP';
      request.acctInfo.AcctNum = applicationObj.tffa__AccountNumber__c;

      for (tffa__Beneficiary__c benef : beneficiaryList) {
        CZHSAAddBeneficiaryReqDTO.AddList addList = new CZHSAAddBeneficiaryReqDTO.AddList();
        addList.E1E2 = benef.tffa__RelationCodeName__c == 'SPOUSE' ? 4 : 5;
        addList.E2E1 = benef.tffa__Type__c == 'PRIMARY' ? 1 : 2;
        addList.EffDte = CZWTFCCommonHelper.formatDate(applicationObj.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
        addList.RelaPercent = benef.tffa__SharePercentage__c;

        if (benef.CZParty__c != null) {
          addList.ExistingCust.CustNum = Decimal.valueOf(benef.CZParty__r.Customer_Number__c);
        } else if (String.isNotBlank(benef.Customer_Number__c)) {
          addList.ExistingCust.CustNum = Decimal.valueOf(benef.Customer_Number__c);
        } else {
          if (benef.tffa__PartyType__c == FISCCIntegrationConstants.ORGANIZATION) {
            addList.NewCust.CustNme = CZWTFCCommonHelper.trimString(benef.tffa__LegalName__c, FISCCIntegrationConstants.FULL_NAME_LENGTH);
            addList.NewCust.CustTyp = 'O';

            if(!Test.isRunningTest()){
              CZTerafinaFisMapping__c tfFisOrganizationTypeeMap = CZTerafinaFisMapping__c.getValues(
                'OrganizationType' +
                '_' +
                benef.tffa__OrganizationType__c
              );
              addList.NewCust.BusTyp = tfFisOrganizationTypeeMap.FisValue__c;
            }
            
          } else {
            addList.NewCust.CustNme = CZWTFCCommonHelper.getFormattedFullName(
              benef.tffa__FirstName__c,
              benef.tffa__MiddleName__c,
              benef.tffa__LastName__c,
              benef.tffa__Suffix__c,
              FISCCIntegrationConstants.FULL_NAME_LENGTH
            );
            addList.NewCust.CustTyp = 'I';
            addList.NewCust.BusTyp = '';
          }


          if (benef.tffa__Address__r != null) {
            addList.NewCust.Addr = benef.tffa__Address__r.tffa__Line1__c;
            addList.NewCust.CtyStZip =
              benef.tffa__Address__r.tffa__City__c +
              ' ' +
              benef.tffa__Address__r.tffa__State__c +
              ' ' +
              benef.tffa__Address__r.tffa__ZipCode__c;
            addList.NewCust.Country = 'USA';
          }

          if (benef.tffa__BirthDate__c != null) {
            Datetime birthDate = Datetime.newInstance(benef.tffa__BirthDate__c, Time.newInstance(0, 0, 0, 0));
            addList.NewCust.BrthDte = birthDate.format('yyyy-MM-dd');
          }

          if (String.isNotBlank(benef.tffa__NationalIdentifierType__c))
            addList.NewCust.TaxId = CZWTFCCommonHelper.getTaxIdType(benef.tffa__NationalIdentifierType__c);
          if (String.isNotBlank(benef.tffa__NationalIdentifierValue__c))
            addList.NewCust.TaxNum = Decimal.valueOf(benef.tffa__NationalIdentifierValue__c);
          if (String.isNotBlank(benef.tffa__PrimaryPhone__c)) {
            String phoneNumber = benef.tffa__PrimaryPhone__c.right(10);
            addList.NewCust.Phone = Decimal.valueOf(phoneNumber);
          }

          addList.NewCust.OvrdStandardized = 'No';
          addList.NewCust.OvrdDupTaxNum = 'No';
          addList.NewCust.OvrdAddrStandardized = 'No';
        }

        request.beneficiaryInfo.AddLst.add(addList);
      }

      fisccRequestBaseDTO = request;

      tffa.Logger.debug('fisccRequestBaseDTO::' + fisccRequestBaseDTO);

      return fisccRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in CZHSAAddBeneficiaryExtension createBeneficiaryRequest : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
    }
    return fisccRequestBaseDTO;
  }

  public static Boolean isFISCCAPICallSuccess(Object response) {
    CZHSAAddBeneficiaryResponseDTO objCZHSAAddBeneficiaryResponseDTO;
    if (response instanceof CZHSAAddBeneficiaryResponseDTO) {
      objCZHSAAddBeneficiaryResponseDTO = (CZHSAAddBeneficiaryResponseDTO) response;
    }

    tffa.Logger.debug('CZHSAAddBeneficiaryExtension - isFISCCAPICallSuccess::' + objCZHSAAddBeneficiaryResponseDTO);

    if (
      objCZHSAAddBeneficiaryResponseDTO != null &&
      objCZHSAAddBeneficiaryResponseDTO.Metadata.MsgLst != null &&
      !objCZHSAAddBeneficiaryResponseDTO.Metadata.MsgLst.isEmpty()
    ) {
      if (
        ('0').equalsIgnoreCase(objCZHSAAddBeneficiaryResponseDTO.Metadata.MsgLst[0].Code) &&
        ('Success').equalsIgnoreCase(objCZHSAAddBeneficiaryResponseDTO.Metadata.MsgLst[0].Text)
      ) {
        return true;
      }
    }

    return false;
  }
}