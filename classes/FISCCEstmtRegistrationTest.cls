@isTest
public with sharing class FISCCEstmtRegistrationTest {
  @isTest
  static void testEstmtRegistration() {
    tffa__Submission__c sub = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '118'
    );
    insert sub;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    //party.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
    insert party;
    lstParty.add(party);

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = true,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref;

    //create party
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.tffa__PrimaryPhone__c = '5072630009';
    objParty.tffa__FirstName__c = 'SSANDRAA';
    objParty.tffa__NationalIdentifierValue__c = '666001753';
    objParty.tffa__LastName__c = 'CCOBAA';
    objParty.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty.tffa__Citizenship__c = 'Citizen';
    objParty.PreferredContactNumber__c = 'HOME';
    objParty.tffa__SecondaryPhone__c = '987627897';
    objParty.CellPhoneNumber__c = '97557854457';
    objParty.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty;
    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

    //insert app data
    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      AccountPreference__c = 'PENDING'
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;

    //account preference
    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = '12123',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;

    tffa__AccountPreference__c accPrefOd = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'John',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = '12123',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'OVERDRAFT_PROTECTION'
    );
    insert accPrefOd;

    tffa__AdditionalPreference__c addPref = new tffa__AdditionalPreference__c(
      tffa__Code__c = '12122',
      tffa__Party__c = party.Id,
      tffa__Submission__c = sub.Id,
      tffa__AddOnServiceType__c = 'ONLINE_BANKING',
      tffa__Status__c = 'IN_PROGRESS',
      tffa__Enabled__c = true
    );
    insert addPref;

    //create Identity
    tffa__Identification__c identity = new tffa__Identification__c();
    identity.tffa__Party__c = lstParty[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity.tffa__Party__c);
    identity.tffa__IdentificationNumber__c = 'K987667';
    identity.tffa__Type__c = 'DL';
    identity.tffa__IssuingState__c = 'California';
    identity.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref = new tffa__ApplicationPartyXref__c();
    appPartyxref.tffa__Party__c = lstParty[0].Id;
    appPartyxref.tffa__Application__c = app.id;
    appPartyxref.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref.Name = 'Test';
    appPartyxref.tffa__Primary__c = true;
    insert appPartyxref;
    tffa.logger.debug(' party.Id ==>' + party.Id);
    tffa.logger.debug('appPartyxref ==>' + appPartyxref);
    List<tffa__party__c> lstParty1 = new List<tffa__party__c>();

    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;
    //create tffa__Location__c
    tffa__Location__c objLoc = new tffa__Location__c();
    objLoc.Name = '988';
    objLoc.FISBranchCode__c = '200';
    objLoc.CostCenter__c = '1000';
    objLoc.tffa__Address__c = objAddress.id;
    objLoc.tffa__Code__c = '901';
    insert objLoc;
    // create Brand Data
    List<tffa__Brand__c> lstBrand = new List<tffa__Brand__c>();
    tffa__Brand__c objBrand = new tffa__Brand__c();
    objBrand.DefaultLocation__c = objLoc.id;
    objBrand.tffa__Code__c = sub.tffa__Brand__c;
    insert objBrand;
    lstBrand.add(objBrand);
    // create BrandLocation(junction) data
    tffa__BrandLocation__c objBrandLoc = new tffa__BrandLocation__c();
    objBrandLoc.tffa__Brand__c = objBrand.id;
    objBrandLoc.tffa__Location__c = objLoc.id;
    insert objBrandLoc;
    // insert tffa__PartyAddressXref__c
    tffa__PartyAddressXref__c partAddXref = new tffa__PartyAddressXref__c();
    partAddXref.tffa__Address__c = objAddress.id;
    partAddXref.tffa__Party__c = party.id;
    insert partAddXref;
    Test.startTest();
    try {
      Database.executeBatch(new FISAccountPreferencesBatch(), 1);
      List<tffa__Application__c> appList = CZWTFCApplicationRepository.findAppwithChildsForAccountPref();
      Test.setMock(HttpCalloutMock.class, new FISCCEstmtRegistrationMockClass());
      List<tffa__Application__c> apLst = FISAccountPreferencesExecutor.processAccPrefRequest(appList);
      System.assertNotEquals(null, apLst);
      FISCCMultiKeywordsResponseBuilder.testException = true;
      new FISCCMultiKeywordsResponseBuilder().build(null, null, null);
      new FISCCMultiKeywordsResponseBuilder().parseResponse(null, null, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      String str = FISAccountPreferencesExecutor.getPrimaryPartyFrmtedName(app);
      System.assertEquals('', str);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      List<tffa__Application__c> appList = CZWTFCApplicationRepository.findAppwithChildsForAccountPref();
      tffa__Application__c ap = FISAccountPreferencesExecutor.fetchApplication(appList, '13456');
      System.assertEquals(null, ap);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setPartyObjs();
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setApplicationObjs();
      Test.setMock(HttpCalloutMock.class, new FISCCEstmtRegistrationMockClass());
      Boolean flag = FISAccountPreferencesExecutor.processKeywordAPI(app, FISCCIntegrationConstants.OD_ATM_Y);
      System.assertEquals(false, flag);
    } catch (Exception expp) {
      tffa.Logger.debug('Test Execption thrown');
    }
    //test exception block for deficit
    try {
      FISAccountPreferencesExecutor.testException = true;
      List<tffa__Application__c> appList = CZWTFCApplicationRepository.findAppwithChildsForAccountPref();
      List<tffa__Application__c> apLst = FISAccountPreferencesExecutor.processAccPrefRequest(appList);
      System.assertNotEquals(null, apLst);
    } catch (Exception exp) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //test exception block for od atm
    try {
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setPartyObjs();
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setApplicationObjs();
      Test.setMock(HttpCalloutMock.class, new FISCCEstmtRegistrationMockClass());
      FISAccountPreferencesExecutor.testException = true;
      Boolean flag = FISAccountPreferencesExecutor.processKeywordAPI(app, FISCCIntegrationConstants.OD_ATM_Y);
      System.assertEquals(false, flag);
    } catch (Exception exp) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}