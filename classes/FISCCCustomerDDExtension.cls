public with sharing class FISCCCustomerDDExtension {
  public static FISCCDepositOriginationRequestBaseDTO generateCustomerDDRequest(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {
      tffa.Logger.debug('Inside generateCustomerDDRequest method');
      FISCCDOCustomerDDRequest baseddReq = new FISCCDOCustomerDDRequest();
      baseddReq.dueDiligenceReq.dueDiligenceDemographics.CustNbr = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
      if (
        partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL &&
        partyObj.tffa__Employments__r != null &&
        !partyObj.tffa__Employments__r.isEmpty()
      ) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.OccpnDesc = CZWTFCCommonHelper.getOccupationLabel(
          partyObj.tffa__Employments__r[0].OccupationType__c
        );
        if (String.isNotBlank(partyObj.tffa__Employments__r[0].tffa__Title__c)) {
          baseddReq.dueDiligenceReq.dueDiligenceDemographics.Title = partyObj.tffa__Employments__r[0].tffa__Title__c;
        }
        if (partyObj.tffa__Employments__r[0].tffa__Type__c == 'RETIRED') {
          baseddReq.dueDiligenceReq.dueDiligenceDemographics.FullTime = 'R';
        } else if (partyObj.tffa__Employments__r[0].tffa__Type__c == 'UNEMPLOYED') {
          baseddReq.dueDiligenceReq.dueDiligenceDemographics.FullTime = 'U';
        }
      }

      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL && partyObj.tffa__Citizenship__c == CZWTFCConstants.RESIDENT) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.RsdntPrsn = 'Y';
        if (partyObj.tffa__CountryOfCitizenship__c != null) {
          CZTerafinaFisMapping__c tfFisCountryOfCitizenMap = CZTerafinaFisMapping__c.getValues(
            'AddressCountry' +
            '_' +
            partyObj.tffa__CountryOfCitizenship__c
          );
          if (tfFisCountryOfCitizenMap != null) {
            baseddReq.dueDiligenceReq.dueDiligenceDemographics.CntryCtznshp = tfFisCountryOfCitizenMap.FisValue__c;
          }
        }
      }
      /* tffa__Address__c addressObj;
      if (partyObj.tffa__AddressXrefs__r != null && partyObj.tffa__AddressXrefs__r.size() > 1) {
        addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'HOME');
      }
      if (addressObj != null) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.Cmmt = getAddressString(addressObj);
      }
      */
      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
        if (String.isNotBlank(partyObj.tffa__BusinessDescription__c)) {
          baseddReq.dueDiligenceReq.dueDiligenceDemographics.DescBus = partyObj.tffa__BusinessDescription__c;
        }
        if (FISCCIntegrationLogService.cddObjMap.containsKey(partyObj.Id)) {
          baseddReq = setCDDQuestions(partyObj, baseddReq);
        }
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.UsrDefFld22 = partyObj.CZIsCIPExempt__c ? 'Y' : 'N';
      }

      fisccDepositOriginationRequestBaseDTO = baseddReq;
      tffa.Logger.debug('generateCustomerDDRequest req ==> ' + fisccDepositOriginationRequestBaseDTO);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateCustomerDDRequest ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return fisccDepositOriginationRequestBaseDTO;
  }

  public static String getAddressString(tffa__Address__c addressObj) {
    String addressStr = '';
    if (String.isNotBlank(addressObj.tffa__Line1__c)) {
      addressStr += addressObj.tffa__Line1__c;
    }
    if (String.isNotBlank(addressObj.tffa__Line2__c)) {
      addressStr += ' ' + addressObj.tffa__Line2__c;
    }
    if (String.isNotBlank(addressObj.tffa__City__c)) {
      addressStr += ' ' + addressObj.tffa__City__c;
    }
    if (String.isNotBlank(addressObj.tffa__State__c)) {
      addressStr += ' ' + addressObj.tffa__State__c;
    }
    if (String.isNotBlank(addressObj.tffa__ZipCode__c)) {
      addressStr += ' ' + addressObj.tffa__ZipCode__c;
    }
    if (String.isNotBlank(addressObj.tffa__Country__c)) {
      addressStr += ' ' + addressObj.tffa__Country__c;
    }
    return addressStr;
  }

  public static FISCCDOCustomerDDRequest setCDDQuestions(tffa__Party__c partyObj, FISCCDOCustomerDDRequest baseddReq) {
    try {
      if (FISCCIntegrationLogService.cddObjMap != null) {
        List<tffa__DueDiligence__c> ddLst = FISCCIntegrationLogService.cddObjMap.containsKey(partyObj.Id)
          ? FISCCIntegrationLogService.cddObjMap.get(partyObj.Id)
          : null;

        if (ddLst != null && !ddLst.isEmpty()) {
          for (tffa__DueDiligence__c ddObj : ddLst) {
            if (ddObj.tffa__Items__r != null && !ddObj.tffa__Items__r.isEmpty()) {
              for (tffa__DueDiligenceItem__c ddItemObj : ddObj.tffa__Items__r) {
                if (ddItemObj.tffa__Code__c == 'ForeignOriginatingCountry') {
                  List<String> countryLst = ddItemObj.tffa__Value__c.split(';');
                  for (String country : countryLst) {
                    FISCCDOCustomerDDRequest.IncomingCountry incomingCtr = new FISCCDOCustomerDDRequest.IncomingCountry();
                    CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues('AddressCountry' + '_' + country);
                    if (tfFisIdentityMap != null) {
                      incomingCtr.InCtryCde = tfFisIdentityMap.FisValue__c;
                      baseddReq.dueDiligenceReq.incomingCountries.add(incomingCtr);
                    }
                  }
                } else if (ddItemObj.tffa__Code__c == 'ForeignDestinationCountry') {
                  List<String> countryLst = ddItemObj.tffa__Value__c.split(';');
                  for (String country : countryLst) {
                    FISCCDOCustomerDDRequest.OutgoingCountry outgoingCtr = new FISCCDOCustomerDDRequest.OutgoingCountry();
                    CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues('AddressCountry' + '_' + country);
                    if (tfFisIdentityMap != null) {
                      outgoingCtr.OutCtryCde = tfFisIdentityMap.FisValue__c;
                      baseddReq.dueDiligenceReq.outgoingCountries.add(outgoingCtr);
                    }
                  }
                } else {
                  baseddReq.dueDiligenceReq.dueDiligenceDemographics.setValue(
                    ddItemObj.tffa__Code__c,
                    getCddValue(ddItemObj.tffa__Value__c)
                  );
                }
              }
            }
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in setCDDQuestions ' + ex.getMessage());
    }
    return baseddReq;
  }

  public static String getCddValue(String value) {
    if (value == 'Yes') {
      return 'Y';
    } else if (value == 'No') {
      return 'N';
    } else {
      return value;
    }
  }
}