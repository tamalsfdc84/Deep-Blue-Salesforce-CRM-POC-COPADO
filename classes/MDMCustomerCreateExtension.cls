public with sharing class MDMCustomerCreateExtension {
  public static String country = '';
  public static String createCustomer(tffa__Submission__c submission, tffa__Party__c party) {
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL
        ? CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CreateCustomer')
        : CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CreateBusinessCustomer');

      // If Its a DEBIT CARD Product then Card issue status must be success.
      for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
        if (app.tffa__AccountPurpose__c == 'DEBIT_CARD' && app.DebitCardIssuanceStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
          return 'FAILURE';
        }
      }

      if (submission.tffa__Channel__c == CZWTFCConstants.BRANCH) {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '?interactionMethod=BRANCH';
      } else {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '?interactionMethod=ONLINE';
      }

      MDMCustomerCreateRequest request = generateCustomerCreateRequest(submission, party);

      String requestStr = System.JSON.serialize(request, true);

      CZMulesoftAdapter.auth = FISCCIntegrationLogService.auth;

      Object resp = CZMulesoftAdapter.invokeAPI(requestStr, adapterConfig);

      if (resp != null) {
        CZMDMCustomerCreationResponseDTO custResp = (CZMDMCustomerCreationResponseDTO) resp;
        if (custResp.wtfcPartyId != null) {
          party.CZMDMPartyID__c = custResp.wtfcPartyId;
        }
      }

      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CREATE_CUSTOMER_MDM);
      return 'SUCCESS';
    } catch (Exception ex) {
      tffa.logger.error('Exception in MDMCustomerCreateExtension ' + ex.getMessage() + ' ' + ex.getStackTraceString());

      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CREATE_CUSTOMER_MDM);
      return 'FAILURE';
    }
  }

  public static MDMCustomerCreateRequest generateCustomerCreateRequest(tffa__Submission__c submission, tffa__Party__c party) {
    //party = CZWTFCPartyRepository.findByIdWithChildObjects(party.Id);

    MDMCustomerCreateRequest request = new MDMCustomerCreateRequest();

    request.rowidObject = '';

    // If party is part of another charter
    if (party.IsCrossCharterCustomer__c) {
      request.rowidObject = party.CZMDMPartyID__c;
    }

    Datetime startDate = party.tffa__OnboardingDate__c;

    if (startDate == null) {
      startDate = Datetime.now();
    }

    if (party.Customer_Number__c != null) {
      Integer custNumber = Integer.valueOf(party.Customer_Number__c);
      request.key.sourceKey = String.valueOf(custNumber) + '|' + MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
    }

    request.ptyTypCd = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'INDV' : 'ORG';
    request.costCntrNo = party.CostCenter__c != null ? party.CostCenter__c : '';
    request.endDt = '9999-12-31';
    request.strtDt = startDate.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    request.ptyNm = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL
      ? party.tffa__LastName__c + ', ' + party.tffa__FirstName__c
      : party.tffa__LegalName__c;
    request.statChngDt = startDate.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    request.offcrRowid.offcrCd =
      FISCCIntegrationLogService.brandObj.CIPrmyOffcrNbr__c +
      '|' +
      MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);

    // as secOffcrRowid is mandatory field, in digital flow for primary and secondary same values were passed
    request.secOffcrRowid.offcrCd = request.offcrRowid.offcrCd;

    Boolean isDebitCardProduct = false;
    for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
      if (app.tffa__AccountPurpose__c == 'DEBIT_CARD') {
        isDebitCardProduct = true;
        break;
      }

      if (
        (app.tffa__AccountNumber__c != null ||
        app.tffa__DepositBoxAccountNumber__c != null) &&
        (!CZWTFCCommonHelper.isCertificateProduct(app) || app.DPTDId__c != null) &&
        FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST.contains(app.tffa__Status__c)
      ) {
        MDMCustomerCreateRequest.AccountRelationshipItem item = getAccountRelationShip(app, party);

        if (item != null) {
          request.AccountRelationship.item.add(item);
        }
      }
    }

    if (submission.tffa__Channel__c == 'BRANCH') {
      request.offcrRowid.offcrCd = party.CZPrimaryOfficer__c + '|' + MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
      if (String.isNotBlank(party.CZSecondaryOfficer__c)) {
        request.secOffcrRowid.offcrCd = party.CZSecondaryOfficer__c + '|' + MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
      }

      if (party.CZPartyAliases__r != null && party.CZPartyAliases__r.size() > 0 && !isDebitCardProduct) {
        request.Preference = getAliasDetails(party);
      }
    }

    request.bnkCd.locCd = MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
    request.brnchCd.locCd = MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c) + '|' + party.FISBranchCode__c;

    request.Details.item.add(getPartyDetails(party));
    request.DebitCard = getDebitCardDetails(party);

    if (
      party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ||
      (party.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION &&
      party.tffa__NationalIdentifierType__c != 'NONE' &&
      party.tffa__NationalIdentifierType__c != 'FOR')
    ) {
      request.Identifiers.item.add(getIdentifiers(party));
    }

    if (party.tffa__Identifications__r != null && party.tffa__Identifications__r.size() > 0) {
      List<MDMCustomerCreateRequest.IdentifiersItem> itemList = getIdentificationDocuments(party);
      if (itemList != null) {
        request.Identifiers.item.addAll(itemList);
      }
    }

    request.statCd.lkpCd = 'STATUS|A';
    request.psptIn.lkpCd = 'FLAG|N';

    if (String.isNotBlank(party.tffa__PrimaryEmail__c) && !isDebitCardProduct) {
      request.Email.item.add(getEmail(party));
    }

    if (!isDebitCardProduct) {
      request.Addresses = getAddress(party);
    } else {
      // fetch party country
      getAddress(party);
    }

    request.cntryCd.ctryCd = country;

    if (
      (party.CellPhoneNumber__c != null || party.tffa__PrimaryPhone__c != null || party.tffa__SecondaryPhone__c != null) &&
      !isDebitCardProduct
    ) {
      request.Communication.item.addAll(getCommunication(party));
    }

    return request;
  }

  public static MDMCustomerCreateRequest.DetailsItem getPartyDetails(tffa__Party__c party) {
    MDMCustomerCreateRequest.DetailsItem item = new MDMCustomerCreateRequest.DetailsItem();

    if (party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
      if (party.tffa__BirthDate__c != null) {
        Datetime dob = Date.Valueof(party.tffa__BirthDate__c);
        item.birthDt = dob.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);
      }
      item.lstNm = party.tffa__LastName__c.touppercase();
      item.frstNm = party.tffa__FirstName__c.touppercase();
      item.midNm = party.tffa__MiddleName__c != null ? party.tffa__MiddleName__c.touppercase() : '';
      item.sfxVl = party.tffa__Suffix__c != null ? party.tffa__Suffix__c : '';
      item.empIn.lkpCd = party.tffa__IsEmployee__c ? 'FLAG|Y' : 'FLAG|N';
      item.ctznCd.lkpCd = (party.tffa__Citizenship__c == 'Citizen') ? 'CTZNCD|Y' : 'CTZNCD|N';
      item.statCd.lkpCd = 'STATUS|A';

      if (party.tffa__Employments__r != null && party.tffa__Employments__r.size() > 0) {
        item.occpnCd = new MDMCustomerCreateRequest.OccpnCd();
        item.occpnCd.occpnCd = party.tffa__Employments__r[0].OccupationType__c;

        item.empStatIn = new MDMCustomerCreateRequest.empStatIn();
        item.empStatIn.lkpCd = 'EMPSTAT' + '|' + MDMCommonHelper.getEmploymentType(party.tffa__Employments__r[0].tffa__Type__c);

        item.empTitle = party.tffa__Employments__r[0].tffa__Title__c;
        item.emplrSchlNm = party.tffa__Employments__r[0].tffa__EmployerName__c;
      }

      item.plAdvFlag.lkpCd = 'FLAG|N';
      for (tffa__AdditionalPreference__c preference : party.tffa__AdditionalPreferences__r) {
        if (preference.tffa__AddOnServiceType__c == 'PLATINUM_ADVENTURE_MEMBERSHIP' && preference.tffa__Enabled__c) {
          item.plAdvFlag.lkpCd = 'FLAG|Y';
          break;
        }
      }
    } else {
      item.orgNm = party.tffa__LegalName__c;
      item.cntctNm = party.CZCertifyingIndividualFN__c + ' ' + party.CZCertifyingIndividualLN__c;
      item.naicsCd = party.tffa__IndustryClassificationValue__c;

      //DateTime dt = DateTime.newInstance(party.tffa__EstablishmentDate__c, Time.newInstance(0, 0, 0, 0));
      //item.yrOfEstblNo = dt.format('yyyy');
    }

    return item;
  }

  public static MDMCustomerCreateRequest.IdentifiersItem getIdentifiers(tffa__Party__c party) {
    MDMCustomerCreateRequest.IdentifiersItem item = new MDMCustomerCreateRequest.IdentifiersItem();

    item.idntyTypCd.idntyTypCd = MDMCommonHelper.getTaxIdType(party.tffa__NationalIdentifierType__c);
    item.idntyCd = item.idntyTypCd.idntyTypCd == 'N' ? '000000000' : party.tffa__NationalIdentifierValue__c;

    return item;
  }

  public static List<MDMCustomerCreateRequest.IdentifiersItem> getIdentificationDocuments(tffa__Party__c party) {
    List<MDMCustomerCreateRequest.IdentifiersItem> items = new List<MDMCustomerCreateRequest.IdentifiersItem>();

    for (tffa__Identification__c identification : party.tffa__Identifications__r) {
      String identityType = MDMCommonHelper.getIdentificationType(identification.tffa__Type__c);
      if (String.isNotBlank(identityType) && identification.tffa__IdentificationNumber__c != null) {
        MDMCustomerCreateRequest.IdentifiersItem item = new MDMCustomerCreateRequest.IdentifiersItem();
        item.idntyTypCd.idntyTypCd = identityType;
        item.idntyCd = identification.tffa__IdentificationNumber__c.toUppercase();
        items.add(item);
      }
    }

    if (items.size() > 0) {
      return items;
    }

    return null;
  }

  public static List<MDMCustomerCreateRequest.CommunicationItem> getCommunication(tffa__Party__c party) {
    List<MDMCustomerCreateRequest.CommunicationItem> communicationList = new List<MDMCustomerCreateRequest.CommunicationItem>();
    Boolean isHomeAddressAdded = false;
    MDMCustomerCreateRequest.CommunicationItem item = new MDMCustomerCreateRequest.CommunicationItem();

    if (party.CellPhoneNumber__c != null) {
      String phoneNumber = String.valueOf(party.CellPhoneNumber__c);
      item.commcnVl = phoneNumber.right(10);
      item.commcnTypCd.commcnTypCd = 'MBL';
      item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, 'MBL');
      communicationList.add(item);

      if (item.prefFg.lkpCd == 'FLAG|Y' && party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
        item = new MDMCustomerCreateRequest.CommunicationItem();
        item.commcnVl = phoneNumber.right(10);
        item.commcnTypCd.commcnTypCd = 'HME';
        item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, 'HME');
        communicationList.add(item);

        isHomeAddressAdded = true;
      }
    }

    if (party.tffa__PrimaryPhone__c != null && !isHomeAddressAdded) {
      item = new MDMCustomerCreateRequest.CommunicationItem();
      String phoneNumber = String.valueOf(party.tffa__PrimaryPhone__c);
      item.commcnVl = phoneNumber.right(10);
      item.commcnTypCd.commcnTypCd = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'HME' : 'PRI';
      item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, item.commcnTypCd.commcnTypCd);
      communicationList.add(item);
    }

    if (party.tffa__SecondaryPhone__c != null) {
      item = new MDMCustomerCreateRequest.CommunicationItem();
      String phoneNumber = String.valueOf(party.tffa__SecondaryPhone__c);
      item.commcnVl = phoneNumber.right(10);
      item.commcnTypCd.commcnTypCd = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'WRK' : 'SEC';
      item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, item.commcnTypCd.commcnTypCd);
      communicationList.add(item);
    }

    return communicationList;
  }

  public static String isPreferredContactNumber(String type, String code) {
    if (type == 'HOME' && (code == 'HME' || code == 'PRI')) {
      return 'FLAG|Y';
    } else if ((type == 'MOBILE' || type == 'CELL') && code == 'MBL') {
      return 'FLAG|Y';
    } else if (type == 'WORK' && (code == 'WRK' || code == 'SEC')) {
      return 'FLAG|Y';
    }

    return 'FLAG|N';
  }

  public static MDMCustomerCreateRequest.EmailItem getEmail(tffa__Party__c party) {
    MDMCustomerCreateRequest.EmailItem item = new MDMCustomerCreateRequest.EmailItem();

    item.emailTypCd.commcnTypCd = 'EMAIL';
    item.email = party.tffa__PrimaryEmail__c;

    return item;
  }

  public static MDMCustomerCreateRequest.Addresses getAddress(tffa__Party__c party) {
    MDMCustomerCreateRequest.Addresses itemList = new MDMCustomerCreateRequest.Addresses();

    for (tffa__PartyAddressXref__c partyAddress : party.tffa__AddressXrefs__r) {
      MDMCustomerCreateRequest.AddressesItem item = new MDMCustomerCreateRequest.AddressesItem();
      item.addrTypCd.addrTypCd = MDMCommonHelper.getaddressType(partyAddress.tffa__Type__c);
      item.primAddrIn.lkpCd = partyAddress.tffa__Preferred__c ? 'FLAG|Y' : 'FLAG|N';
      item.Address.stateCd = partyAddress.tffa__Address__r.tffa__State__c;
      item.Address.cityNm = partyAddress.tffa__Address__r.tffa__City__c;
      item.Address.addrLine1Tx = partyAddress.tffa__Address__r.tffa__Line1__c;

      if (partyAddress.tffa__Address__r.tffa__Line2__c != null) {
        item.Address.addrLine2Tx = partyAddress.tffa__Address__r.tffa__Line2__c;
      }

      List<String> zipCode = partyAddress.tffa__Address__r.tffa__ZipCode__c.split('-', 2);
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

      CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
        'AddressCountry' +
        '_' +
        partyAddress.tffa__Address__r.tffa__Country__c
      );
      if (tfFisIdentityMap != null) {
        item.Address.cntryCd.ctryCd = tfFisIdentityMap.FisValue__c;
        country = tfFisIdentityMap.FisValue__c;
      }

      itemList.item.add(item);
    }

    return itemList;
  }

  public static MDMCustomerCreateRequest.AccountRelationshipItem getAccountRelationShip(tffa__Application__c app, tffa__Party__c party) {
    MDMCustomerCreateRequest.AccountRelationshipItem item = new MDMCustomerCreateRequest.AccountRelationshipItem();

    tffa__ApplicationPartyXref__c applicationParty = null;

    for (tffa__ApplicationPartyXref__c applicationPartyObjs : app.tffa__PartyXrefs__r) {
      if (applicationPartyObjs.tffa__Party__c == party.Id) {
        applicationParty = applicationPartyObjs;
      }
    }

    if (applicationParty == null && !Test.isRunningTest()) {
      return null;
    }

    String relnCode = '';
    if (
      !Test.isRunningTest() &&
      applicationParty.tffa__ApplicantRole__r != null &&
      applicationParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null
    ) {
      relnCode = applicationParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
    }

    String accountNumber = '';
    Boolean isSDBProduct = false;
    Date startDate;

    if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
      accountNumber = app.tffa__DepositBoxAccountNumber__c;
      isSDBProduct = true;
      startDate = app.tffa__DepositBoxStartDate__c;
    } else {
      accountNumber = app.tffa__AccountNumber__c;
      startDate = app.CZAccountOpeningDate__c;
    }

    item.relRoleCd = 'CtoA' + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + relnCode;
    item.hierarchyCode = 'PTY_ACCT_HIER';
    item.endDt = '9999-12-31';
    item.strtDt = CZWTFCCommonHelper.formatDate(startDate, FISCCIntegrationConstants.MDM_DATE_FORMAT);
    item.primCustAcctFg.lkpCd = 'FLAG|Y';
    item.statCd.lkpCd = 'STATUS|A';

    MDMCustomerCreateRequest.Account accountDetails = new MDMCustomerCreateRequest.Account();

    if (accountNumber != null && accountNumber.length() != 11 && !isSDBProduct) {
      accountNumber = accountNumber.leftPad(11, '0');
    }

    if (CZWTFCCommonHelper.isCertificateProduct(app) && app.DPTDId__c != null) {
      String DPTDId = app.DPTDId__c.leftPad(11, '0');
      accountNumber = accountNumber + '-' + DPTDId;
    }

    if (isSDBProduct) {
      Integer custNumber = Integer.valueOf(party.Customer_Number__c);
      accountDetails.key.sourceKey =
        accountNumber +
        '|' +
        String.valueOf(custNumber) +
        '|' +
        MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    } else {
      accountDetails.key.sourceKey = accountNumber + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    }
    accountDetails.acctNo = accountNumber;
    accountDetails.boClassCode = isSDBProduct ? 'OTHER' : 'DEPOSIT';
    accountDetails.closeDate = '9999-12-31';
    accountDetails.openDate = CZWTFCCommonHelper.formatDate(startDate, FISCCIntegrationConstants.MDM_DATE_FORMAT);
    accountDetails.statChngDt = accountDetails.openDate;

    accountDetails.bnkCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    accountDetails.brnchCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + app.FISBranchCode__c;
    accountDetails.prodCtgry.prodCd = isSDBProduct ? 'SB' : 'DP';
    accountDetails.statCd.lkpCd = isSDBProduct ? 'ACCTSTAT|RENTED' : 'ACCTSTAT|O';

    MDMCustomerCreateRequest.AccountPreferencesItem acctPrefItem = new MDMCustomerCreateRequest.AccountPreferencesItem();
    acctPrefItem.prefTypCd.prefTypCd = 'ACCT|STMT';
    acctPrefItem.prefVl.lkpCd = 'ACCTPREFVL|E';
    acctPrefItem.statCd.lkpCd = 'STATUS|A';

    accountDetails.AccountPreferences.item.add(acctPrefItem);

    if (!isSDBProduct) {
      accountDetails.prodType.prodCd = 'DP|' + MDMCommonHelper.getProductTypeCode(app.tffa__Product__r);
      accountDetails.prodSubType.prodCd = accountDetails.prodType.prodCd + '|' + app.tffa__Product__r.tffa__Code__c.leftPad(3, '0');
    } else {
      accountDetails.prodType = null;
      accountDetails.prodSubType = null;
    }

    if (party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
      item.relTypeCode = 'INDV_DEP';
      if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
        item.relTypeCode = 'INDV_OTH';
      }
    } else {
      item.relTypeCode = 'ORG_DEP';
      if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)) {
        item.relTypeCode = 'ORG_OTH';
      }
    }

    item.Account = accountDetails;

    return item;
  }

  public static MDMCustomerCreateRequest.preference getAliasDetails(tffa__Party__c party) {
    MDMCustomerCreateRequest.Preference preference = new MDMCustomerCreateRequest.Preference();
    for (CZPartyAlias__c alias : party.CZPartyAliases__r) {
      MDMCustomerCreateRequest.PreferenceItem item = new MDMCustomerCreateRequest.PreferenceItem();
      item.prefTypCd.prefTypCd = 'PTY|ALIASNAME';
      item.statCd.lkpCd = 'STATUS|A';
      item.prefVl = alias.AliasFirstName__c + (alias.AliasLastName__c != null ? alias.AliasLastName__c : '');
      preference.item.add(item);
    }

    return preference;
  }

  public static MDMCustomerCreateRequest.DebitCard getDebitCardDetails(tffa__Party__c party) {
    MDMCustomerCreateRequest.DebitCard debitCard = new MDMCustomerCreateRequest.DebitCard();
    for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
      for (tffa__AccountPreference__c accPref : app.tffa__AccountPreferences__r) {
        if (
          accPref.tffa__AddOnServiceType__c == 'DEBIT_CARD' &&
          accPref.tffa__Enabled__c &&
          String.isNotBlank(accPref.tffa__CardNumber__c) &&
          accPref.tffa__Party__c == party.Id
        ) {
          DateTime currentDate = Datetime.now();

          MDMCustomerCreateRequest.DebitCardItem item = new MDMCustomerCreateRequest.DebitCardItem();
          item.openDt = app.tffa__AccountPurpose__c == 'DEBIT_CARD'
            ? currentDate.format(FISCCIntegrationConstants.MDM_DATE_FORMAT)
            : CZWTFCCommonHelper.formatDate(app.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
          item.bankLocCd = MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
          item.crdNo = accPref.tffa__CardNumber__c;
          item.endDt = '9999-12-31';
          item.boClassCode = 'DBT';
          item.prodCtgry.prodCd = 'CBM';
          item.prodType.prodCd = 'CBM|P';
          item.statCd.lkpCd = 'DEBCRDSTAT|1';

          MDMCustomerCreateRequest.DebitCardAccountItem accountItem = new MDMCustomerCreateRequest.DebitCardAccountItem();
          accountItem.relTypeCode = 'DEP_DBT';
          accountItem.hierarchyCode = 'PTY_ACCT_HIER';
          accountItem.strtDt = app.tffa__AccountPurpose__c == 'DEBIT_CARD'
            ? currentDate.format(FISCCIntegrationConstants.MDM_DATE_FORMAT)
            : CZWTFCCommonHelper.formatDate(app.CZAccountOpeningDate__c, FISCCIntegrationConstants.MDM_DATE_FORMAT);
          accountItem.endDt = '9999-12-31';
          accountItem.statCd.lkpCd = 'DEBCRDSTAT|1';
          accountItem.Account.acctNo = app.tffa__AccountPurpose__c == 'DEBIT_CARD'
            ? accPref.tffa__AccountNumber__c.leftPad(11, '0')
            : app.tffa__AccountNumber__c.leftPad(11, '0');
          accountItem.Account.statCd.lkpCd = 'ACCTSTAT|O';
          accountItem.Account.boClassCode = 'DEPOSIT';

          item.DebitCardAccount.item.add(accountItem);

          debitCard.item.add(item);
        }
      }
    }

    return debitCard;
  }

  public static String getPartySuffixData(String value) {
    Schema.DescribeFieldResult fieldResult = tffa__party__c.tffa__Suffix__c.getDescribe();
    List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry v : values) {
      if (v.getValue() == value) {
        return v.getLabel();
      }
    }

    return '';
  }
}