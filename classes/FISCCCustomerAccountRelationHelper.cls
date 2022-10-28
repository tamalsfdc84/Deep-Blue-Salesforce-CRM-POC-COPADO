public with sharing class FISCCCustomerAccountRelationHelper {
  public static FISCCCustomerAccountRelationDTO customerAccountRelationRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCCustomerAccountRelationDTO fisccCustomerAccountRelationDTO = new FISCCCustomerAccountRelationDTO();
    Integer jointApplicantCounter = 1;

    try {
      tffa.Logger.debug('Inside customerAccountRelationRequest method');
      fisccCustomerAccountRelationDTO.ApplCde = FISCCIntegrationConstants.GenDPApplID;
      tffa__Party__c primaryParty = CZWTFCCommonHelper.getPrimaryParty(FISCCIntegrationLogService.submissionObj, partyObjs);
      tffa__Product__c prod = appObjs[0].tffa__Product__r;
      for (tffa__Party__c tfParty : partyObjs) {
        Boolean isPrimary = primaryParty.Id.equals(tfParty.Id);
        // check for Custodian Product
        Integer idx = getPartyIndex(appObjs[0], tfParty);
        if (isPrimary) {
          tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
          if (String.isBlank(tfParty.Customer_Number__c)) {
            fisccCustomerAccountRelationDTO.CIRltApplNbr01 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
          } else {
            fisccCustomerAccountRelationDTO.CIRltApplNbr01 = tfParty.Customer_Number__c;
          }
          fisccCustomerAccountRelationDTO.NAStandardizationOvride = 'Y';
          fisccCustomerAccountRelationDTO.PriSecRltCde01 = FISCCIntegrationConstants.PrimaryApplicant;
          if (prod.IsCustodianProduct__c) {
            fisccCustomerAccountRelationDTO.CIEnt1ToEnt2RltCde = FISCCIntegrationConstants.CustodianProduct_PrimaryRelation;
            if (idx != 999) {
              appObjs[0].tffa__PartyXrefs__r[idx].CZFISRelationshipCode__c = FISCCIntegrationConstants.CustodianProduct_PrimaryRelation;
            }
          } else {
            if (partyObjs.size() > 1) {
              fisccCustomerAccountRelationDTO.CIEnt1ToEnt2RltCde = FISCCIntegrationConstants.JOINT_RELATION;
              if (idx != 999) {
                appObjs[0].tffa__PartyXrefs__r[idx].CZFISRelationshipCode__c = FISCCIntegrationConstants.JOINT_RELATION;
              }
            } else {
              fisccCustomerAccountRelationDTO.CIEnt1ToEnt2RltCde = FISCCIntegrationConstants.SOLE_OWNER;
              if (idx != 999) {
                appObjs[0].tffa__PartyXrefs__r[idx].CZFISRelationshipCode__c = FISCCIntegrationConstants.SOLE_OWNER;
              }
            }
          }
        } else {
          if (jointApplicantCounter == 1) {
            tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
            if (String.isBlank(tfParty.Customer_Number__c)) {
              fisccCustomerAccountRelationDTO.CustNbr02 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
            } else {
              fisccCustomerAccountRelationDTO.CustNbr02 = tfParty.Customer_Number__c;
            }
            fisccCustomerAccountRelationDTO.PrmyScndyCde02 = FISCCIntegrationConstants.SecondaryApplicant;
            if (prod.IsCustodianProduct__c) {
              fisccCustomerAccountRelationDTO.RltCde02 = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            } else {
              fisccCustomerAccountRelationDTO.RltCde02 = FISCCIntegrationConstants.JOINT_RELATION;
            }
          } else if (jointApplicantCounter == 2) {
            tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
            if (String.isBlank(tfParty.Customer_Number__c)) {
              fisccCustomerAccountRelationDTO.CustNbr03 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
            } else {
              fisccCustomerAccountRelationDTO.CustNbr03 = tfParty.Customer_Number__c;
            }
            fisccCustomerAccountRelationDTO.PrmyScndyCde03 = FISCCIntegrationConstants.SecondaryApplicant;
            if (prod.IsCustodianProduct__c) {
              fisccCustomerAccountRelationDTO.RltCde03 = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            } else {
              fisccCustomerAccountRelationDTO.RltCde03 = FISCCIntegrationConstants.JOINT_RELATION;
            }
          } else if (jointApplicantCounter == 3) {
            tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
            if (String.isBlank(tfParty.Customer_Number__c)) {
              fisccCustomerAccountRelationDTO.CustNbr04 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
            } else {
              fisccCustomerAccountRelationDTO.CustNbr04 = tfParty.Customer_Number__c;
            }
            fisccCustomerAccountRelationDTO.PrmyScndyCde04 = FISCCIntegrationConstants.SecondaryApplicant;
            if (prod.IsCustodianProduct__c) {
              fisccCustomerAccountRelationDTO.RltCde04 = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            } else {
              fisccCustomerAccountRelationDTO.RltCde04 = FISCCIntegrationConstants.JOINT_RELATION;
            }
          }
          if (idx != 999) {
            if (prod.IsCustodianProduct__c) {
              appObjs[0].tffa__PartyXrefs__r[idx].CZFISRelationshipCode__c = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            } else {
              appObjs[0].tffa__PartyXrefs__r[idx].CZFISRelationshipCode__c = FISCCIntegrationConstants.JOINT_RELATION;
            }
          }
          jointApplicantCounter++;
        }
      }
      tffa__Party__c partyAdressObj = CZWTFCCommonHelper.getPrimaryParty(FISCCIntegrationLogService.submissionObj, partyObjs);

      tffa__Address__C objAddress = partyAdressObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      // --call address
      fillPartyAndAddressDetails(partyObjs, primaryParty, objAddress, fisccCustomerAccountRelationDTO, prod.IsCustodianProduct__c);
      tffa.logger.debug('fillPartyAndAddressDetails called');
      tffa.logger.debug('appObjs in depositAccountNumberRequest==>' + appObjs);
      fisccCustomerAccountRelationDTO.AcctNbr = FISCCIntegrationConstants.DUMMY_ACCT_NUMBER;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in customerAccountRelationRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('customerAccountRelationRequest ==>' + fisccCustomerAccountRelationDTO);
    return fisccCustomerAccountRelationDTO;
  }
  public static FISCCCustomerAccountRelationDTO fillPartyAndAddressDetails(
    List<tffa__Party__c> partyObjs,
    tffa__Party__c primaryParty,
    tffa__Address__c addressObj,
    FISCCCustomerAccountRelationDTO fisccCustomerAccountRelationDTO,
    Boolean isCustodian
  ) {
    Integer jointApplicantCounter = 1;
    tffa.logger.debug('inside customerAccountRelationRequest fillPartyAndAddressDetails');
    try {
      if (partyObjs != null && !partyObjs.isEmpty()) {
        tffa.logger.debug('inside objParty not null ');
        for (tffa__Party__c partyObj : partyObjs) {
          Boolean isPrimary = primaryParty.Id.equals(partyObj.Id);
          String sfx = partyObj.tffa__Suffix__c != null ? partyObj.tffa__Suffix__c + ' ' : '';
          if (isPrimary) {
            fisccCustomerAccountRelationDTO.CINmeAddrLneCde01 = 'N';
            fisccCustomerAccountRelationDTO.NmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
              partyObj.tffa__FirstName__c,
              partyObj.tffa__MiddleName__c,
              partyObj.tffa__LastName__c,
              (isCustodian) ? sfx + FISCCIntegrationConstants.MINOR_UTMA : partyObj.tffa__Suffix__c,
              FISCCIntegrationConstants.FULL_NAME_LENGTH
            );
          } else {
            if (jointApplicantCounter == 1) {
              fisccCustomerAccountRelationDTO.CINmeAddrLneCde02 = 'N';
              fisccCustomerAccountRelationDTO.NmeAddrLne02 = CZWTFCCommonHelper.getFormattedFullName(
                partyObj.tffa__FirstName__c,
                partyObj.tffa__MiddleName__c,
                partyObj.tffa__LastName__c,
                (isCustodian) ? sfx + FISCCIntegrationConstants.CUSTODIAN : partyObj.tffa__Suffix__c,
                FISCCIntegrationConstants.FULL_NAME_LENGTH
              );
            }
            jointApplicantCounter++;
          }
        }
      }
      fillAddress(partyObjs, addressObj, fisccCustomerAccountRelationDTO);
    } catch (Exception ex) {
      tffa.logger.debug(
        ' Exception into FISCCCustomerAccountRelationHelper : assignNameValue :::' +
        ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
      return null;
    }
    //tffa.Logger.debug('fillPersIdDetails End ::: '+objFISCCCreateCustomerDTO);
    tffa.logger.debug('fisccCustomerAccountRelationDTO in AssignNameValue : ==>' + fisccCustomerAccountRelationDTO);
    return fisccCustomerAccountRelationDTO;
  }

  public static FISCCCustomerAccountRelationDTO fillAddress(
    List<tffa__Party__c> partyObjs,
    tffa__Address__c addressObj,
    FISCCCustomerAccountRelationDTO fisccCustomerAccountRelationDTO
  ) {
    if (partyObjs.size() == 1) {
      fisccCustomerAccountRelationDTO.NmeAddrLne02 = addressObj.tffa__Line1__c;

      if (String.isNotBlank(addressObj.tffa__Line2__c)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne03 = addressObj.tffa__Line2__c;
        fisccCustomerAccountRelationDTO.NmeAddrLne04 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde02 = 'A';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = 'S';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde04 = 'C';
      } else {
        fisccCustomerAccountRelationDTO.NmeAddrLne03 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde02 = 'S';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = 'C';
      }
    } else if (partyObjs.size() >= 2) {
      fisccCustomerAccountRelationDTO.NmeAddrLne03 = addressObj.tffa__Line1__c;

      if (String.isNotBlank(addressObj.tffa__Line2__c)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne04 = addressObj.tffa__Line2__c;
        fisccCustomerAccountRelationDTO.NmeAddrLne05 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = 'A';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde04 = 'S';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde05 = 'C';
      } else {
        fisccCustomerAccountRelationDTO.NmeAddrLne04 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = 'S';
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde04 = 'C';
      }
    }
    return fisccCustomerAccountRelationDTO;
  }

  public static Integer getPartyIndex(tffa__Application__c app, tffa__Party__c party) {
    for (Integer idx = 0; idx < app.tffa__PartyXrefs__r.size(); idx++) {
      if (party.Id == app.tffa__PartyXrefs__r[idx].tffa__party__c) {
        return idx;
      }
    }
    return 999;
  }
}