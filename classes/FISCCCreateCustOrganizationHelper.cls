public with sharing class FISCCCreateCustOrganizationHelper {
  public static FISCCOrganizationDTO createCustomerRequest(
    tffa__Party__c currentPartyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCOrganizationDTO objFISCCCustomerDTO = new FISCCOrganizationDTO();

    tffa__Identification__c identificationObj = null;
    try {
      tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
      if (currentPartyObj != null) {
        tffa.logger.debug('Party is not null');
        String orgType = currentPartyObj.tffa__OrganizationType__c;
        if (orgType == 'LIMITED_LIABILITY_COMPANY') {
          orgType = 'LLC';
        }
        CZTerafinaFisMapping__c tfFisOrgTypeMap = CZTerafinaFisMapping__c.getValues('OrganizationType' + '_' + orgType);
        if (tfFisOrgTypeMap != null) {
          objFISCCCustomerDTO.CITypOfBusCde = tfFisOrgTypeMap.FisValue__c;
        }

        objFISCCCustomerDTO.NAStandardizationOvride = 'Y';
        objFISCCCustomerDTO.DupTaxNbrOverride = 'Y';
        if (currentPartyObj.tffa__EstablishmentDate__c != null) {
          objFISCCCustomerDTO.CIBusSinceDte = String.valueOf(currentPartyObj.tffa__EstablishmentDate__c);
        }

        if (String.isNotBlank(currentPartyObj.tffa__IndustryClassificationValue__c)) {
          objFISCCCustomerDTO.CINAICSCde = currentPartyObj.tffa__IndustryClassificationValue__c;
        }

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

        if (String.isNotBlank(currentPartyObj.CZForeignCustomerForm__c) && currentPartyObj.CZForeignCustomerForm__c != 'None') {
          objFISCCCustomerDTO.CIW8Ind = currentPartyObj.CZForeignCustomerForm__c;
          if (currentPartyObj.CZFormCertificationDate__c != null) {
            objFISCCCustomerDTO.CIW8Dte = String.valueOf(currentPartyObj.CZFormCertificationDate__c);
          }
        }

        CZTerafinaFisMapping__c tfFisTaxMap = CZTerafinaFisMapping__c.getValues(
          'TaxType' +
          '_' +
          currentPartyObj.tffa__NationalIdentifierType__c
        );
        if (tfFisTaxMap != null) {
          objFISCCCustomerDTO.CICustTaxCde = tfFisTaxMap.FisValue__c;
          objFISCCCustomerDTO.CICustTaxNbr = currentPartyObj.tffa__NationalIdentifierValue__c;
        }

        objFISCCCustomerDTO.CIPPwd = currentPartyObj.SecretWord__c;
        objFISCCCustomerDTO.CIPPwdQuestion = currentPartyObj.SecretWordHint__c;

        if (String.isNotBlank(currentPartyObj.CZPrimaryOfficer__c)) {
          objFISCCCustomerDTO.CIPrmyOffcrNbr = currentPartyObj.CZPrimaryOfficer__c;
        }

        if (
          String.isNotBlank(currentPartyObj.CZSecondaryOfficer__c) &&
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH
        ) {
          objFISCCCustomerDTO.CIScndyOffcrNbr = currentPartyObj.CZSecondaryOfficer__c;
        }
        objFISCCCustomerDTO.CIBrnchNbr = Integer.valueOf(currentPartyObj.FISBranchCode__c);
        objFISCCCustomerDTO.CICstCntrNbr = Integer.valueOf(currentPartyObj.CostCenter__c);

        fillCustomerIdentityDetails(currentPartyObj, objFISCCCustomerDTO);

        if (currentPartyObj.tffa__AddressXrefs__r != null && currentPartyObj.tffa__AddressXrefs__r.size() > 0) {
          fillAddressDetails(currentPartyObj, objFISCCCustomerDTO);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCCreateCustOrganizationHelper.createCustomerRequest : ' +
        ex.getMessage() +
        ex.getStackTraceString()
      );
    }
    return objFISCCCustomerDTO;
  }

  @TestVisible
  private static FISCCOrganizationDTO fillAddressDetails(tffa__Party__c partyObj, FISCCOrganizationDTO objFISCCCustomerDTO) {
    tffa.logger.debug('Inside fillAddressDetails');
    try {
      tffa__Address__c addressObj;
      if (partyObj.tffa__AddressXrefs__r.size() > 1) {
        addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'MAILING');
      } else {
        addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      }

      if (partyObj != null && addressObj != null) {
        tffa.logger.debug('inside party and addressObj not null 2');
        if (partyObj.tffa__LegalName__c.length() > 40) {
          objFISCCCustomerDTO.CINmeAddrLne01 = partyObj.tffa__LegalName__c.substring(0, 39);
        } else {
          objFISCCCustomerDTO.CINmeAddrLne01 = partyObj.tffa__LegalName__c;
        }

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

  public static FISCCOrganizationDTO fillCustomerIdentityDetails(tffa__Party__c partyObj, FISCCOrganizationDTO objFISCCCustomerDTO) {
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
          String idenType = FISCCIntegrationConstants.ORG_IDENTIFICATION_MAP.containsKey(identificationObj.tffa__Type__c)
            ? FISCCIntegrationConstants.ORG_IDENTIFICATION_MAP.get(identificationObj.tffa__Type__c)
            : '';
          CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.IDENTITY_TYPE +
            '_' +
            idenType
          );
          if (tfFisIdentityMap != null) {
            objFISCCCustomerDTO.CIPIDTyp1 = tfFisIdentityMap.FisValue__c;
          }
          objFISCCCustomerDTO.CIPIDNbr1 = identificationObj.tffa__IdentificationNumber__c;
          objFISCCCustomerDTO.CIPIDIssLoc1 = identificationObj.tffa__IssuingState__c;
          objFISCCCustomerDTO.CIPIDIssDte1 = identificationObj.tffa__IssueDate__c != null
            ? String.valueOf(identificationObj.tffa__IssueDate__c)
            : null;
          objFISCCCustomerDTO.CIPIDIssEnt1 = identificationObj.tffa__IssuingAuthority__c;
        }
        if (partyObj.tffa__Identifications__r.size() > 1) {
          tffa__Identification__c identificationObj2 = partyObj.tffa__Identifications__r[1];
          String idenType = FISCCIntegrationConstants.ORG_IDENTIFICATION_MAP.containsKey(identificationObj2.tffa__Type__c)
            ? FISCCIntegrationConstants.ORG_IDENTIFICATION_MAP.get(identificationObj2.tffa__Type__c)
            : '';
          CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.IDENTITY_TYPE +
            '_' +
            idenType
          );
          if (tfFisIdentityMap != null) {
            objFISCCCustomerDTO.CIPIDTyp2 = tfFisIdentityMap.FisValue__c;
          }
          objFISCCCustomerDTO.CIPIDNbr2 = identificationObj2.tffa__IdentificationNumber__c;
          objFISCCCustomerDTO.CIPIDIssLoc2 = identificationObj2.tffa__IssuingState__c;
          objFISCCCustomerDTO.CIPIDIssDte2 = String.valueOf(identificationObj2.tffa__IssueDate__c);

          objFISCCCustomerDTO.CIPIDIssEnt2 = identificationObj2.tffa__IssuingAuthority__c;
        }
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception into fillCustomerIdentityDetails :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return objFISCCCustomerDTO;
    }

    tffa.logger.debug('objFISCCCustomerDTO in identity : ==>' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }
}