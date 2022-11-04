public with sharing class FISCCDOAddSDBDeputyExtension {

  public static List<FISCCDepositOriginationRequestBaseDTO> invokeDepositeBoxDeputy(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFisccDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {

      List<tffa__Party__c> deputyList = new List<tffa__Party__c>();
      for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
        if(FISCCIntegrationConstants.DEPUTY.equalsIgnoreCase(appParty.tffa__ApplicantRole__r.tffa__Code__c) && !appParty.CZDeputyCreated__c){

          deputyList.add(appParty.tffa__party__r);
          FISCCDepositOriginationExtension.deputyId.add(appParty.Id);

          if(deputyList.size() == 2) {
            fisccDepositOriginationRequestBaseDTO = depositBoxDeputyRequest(deputyList, appObj);
            lstFisccDepositOriginationRequestBaseDTO.add(fisccDepositOriginationRequestBaseDTO);
            deputyList.clear();
          }
        }
      }

      if(deputyList.size() == 1){
        fisccDepositOriginationRequestBaseDTO = depositBoxDeputyRequest(deputyList, appObj);
        lstFisccDepositOriginationRequestBaseDTO.add(fisccDepositOriginationRequestBaseDTO);
        deputyList.clear();
      }

      return lstFisccDepositOriginationRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeDepositeBoxOwner : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return lstFisccDepositOriginationRequestBaseDTO;
    }
  }

  public static FISCCDepositOriginationRequestBaseDTO depositBoxDeputyRequest(
    List<tffa__Party__c> deputyList,
    tffa__Application__c appObj
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    CZSDBAddDeputyRequest request = new CZSDBAddDeputyRequest();
    request.SvcID = FISCCIntegrationConstants.SVCID_SDBAddDeputy;

    request.boxDeputies.BoxNbr = appObj.tffa__DepositBoxAccountNumber__c;
    request.boxDeputies.BoxPrfx = appObj.tffa__DepositBoxCode__c;
    request.boxDeputies.Brnch = appObj.FISBranchCode__c;

    if(deputyList.size() > 0){
      generateDeputy1request(request, deputyList[0]);
    } 
    
    if(deputyList.size() > 1){
      generateDeputy2request(request, deputyList[1]);
    }

    fisccDepositOriginationRequestBaseDTO = request;
      
    return fisccDepositOriginationRequestBaseDTO;
  }

  public static CZSDBAddDeputyRequest generateDeputy1request(CZSDBAddDeputyRequest request, tffa__Party__c partyObj){

    request.boxDeputies.Deputy1ShrtNme = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.CUST_NAME_LENGTH_1
    );

    request.boxDeputies.Deputy1NmeAddr1 = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.FULL_NAME_LENGTH
    );

    tffa__Address__c addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    // Set Address
    if(addressObj != null){
      request.boxDeputies.Deputy1NmeAddr2 = addressObj.tffa__Line1__c;

      if(addressObj.tffa__Line2__c != null){
        request.boxDeputies.Deputy1NmeAddr3 = addressObj.tffa__Line2__c;
        request.boxDeputies.Deputy1NmeAddr4 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' +
        addressObj.tffa__ZipCode__c;
      } else {
        request.boxDeputies.Deputy1NmeAddr3 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' +
        addressObj.tffa__ZipCode__c;
      }
    }

    // Set Phone number
    if(partyObj.tffa__PrimaryPhone__c != null){
      String phoneNumber = getPhoneNumber(partyObj.tffa__PrimaryPhone__c);
      request.boxDeputies.Deputy1HmPhPrt1 = phoneNumber.substring(0, 3);
      request.boxDeputies.Deputy1HmPhPrt2 = phoneNumber.substring(3, 6);
      request.boxDeputies.Deputy1HmPhPrt3 = phoneNumber.substring(6);
    }

    // Set Tax Id and type
    request.boxDeputies.Deputy1TaxNbr = partyObj.tffa__NationalIdentifierValue__c;
    request.boxDeputies.Deputy1TaxId = CZWTFCCommonHelper.getTaxIdType(partyObj.tffa__NationalIdentifierType__c);

    return request;
  }

  public static CZSDBAddDeputyRequest generateDeputy2request(CZSDBAddDeputyRequest request, tffa__Party__c partyObj){
    
    request.boxDeputies.Deputy2ShrtNme = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.CUST_NAME_LENGTH_1
    );

    request.boxDeputies.Deputy2NmeAddr1 = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.FULL_NAME_LENGTH
    );

    tffa__Address__c addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    // Set Address
    if(addressObj != null){
      request.boxDeputies.Deputy2NmeAddr2 = addressObj.tffa__Line1__c;

      if(addressObj.tffa__Line2__c != null){
        request.boxDeputies.Deputy2NmeAddr3 = addressObj.tffa__Line2__c;
        request.boxDeputies.Deputy2NmeAddr4 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' +
        addressObj.tffa__ZipCode__c;
      } else {
        request.boxDeputies.Deputy2NmeAddr3 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' +
        addressObj.tffa__ZipCode__c;
      }
    }

    // Set Phone number
    if(partyObj.tffa__PrimaryPhone__c != null){
      String phoneNumber = getPhoneNumber(partyObj.tffa__PrimaryPhone__c);
      request.boxDeputies.Deputy2HmPhPrt1 = phoneNumber.substring(0, 3);
      request.boxDeputies.Deputy2HmPhPrt2 = phoneNumber.substring(3, 6);
      request.boxDeputies.Deputy2HmPhPrt3 = phoneNumber.substring(6);
    }

    // Set Tax Id and type
    request.boxDeputies.Deputy2TaxNbr = partyObj.tffa__NationalIdentifierValue__c;
    request.boxDeputies.Deputy2TaxId = CZWTFCCommonHelper.getTaxIdType(partyObj.tffa__NationalIdentifierType__c);

    return request;
  }

  public static String getPhoneNumber(String phonenumber){
    phonenumber = phonenumber.reverse();
    phonenumber = phonenumber.substring(0,10);
    phonenumber = phonenumber.reverse();

    return phonenumber;
  }
}