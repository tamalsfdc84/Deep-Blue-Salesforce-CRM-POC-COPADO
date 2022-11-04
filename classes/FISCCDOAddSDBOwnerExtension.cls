public with sharing class FISCCDOAddSDBOwnerExtension {
  public static FISCCDepositOriginationRequestBaseDTO invokeDepositeBoxOwner(
    tffa__Party__c partyObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {
      fisccDepositOriginationRequestBaseDTO = depositBoxOwnerRequest(partyObj, appObj);

      return fisccDepositOriginationRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeDepositeBoxOwner : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return fisccDepositOriginationRequestBaseDTO;
    }
  }

  public static FISCCDepositOriginationRequestBaseDTO depositBoxOwnerRequest(tffa__Party__c partyObj, tffa__Application__c appObj) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    CZSDBAddOwnerRequest request = new CZSDBAddOwnerRequest();
    request.SvcID = FISCCIntegrationConstants.SVCID_SDBAddOwner;

    String[] boxDetails = appObj.tffa__DepositBoxAccountNumber__c.split('-');

    request.boxOwnerNew.Brnch = boxDetails[0];
    request.boxOwnerNew.BoxPrfx = boxDetails[1];
    request.boxOwnerNew.BoxNbr = boxDetails[2];
    request.boxOwnerNew.CurTerm = String.valueOf(appObj.tffa__DepositBoxExpirationTerm__c);
    request.boxOwnerNew.RnwTerm = String.valueOf(appObj.tffa__DepositBoxExpirationTerm__c);
    request.boxOwnerNew.RepositionPassInd = '';

    // Set Expiration date
    Datetime expDate = DateTime.newInstance(appObj.tffa__DepositBoxExpirationDate__c, Time.newInstance(0, 0, 0, 0));
    request.boxOwnerNew.ExpDte = expDate.format('MM') + '/' + expDate.format('dd') + '/' + expDate.format('yy');

    // Set Rented date
    Datetime dt = DateTime.newInstance(appObj.tffa__DepositBoxStartDate__c, Time.newInstance(0, 0, 0, 0));
    request.boxOwnerNew.DteRentedMM = dt.format('MM');
    request.boxOwnerNew.DteRentedDD = dt.format('dd');
    request.boxOwnerNew.DteRentedCCYY = dt.format('yyyy');

    request.boxOwnerNew.NmeAddr1 = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.FULL_NAME_LENGTH
    );

    request.boxOwnerNew.ShrtNme = CZWTFCCommonHelper.getFormattedFullName(
      partyObj.tffa__FirstName__c,
      partyObj.tffa__MiddleName__c,
      partyObj.tffa__LastName__c,
      partyObj.tffa__Suffix__c,
      FISCCIntegrationConstants.CUST_NAME_LENGTH_1
    );

    tffa__Address__c addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;

    // Set Address
    if (addressObj != null) {
      request.boxOwnerNew.NmeAddr2 = addressObj.tffa__Line1__c;

      if (addressObj.tffa__Line2__c != null) {
        request.boxOwnerNew.NmeAddr3 = addressObj.tffa__Line2__c;
        request.boxOwnerNew.NmeAddr4 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c;
      } else {
        request.boxOwnerNew.NmeAddr3 = addressObj.tffa__City__c + ' ' + addressObj.tffa__State__c + ' ' + addressObj.tffa__ZipCode__c;
      }
    }

    // Set Phone number
    if (partyObj.tffa__PrimaryPhone__c != null) {
      String phoneNumber = getPhoneNumber(partyObj.tffa__PrimaryPhone__c);
      request.boxOwnerNew.HmPh1 = phoneNumber.substring(0, 3);
      request.boxOwnerNew.HmPh2 = phoneNumber.substring(3, 6);
      request.boxOwnerNew.HmPh3 = phoneNumber.substring(6);
    }

    // Set Tax Id and type
    request.boxOwnerNew.TaxNbr = partyObj.tffa__NationalIdentifierValue__c;
    request.boxOwnerNew.TaxId = CZWTFCCommonHelper.getTaxIdType(partyObj.tffa__NationalIdentifierType__c);

    request.boxOwnerNew.PrmyOffcr = appObj.CZPrimaryOfficer__c;
    request.boxOwnerNew.CstCntr = appObj.CostCenter__c;

    // Set Discount Reason text
    getReasonText(request, appObj);

    // Set Billing Details
    setBillingDetails(request, appObj);

    // Set Current Rate Code
    setRateCode(request, appObj);

    //set Caution codes
    getCautionCodes(request, appObj);

    fisccDepositOriginationRequestBaseDTO = request;

    tffa.Logger.debug('FISCCDOAddSDBOwnerExtension::fisccDepositOriginationRequestBaseDTO: ' + fisccDepositOriginationRequestBaseDTO);

    return fisccDepositOriginationRequestBaseDTO;
  }

  public static CZSDBAddOwnerRequest getCautionCodes(CZSDBAddOwnerRequest request, tffa__Application__c appObj) {
    if (String.isNotBlank(appObj.CZCautionCode1__c)) {
      request.boxOwnerNew.CautionCde1 = String.valueOf(appObj.CZCautionCode1__c);
    }

    if (String.isNotBlank(appObj.CZCautionCode2__c)) {
      request.boxOwnerNew.CautionCde2 = String.valueOf(appObj.CZCautionCode2__c);
    }

    // if (String.isNotBlank(appObj.CZCautionCode3__c)) {
    //   request.boxOwnerNew.CautionCde3 = String.valueOf(appObj.CZCautionCode3__c);
    // }

    return request;
  }

  public static CZSDBAddOwnerRequest getReasonText(CZSDBAddOwnerRequest request, tffa__Application__c appObj) {
    if (String.isNotBlank(appObj.CZSDBDiscountReasonTxt__c)) {
      if (appObj.CZSDBDiscountReasonTxt__c.length() <= 30) {
        request.boxOwnerNew.OwnComment1 = appObj.CZSDBDiscountReasonTxt__c;
      } else if (appObj.CZSDBDiscountReasonTxt__c.length() > 30 && appObj.CZSDBDiscountReasonTxt__c.length() <= 60) {
        request.boxOwnerNew.OwnComment1 = appObj.CZSDBDiscountReasonTxt__c.substring(0, 29);
        request.boxOwnerNew.OwnComment2 = appObj.CZSDBDiscountReasonTxt__c.substring(30, appObj.CZSDBDiscountReasonTxt__c.length() - 1);
      } else if (appObj.CZSDBDiscountReasonTxt__c.length() > 60) {
        request.boxOwnerNew.OwnComment1 = appObj.CZSDBDiscountReasonTxt__c.substring(0, 29);
        request.boxOwnerNew.OwnComment2 = appObj.CZSDBDiscountReasonTxt__c.substring(30, 59);
      }
    }

    return request;
  }

  public static void setRateCode(CZSDBAddOwnerRequest request, tffa__Application__c appObj) {
    request.boxOwnerNew.CurRteCde = appObj.tffa__IsDepositBoxDiscountApplied__c ? 'O' : appObj.CZSDBRateApplied__c == 'S' ? 'S' : '1';
    request.boxOwnerNew.CurDiscPremInd = appObj.tffa__IsDepositBoxDiscountApplied__c ? 'D' : 'N';
    request.boxOwnerNew.StdRte = String.valueOf(appObj.tffa__Amount__c);
    request.boxOwnerNew.AmtDue = String.valueOf(appObj.tffa__Amount__c);

    if (appObj.tffa__IsDepositBoxDiscountApplied__c && appObj.CZIsDiscountForFirstYearOnly__c) {
      request.boxOwnerNew.RnwRteCde = appObj.CZSDBRateApplied__c == 'S' ? 'S' : '1';
      /* TODO : set rate without discount*/
      request.boxOwnerNew.RnwRte = String.valueOf(appObj.tffa__DepositBoxRentalDiscount__c + appObj.tffa__Amount__c);
      request.boxOwnerNew.RnwDiscPremInd = 'N';
    } else {
      request.boxOwnerNew.RnwRteCde = request.boxOwnerNew.CurRteCde;
      request.boxOwnerNew.RnwRte = request.boxOwnerNew.StdRte;
      request.boxOwnerNew.RnwDiscPremInd = request.boxOwnerNew.CurDiscPremInd;
    }
    if (request.boxOwnerNew.CurBillCde == 'W' || request.boxOwnerNew.CurBillCde == 'B') {
      request.boxOwnerNew.CurRteCde = 'S';
      request.boxOwnerNew.CurDiscPremInd = 'N';
    }
    if (request.boxOwnerNew.RnwBillCde == 'W' || request.boxOwnerNew.RnwBillCde == 'B') {
      request.boxOwnerNew.RnwRteCde = 'S';
      request.boxOwnerNew.RnwDiscPremInd = 'N';
    }
  }

  public static CZSDBAddOwnerRequest setBillingDetails(CZSDBAddOwnerRequest request, tffa__Application__c appObj) {
    if (appObj.tffa__IsDepositBoxFeeWaived__c) {
      request.boxOwnerNew.CurBillCde = 'W';
      return request;
    }

    if (appObj.CZBillingMode__c != null && FISCCIntegrationConstants.SDB_BILLING_CODE_MAP.containsKey(appObj.CZBillingMode__c)) {
      request.boxOwnerNew.CurBillCde = FISCCIntegrationConstants.SDB_BILLING_CODE_MAP.get(appObj.CZBillingMode__c);
    }
    if (
      appObj.CZRenewalBillingMode__c != null && FISCCIntegrationConstants.SDB_BILLING_CODE_MAP.containsKey(appObj.CZRenewalBillingMode__c)
    ) {
      request.boxOwnerNew.RnwBillCde = FISCCIntegrationConstants.SDB_BILLING_CODE_MAP.get(appObj.CZRenewalBillingMode__c);
    }
    if (request.boxOwnerNew.CurBillCde == 'A' && FISCCIntegrationLogService.SDB_Funding_Details_MAP.containsKey(appObj.Id + '_DEPOSIT')) {
      request.boxOwnerNew.BillableAcct = FISCCIntegrationLogService.SDB_Funding_Details_MAP.get(appObj.Id + '_DEPOSIT')
        .tffa__AccountNumber__c;
    } else if (
      request.boxOwnerNew.RnwBillCde == 'A' && FISCCIntegrationLogService.SDB_Funding_Details_MAP.containsKey(appObj.Id + '_RENEWAL')
    ) {
      request.boxOwnerNew.BillableAcct = FISCCIntegrationLogService.SDB_Funding_Details_MAP.get(appObj.Id + '_RENEWAL')
        .tffa__AccountNumber__c;
    }
    return request;
  }

  public static String getPhoneNumber(String phonenumber) {
    phonenumber = phonenumber.reverse();
    phonenumber = phonenumber.substring(0, 10);
    phonenumber = phonenumber.reverse();

    return phonenumber;
  }
}