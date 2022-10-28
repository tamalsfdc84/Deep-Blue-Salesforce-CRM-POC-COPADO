public with sharing class MDMCustomerCreateExtension {
  public static String createCustomer(tffa__Submission__c submission, tffa__Party__c party) {
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CreateCustomer');

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

    request.ptyTypCd = 'INDV';
    request.costCntrNo = party.CostCenter__c != null ? party.CostCenter__c : '';
    request.endDt = '9999-12-31';
    request.strtDt = startDate.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    request.ptyNm = party.tffa__LastName__c + ', ' + party.tffa__FirstName__c;
    request.statChngDt = startDate.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    request.offcrRowid.offcrCd =
      FISCCIntegrationLogService.brandObj.CIPrmyOffcrNbr__c +
      '|' +
      MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
    request.statCd.lkpCd = 'STATUS|A';
    request.psptIn.lkpCd = 'FLAG|N';
    request.cntryCd.ctryCd = 'USA'; // Default set to USA
    request.bnkCd.locCd = MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c);
    request.brnchCd.locCd = MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c) + '|' + party.FISBranchCode__c;

    request.Details.item.add(getPartyDetails(party));
    request.Identifiers.item.add(getIdentifiers(party));
    request.Email.item.add(getEmail(party));
    request.Addresses.item.add(getAddress(party));

    if (party.CellPhoneNumber__c != null || party.tffa__PrimaryPhone__c != null || party.tffa__SecondaryPhone__c != null) {
      request.Communication.item.addAll(getCommunication(party));
    }

    for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
      if (app.tffa__AccountNumber__c != null && (app.tffa__Product__r.tffa__Category__c != 'CERTIFICATE' || app.DPTDId__c != null)) {
        request.AccountRelationship.item.add(getAccountRelationShip(app, party));
      }
    }

    return request;
  }

  public static MDMCustomerCreateRequest.DetailsItem getPartyDetails(tffa__Party__c party) {
    MDMCustomerCreateRequest.DetailsItem item = new MDMCustomerCreateRequest.DetailsItem();
    item.lstNm = party.tffa__LastName__c.touppercase();
    item.frstNm = party.tffa__FirstName__c.touppercase();
    item.midNm = party.tffa__MiddleName__c != null ? party.tffa__MiddleName__c.touppercase() : '';
    item.sfxVl = party.tffa__Suffix__c != null ? party.tffa__Suffix__c : '';

    Datetime dob = Date.Valueof(party.tffa__BirthDate__c);
    item.birthDt = dob.formatGMT(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    item.empIn.lkpCd = 'FLAG|N';

    item.ctznCd.lkpCd = (party.tffa__Citizenship__c == 'Citizen') ? 'CTZNCD|Y' : 'CTZNCD|N';
    item.statCd.lkpCd = 'STATUS|A';
    item.occpnCd.occpnCd = '011';

    return item;
  }

  public static MDMCustomerCreateRequest.IdentifiersItem getIdentifiers(tffa__Party__c party) {
    MDMCustomerCreateRequest.IdentifiersItem item = new MDMCustomerCreateRequest.IdentifiersItem();

    item.idntyCd = party.tffa__NationalIdentifierValue__c;
    item.idntyTypCd.idntyTypCd = 'S';

    return item;
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

      if (item.prefFg.lkpCd == 'FLAG|Y') {
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
      item.commcnTypCd.commcnTypCd = 'HME';
      item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, 'HME');
      communicationList.add(item);
    }

    if (party.tffa__SecondaryPhone__c != null) {
      item = new MDMCustomerCreateRequest.CommunicationItem();
      String phoneNumber = String.valueOf(party.tffa__SecondaryPhone__c);
      item.commcnVl = phoneNumber.right(10);
      item.commcnTypCd.commcnTypCd = 'WRK';
      item.prefFg.lkpCd = isPreferredContactNumber(party.PreferredContactNumber__c, 'WRK');
      communicationList.add(item);
    }

    return communicationList;
  }

  public static String isPreferredContactNumber(String type, String code) {
    if (type == 'HOME' && code == 'HME') {
      return 'FLAG|Y';
    } else if ((type == 'MOBILE' || type == 'CELL') && code == 'MBL') {
      return 'FLAG|Y';
    } else if (type == 'WORK' && code == 'WRK') {
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

  public static MDMCustomerCreateRequest.AddressesItem getAddress(tffa__Party__c party) {
    MDMCustomerCreateRequest.AddressesItem item = new MDMCustomerCreateRequest.AddressesItem();

    item.primAddrIn.lkpCd = 'FLAG|Y';
    item.addrTypCd.addrTypCd = 'PRIM';
    item.Address.stateCd = party.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c;
    item.Address.cityNm = party.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__City__c;
    item.Address.addrLine1Tx = party.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__Line1__c;

    List<String> zipCode = party.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c.split('-', 2);
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
    item.Address.cntryCd.ctryCd = 'USA'; // Default set to USA

    return item;
  }

  public static MDMCustomerCreateRequest.AccountRelationshipItem getAccountRelationShip(tffa__Application__c app, tffa__Party__c party) {
    MDMCustomerCreateRequest.AccountRelationshipItem item = new MDMCustomerCreateRequest.AccountRelationshipItem();

    tffa__ApplicationPartyXref__c applicationParty = new tffa__ApplicationPartyXref__c();

    for (tffa__ApplicationPartyXref__c applicationPartyObjs : app.tffa__PartyXrefs__r) {
      if (applicationPartyObjs.tffa__Party__c == party.Id) {
        applicationParty = applicationPartyObjs;
      }
    }

    item.relRoleCd = 'CtoA' + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + applicationParty.CZFISRelationshipCode__c;

    item.relTypeCode = 'INDV_DEP';
    item.hierarchyCode = 'PTY_ACCT_HIER';
    item.endDt = '9999-12-31';
    item.strtDt = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    item.primCustAcctFg.lkpCd = 'FLAG|Y';
    item.statCd.lkpCd = 'STATUS|A';

    MDMCustomerCreateRequest.Account accountDetails = new MDMCustomerCreateRequest.Account();

    String accountNumber = app.tffa__AccountNumber__c;

    if (accountNumber != null && accountNumber.length() != 11) {
      accountNumber = accountNumber.leftPad(11, '0');
    }

    if (app.tffa__Product__r.tffa__Category__c == 'CERTIFICATE' && app.DPTDId__c != null) {
      String DPTDId = app.DPTDId__c.leftPad(11, '0');
      accountNumber = accountNumber + '-' + DPTDId;
    }

    accountDetails.key.sourceKey = accountNumber + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    accountDetails.acctNo = accountNumber;
    accountDetails.boClassCode = 'DEPOSIT';
    accountDetails.closeDate = '9999-12-31';
    accountDetails.openDate = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    accountDetails.statChngDt = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    accountDetails.bnkCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    accountDetails.brnchCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + app.FISBranchCode__c;
    accountDetails.prodCtgry.prodCd = 'DP';
    accountDetails.statCd.lkpCd = 'ACCTSTAT|O';
    accountDetails.prodType.prodCd = 'DP|' + MDMCommonHelper.getProductTypeCode(app.tffa__Product__r);
    accountDetails.prodSubType.prodCd = accountDetails.prodType.prodCd + '|' + app.tffa__Product__r.tffa__Code__c.leftPad(3, '0');

    MDMCustomerCreateRequest.AccountPreferencesItem acctPrefItem = new MDMCustomerCreateRequest.AccountPreferencesItem();
    acctPrefItem.prefTypCd.prefTypCd = 'ACCT|STMT';
    acctPrefItem.prefVl.lkpCd = 'ACCTPREFVL|E';
    acctPrefItem.statCd.lkpCd = 'STATUS|A';

    accountDetails.AccountPreferences.item.add(acctPrefItem);

    item.Account = accountDetails;

    return item;
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