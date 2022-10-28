public with sharing class FISCCCardBaseIntegrationHelper {
  public static String cardNumber = '';

  public static FISCCRequestBaseDTO getGenerateCardNoRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCDebitCardNoGenRequestDTO request = new FISCCDebitCardNoGenRequestDTO();
    //request.CardNumber.CBInstnNbr = (partyObj.BrandCode__c == null) ? '' : partyObj.BrandCode__c.leftPad(5, '0');
    //request.CardNumber.CBCrdPrfxNbr = accPref.tffa__CardBINCode__c == null ? '' :accPref.tffa__CardBINCode__c;
    request.CardNumber.CBInstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');
    request.CardNumber.CBCrdPrfxNbr = CZWTFCHelperRepository.findAddOnServiceByCodeandType(
        accPref.tffa__code__c,
        FISCCIntegrationConstants.DBT_TYPE
      )
      .tffa__CardBINCode__c;
    requestDTO = request;

    return requestDTO;
  }

  public static FISCCRequestBaseDTO getCardCreationRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCDebitCardCreationRequestDTO request = new FISCCDebitCardCreationRequestDTO();
    tffa__Address__c addressObj = new tffa__Address__c();
    addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    request.CardNew.CBCrdNbr = accPref.tffa__CardNumber__c;
    request.CardNew.CustNbr = partyObj.Customer_Number__c;
    request.CardNew.CBStAbbr = addressObj.tffa__State__c;
    request.CardNew.CBInstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');
    request.CardNew.CBCrdPrfxNbr = CZWTFCHelperRepository.findAddOnServiceByCodeandType(
        accPref.tffa__code__c,
        FISCCIntegrationConstants.DBT_TYPE
      )
      .tffa__CardBINCode__c;
    request.CardNew.CBBrnchNbr = appObj.FISBranchCode__c;
    request.CardNew.CBStrAddrLne1 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
    request.CardNew.CBStrAddrLne2 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line2__c, 30);
    request.CardNew.CBCtyNme = CZWTFCCommonHelper.trimString(addressObj.tffa__City__c, 20);
    request.CardNew.CBZIP = CZWTFCCommonHelper.trimString(addressObj.tffa__ZipCode__c, 5);
    //if ('SAVINGS'.equals(appObj.tffa__Product__r.tffa__Category__c)) {
    //request.CardNew.CBPrmyDdaAcctNbr = appObj.tffa__AccountNumber__c;
    //} else if ('CHECKING'.equals(appObj.tffa__Product__r.tffa__Category__c)) {
    //request.CardNew.CBPrmySavAcctNbr = appObj.tffa__AccountNumber__c;
    //}
    request.CardNew.CBPrmyDdaAcctNbr = appObj.tffa__AccountNumber__c;
    request.CardNew.CBPrmySsn = partyObj.tffa__NationalIdentifierValue__c;
    request.CardNew.NmeEmbossOnCard = accPref.tffa__EmbossedName__c;
    request.CardNew.CBShrtNmeFrst = CZWTFCCommonHelper.trimString(partyObj.tffa__FirstName__c, 10);
    request.CardNew.CBShrtNmeLst = CZWTFCCommonHelper.trimString(partyObj.tffa__LastName__c, 15);
    String middleNameInitial = CZWTFCCommonHelper.trimString(partyObj.tffa__MiddleName__c, 1);
    request.CardNew.CBCrdNmeLne1 = accPref.tffa__EmbossedName__c;

    requestDTO = request;

    return requestDTO;
  }

  public static FISCCRequestBaseDTO getCardToCustRelationRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCDebitCardAccRelRequestDTO request = new FISCCDebitCardAccRelRequestDTO();
    tffa__Address__c addressObj = new tffa__Address__c();
    addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    request.acc.CIRltApplNbr01 = partyObj.Customer_Number__c;
    request.acc.CIEnt1ToEnt2RltCde = FISCCIntegrationConstants.SOLE_OWNER;
    request.acc.PriSecRltCde01 = 'P';
    request.acc.NAStandardizationOvride = 'Y';
    request.acc.CINmeAddrLneCde01 = 'N';
    String suffix = partyObj.tffa__Suffix__c != null ? partyObj.tffa__Suffix__c : '';
    request.acc.NmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      suffix,
      FISCCIntegrationConstants.CUST_NAME_LENGTH
    );

    if (addressObj.tffa__Line2__c != null) {
      request.acc.CINmeAddrLneCde02 = 'A';
      request.acc.CINmeAddrLneCde03 = 'S';
      request.acc.CINmeAddrLneCde04 = 'C';
      request.acc.NmeAddrLne02 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
      request.acc.NmeAddrLne03 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line2__c, 30);
      request.acc.NmeAddrLne04 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    } else {
      request.acc.CINmeAddrLneCde02 = 'S';
      request.acc.CINmeAddrLneCde03 = 'C';
      request.acc.NmeAddrLne02 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
      request.acc.NmeAddrLne03 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    }
    request.acc.ApplCde = 'CBM';
    request.acc.AcctNbr = accPref.tffa__CardNumber__c;
    requestDTO = request;

    return requestDTO;
  }

  public static FISCCRequestBaseDTO getUpdateCustDemographicsRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCDebitCardCustDetailsRequestDTO request = new FISCCDebitCardCustDetailsRequestDTO();

    request.CardsCardholderAddress.Email = partyObj.tffa__PrimaryEmail__c;
    request.CardsCardholderAddress.PrmyHmPh = (partyObj.CellPhoneNumber__c) == null
      ? partyObj.tffa__PrimaryPhone__c
      : partyObj.CellPhoneNumber__c;
    requestDTO = request;

    return requestDTO;
  }

  public static Boolean isAPICallSuccess(List<FISCCMsgListDTO> msgList) {
    Boolean isScuccess = false;
    if (msgList != null && !msgList.isEmpty()) {
      if (('0').equalsIgnoreCase(msgList[0].Code) && ('Success').equalsIgnoreCase(msgList[0].Text)) {
        isScuccess = true;
      }
    }
    return isScuccess;
  }
}