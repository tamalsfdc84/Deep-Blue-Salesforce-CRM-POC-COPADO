public with sharing class MDMAccountCreateExtension {
  public static Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();

  public static String createAccount(tffa__Application__c app) {
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CreateAccount');

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

    String accountNumber = app.tffa__AccountNumber__c;

    if (accountNumber != null && accountNumber.length() != 11) {
      accountNumber = accountNumber.leftPad(11, '0');
    }

    if (app.tffa__Product__r.tffa__Category__c == 'CERTIFICATE' && app.DPTDId__c != null) {
      String DPTDId = app.DPTDId__c.leftPad(11, '0');
      accountNumber = accountNumber + '-' + DPTDId;
    }
    request.key.sourceKey = accountNumber + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    request.acctNo = accountNumber;
    request.costCntrNo = app.CostCenter__c;
    request.statChngDt = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    request.closeDt = '9999-12-31';
    request.boClassCode = 'DEPOSIT';
    request.openDt = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);

    request.offcrRowid.offcrCd =
      FISCCIntegrationLogService.brandObj.CIPrmyOffcrNbr__c +
      '|' +
      MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    request.statCd.lkpCd = 'ACCTSTAT|O';
    request.bnkCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    request.brnchCd.locCd = MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + app.FISBranchCode__c;
    request.prodCtgry.prodCd = 'DP';
    request.prodType.prodCd = 'DP|' + MDMCommonHelper.getProductTypeCode(app.tffa__Product__r);
    request.prodSubType.prodCd = request.prodType.prodCd + '|' + app.tffa__Product__r.tffa__Code__c.leftPad(3, '0');

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

    request.Preference.item.add(item1);

    for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
      partyMap.put(party.Id, party);
    }

    for (tffa__ApplicationPartyXref__c applicationParty : app.tffa__PartyXrefs__r) {
      tffa__Party__c party = partyMap.get(applicationParty.tffa__Party__c);
      if (party.tffa__IsExistingCustomer__c || party.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
        request.PartyRelationship.item.add(getPartyRelationShipItem(applicationParty, app));
      }
    }

    return request;
  }

  public static MDMAccountCreateRequest.PartyRelationshipItem getPartyRelationShipItem(
    tffa__ApplicationPartyXref__c applicationParty,
    tffa__Application__c app
  ) {
    MDMAccountCreateRequest.PartyRelationshipItem item = new MDMAccountCreateRequest.PartyRelationshipItem();
    item.relRoleCd = 'CtoA' + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c) + '|' + applicationParty.CZFISRelationshipCode__c;
    item.relTypeCode = 'INDV_DEP';
    item.primCustAcctFlag = '';
    item.hierarchyCode = 'PTY_ACCT_HIER';
    item.endDt = '9999-12-31';
    item.strtDt = app.CZAccountOpeningDate__c.format(FISCCIntegrationConstants.MDM_DATE_FORMAT);
    item.statCd.lkpCd = 'STATUS|A';
    item.Party.ptyTypCd = 'INDV';

    if (partyMap.get(applicationParty.tffa__Party__c).Customer_Number__c != null) {
      Integer custNumber = Integer.valueOf(partyMap.get(applicationParty.tffa__Party__c).Customer_Number__c);
      item.Party.key.sourceKey = String.valueOf(custNumber) + '|' + MDMCommonHelper.getBrandCode(app.tffa__Brand__c);
    }

    return item;
  }
}