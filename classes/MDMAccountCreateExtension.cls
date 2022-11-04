public with sharing class MDMAccountCreateExtension {
  public static Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();

  public static String createAccount(tffa__Application__c app) {
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(
          app.tffa__ProductCategory__c
        )
        ? CZWTFCHelperRepository.fetchMulesoftAdapterConfig('SDBCreateAccount')
        : CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CreateAccount');

      if (FISCCIntegrationLogService.submissionObj.tffa__Channel__c == CZWTFCConstants.BRANCH) {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '?interactionMethod=BRANCH';
      } else {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '?interactionMethod=ONLINE';
      }

      MDMAccountCreateRequest request = generateAccountCreateRequest(app);

      String requestStr = System.JSON.serialize(request, true);

      CZMulesoftAdapter.auth = FISCCIntegrationLogService.auth;

      CZMulesoftAdapter.invokeAPI(requestStr, adapterConfig);

      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CREATE_ACCOUNT_MDM);
      return CZWTFCConstants.PROCESS_STATUS_SUCCESS;
    } catch (Exception ex) {
      tffa.logger.error('Exception in MDMAccountCreateExtension ' + ex.getMessage() + ' ' + ex.getStackTraceString());

      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CREATE_ACCOUNT_MDM);
      return 'FAILURE';
    }
  }

  public static MDMAccountCreateRequest generateAccountCreateRequest(tffa__Application__c app) {
    MDMAccountCreateRequest request = new MDMAccountCreateRequest();
    request.rowidObject = '';
    String accountNumber = '';
    Boolean isSDBProduct = false;
    Date startDate;

    if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
      accountNumber = app.tffa__DepositBoxAccountNumber__c;
      isSDBProduct = true;
      request.rowidObject = null;
      startDate = app.tffa__DepositBoxStartDate__c;
    } else {
      startDate = app.CZAccountOpeningDate__c;
      accountNumber = app.tffa__AccountNumber__c;
    }

    if (accountNumber != null && accountNumber.length() != 11 && !isSDBProduct) {
      accountNumber = accountNumber.leftPad(11, '0');
    }

    if (CZWTFCCommonHelper.isCertificateProduct(app) && app.DPTDId__c != null) {
      String DPTDId = app.DPTDId__c.leftPad(11, '0');
      accountNumber = accountNumber + '-' + DPTDId;
    }

    for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
      partyMap.put(party.Id, party);
    }

    tffa__Party__c primaryOwner = new tffa__Party__c();
    for (tffa__ApplicationPartyXref__c applicationParty : app.tffa__PartyXrefs__r) {
      tffa__Party__c party = partyMap.get(applicationParty.tffa__Party__c);
      if (applicationParty.tffa__Primary__c) {
        primaryOwner = party;
      }
      if (party.tffa__IsExistingCustomer__c || party.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
        request.PartyRelationship.item.add(getPartyRelationShipItem(applicationParty, app));
        MDMAccountCreateRequest.DebitCardItem item = getDebitcardDetails(applicationParty, app);
        if (item != null)
          request.DebitCard.item.add(item);
      }
    }

    if (isSDBProduct) {
      Integer custNumber = Integer.valueOf(primaryOwner.Customer_Number__c);
      request.key.sourceKey = accountNumber + '|' + String.valueOf(custNumber) + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    } else {
      request.key.sourceKey = accountNumber + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    }

    request.acctNo = accountNumber;
    request.costCntrNo = app.CostCenter__c;
    request.statChngDt = CZWTFCCommonHelper.formatDate(startDate, FISCCIntegrationConstants.MDM_DATE_FORMAT);
    request.closeDt = '9999-12-31';
    request.boClassCode = isSDBProduct ? 'OTHER' : 'DEPOSIT';
    request.openDt = request.statChngDt;

    if (FISCCIntegrationLogService.submissionObj.tffa__Channel__c == CZWTFCConstants.BRANCH) {
      request.offcrRowid.offcrCd = app.CZPrimaryOfficer__c + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    } else {
      request.offcrRowid.offcrCd =
        FISCCIntegrationLogService.brandObj.CIPrmyOffcrNbr__c +
        '|' +
        MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    }
    request.statCd.lkpCd = isSDBProduct ? 'ACCTSTAT|RENTED' : 'ACCTSTAT|O';
    request.bnkCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    request.brnchCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + app.FISBranchCode__c;
    request.prodCtgry.prodCd = isSDBProduct ? 'SB' : 'DP';

    if (!isSDBProduct) {
      request.prodType.prodCd = 'DP|' + MDMCommonHelper.getProductTypeCode(app.tffa__Product__r);
      request.prodSubType.prodCd = request.prodType.prodCd + '|' + app.tffa__Product__r.tffa__Code__c.leftPad(3, '0');
      request.Preference.item.add(getAccountPreference(app));
    }

    if (isSDBProduct) {
      request.Addresses.item.add(getAddress(app.tffa__Address__r));
    }

    return request;
  }

  public static MDMAccountCreateRequest.PartyRelationshipItem getPartyRelationShipItem(
    tffa__ApplicationPartyXref__c applicationParty,
    tffa__Application__c app
  ) {
    MDMAccountCreateRequest.PartyRelationshipItem item = new MDMAccountCreateRequest.PartyRelationshipItem();
    String relnCode = '';
    if (applicationParty.tffa__ApplicantRole__r != null && applicationParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
      relnCode = applicationParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
    }

    item.relRoleCd = 'CtoA' + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + relnCode;
    item.primCustAcctFlag = applicationParty.tffa__Primary__c ? 'FLAG|Y' : 'FLAG|N';
    item.hierarchyCode = 'PTY_ACCT_HIER';
    item.endDt = '9999-12-31';
    item.statCd.lkpCd = 'STATUS|A';

    if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
      item.strtDt = CZWTFCCommonHelper.formatDate(app.tffa__DepositBoxStartDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
    } else {
      item.strtDt = CZWTFCCommonHelper.formatDate(app.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
    }

    tffa__Party__c party = partyMap.get(applicationParty.tffa__Party__c);

    if (party != null && party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
      item.relTypeCode = 'INDV_DEP';
      item.Party.ptyTypCd = 'INDV';
      if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
        item.relTypeCode = 'INDV_OTH';
      }
    } else {
      item.relTypeCode = 'ORG_DEP';
      item.Party.ptyTypCd = 'ORG';
      if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
        item.relTypeCode = 'ORG_OTH';
      }
    }

    if (party != null && party.Customer_Number__c != null) {
      Integer custNumber = Integer.valueOf(party.Customer_Number__c);
      item.Party.key.sourceKey = String.valueOf(custNumber) + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    }

    return item;
  }

  public static MDMAccountCreateRequest.PreferenceItem getAccountPreference(tffa__Application__c app) {
    MDMAccountCreateRequest.PreferenceItem item1 = new MDMAccountCreateRequest.PreferenceItem();
    item1.prefTypCd.prefTypCd = 'ACCT|STMT';
    item1.statCd.lkpCd = 'STATUS|A';

    List<tffa__AccountPreference__c> acctPref = new List<tffa__AccountPreference__c>();

    for (tffa__AccountPreference__c accountPreference : app.tffa__AccountPreferences__r) {
      if (accountPreference.tffa__Code__c == 'E-STATEMENTS') {
        acctPref.add(accountPreference);
      }
    }

    if (acctPref != null && acctPref.size() > 0 && acctPref[0].tffa__Enabled__c) {
      item1.prefVl.lkpCd = 'ACCTPREFVL|E';
    } else {
      item1.prefVl.lkpCd = 'ACCTPREFVL|P';
    }

    return item1;
  }

  public static MDMAccountCreateRequest.AddressesItem getAddress(tffa__Address__c address) {
    MDMAccountCreateRequest.AddressesItem item = new MDMAccountCreateRequest.AddressesItem();

    item.addrTypCd.addrTypCd = 'ACCT';
    item.relTypCd.lkpCd = 'ACCTADDR|ACCT_SB';
    item.Address.addrLine1Tx = address.tffa__Line1__c;
    item.Address.addrLine2Tx = address.tffa__Line2__c;
    item.Address.cityNm = address.tffa__City__c;
    item.Address.stateCd = address.tffa__State__c;

    List<String> zipCode = address.tffa__ZipCode__c.split('-', 2);
    if (zipCode != null) {
      if (zipCode.size() > 0) {
        if (zipCode.get(0).length() > 5) {
          item.Address.zip5Cd = zipCode.get(0).substring(0, 5);
          if (zipCode.get(0).length() == 9) {
            item.Address.zip4Cd = zipCode.get(0).substring(5, 9);
          }
        } else {
          item.Address.zip5Cd = zipCode.get(0);
        }
      }
      if (zipCode.size() > 1 && zipCode.get(1).length() == 4) {
        item.Address.zip4Cd = zipCode.get(1);
      }
    }

    CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues('AddressCountry' + '_' + address.tffa__Country__c);
    if (tfFisIdentityMap != null) {
      item.Address.cntryCd.ctryCd = tfFisIdentityMap.FisValue__c;
    }

    return item;
  }

  public static MDMAccountCreateRequest.DebitCardItem getDebitcardDetails(
    tffa__ApplicationPartyXref__c applicationParty,
    tffa__Application__c app
  ) {
    MDMAccountCreateRequest.DebitCardItem item;
    for (tffa__AccountPreference__c accPref : app.tffa__AccountPreferences__r) {
      if (accPref.tffa__AddOnServiceType__c == 'DEBIT_CARD' && accPref.tffa__Enabled__c && String.isNotBlank(accPref.tffa__CardNumber__c)) {
        item = new MDMAccountCreateRequest.DebitCardItem();
        item.relTypeCode = 'DEP_DBT';
        item.hierarchyCode = 'PTY_ACCT_HIER';
        item.strtDt = CZWTFCCommonHelper.formatDate(app.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
        item.endDt = '9999-12-31';
        item.statCd.lkpCd = 'DEBCRDSTAT|1';
        item.CardHolder.boClassCode = 'DBT';
        item.CardHolder.fiBnkNo = MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
        item.CardHolder.crdNo = accPref.tffa__CardNumber__c;
        item.CardHolder.openDt = CZWTFCCommonHelper.formatDate(app.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
        item.CardHolder.endDt = '9999-12-31';
        item.CardHolder.prodCtgry.prodCd = 'CBM';
        item.CardHolder.prodType.prodCd = 'CBM|P';

        tffa__Party__c party = partyMap.get(applicationParty.tffa__Party__c);

        if (party != null && party.Customer_Number__c != null) {
          Integer custNumber = Integer.valueOf(party.Customer_Number__c);
          item.CardHolder.Customer.key.sourceKey = String.valueOf(custNumber) + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
          item.CardHolder.Customer.ptyTypCd = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'INDV' : 'ORG';
        }
      }
    }

    return item;
  }
}