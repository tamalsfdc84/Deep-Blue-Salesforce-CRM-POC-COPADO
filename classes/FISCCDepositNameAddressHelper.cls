public with sharing class FISCCDepositNameAddressHelper {
  public static FISCCDepositNameAddressDTO depositAccountAddressRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositNameAddressDTO fisccDepositNameAddressDTO = new FISCCDepositNameAddressDTO();

    try {
      tffa.Logger.debug('Inside depositAccountAddressRequest method');
      tffa__Party__c partyObj = CZWTFCCommonHelper.getAppPrimaryParty(appObjs[0], partyObjs);
      tffa__Product__c prod = appObjs[0].tffa__Product__r;
      fisccDepositNameAddressDTO.DPAcctNbrNmeAddrMaint = appObjs[0].tffa__AccountNumber__c;
      fisccDepositNameAddressDTO.DPNmeAndAddrTyp = FISCCIntegrationConstants.DPNmeAndAddrTyp;

      fisccDepositNameAddressDTO.DPCIRqstInd = FISCCIntegrationConstants.DPCIRqstInd;

      if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('CELL')) {
        fisccDepositNameAddressDTO.DPNmeAndAddrHmPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.CellPhoneNumber__c));
        if (!String.isBlank(partyObj.tffa__SecondaryPhone__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(
            CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__SecondaryPhone__c)
          );
        } else if (!String.isBlank(partyObj.tffa__PrimaryPhone__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__PrimaryPhone__c));
        }
      } else if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('HOME')) {
        fisccDepositNameAddressDTO.DPNmeAndAddrHmPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__PrimaryPhone__c));
        if (!String.isBlank(partyObj.tffa__SecondaryPhone__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(
            CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__SecondaryPhone__c)
          );
        } else if (!String.isBlank(partyObj.CellPhoneNumber__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.CellPhoneNumber__c));
        }
      } else if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('WORK')) {
        fisccDepositNameAddressDTO.DPNmeAndAddrHmPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__SecondaryPhone__c));
        if (!String.isBlank(partyObj.CellPhoneNumber__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.CellPhoneNumber__c));
        } else if (!String.isBlank(partyObj.tffa__PrimaryPhone__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrBusPh = Long.valueOf(CZWTFCCommonHelper.formatPhoneNumber(partyObj.tffa__PrimaryPhone__c));
        }
      }
      /*tffa__Address__c addressObj;
      if (partyObj.tffa__AddressXrefs__r.size() > 1) {
        addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'MAILING');
      } else {
        addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      }*/
      // --call address

      fillAccountTitle(appObjs[0], fisccDepositNameAddressDTO);
      tffa.logger.debug('fillAddressDetails called');

      tffa.logger.debug('appObjs in depositAccountAddressRequest==>' + appObjs);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in depositAccountAddressRequest : ' + +ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('fisccDepositNameAddressDTO ==>' + fisccDepositNameAddressDTO);
    return fisccDepositNameAddressDTO;
  }

  // Not Used TODO: Remove this code
  public static fisccDepositNameAddressDTO fillPartyAndAddressDetails(
    List<tffa__Party__c> partyObjs,
    tffa__Party__c primaryParty,
    tffa__Application__c appObj,
    FISCCDepositNameAddressDTO fisccDepositNameAddressDTO,
    Boolean isCustodian
  ) {
    Integer jointApplicantCounter = 1;
    tffa.logger.debug('inside fisccDepositNameAddressDTO fillPartyAndAddressDetails');
    try {
      if (partyObjs != null && !partyObjs.isEmpty()) {
        tffa.logger.debug('inside objParty not null ');
        for (tffa__Party__c partyObj : partyObjs) {
          Boolean isPrimary = primaryParty.Id.equals(partyObj.Id);
          String sfx = partyObj.tffa__Suffix__c != null ? partyObj.tffa__Suffix__c + ' ' : '';
          if (isPrimary) {
            fisccDepositNameAddressDTO.DPNmeAndAddrLne1 = CZWTFCCommonHelper.getFormattedFullName(
              partyObj.tffa__FirstName__c,
              partyObj.tffa__MiddleName__c,
              partyObj.tffa__LastName__c,
              (isCustodian) ? sfx + FISCCIntegrationConstants.MINOR_UTMA : partyObj.tffa__Suffix__c,
              FISCCIntegrationConstants.FULL_NAME_LENGTH
            );
          } else {
            if (jointApplicantCounter == 1) {
              fisccDepositNameAddressDTO.DPNmeAndAddrLne2 = CZWTFCCommonHelper.getFormattedFullName(
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
      fillAddress(partyObjs, appObj, fisccDepositNameAddressDTO);
    } catch (Exception ex) {
      tffa.logger.debug(
        ' Exception into FISCCCreateNewDepositAccountHelper : assignNameValue :::' +
        ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
      return null;
    }

    tffa.logger.debug('FISCCCreateNewDepositAccountHelper in AssignNameValue : ==>' + fisccDepositNameAddressDTO);
    return fisccDepositNameAddressDTO;
  }

  public static FisccDepositNameAddressDTO fillAccountTitle(
    tffa__Application__c appObj,
    FisccDepositNameAddressDTO fisccDepositNameAddressDTO
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

    if (appObj.tffa__Address__r != null) {
      FISCCCommonHelper.setAccountAddress(accTitleLst, appObj.tffa__Address__r);
    }
    for (String title : accTitleLst) {
      if (String.isBlank(fisccDepositNameAddressDTO.DPNmeAndAddrLne1)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne1 = title;
      } else if (String.isBlank(fisccDepositNameAddressDTO.DPNmeAndAddrLne2)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne2 = title;
      } else if (String.isBlank(fisccDepositNameAddressDTO.DPNmeAndAddrLne3)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = title;
      } else if (String.isBlank(fisccDepositNameAddressDTO.DPNmeAndAddrLne4)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 = title;
      } else if (String.isBlank(fisccDepositNameAddressDTO.DPNmeAndAddrLne5)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne5 = title;
      }
    }
    return fisccDepositNameAddressDTO;
  }

  // Not Used TODO: Remove this code
  /**
   *  fill address in DTO
   */
  public static FisccDepositNameAddressDTO fillAddress(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c appObj,
    FisccDepositNameAddressDTO fisccDepositNameAddressDTO
  ) {
    if (partyObjs.size() == 1) {
      fisccDepositNameAddressDTO.DPNmeAndAddrLne2 = appObj.CZLine1__c;

      if (String.isNotBlank(appObj.CZLine2__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = appObj.CZLine2__c;
        if (String.isNotBlank(appObj.CZCity__c) && String.isNotBlank(appObj.CZState__c) && String.isNotBlank(appObj.CZZipCode__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrLne4 = appObj.CZCity__c + ' ' + appObj.CZState__c + ' ' + appObj.CZZipCode__c;
        }
      } else if (String.isNotBlank(appObj.CZCity__c) && String.isNotBlank(appObj.CZState__c) && String.isNotBlank(appObj.CZZipCode__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = appObj.CZCity__c + ' ' + appObj.CZState__c + ' ' + appObj.CZZipCode__c;
      }
    } else if (partyObjs.size() >= 2) {
      fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = appObj.CZLine1__c;

      if (String.isNotBlank(appObj.CZLine2__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 = appObj.CZLine2__c;
        if (String.isNotBlank(appObj.CZCity__c) && String.isNotBlank(appObj.CZState__c) && String.isNotBlank(appObj.CZZipCode__c)) {
          fisccDepositNameAddressDTO.DPNmeAndAddrLne5 = appObj.CZCity__c + ' ' + appObj.CZState__c + ' ' + appObj.CZZipCode__c;
        }
      } else if (String.isNotBlank(appObj.CZCity__c) && String.isNotBlank(appObj.CZState__c) && String.isNotBlank(appObj.CZZipCode__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 = appObj.CZCity__c + ' ' + appObj.CZState__c + ' ' + appObj.CZZipCode__c;
      }
    }
    return fisccDepositNameAddressDTO;
  }
}