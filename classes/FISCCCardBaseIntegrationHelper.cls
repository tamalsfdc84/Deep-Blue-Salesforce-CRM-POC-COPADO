public with sharing class FISCCCardBaseIntegrationHelper {
  public static String cardNumber = '';
  public static List<String> statuses = new List<String>{ 'FUNDED', 'ACCOUNT_OPENED' };

  public static FISCCRequestBaseDTO getGenerateCardNoRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCDebitCardNoGenRequestDTO request = new FISCCDebitCardNoGenRequestDTO();
    request.CardNumber.CBInstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');
    String binCode;
    if (FISCCSubmissionExecutor.wintrustEnvConfig != null && FISCCSubmissionExecutor.wintrustEnvConfig.IsTestEnv__c) {
      binCode = FISCCIntegrationConstants.TEST_BANK_CARD_BINCODE;
    } else {
      binCode = CZWTFCHelperRepository.findAddOnServiceByCodeandType(accPref.tffa__code__c, FISCCIntegrationConstants.DBT_TYPE)
        .tffa__CardBINCode__c;
    }
    request.CardNumber.CBCrdPrfxNbr = binCode;
    requestDTO = request;

    return requestDTO;
  }

  public static FISCCDOCardCreationRequest getCardCreationRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDebitCardCreationRequestDTO request = new FISCCDebitCardCreationRequestDTO();
    tffa__Address__c addressObj = new tffa__Address__c();
    addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    if (accPref.tffa__Address__c != null) {
      addressObj = accPref.tffa__Address__r;
    }

    request.CBCrdNbr = accPref.tffa__CardNumber__c;
    request.CustNbr = partyObj.Customer_Number__c;
    request.CBStAbbr = addressObj.tffa__State__c;
    request.CBInstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');
    request.CBBrnchNbr = appObj.FISBranchCode__c;
    request.CBStrAddrLne1 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
    request.CBStrAddrLne2 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line2__c, 30);
    request.CBCtyNme = CZWTFCCommonHelper.trimString(addressObj.tffa__City__c, 20);
    request.CBZIP = CZWTFCCommonHelper.trimString(addressObj.tffa__ZipCode__c, 5);

    String accountNumber = appObj.tffa__AccountPurpose__c == 'DEBIT_CARD'
      ? accPref.tffa__AccountNumber__c.replaceFirst('^0+', '')
      : appObj.tffa__AccountNumber__c.replaceFirst('^0+', ''); // To remove leading Zero's
    request.CBPrmyDdaAcctNbr = String.valueOf(accountNumber);
    request.CBPrmySsn = partyObj.tffa__NationalIdentifierValue__c;
    request.NmeEmbossOnCard = accPref.tffa__EmbossedName__c;
    request.CBShrtNmeFrst = CZWTFCCommonHelper.trimString(partyObj.tffa__FirstName__c, 10);
    request.CBShrtNmeLst = CZWTFCCommonHelper.trimString(partyObj.tffa__LastName__c, 15);
    String middleNameInitial = CZWTFCCommonHelper.trimString(partyObj.tffa__MiddleName__c, 1);
    request.CBCrdNmeLne1 = accPref.tffa__EmbossedName__c;

    if (String.isNotBlank(accPref.tffa__EmbossedBusinessName__c)) {
      request.OptlLneEmbossOnCard = CZWTFCCommonHelper.trimString(accPref.tffa__EmbossedBusinessName__c, 26);
    }

    if (accPref.PriSavingApplicationId__c != null || accPref.PriSavingAccountNumber__c != null) {
      request.CBPrmySavAcctNbr = accPref.PriSavingApplicationId__c != null
        ? accPref.PriSavingApplicationId__r.tffa__AccountNumber__c
        : accPref.PriSavingAccountNumber__c;
    }

    String binCode;
    if (FISCCSubmissionExecutor.wintrustEnvConfig != null && FISCCSubmissionExecutor.wintrustEnvConfig.IsTestEnv__c) {
      binCode = FISCCIntegrationConstants.TEST_BANK_CARD_BINCODE;
    } else {
      binCode = CZWTFCHelperRepository.findAddOnServiceByCodeandType(accPref.tffa__code__c, FISCCIntegrationConstants.DBT_TYPE)
        .tffa__CardBINCode__c;
    }

    request.CBCrdPrfxNbr = binCode;

    FISCCDOCardCreationRequest objCCDOCardCreationRequest = new FISCCDOCardCreationRequest();
    objCCDOCardCreationRequest.cardNew = request;
    objCCDOCardCreationRequest.SvcID = FISCCIntegrationConstants.SVCID_CardCreation;

    return objCCDOCardCreationRequest;
  }

  public static FISCCDOMultiAccountRequest getMultiAccountCardCreationRequest(
    tffa__AccountPreference__c accPref,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCMultiAccDebitCardCreationRequestDTO request = new FISCCMultiAccDebitCardCreationRequestDTO();

    request.CrdNbr = accPref.tffa__CardNumber__c;
    request.InstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');

    FISCCMultiAccDebitCardCreationRequestDTO.MultipleAccountsNewLst requestList = new FISCCMultiAccDebitCardCreationRequestDTO.MultipleAccountsNewLst();

    if (accPref.SecDDAApplicationId__c != null || accPref.SecDDAAccountNumber__c != null) {
      requestList.AcctNbr = accPref.SecDDAApplicationId__c != null
        ? accPref.SecDDAApplicationId__r.tffa__AccountNumber__c.replaceFirst('^0+', '')
        : accPref.SecDDAAccountNumber__c.replaceFirst('^0+', '');
      requestList.AcctTyp = 'DDA';
      request.debitCardmultipleAccountsNewLst.add(requestList);
    }

    if (accPref.SecSavingApplicationId__c != null || accPref.SecSavingAccountNumber__c != null) {
      requestList = new FISCCMultiAccDebitCardCreationRequestDTO.MultipleAccountsNewLst();
      requestList.AcctNbr = accPref.SecSavingApplicationId__c != null
        ? accPref.SecSavingApplicationId__r.tffa__AccountNumber__c.replaceFirst('^0+', '')
        : accPref.SecSavingAccountNumber__c.replaceFirst('^0+', '');
      requestList.AcctTyp = 'SAV ';
      request.debitCardmultipleAccountsNewLst.add(requestList);
    }

    FISCCDOMultiAccountRequest objFISCCDOMultiAccountRequest = new FISCCDOMultiAccountRequest();
    objFISCCDOMultiAccountRequest.debitCardMultipleAccount = request;
    objFISCCDOMultiAccountRequest.SvcID = FISCCIntegrationConstants.SVCID_CardMultiAccount;

    return objFISCCDOMultiAccountRequest;
  }

  public static FISCCDODebitCardAccRelRequestRequest getCardToCustRelationRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj
  ) {
    FISCCDebitCardAccRelRequestDTO request = new FISCCDebitCardAccRelRequestDTO();
    tffa__Address__c addressObj = new tffa__Address__c();
    addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    request.CIRltApplNbr01 = partyObj.Customer_Number__c;
    request.CIEnt1ToEnt2RltCde = FISCCIntegrationConstants.SOLE_OWNER_RELN_CODE;
    request.PriSecRltCde01 = 'P';
    request.NAStandardizationOvride = 'Y';
    request.CINmeAddrLneCde01 = 'N';
    String suffix = partyObj.tffa__Suffix__c != null ? partyObj.tffa__Suffix__c : '';
    request.NmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      suffix,
      FISCCIntegrationConstants.CUST_NAME_LENGTH
    );

    if (addressObj.tffa__Line2__c != null) {
      request.CINmeAddrLneCde02 = 'A';
      request.CINmeAddrLneCde03 = 'S';
      request.CINmeAddrLneCde04 = 'C';
      request.NmeAddrLne02 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
      request.NmeAddrLne03 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line2__c, 30);
      request.NmeAddrLne04 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    } else {
      request.CINmeAddrLneCde02 = 'S';
      request.CINmeAddrLneCde03 = 'C';
      request.NmeAddrLne02 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
      request.NmeAddrLne03 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    }
    request.ApplCde = 'CBM';
    request.AcctNbr = accPref.tffa__CardNumber__c;

    FISCCDODebitCardAccRelRequestRequest objFISCCDODebitCardAccRelRequestRequest = new FISCCDODebitCardAccRelRequestRequest();
    objFISCCDODebitCardAccRelRequestRequest.customerAccounts = request;
    objFISCCDODebitCardAccRelRequestRequest.SvcID = FISCCIntegrationConstants.SVCID_CustomerAccount;

    return objFISCCDODebitCardAccRelRequestRequest;
  }

  public static FISCCRequestBaseDTO getDepositOriginationRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO;

    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();

    // Card Creation Request && Customer relationship request
    if (!(CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(accPref.tffa__Status__c)) {
      lstFISCCDepositOriginationRequestBaseDTO.add(getCardCreationRequest(partyObj, accPref, appObj, charterConfig));
      lstFISCCDepositOriginationRequestBaseDTO.add(getCardToCustRelationRequest(partyObj, accPref, appObj));
    }

    if (
      (accPref.SecDDAApplicationId__c != null &&
      FISCCIntegrationLogService.applicationObjMap.get(accPref.SecDDAApplicationId__c) != null &&
      !statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.SecDDAApplicationId__c).tffa__Status__c)) ||
      (accPref.SecSavingApplicationId__c != null &&
      FISCCIntegrationLogService.applicationObjMap.get(accPref.SecSavingApplicationId__c) != null &&
      !statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.SecSavingApplicationId__c).tffa__Status__c))
    ) {
      accPref.CZSecAccountAdditionFlag__c = false;
    }

    // Multi account linking request
    if (
      ((accPref.SecDDAApplicationId__c != null &&
      FISCCIntegrationLogService.applicationObjMap.get(accPref.SecDDAApplicationId__c) != null &&
      statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.SecDDAApplicationId__c).tffa__Status__c)) &&
      (accPref.SecSavingApplicationId__c != null &&
      FISCCIntegrationLogService.applicationObjMap.get(accPref.SecSavingApplicationId__c) != null &&
      statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.SecSavingApplicationId__c).tffa__Status__c))) ||
      (String.isNotBlank(accPref.SecDDAAccountNumber__c) || String.isNotBlank(accPref.SecSavingAccountNumber__c))
    ) {
      accPref.CZSecAccountAdditionFlag__c = true;
      lstFISCCDepositOriginationRequestBaseDTO.add(getMultiAccountCardCreationRequest(accPref, charterConfig));
    }

    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
    fisccRequestBaseDTO = objFISCCDepositOriginationRequest;

    return fisccRequestBaseDTO;
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

  public static FISCCRequestBaseDTO getExpediteDeliveryRequest(
    tffa__party__c partyObj,
    tffa__AccountPreference__c accPref,
    tffa__Application__c appObj,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO requestDTO;
    FISCCExpediteCardDeliveryRequestDTO request = new FISCCExpediteCardDeliveryRequestDTO();

    request.pinlessCardData.CrdNbr = accPref.tffa__CardNumber__c;
    request.pinlessCardData.CBInstnNbr = (charterConfig.OrganizationId__c).right(3).leftPad(5, '0');
    request.pinlessCardData.CBReissueCardInd = 'X';
    request.pinlessCardData.WaiveReissCrdFee = accPref.CZWaiveExpediteShippingFee__c ? 'Y' : 'N';

    tffa__Address__c addressObj = new tffa__Address__c();
    addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    if (accPref.tffa__Address__c != null) {
      addressObj = accPref.tffa__Address__r;
    }

    request.pinlessCardData.ExpAddr1 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line1__c, 30);
    if (addressObj.tffa__Line2__c != null) {
      request.pinlessCardData.ExpAddr2 = CZWTFCCommonHelper.trimString(addressObj.tffa__Line2__c, 30);
      request.pinlessCardData.ExpAddr3 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    } else {
      request.pinlessCardData.ExpAddr2 = (addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c);
    }

    CZTerafinaFisMapping__c tfFisCountryMap = CZTerafinaFisMapping__c.getValues('AddressCountry' + '_' + addressObj.tffa__Country__c);
    if (tfFisCountryMap != null) {
      request.pinlessCardData.ExpCountry = tfFisCountryMap.FisValue__c;
    }
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