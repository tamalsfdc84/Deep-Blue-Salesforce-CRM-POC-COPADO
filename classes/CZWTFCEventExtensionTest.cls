@isTest
public with sharing class CZWTFCEventExtensionTest {
  @isTest
  public static void eventTest() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;

    SubBrand__c subBrandObj = new SubBrand__c();
    subBrandObj.Brand__c = brandObj.Id;
    insert subBrandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Application__c appObj = new tffa__Application__c();
    appObj.tffa__Submission__c = sub.Id;
    appObj.tffa__Status__c = 'APPROVED';
    insert appObj;

    tffa__Application__c appObj2 = new tffa__Application__c();
    appObj2.tffa__Submission__c = sub.Id;
    appObj2.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj2.tffa__AutoKYCDecisionOutcome__c = 'APPROVED';
    insert appObj2;

    tffa__Application__c appObj3 = new tffa__Application__c();
    appObj3.tffa__Submission__c = sub.Id;
    appObj3.Name = 'Test';
    appObj3.tffa__Status__c = 'DECLINED';
    appObj3.tffa__AutoKYCDecisionOutcome__c = 'DECLINED';
    insert appObj3;

    tffa__Application__c appObj4 = new tffa__Application__c();
    appObj4.tffa__Submission__c = sub.Id;
    appObj4.tffa__Status__c = 'DECLINED';
    appObj4.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj4.tffa__KYCDecisionOutcome__c = 'DECLINED';
    insert appObj4;

    tffa__Application__c appObj5 = new tffa__Application__c();
    appObj5.tffa__Submission__c = sub.Id;
    appObj5.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj5.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj5.tffa__KYCDecisionOutcome__c = 'APPROVED';
    insert appObj5;

    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';

    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;

    tffa__ApplicationPartyXref__c appPartyObj = new tffa__ApplicationPartyXref__c();
    appPartyObj.tffa__Party__c = partyObj.Id;
    appPartyObj.tffa__Application__c = appObj.Id;
    appPartyObj.tffa__Party__r = partyObj;
    appPartyObj.tffa__Type__c = 'INDIVIDUAL';
    appPartyObj.tffa__Primary__c = true;
    insert appPartyObj;

    // tffa__Application__c appObj3a = new tffa__Application__c();
    // appObj3a.tffa__Submission__c = sub.Id;
    // appObj3a.tffa__Status__c = 'Application_AccountOpened';
    // appObj3a.tffa__PartyXrefs__r=appPartyObj;
    // insert appObj3a;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c();
    subPartyXref.tffa__Submission__c = sub.Id;
    subPartyXref.tffa__Party__c = partyObj.Id;
    subPartyXref.tffa__Primary__c = true;
    subPartyXref.tffa__Party__r = partyObj;
    subPartyXref.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref;

    Test.startTest();

    new CZWTFCPartyEventExtension().post(partyObj);
    new CZWTFCSubmissionEventExtension();
    new CZWTFCSubmissionEventExtension('Submission_Abandoned').post(sub);
    new CZWTFCSubmissionEventExtension('Submission_Cancelled').post(sub);
    new CZWTFCSubmissionEventExtension('Submission_Review').post(sub);
    new CZWTFCSubmissionEventExtension('Submission_Reminder').post(sub);
    new CZWTFCSubmissionEventExtension('Submission_Reopened').post(sub);
    new CZWTFCSubmissionEventExtension('Submission_OTP_Generated').post(subPartyXref);
    CZWTFCPartyRepository.fetchPartyById(partyObj.Id);
    new CZWTFCPartyEventExtension('Application_Declined_Adverse').sendAdverseActionMail(partyObj, appObj3);
    Test.stopTest();
  }
  @isTest
  public static void eventTest1() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;

    SubBrand__c subBrandObj = new SubBrand__c();
    subBrandObj.Brand__c = brandObj.Id;
    insert subBrandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Application__c appObj = new tffa__Application__c();
    appObj.tffa__Submission__c = sub.Id;
    appObj.tffa__Status__c = 'APPROVED';
    insert appObj;

    tffa__Application__c appObj2 = new tffa__Application__c();
    appObj2.tffa__Submission__c = sub.Id;
    appObj2.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj2.tffa__AutoKYCDecisionOutcome__c = 'APPROVED';
    insert appObj2;

    tffa__Application__c appObj3 = new tffa__Application__c();
    appObj3.tffa__Submission__c = sub.Id;
    appObj3.tffa__Status__c = 'DECLINED';
    appObj3.tffa__AutoKYCDecisionOutcome__c = 'DECLINED';
    insert appObj3;

    tffa__Application__c appObj4 = new tffa__Application__c();
    appObj4.tffa__Submission__c = sub.Id;
    appObj4.tffa__Status__c = 'DECLINED';
    appObj4.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj4.tffa__KYCDecisionOutcome__c = 'DECLINED';
    insert appObj4;

    tffa__Application__c appObj5 = new tffa__Application__c();
    appObj5.tffa__Submission__c = sub.Id;
    appObj5.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj5.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj5.tffa__KYCDecisionOutcome__c = 'APPROVED';
    insert appObj5;

    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';

    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;

    tffa__ApplicationPartyXref__c appPartyObj = new tffa__ApplicationPartyXref__c();
    appPartyObj.tffa__Party__c = partyObj.Id;
    appPartyObj.tffa__Application__c = appObj.Id;
    appPartyObj.tffa__Party__r = partyObj;
    appPartyObj.tffa__Type__c = 'INDIVIDUAL';
    appPartyObj.tffa__Primary__c = true;
    insert appPartyObj;

    // tffa__Application__c appObj3a = new tffa__Application__c();
    // appObj3a.tffa__Submission__c = sub.Id;
    // appObj3a.tffa__Status__c = 'Application_AccountOpened';
    // appObj3a.tffa__PartyXrefs__r=appPartyObj;
    // insert appObj3a;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c();
    subPartyXref.tffa__Submission__c = sub.Id;
    subPartyXref.tffa__Party__c = partyObj.Id;
    subPartyXref.tffa__Primary__c = true;
    subPartyXref.tffa__Party__r = partyObj;
    subPartyXref.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref;

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c();
    subPartyXref1.tffa__Submission__c = sub.Id;
    subPartyXref1.tffa__Party__c = partyObj.Id;
    subPartyXref1.tffa__Primary__c = false;
    subPartyXref1.tffa__Party__r = partyObj;
    subPartyXref1.tffa__IsPresent__c = false;
    subPartyXref1.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref1;

    Test.startTest();

    new CZWTFCSubmissionJointEventExtension();
    new CZWTFCSubmissionJointEventExtension('Submission_Primary_Submitted').post(sub);
    new CZWTFCSubmissionJointEventExtension('Submission_Joint_Abandoned').post(subPartyXref);
    new CZWTFCSubmissionJointEventExtension('Submission_Joint_Initiated').post(subPartyXref);
    new CZWTFCSubmissionJointEventExtension('Submission_OTP_Generated').post(subPartyXref1);
    new CZWTFCSubmissionJointEventExtension('Submission_Joint_Saved').post(subPartyXref);
    CZWTFCPartyRepository.fetchPartyById(partyObj.Id);
    try {
      CZWTFCSubmissionJointEventExtension subjoint = new CZWTFCSubmissionJointEventExtension('Submission_OTP_Generated');
      subjoint.processJointApplicantNotifications(subPartyXref1);
    } catch (Exception ex) {
    }
    Test.stopTest();
  }

  @isTest
  public static void eventTest2() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;

    SubBrand__c subBrandObj = new SubBrand__c();
    subBrandObj.Brand__c = brandObj.Id;
    insert subBrandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Application__c appObj = new tffa__Application__c();
    appObj.tffa__Submission__c = sub.Id;
    appObj.tffa__Status__c = 'APPROVED';
    insert appObj;

    tffa__Application__c appObj2 = new tffa__Application__c();
    appObj2.tffa__Submission__c = sub.Id;
    appObj2.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj2.tffa__AutoKYCDecisionOutcome__c = 'APPROVED';
    insert appObj2;

    tffa__Application__c appObj6 = new tffa__Application__c();
    appObj6.tffa__Submission__c = sub.Id;
    appObj6.tffa__Status__c = 'FUNDED';
    appObj6.tffa__AutoKYCDecisionOutcome__c = 'APPROVED';
    insert appObj6;

    tffa__Application__c appObj7 = new tffa__Application__c();
    appObj7.tffa__Submission__c = sub.Id;
    appObj7.tffa__Status__c = 'FUNDED';
    appObj7.tffa__AutoKYCDecisionOutcome__c = 'DECLINED';
    appObj7.tffa__KYCDecisionOutcome__c = 'APPROVED';
    insert appObj7;

    tffa__Application__c appObj3 = new tffa__Application__c();
    appObj3.tffa__Submission__c = sub.Id;
    appObj3.tffa__Status__c = 'DECLINED';
    appObj3.tffa__AutoKYCDecisionOutcome__c = 'DECLINED';
    insert appObj3;

    tffa__Application__c appObj4 = new tffa__Application__c();
    appObj4.tffa__Submission__c = sub.Id;
    appObj4.tffa__Status__c = 'DECLINED';
    appObj4.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj4.tffa__KYCDecisionOutcome__c = 'DECLINED';
    insert appObj4;

    tffa__Application__c appObj5 = new tffa__Application__c();
    appObj5.tffa__Submission__c = sub.Id;
    appObj5.tffa__Status__c = 'ACCOUNT_OPENED';
    appObj5.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
    appObj5.tffa__KYCDecisionOutcome__c = 'APPROVED';
    insert appObj5;

    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';

    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;

    tffa__ApplicationPartyXref__c appPartyObj = new tffa__ApplicationPartyXref__c();
    appPartyObj.tffa__Party__c = partyObj.Id;
    appPartyObj.tffa__Application__c = appObj.Id;
    appPartyObj.tffa__Party__r = partyObj;
    appPartyObj.tffa__Type__c = 'INDIVIDUAL';
    appPartyObj.tffa__Primary__c = true;
    insert appPartyObj;

    // tffa__Application__c appObj3a = new tffa__Application__c();
    // appObj3a.tffa__Submission__c = sub.Id;
    // appObj3a.tffa__Status__c = 'Application_AccountOpened';
    // appObj3a.tffa__PartyXrefs__r=appPartyObj;
    // insert appObj3a;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c();
    subPartyXref.tffa__Submission__c = sub.Id;
    subPartyXref.tffa__Party__c = partyObj.Id;
    subPartyXref.tffa__Primary__c = true;
    subPartyXref.tffa__Party__r = partyObj;
    subPartyXref.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref;

    Test.startTest();

    new CZWTFCApplicationEventExtension().post(appObj2);
    new CZWTFCApplicationEventExtension().post(appObj);
    //new CZWTFCApplicationEventExtension().processApplicationDeclinedEvents(appObj3);
    new CZWTFCApplicationEventExtension().post(appObj3);
    new CZWTFCApplicationEventExtension().post(appObj4);
    new CZWTFCApplicationEventExtension().post(appObj5);
    new CZWTFCApplicationEventExtension().post(appObj6);
    new CZWTFCApplicationEventExtension().post(appObj7);
    Map<String, String> mp = CZWTFCApplicationEventExtension.prequalEventMap;
    CZWTFCPartyRepository.fetchPartyById(partyObj.Id);
    Test.stopTest();
  }

  @isTest
  public static void eventTest4() {
    Test.startTest();
    tffa__Party__c ob = new tffa__Party__c();
    tffa__Submission__c obj = new tffa__Submission__c();
    Map<String, Object> factsMap = new Map<String, Object>();

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;

    SubBrand__c subBrandObj = new SubBrand__c();
    subBrandObj.Brand__c = brandObj.Id;
    insert subBrandObj;

    ob.Name = 'MM';
    ob.tffa__PrimaryEmail__c = 'mm@gmail.com';
    ob.tffa__PrimaryPhone__c = '7030647671';
    ob.tffa__AdverseActionNoticeRequired__c = true;
    ob.tffa__FirstName__c = 'Mehul';
    ob.tffa__LastName__c = 'M';
    ob.tffa__BrandCode__c = '118';

    insert ob;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c();
    subPartyXref.tffa__Submission__c = sub.Id;
    subPartyXref.tffa__Party__c = ob.Id;
    subPartyXref.tffa__Primary__c = true;
    subPartyXref.tffa__Party__r = ob;
    subPartyXref.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref;

    new CZWTFCPartyEventExtension();
    new CZWTFCPartyEventExtension('Application_Declined_Adverse').post(obj);
    new CZWTFCPartyEventExtension('Application_Declined_Adverse').post(ob);
    Test.stopTest();
  }

  @isTest
  public static void eventTest5() {
    Test.startTest();
    tffa__Party__c ob = new tffa__Party__c();
    tffa__Stipulation__c obj = new tffa__Stipulation__c();
    tffa__Stipulation__c obj2 = new tffa__Stipulation__c();
    tffa__Stipulation__c obj3 = new tffa__Stipulation__c();
    List<tffa__Stipulation__c> stip1 = new List<tffa__Stipulation__c>();
    List<tffa__Stipulation__c> stip2 = new List<tffa__Stipulation__c>();
    List<tffa__Stipulation__c> stip3 = new List<tffa__Stipulation__c>();
    Map<String, Object> factsMap = new Map<String, Object>();

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Application__c app = new tffa__Application__c();
    //app.BrandCode__c = '118';
    app.tffa__Submission__c = sub.Id;
    insert app;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;

    SubBrand__c subBrandObj = new SubBrand__c();
    subBrandObj.Brand__c = brandObj.Id;
    insert subBrandObj;

    ob.Name = 'MM';
    ob.tffa__PrimaryEmail__c = 'mm@gmail.com';
    ob.tffa__PrimaryPhone__c = '7030647671';
    ob.tffa__AdverseActionNoticeRequired__c = true;
    ob.tffa__FirstName__c = 'Mehul';
    ob.tffa__LastName__c = 'M';
    ob.tffa__BrandCode__c = '118';

    insert ob;

    obj.tffa__Status__c = 'NEW';
    obj.tffa__Party__c = ob.id;
    obj.tffa__Application__c = app.Id;
    obj.tffa__Code__c = 'STDL';
    obj.tffa__Label__c = 'Please provide the documents for Driver License';
    insert obj;
    stip1.add(obj);
    obj2.tffa__Status__c = 'UPLOADED';
    obj2.tffa__Party__c = ob.id;
    obj2.tffa__Application__c = app.Id;
    obj2.tffa__Code__c = 'STDL';
    obj2.tffa__Label__c = 'Please provide the documents for Driver License';
    insert obj2;
    stip2.add(obj2);
    obj3.tffa__Status__c = 'REJECTED';
    obj3.tffa__Party__c = ob.id;
    obj3.tffa__Application__c = app.Id;
    obj3.tffa__Code__c = 'STDL';
    obj3.tffa__Label__c = 'Please provide the documents for Driver License';
    insert obj3;
    stip3.add(obj3);
    new CZWTFCStipulationEventExtension();
    new CZWTFCStipulationEventExtension('Stipulation_Created').post(stip1);
    new CZWTFCStipulationEventExtension('Stipulation_Created').post(stip2);
    new CZWTFCStipulationEventExtension('Stipulation_Created').post(stip3);
    new CZWTFCStipulationEventExtension('Stipulation_Created').post(ob);

    Test.stopTest();
  }

  @isTest
  static void eventManualFundingVerification() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__PrimaryEmail__c = 'wtfctestmailer@gmail.com';
    party.tffa__FirstName__c = 'SSANDRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    //party.tffa__Suffix__c = '246';
    insert party;
    lstParty.add(party);

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = true,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref;

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
    insert app;
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

    tffa__FundingRequest__c fundingRequest = new tffa__FundingRequest__c();
    fundingRequest.tffa__AccountType__c = 'CHECKING';
    fundingRequest.tffa__Amount__c = 100.0;
    fundingRequest.tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION';
    fundingRequest.tffa__LinkedApplication__c = app.Id;
    fundingRequest.tffa__Purpose__c = 'DEPOSIT';
    insert fundingRequest;

    Test.startTest();
    try {
      tffa__Submission__c subObj;
      tffa.Logger.debug('start of funding verification status event');
      subObj = FISCCIntegrationLogRepository.findSubmissionById(sub.Id);
      List<tffa__Application__c> appList = FISCCIntegrationLogRepository.findApplicationWithChildObjects(subObj.tffa__Applications__r);
      //System.debug(appList[0].tffa__LinkedFundingRequests__r);
      FISCCIntegrationLogService.triggerMailForManualFundingPending(sub.Id);
    } catch (Exception ex) {
      //System.debug('Exception : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
    }
    Test.stopTest();
  }
}