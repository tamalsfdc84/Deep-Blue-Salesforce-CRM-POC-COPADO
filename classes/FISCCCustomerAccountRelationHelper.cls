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
      tffa__Party__c partyObj = CZWTFCCommonHelper.getAppPrimaryParty(appObjs[0], partyObjs);
      tffa__Product__c prod = appObjs[0].tffa__Product__r;
      List<tffa__Party__c> currentAppPartyObjs = new List<tffa__Party__c>();
      for (tffa__ApplicationPartyXref__c appPartyList : appObjs[0].tffa__PartyXrefs__r) {
        if (FISCCIntegrationLogService.partyObjMap.containsKey(appPartyList.tffa__party__c)) {
          currentAppPartyObjs.add(FISCCIntegrationLogService.partyObjMap.get(appPartyList.tffa__party__c));
        }
      }

      for (tffa__ApplicationPartyXref__c appParty : appObjs[0].tffa__PartyXrefs__r) {
        if (!FISCCIntegrationConstants.DEPUTY.equalsIgnoreCase(appParty.tffa__ApplicantRole__r.tffa__Code__c)) {
          tffa__Party__c tfParty = FISCCIntegrationLogService.partyObjMap.get(appParty.tffa__Party__c);
          Boolean isPrimary = partyObj.Id.equals(tfParty.Id);
          // check for Custodian Product
          Integer idx = getPartyIndex(appObjs[0], tfParty);
          if (isPrimary) {
            FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
            tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
            if (String.isBlank(tfParty.Customer_Number__c)) {
              fisccCustomerAccountRelationDTO.CIRltApplNbr01 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
            } else {
              fisccCustomerAccountRelationDTO.CIRltApplNbr01 = tfParty.Customer_Number__c;
            }
            fisccCustomerAccountRelationDTO.NAStandardizationOvride = 'Y';
            fisccCustomerAccountRelationDTO.PriSecRltCde01 = FISCCIntegrationConstants.PrimaryApplicant;
            tffa.Logger.debug('appParty.tffa__ApplicantRole__r ' + appParty.tffa__ApplicantRole__r);
            if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
              fisccCustomerAccountRelationDTO.CIEnt1ToEnt2RltCde = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
            }
          } else {
            if (jointApplicantCounter == 1) {
              FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
              tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
              if (String.isBlank(tfParty.Customer_Number__c)) {
                fisccCustomerAccountRelationDTO.CustNbr02 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
              } else {
                fisccCustomerAccountRelationDTO.CustNbr02 = tfParty.Customer_Number__c;
              }
              fisccCustomerAccountRelationDTO.PrmyScndyCde02 = FISCCIntegrationConstants.SecondaryApplicant;
              tffa.Logger.debug('appParty.tffa__ApplicantRole__r ' + appParty.tffa__ApplicantRole__r);
              if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
                fisccCustomerAccountRelationDTO.RltCde02 = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
              }
            } else if (jointApplicantCounter == 2) {
              FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
              tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
              if (String.isBlank(tfParty.Customer_Number__c)) {
                fisccCustomerAccountRelationDTO.CustNbr03 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
              } else {
                fisccCustomerAccountRelationDTO.CustNbr03 = tfParty.Customer_Number__c;
              }
              fisccCustomerAccountRelationDTO.PrmyScndyCde03 = FISCCIntegrationConstants.SecondaryApplicant;
              if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
                fisccCustomerAccountRelationDTO.RltCde03 = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
              }
            } else if (jointApplicantCounter == 3) {
              FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
              tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
              if (String.isBlank(tfParty.Customer_Number__c)) {
                fisccCustomerAccountRelationDTO.CustNbr04 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
              } else {
                fisccCustomerAccountRelationDTO.CustNbr04 = tfParty.Customer_Number__c;
              }
              fisccCustomerAccountRelationDTO.PrmyScndyCde04 = FISCCIntegrationConstants.SecondaryApplicant;
              if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
                fisccCustomerAccountRelationDTO.RltCde04 = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
              }
            } else if (jointApplicantCounter == 4) {
              FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
              tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
              if (String.isBlank(tfParty.Customer_Number__c)) {
                fisccCustomerAccountRelationDTO.CustNbr05 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
              } else {
                fisccCustomerAccountRelationDTO.CustNbr05 = tfParty.Customer_Number__c;
              }
              fisccCustomerAccountRelationDTO.PrmyScndyCde05 = FISCCIntegrationConstants.SecondaryApplicant;
              if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
                fisccCustomerAccountRelationDTO.RltCde05 = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
              }
            } else if (jointApplicantCounter == 5) {
              FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
              tffa.Logger.debug('tfParty.Customer_Number__c ==> ' + tfParty.Customer_Number__c);
              if (String.isBlank(tfParty.Customer_Number__c)) {
                fisccCustomerAccountRelationDTO.CustNbr06 = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;
              } else {
                fisccCustomerAccountRelationDTO.CustNbr06 = tfParty.Customer_Number__c;
              }
              fisccCustomerAccountRelationDTO.PrmyScndyCde06 = FISCCIntegrationConstants.SecondaryApplicant;
              if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
                fisccCustomerAccountRelationDTO.RltCde06 = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
              }
            }
            jointApplicantCounter++;
          }
        }
      }
      tffa__Address__c objAddress;
      if (partyObj.tffa__AddressXrefs__r.size() > 1) {
        objAddress = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'HOME');
      } else {
        objAddress = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      }
      // --call address
      // fillPartyAndAddressDetails(currentAppPartyObjs, partyObj, objAddress, fisccCustomerAccountRelationDTO, prod.IsCustodianProduct__c);
      fillAccountTitle(appObjs[0], fisccCustomerAccountRelationDTO);
      tffa.logger.debug('fillPartyAndAddressDetails called');
      tffa.logger.debug('appObjs in depositAccountNumberRequest==>' + appObjs);
      fisccCustomerAccountRelationDTO.AcctNbr = appObjs[0].tffa__AccountNumber__c;

      if (
        appObjs[0].tffa__ProductCategory__c != null &&
        FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObjs[0].tffa__ProductCategory__c) &&
        appObjs[0].tffa__DepositBoxAccountNumber__c != null
      ) {
        fisccCustomerAccountRelationDTO.ApplCde = FISCCIntegrationConstants.GenSDBApplID;
        fisccCustomerAccountRelationDTO.AcctNbr = appObjs[0].tffa__DepositBoxAccountNumber__c;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in customerAccountRelationRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('customerAccountRelationRequest ==>' + fisccCustomerAccountRelationDTO);
    return fisccCustomerAccountRelationDTO;
  }

  public static FISCCCustomerAccountRelationDTO fillAccountTitle(
    tffa__Application__c appObj,
    FISCCCustomerAccountRelationDTO fisccCustomerAccountRelationDTO
  ) {
    List<String> accTitleLst = new List<String>();
    if (String.isNotBlank(appObj.CZTitle1__c)) {
      accTitleLst.add(appObj.CZTitle1__c);
    }
    if (String.isNotBlank(appObj.CZTitle2__c)) {
      accTitleLst.add(appObj.CZTitle2__c);
    }
    if (String.isNotBlank(appObj.CZTitle3__c)) {
      accTitleLst.add(appObj.CZTitle3__c);
    }
    List<String> addTitleLst = new List<String>();
    if (appObj.tffa__Address__r != null) {
      FISCCCommonHelper.setAccountAddress(addTitleLst, appObj.tffa__Address__r);
    }
    for (String title : accTitleLst) {
      if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne01)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne01 = title;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde01 = 'N';
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne02)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne02 = title;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde02 = 'N';
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne03)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne03 = title;
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = 'N';
      }
    }

    for (Integer i = 0; i < addTitleLst.size(); i++) {
      String code;
      if (i == 0) {
        code = 'S';
      } else {
        code = 'C';
      }

      if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne01)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne01 = addTitleLst[i];
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde01 = code;
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne02)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne02 = addTitleLst[i];
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde02 = code;
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne03)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne03 = addTitleLst[i];
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde03 = code;
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne04)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne04 = addTitleLst[i];
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde04 = code;
      } else if (String.isBlank(fisccCustomerAccountRelationDTO.NmeAddrLne05)) {
        fisccCustomerAccountRelationDTO.NmeAddrLne05 = addTitleLst[i];
        fisccCustomerAccountRelationDTO.CINmeAddrLneCde05 = code;
      }
    }

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
            if (partyObj.tffa__Type__c == 'ORGANIZATION') {
              if (partyObj.tffa__LegalName__c.length() > 40) {
                fisccCustomerAccountRelationDTO.NmeAddrLne01 = partyObj.tffa__LegalName__c.substring(0, 39);
              } else {
                fisccCustomerAccountRelationDTO.NmeAddrLne01 = partyObj.tffa__LegalName__c;
              }
            } else {
              fisccCustomerAccountRelationDTO.NmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
                partyObj.tffa__FirstName__c,
                partyObj.tffa__MiddleName__c,
                partyObj.tffa__LastName__c,
                (isCustodian) ? sfx + FISCCIntegrationConstants.MINOR_UTMA : partyObj.tffa__Suffix__c,
                FISCCIntegrationConstants.FULL_NAME_LENGTH
              );
            }
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