public with sharing class FISCCCreateCustomerIndividualHelper {
  public static FISCCCustomerDTO createCustomerRequest(
    tffa__Party__c partyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug('Inside createCustomerSearchRequest method');
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCCustomerDTO objFISCCCustomerDTO = new FISCCCustomerDTO();
    tffa.logger.debug('partyObjs in createCustomerSearchRequest==>' + partyObj);

    tffa__Identification__c identificationObj = null;
    try {
      tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
      if (partyObj != null) {
        tffa.logger.debug('Party is not null');

        objFISCCCustomerDTO.CIBirthdate = String.valueOf(partyObj.tffa__BirthDate__c);
        objFISCCCustomerDTO.NAStandardizationOvride = 'Y';
        objFISCCCustomerDTO.CICitizenshipCde = 'Y';
        if (partyObj.tffa__Citizenship__c != 'Citizen') {
          objFISCCCustomerDTO.CICitizenshipCde = 'N';
        }
        tffa.logger.debug('objFISCCCustomerDTO.CICitizenshipCde ==>' + objFISCCCustomerDTO.CICitizenshipCde);
        //--- Primary number Should be set based on Preferred contact
        String strPrimaryphone = partyObj.tffa__PrimaryPhone__c != null ? partyObj.tffa__PrimaryPhone__c : '';
        String strSecondaryphone = partyObj.tffa__SecondaryPhone__c != null ? partyObj.tffa__SecondaryPhone__c : '';
        String strCellphone = partyObj.CellPhoneNumber__c != null ? partyObj.CellPhoneNumber__c : '';
        if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('HOME')) {
          tffa.logger.debug('Home ==');
          if (strPrimaryphone.length() > 10) {
            objFISCCCustomerDTO.CIPrmyPhNbr = strPrimaryphone.Substring(strPrimaryphone.length() - 10);
          } else {
            objFISCCCustomerDTO.CIPrmyPhNbr = strPrimaryphone;
          }
        }
        if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('WORK')) {
          tffa.logger.debug('WORK ==');
          if (strSecondaryphone.length() > 10) {
            objFISCCCustomerDTO.CIPrmyPhNbr = strSecondaryphone.Substring(strSecondaryphone.length() - 10);
          } else {
            objFISCCCustomerDTO.CIPrmyPhNbr = strSecondaryphone;
          }
        }
        if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('CELL')) {
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
        if (String.isNotBlank(partyObj.tffa__NationalIdentifierValue__c)) {
          objFISCCCustomerDTO.CICustTaxNbr = partyObj.tffa__NationalIdentifierValue__c;
          objFISCCCustomerDTO.CICustTaxCde = 'S';
        } else {
          objFISCCCustomerDTO.CICustTaxCde = 'N';
        }
        if (brandObj != null && !String.isBlank(brandObj.CIPrmyOffcrNbr__c)) {
          objFISCCCustomerDTO.CIPrmyOffcrNbr = brandObj.CIPrmyOffcrNbr__c;
        }

        objFISCCCustomerDTO.CIPPwd = partyObj.SecretWord__c;
        objFISCCCustomerDTO.CIPPwdQuestion = partyObj.SecretWordHint__c;

        fillCustomerIdentityDetails(partyObj, objFISCCCustomerDTO);

        objFISCCCustomerDTO.CIBrnchNbr = Integer.valueOf(partyObj.FISBranchCode__c);
        objFISCCCustomerDTO.CICstCntrNbr = Integer.valueOf(partyObj.CostCenter__c);

        fillAddressDetails(partyObj, objFISCCCustomerDTO);
        tffa.logger.debug('fillAddressDetails called');
        fillEmploymentDetails(partyObj, objFISCCCustomerDTO);
        tffa.logger.debug('objFISCCCustomerDTO ==>' + objFISCCCustomerDTO);
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

    try {
      if (partyObj != null && partyObj.tffa__Identifications__r != null && !partyObj.tffa__Identifications__r.isEmpty()) {
        tffa.logger.debug('inside party not null 2');
        identificationObj = partyObj.tffa__Identifications__r[0];
        if (identificationObj != null) {
          tffa.logger.debug('inside identificationObj not null 2');
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
          objFISCCCustomerDTO.CIPIDIssLoc1 = identificationObj.tffa__IssuingState__c;
          objFISCCCustomerDTO.CIPIDIssDte1 = String.valueOf(identificationObj.tffa__IssueDate__c);
          objFISCCCustomerDTO.CIPIDExpDte1 = String.valueOf(identificationObj.tffa__ExpirationDate__c);
        }
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerIdentityDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }

    tffa.logger.debug('objFISCCCustomerDTO in identity : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }

  // Method to derive AddressLines and AddressCodes
  public static FISCCCustomerDTO fillAddressDetails(tffa__Party__c partyObj, FISCCCustomerDTO objFISCCCustomerDTO) {
    tffa.logger.debug('inside fillAddressDetails');
    try {
      tffa__Address__c addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
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
          objFISCCCustomerDTO.CINmeAddrLne04 =
            addressObj.tffa__City__c +
            ' ' +
            addressObj.tffa__State__c +
            ' ' +
            addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'A';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde04 = 'C';
        } else {
          objFISCCCustomerDTO.CINmeAddrLne03 =
            addressObj.tffa__City__c +
            ' ' +
            addressObj.tffa__State__c +
            ' ' +
            addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'C';
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
      tffa.logger.debug('partyObj ==>' + partyObj);
      tffa.logger.debug('partyObj.tffa__Employments__r ==>' + partyObj.tffa__Employments__r);
      if (partyObj != null && partyObj.tffa__Employments__r != null && !partyObj.tffa__Employments__r.isEmpty()) {
        tffa.logger.debug('inside Employment not null ');
        employmentObj = partyObj.tffa__Employments__r[0];

        objFISCCCustomerDTO.CICustEmploymentSchool = employmentObj.tffa__EmployerName__c;
        if (
          employmentObj.tffa__Type__c != null &&
          ((employmentObj.tffa__Type__c).equalsIgnoreCase('STUDENT') || (employmentObj.tffa__Type__c).equalsIgnoreCase('HOMEMAKER'))
        ) {
          CZTerafinaFisMapping__c tfFisMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.EMPLOYMENT_TYPE +
            '_' +
            employmentObj.tffa__Type__c
          );
          if (tfFisMap != null) {
            objFISCCCustomerDTO.CIOccpnCde = tfFisMap.FisValue__c;
          }
        } else {
          objFISCCCustomerDTO.CIOccpnCde = employmentObj.OccupationType__c;
        }
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerEmpDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }

    tffa.logger.debug('objFISCCCustomerDTO in employmnt : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }
}