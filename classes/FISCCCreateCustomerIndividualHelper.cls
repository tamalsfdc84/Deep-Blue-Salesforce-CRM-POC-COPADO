public with sharing class FISCCCreateCustomerIndividualHelper {
  public static FISCCCustomerDTO createCustomerRequest(
    tffa__Party__c currentPartyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug('Inside createCustomerRequest method');
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCCustomerDTO objFISCCCustomerDTO = new FISCCCustomerDTO();

    tffa__Identification__c identificationObj = null;
    try {
      tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
      if (currentPartyObj != null) {
        tffa.logger.debug('Party is not null');

        objFISCCCustomerDTO.CIBirthdate = String.valueOf(currentPartyObj.tffa__BirthDate__c);
        objFISCCCustomerDTO.NAStandardizationOvride = 'Y';
        objFISCCCustomerDTO.CICitizenshipCde = 'Y';
        objFISCCCustomerDTO.DupTaxNbrOverride = 'Y';

        if (currentPartyObj.tffa__Citizenship__c != 'Citizen') {
          objFISCCCustomerDTO.CICitizenshipCde = 'N';
        }
        tffa.logger.debug('objFISCCCustomerDTO.CICitizenshipCde ==>' + objFISCCCustomerDTO.CICitizenshipCde);
        //--- Primary number Should be set based on Preferred contact
        String strPrimaryphone = currentPartyObj.tffa__PrimaryPhone__c != null ? currentPartyObj.tffa__PrimaryPhone__c : '';
        String strSecondaryphone = currentPartyObj.tffa__SecondaryPhone__c != null ? currentPartyObj.tffa__SecondaryPhone__c : '';
        String strCellphone = currentPartyObj.CellPhoneNumber__c != null ? currentPartyObj.CellPhoneNumber__c : '';
        if (
          String.isNotBlank(currentPartyObj.PreferredContactNumber__c) && currentPartyObj.PreferredContactNumber__c.equalsIgnoreCase('HOME')
        ) {
          tffa.logger.debug('Home ==');
          if (strPrimaryphone.length() > 10) {
            objFISCCCustomerDTO.CIPrmyPhNbr = strPrimaryphone.Substring(strPrimaryphone.length() - 10);
          } else {
            objFISCCCustomerDTO.CIPrmyPhNbr = strPrimaryphone;
          }
        }
        if (
          String.isNotBlank(currentPartyObj.PreferredContactNumber__c) && currentPartyObj.PreferredContactNumber__c.equalsIgnoreCase('WORK')
        ) {
          tffa.logger.debug('WORK ==');
          if (strSecondaryphone.length() > 10) {
            objFISCCCustomerDTO.CIPrmyPhNbr = strSecondaryphone.Substring(strSecondaryphone.length() - 10);
          } else {
            objFISCCCustomerDTO.CIPrmyPhNbr = strSecondaryphone;
          }
        }
        if (
          String.isNotBlank(currentPartyObj.PreferredContactNumber__c) && currentPartyObj.PreferredContactNumber__c.equalsIgnoreCase('CELL')
        ) {
          tffa.logger.debug('CELL ==');
          if (strCellphone.length() > 10) {
            tffa.logger.debug('inside if strCellphone.length()> 10');
            objFISCCCustomerDTO.CIPrmyPhNbr = strCellphone.Substring(strCellphone.length() - 10);
          } else {
            tffa.logger.debug('inside else strCellphone.length()> 10');
            objFISCCCustomerDTO.CIPrmyPhNbr = strCellphone;
          }
        }
        if (String.isNotBlank(strSecondaryphone) && strSecondaryphone.length() > 10) {
          objFISCCCustomerDTO.CIScndyPhNbr = strSecondaryphone.Substring(strSecondaryphone.length() - 10);
        } else {
          objFISCCCustomerDTO.CIScndyPhNbr = strSecondaryphone;
        }
        if (strCellphone.length() > 10) {
          objFISCCCustomerDTO.CIMobilePhNbr = strCellphone.Substring(strCellphone.length() - 10);
        } else {
          objFISCCCustomerDTO.CIMobilePhNbr = strCellphone;
        }
        if (String.isNotBlank(currentPartyObj.tffa__NationalIdentifierValue__c)) {
          objFISCCCustomerDTO.CICustTaxNbr = currentPartyObj.tffa__NationalIdentifierValue__c;
          CZTerafinaFisMapping__c tfFisTaxMap = CZTerafinaFisMapping__c.getValues(
            'TaxType' +
            '_' +
            currentPartyObj.tffa__NationalIdentifierType__c
          );
          if (tfFisTaxMap != null) {
            objFISCCCustomerDTO.CICustTaxCde = tfFisTaxMap.FisValue__c;
          }
        } else {
          objFISCCCustomerDTO.CICustTaxCde = 'N';
        }
        if (String.isNotBlank(currentPartyObj.CZPrimaryOfficer__c)) {
          objFISCCCustomerDTO.CIPrmyOffcrNbr = currentPartyObj.CZPrimaryOfficer__c;
        }

        if (
          String.isNotBlank(currentPartyObj.CZSecondaryOfficer__c) &&
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH
        ) {
          objFISCCCustomerDTO.CIScndyOffcrNbr = currentPartyObj.CZSecondaryOfficer__c;
        }

        objFISCCCustomerDTO.CIPPwd = currentPartyObj.SecretWord__c;
        objFISCCCustomerDTO.CIPPwdQuestion = currentPartyObj.SecretWordHint__c;

        fillCustomerIdentityDetails(currentPartyObj, objFISCCCustomerDTO);

        objFISCCCustomerDTO.CIBrnchNbr = Integer.valueOf(currentPartyObj.FISBranchCode__c);
        objFISCCCustomerDTO.CICstCntrNbr = Integer.valueOf(currentPartyObj.CostCenter__c);

        fillCustomerCodes(currentPartyObj, objFISCCCustomerDTO);

        if (currentPartyObj.tffa__AddressXrefs__r != null && currentPartyObj.tffa__AddressXrefs__r.size() > 0) {
          fillAddressDetails(currentPartyObj, objFISCCCustomerDTO);
        }
        tffa.logger.debug('fillAddressDetails called');
        fillEmploymentDetails(currentPartyObj, objFISCCCustomerDTO);
        tffa.logger.debug('objFISCCCustomerDTO ==>' + objFISCCCustomerDTO);
        if (String.isNotBlank(currentPartyObj.CZForeignCustomerForm__c) && currentPartyObj.CZForeignCustomerForm__c != 'None') {
          objFISCCCustomerDTO.CIW8Ind = currentPartyObj.CZForeignCustomerForm__c;
          if (currentPartyObj.CZFormCertificationDate__c != null) {
            objFISCCCustomerDTO.CIW8Dte = String.valueOf(currentPartyObj.CZFormCertificationDate__c);
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createCustomerRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }

    return objFISCCCustomerDTO;
  }

  public static FISCCCustomerDTO fillCustomerIdentityDetails(tffa__Party__c partyObj, FISCCCustomerDTO objFISCCCustomerDTO) {
    tffa.logger.debug('Inside fillCustomerIdentityDetails');
    tffa__Identification__c identificationObj = null;
    List<String> idTypes = new List<String>{ '104', '105', '107', '108' };

    try {
      if (partyObj != null && partyObj.tffa__Identifications__r != null && !partyObj.tffa__Identifications__r.isEmpty()) {
        identificationObj = partyObj.tffa__Identifications__r[0];
        if (identificationObj != null) {
          if (identificationObj.tffa__Type__c.equalsIgnoreCase('DL')) {
            objFISCCCustomerDTO.CIPrmyID = identificationObj.tffa__IdentificationNumber__c;
          }
          CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.IDENTITY_TYPE +
            '_' +
            identificationObj.tffa__Type__c
          );
          if (tfFisIdentityMap != null) {
            objFISCCCustomerDTO.CIPIDTyp1 = tfFisIdentityMap.FisValue__c;
          }
          objFISCCCustomerDTO.CIPIDNbr1 = identificationObj.tffa__IdentificationNumber__c;
          if (idTypes.contains(objFISCCCustomerDTO.CIPIDTyp1)) {
            objFISCCCustomerDTO.CIPIDIssLoc1 = identificationObj.tffa__IssuingCountry__c;
          } else {
            objFISCCCustomerDTO.CIPIDIssLoc1 = identificationObj.tffa__IssuingState__c;
          }

          objFISCCCustomerDTO.CIPIDIssDte1 = String.valueOf(identificationObj.tffa__IssueDate__c);
          objFISCCCustomerDTO.CIPIDExpDte1 = String.valueOf(identificationObj.tffa__ExpirationDate__c);
        }
        if (partyObj.tffa__Identifications__r.size() > 1) {
          tffa__Identification__c identificationObj2 = partyObj.tffa__Identifications__r[1];
          CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.IDENTITY_TYPE +
            '_' +
            identificationObj2.tffa__Type__c
          );
          if (tfFisIdentityMap != null) {
            objFISCCCustomerDTO.CIPIDTyp2 = tfFisIdentityMap.FisValue__c;
          }
          objFISCCCustomerDTO.CIPIDNbr2 = identificationObj2.tffa__IdentificationNumber__c;
          if (idTypes.contains(objFISCCCustomerDTO.CIPIDTyp1)) {
            objFISCCCustomerDTO.CIPIDIssLoc1 = identificationObj2.tffa__IssuingCountry__c;
          } else {
            objFISCCCustomerDTO.CIPIDIssLoc2 = identificationObj2.tffa__IssuingState__c;
          }
          objFISCCCustomerDTO.CIPIDIssDte2 = String.valueOf(identificationObj2.tffa__IssueDate__c);
          objFISCCCustomerDTO.CIPIDExpDte2 = String.valueOf(identificationObj2.tffa__ExpirationDate__c);
        }
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerIdentityDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return objFISCCCustomerDTO;
    }

    tffa.logger.debug('objFISCCCustomerDTO in identity : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }

  // Method to derive AddressLines and AddressCodes
  public static FISCCCustomerDTO fillAddressDetails(tffa__Party__c partyObj, FISCCCustomerDTO objFISCCCustomerDTO) {
    tffa.logger.debug('Inside fillAddressDetails');
    try {
      tffa__Address__c addressObj;
      String stateCode = '';
      if (partyObj.tffa__AddressXrefs__r.size() > 1) {
        addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'HOME');
      } else {
        addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      }
      if (addressObj.tffa__Country__c != null && addressObj.tffa__Country__c != 'US' && String.isNotBlank(addressObj.CZStateLabel__c)) {
        stateCode = addressObj.CZStateLabel__c;
      } else {
        stateCode = addressObj.tffa__State__c;
      }

      if (partyObj != null && addressObj != null) {
        tffa.logger.debug('inside party and addressObj not null 2');
        objFISCCCustomerDTO.CINmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
          partyObj.tffa__FirstName__c,
          partyObj.tffa__MiddleName__c,
          partyObj.tffa__LastName__c,
          partyObj.tffa__Suffix__c,
          FISCCIntegrationConstants.FULL_NAME_LENGTH
        );

        // if (partyObj.tffa__Suffix__c != null && !String.isBlank(partyObj.tffa__Suffix__c)) {
        //   objFISCCCustomerDTO.CICurNmeSfxCde = Integer.valueOf(partyObj.tffa__Suffix__c);
        // }
        objFISCCCustomerDTO.CINmeAddrLneCde01 = 'N';
        objFISCCCustomerDTO.CINmeAddrLne02 = addressObj.tffa__Line1__c;
        if (String.isNotBlank(addressObj.tffa__Line2__c)) {
          objFISCCCustomerDTO.CINmeAddrLne03 = addressObj.tffa__Line2__c;
          objFISCCCustomerDTO.CINmeAddrLne04 = addressObj.tffa__City__c + ' ' + stateCode + ' ' + addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'A';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde04 = 'C';
        } else {
          objFISCCCustomerDTO.CINmeAddrLne03 = addressObj.tffa__City__c + ' ' + stateCode + ' ' + addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'C';
        }

        if (addressObj.tffa__Country__c != null) {
          CZTerafinaFisMapping__c tfFisAddressMap = CZTerafinaFisMapping__c.getValues('AddressCountry' + '_' + addressObj.tffa__Country__c);
          if (tfFisAddressMap != null) {
            objFISCCCustomerDTO.CtryCde = tfFisAddressMap.FisValue__c;
          }
        }
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerIdentityDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return objFISCCCustomerDTO;
    }

    tffa.logger.debug('objFISCCCustomerDTO in identity : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }

  // Method to get Employment details
  public static FISCCCustomerDTO fillEmploymentDetails(tffa__Party__c partyObj, FISCCCustomerDTO objFISCCCustomerDTO) {
    tffa.logger.debug('Inside fillEmploymentDetails');
    try {
      tffa__Employment__c employmentObj = new tffa__Employment__c();
      tffa.logger.debug('partyObj.tffa__Employments__r ==>' + partyObj.tffa__Employments__r);
      if (partyObj != null && partyObj.tffa__Employments__r != null && !partyObj.tffa__Employments__r.isEmpty()) {
        tffa.logger.debug('inside Employment not null ');
        employmentObj = partyObj.tffa__Employments__r[0];
        objFISCCCustomerDTO.CICustEmploymentSchool = employmentObj.tffa__EmployerName__c;
        objFISCCCustomerDTO.CIOccpnCde = employmentObj.OccupationType__c;
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerEmpDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }

    tffa.logger.debug('objFISCCCustomerDTO in employmnt : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }

  public static FISCCCustomerDTO fillCustomerCodes(tffa__Party__c partyObj, FISCCCustomerDTO objFISCCCustomerDTO) {
    tffa.Logger.debug('In fillCustomerCodes');
    List<String> codeLst = FISCCCommonHelper.getCustomerCustomCodes(partyObj);
    for (String code : codeLst) {
      if (String.isBlank(objFISCCCustomerDTO.CICustCde1)) {
        objFISCCCustomerDTO.CICustCde1 = code;
      } else if (String.isBlank(objFISCCCustomerDTO.CICustCde2)) {
        objFISCCCustomerDTO.CICustCde2 = code;
      } else if (String.isBlank(objFISCCCustomerDTO.CICustCde3)) {
        objFISCCCustomerDTO.CICustCde3 = code;
      } else if (String.isBlank(objFISCCCustomerDTO.CICustCde4)) {
        objFISCCCustomerDTO.CICustCde4 = code;
      }
    }
    return objFISCCCustomerDTO;
  }
}