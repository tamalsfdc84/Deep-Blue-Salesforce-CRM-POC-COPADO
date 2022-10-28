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
      tffa__Party__c partyObj = CZWTFCCommonHelper.getPrimaryParty(FISCCIntegrationLogService.submissionObj, partyObjs);
      tffa__Product__c prod = appObjs[0].tffa__Product__r;
      fisccDepositNameAddressDTO.DPAcctNbrNmeAddrMaint = FISCCIntegrationConstants.DUMMY_ACCT_NUMBER;
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

      tffa__Party__c partyAdressObj = CZWTFCCommonHelper.getPrimaryParty(FISCCIntegrationLogService.submissionObj, partyObjs);

      tffa__Address__C objAddress = partyAdressObj.tffa__AddressXrefs__r[0].tffa__Address__r;
      // --call address
      fillPartyAndAddressDetails(partyObjs, partyObj, objAddress, fisccDepositNameAddressDTO, prod.IsCustodianProduct__c);
      tffa.logger.debug('fillAddressDetails called');

      tffa.logger.debug('appObjs in depositAccountAddressRequest==>' + appObjs);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in depositAccountAddressRequest : ' + +ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('fisccDepositNameAddressDTO ==>' + fisccDepositNameAddressDTO);
    return fisccDepositNameAddressDTO;
  }
  public static fisccDepositNameAddressDTO fillPartyAndAddressDetails(
    List<tffa__Party__c> partyObjs,
    tffa__Party__c primaryParty,
    tffa__Address__c addressObj,
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
      fillAddress(partyObjs, addressObj, fisccDepositNameAddressDTO);
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

  public static FisccDepositNameAddressDTO fillAddress(
    List<tffa__Party__c> partyObjs,
    tffa__Address__c addressObj,
    FisccDepositNameAddressDTO fisccDepositNameAddressDTO
  ) {
    if (partyObjs.size() == 1) {
      fisccDepositNameAddressDTO.DPNmeAndAddrLne2 = addressObj.tffa__Line1__c;

      if (String.isNotBlank(addressObj.tffa__Line2__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = addressObj.tffa__Line2__c;
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
      } else {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne3 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
      }
    } else if (partyObjs.size() >= 2) {
      fisccDepositNameAddressDTO.DPNmeAndAddrLne3 = addressObj.tffa__Line1__c;

      if (String.isNotBlank(addressObj.tffa__Line2__c)) {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 = addressObj.tffa__Line2__c;
        fisccDepositNameAddressDTO.DPNmeAndAddrLne5 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
      } else {
        fisccDepositNameAddressDTO.DPNmeAndAddrLne4 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
      }
    }
    return fisccDepositNameAddressDTO;
  }
}