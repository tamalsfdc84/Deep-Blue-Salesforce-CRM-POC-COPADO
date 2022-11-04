/**
 * @description Repository/Utility class to create test data
 */
public with sharing class CZWTFCTestDataRepository {
  /**
   * Creates a submission (persisted)
   */
  public static tffa__Submission__c createSubmissionWithIndividualPartyAndCheckingApplication() {
    tffa__Submission__c sub = CZWTFCTestDataRepository.createSubmission();
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(sub);
    asm.addChildObject('Applications__r', CZWTFCTestDataRepository.createCheckingApplication());
    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Party__r = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    asm.addChildObject('tffa__PartyXrefs__r', xref);
    // put together
    sub = (tffa__Submission__c) asm.assemble();
    sub = tffa.SubmissionService.create(sub);
    return sub;
  }

  public static tffa__Submission__c createSubmission() {
    tffa__Submission__c submission = new tffa__Submission__c();
    submission.tffa__CreatedChannel__c = tffa.ChannelType.DIGITAL.name();
    submission.tffa__SubmittedChannel__c = tffa.ChannelType.DIGITAL.name();
    return submission;
  }

  public static tffa__Application__c createCheckingApplication() {
    tffa__Application__c application = new tffa__Application__c();
    application.tffa__ProductCategory__c = 'CHECKING';
    application.tffa__ProductCode__c = '801';
    return application;
  }

  public static tffa__DisclosureChecklist__c createDisclosureChecklist() {
    tffa__DisclosureChecklist__c cl = new tffa__DisclosureChecklist__c();
    cl.Name = 'Sign Document';
    cl.tffa__Channel__c = 'DIGITAL';
    cl.tffa__ProductCategory__c = 'CHECKING';
    cl.tffa__EventName__c = 'Submission_SignDocument';
    cl.tffa__Description__c = 'Sign Documents';
    tffa__Product__c p = createCheckingProduct();
    //p = tffa.ProductService.create(p);
    cl.tffa__Product__c = p.Id;
    cl.tffa__Description__c = 'Disclosure checklist for CHECKING products';
    return cl;
  }

  public static tffa__DisclosureItem__c createDisclosureItem() {
    tffa__DisclosureItem__c item = new tffa__DisclosureItem__c();
    item.Name = 'Signature Card';
    item.tffa__Label__c = 'Please review the ';
    item.tffa__ActionText__c = 'Signature Card';
    return item;
  }

  public static tffa__DisclosureTemplate__c createDisclosureTemplate() {
    tffa__DisclosureTemplate__c template = new tffa__DisclosureTemplate__c();
    template.Name = 'Signature Card';
    template.tffa__Description__c = 'Signature Card';
    template.tffa__Type__c = 'DOCUSIGN';
    template.tffa__Template__c = '74a966e1-e924-465b-89e0-cfb74f0aa004';
    template.tffa__DocumentName__c = 'SCardArgo';
    template.tffa__Locale__c = 'en-US';
    template.tffa__Code__c = 'DTACCTOPENING';
    return template;
  }

  public static tffa__Product__c createCheckingProduct() {
    tffa__Product__c product = new tffa__Product__c();
    product.tffa__Category__c = 'CHECKING';
    product.tffa__Code__c = '801';
    product.Name = 'Premier Checking';
    product.tffa__ImageUrl__c = 'flexible_business.png';
    product.tffa__Description__c = '&#10003 Interest Bearing Checking<br/><br/>&#10003 $100 Minimum Opening Deposit<br/><br/>&#10003 No Minimum Balance Requirement<br/><br/>&#10003 No Monthly Service Fee<br/><br/>&#10003 Checks are Optional<br/><br/>&#10003 No Charge at Bank ATMs';
    product.tffa__FullDescription__c = '&#10003 Interest Bearing Checking<br/><br/>&#10003 $100 Minimum Opening Deposit<br/><br/>&#10003 No Minimum Balance Requirement<br/><br/>&#10003 No Monthly Service Fee<br/><br/>&#10003 Checks are Optional<br/><br/>&#10003 No Charge at Bank ATMs';
    product = tffa.ProductService.create(product);
    return product;
  }

  // public static tffa__FundingRequest__c createFundingRequest() {
  //   tffa__FundingRequest__c fr = new tffa__FundingRequest__c();
  //   fr.tffa__AccountNumber__c = '1321324234';
  //   fr.tffa__Amount__c = 10000;
  //   fr.tffa__FinancialInstitution__c = 'WELLSFARGO';
  //   fr.tffa__AccountType__c = 'SAVINGS';
  //   fr.tffa__Type__c = 'ACH';
  //   fr.tffa__RoutingNumber__c = '121000248';
  //   fr.tffa__Status__c = 'FUNDED';
  //   return fr;
  // }

  public static tffa__Party__c createIndividualPartyWithChildObjects() {
    tffa__Party__c party = createIndividualParty();
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(party);
    asm.addChildObjects('tffa__AddressXrefs__r', createPartyAddressXrefs());
    asm.addChildObject('tffa__Employments__r', createEmployment());
    asm.addChildObject('tffa__Identifications__r', createIdentification());

    party = (tffa__Party__c) asm.assemble();
    return party;
  }

  public static tffa__Party__c createIndividualParty() {
    tffa__Party__c party = new tffa__Party__c();
    party.tffa__IsExistingCustomer__c = false;
    party.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    party.tffa__Citizenship__c = 'Citizen';
    party.tffa__DoNotCall__c = false;
    party.tffa__DoNotEmail__c = false;
    party.tffa__DoNotText__c = false;
    party.tffa__FirstName__c = 'Florence';
    party.tffa__LastName__c = 'May';
    party.tffa__MaritalStatus__c = 'Married';
    party.tffa__MiddleName__c = 'J';
    party.tffa__NationalIdentifierType__c = 'SSN';
    party.tffa__NationalIdentifierValue__c = '211232323';
    party.tffa__PreferredContactMethod__c = 'Phone';
    party.tffa__PoliticallyExposedPerson__c = false;
    party.tffa__PreferredLanguage__c = 'English';
    party.tffa__PreferredTimeToCall__c = 'Morning';
    party.tffa__Prefilled__c = false;
    party.tffa__Prefix__c = 'Mr';
    party.tffa__PrimaryEmailType__c = 'PRIMARY';
    party.tffa__PrimaryEmail__c = 'a@a.com';
    party.tffa__PrimaryPhoneType__c = 'HOME';
    party.tffa__PrimaryPhone__c = ' 131334234';
    party.tffa__FicoScore__c = 750;
    party.tffa__IsEmployee__c = false;
    party.tffa__NickName__c = 'Florence';
    party.tffa__SpousalVABenefitsEligibilityIndicator__c = false;
    party.tffa__Type__c = 'INDIVIDUAL';
    return party;
  }

  @SuppressWarnings('PMD.AvoidHardcodingId')
  public static tffa__Identification__c createIdentification() {
    tffa__Identification__c iden = new tffa__Identification__c();
    iden.tffa__Type__c = 'DL';
    iden.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden.tffa__ExpirationDate__c = Date.valueOf('2020-01-01');
    iden.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden.tffa__IdentificationNumber__c = '341234234';
    iden.tffa__IssueDate__c = Date.valueOf('1990-01-01');
    iden.tffa__IssuingCountry__c = 'US';
    iden.tffa__IssuingState__c = 'CA';
    return iden;
  }

  public static tffa__Employment__c createEmployment() {
    tffa__Employment__c emp = new tffa__Employment__c();
    emp.tffa__EmployerName__c = 'Audi';
    emp.tffa__Status__c = 'CURRENT';
    emp.tffa__Type__c = 'FULLTIME';
    emp.tffa__MonthlyIncome__c = 10000;
    emp.tffa__MonthsEmployed__c = 10;
    emp.tffa__Occupation__c = 'Automobiles';
    emp.tffa__StartDate__c = Date.valueOf('2017-01-01');
    emp.tffa__Title__c = 'Director';
    emp.tffa__YearsEmployed__c = 2;
    return emp;
  }

  public static List<tffa__PartyAddressXref__c> createPartyAddressXrefs() {
    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = createAddress();
    partyAddressXrefs.add(partyAddressXref0);
    return partyAddressXrefs;
  }

  public static tffa__Address__c createAddress() {
    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = ' ';
    address.tffa__State__c = 'CT';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    return address;
  }

  /***
   * @description This is to generate master key
   */
  public static void generateEnvironmentConfiguration() {
    String newKey = EncodingUtil.base64Encode(Crypto.generateAesKey(256));

    tffa__EnvironmentConfiguration__c config = tffa__EnvironmentConfiguration__c.getOrgDefaults();
    config.tffa__Key__c = newKey;
    config.tffa__SessionValidityDuration__c = 20;
    config.tffa__SessionIdleDuration__c = 18;
    config.tffa__SubmissionExpirationDuration__c = 4;
    config.tffa__SubmissionAbandonmentDuration__c = 60;
    config.tffa__MaxPreviousAddressCount__c = 1;
    config.tffa__MaxPreviousEmployerCount__c = 1;
    config.tffa__MaxBeneficiaryCount__c = 1;
    config.tffa__MaxOtherIncomeCount__c = 1;
    config.tffa__MaxIndividualApplicantCount__c = 1;
    config.tffa__MaxOrganizationApplicantCount__c = 1;
    if (tffa__EnvironmentConfiguration__c.SObjectType.getDescribe().isCreateable()) {
      insert config;
    }
    tffa__DebugLogConfiguration__c lconfig = tffa__DebugLogConfiguration__c.getOrgDefaults();
    lconfig.tffa__Enabled__c = true;
    lconfig.tffa__DatabaseLoggingLevel__c = 'DEBUG';
    if (
      tffa__DebugLogConfiguration__c.SObjectType.getDescribe().isCreateable() &&
      tffa__DebugLogConfiguration__c.SObjectType.getDescribe().isUpdateable()
    ) {
      upsert lconfig;
    }
  }

  @SuppressWarnings('PMD.AvoidProductionDebugLogs')
  public static void generateSystemLogs() {
    tffa.Logger.flush();
    if (!tffa__DebugLog__c.SObjectType.getDescribe().isAccessible()) {
      return;
    }
    List<tffa__DebugLog__c> dbLogs = [SELECT Id, tffa__Message__c FROM tffa__DebugLog__c];

    for (tffa__DebugLog__c log : dbLogs) {
    }
  }

  public static List<tffa__Party__c> createPartyWithChilds(Integer countOfParties) {
    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    for (Integer i = 1; i <= countOfParties; i++) {
      tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
      party.tffa__PrimaryEmail__c = i + party.tffa__PrimaryEmail__c;
      party.tffa__LastName__c = party.tffa__LastName__c + i;
      party.tffa__Type__c = 'INDIVIDUAL';
      party.tffa__NationalIdentifierValue__c = String.valueOf(800000000 + i);
      insert party;
      tffa.SObjectAssembler asm2 = new tffa.SObjectAssembler(party);
      asm2.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
      tffa__Employment__c objEmployment2 = new tffa__Employment__c();
      objEmployment2.OccupationType__c = '027';
      asm2.addChildObject('tffa__Employments__r', objEmployment2);

      tffa__Identification__c identity2 = new tffa__Identification__c();
      identity2.tffa__IdentificationNumber__c = 'K987667';
      identity2.tffa__Type__c = 'DL';
      identity2.tffa__IssuingState__c = 'CA';
      identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
      identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
      asm2.addChildObject('tffa__Identifications__r', identity2);

      CZPartyAlias__c aliasObj = new CZPartyAlias__c();
      aliasObj.Name = 'onee';
      aliasObj.AliasFirstName__c = 'Testttttt';
      aliasObj.AliasLastName__c = 'Testone';
      aliasObj.Party__c = party.Id;
      insert aliasObj;

      party.CZPartyAliases__r.add(aliasObj);
      asm2.addChildObject('CZPartyAliases__r', aliasObj);

      partyList.add((tffa__Party__c) asm2.assemble());
    }
    return partyList;
  }
  public static List<tffa__Application__c> createAppsWithChilds(Integer countOfApps) {
    List<tffa__Application__c> appList = new List<tffa__Application__c>();
    for (Integer j = 1; j <= countOfApps; j++) {
      tffa__Application__c application = new tffa__Application__c();
      application.tffa__ProductCategory__c = 'CHECKING';
      application.tffa__ProductCode__c = '8004';
      application.tffa__IsFundingCaptured__c = false;
      tffa__Product__c prod = new tffa__Product__c();
      prod.tffa__Category__c = 'CHECKING';
      prod.tffa__Code__c = '8004';
      prod.Name = 'Test';
      insert prod;
      application.tffa__Product__r = prod;

      appList.add(application);
    }
    return appList;
  }

  public static tffa__Submission__c getSubmissionForTest() {
    tffa__Submission__c sub = CZWTFCTestDataRepository.createSubmission();
    sub.tffa__Status__c = 'ABANDONED';
    sub.CZHearAboutUs__c = 'Email';
    sub.tffa__CreatedChannel__c = 'BRANCH';
    insert sub;

    tffa.SObjectAssembler asm1 = new tffa.SObjectAssembler(sub);

    List<tffa__Party__c> partyList = CZWTFCTestDataRepository.createPartyWithChilds(2);
    upsert partyList;
    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Primary__c = true;
    xref.tffa__IsPresent__c = true;
    xref.tffa__Party__r = partyList.get(0);
    xref.tffa__Party__c = partyList.get(0).Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__Submission__c = sub.Id;
    insert xref;
    asm1.addChildObject('tffa__PartyXrefs__r', xref);

    List<tffa__Application__c> appList = CZWTFCTestDataRepository.createAppsWithChilds(1);
    appList.get(0).tffa__Submission__c = sub.Id;
    insert appList;

    // tffa.SObjectAssembler asm3 = new tffa.SObjectAssembler(application);
    for (Integer i = 0; i < partyList.size(); i++) {
      tffa__ApplicationPartyXref__c appXref = new tffa__ApplicationPartyXref__c();
      appXref.tffa__Party__c = partyList.get(i).Id;
      appXref.tffa__Type__c = 'INDIVIDUAL';
      appXref.tffa__RoleCode__c = 'JOINT_OR';
      if (i == 0)
        appXref.tffa__Primary__c = true;
      appXref.tffa__Application__c = appList.get(0).Id;
      insert appXref;
    }
    //asm3.addChildObject('tffa__PartyXrefs__r', xref);
    //appList.add((tffa__Application__c) asm3.assemble());

    asm1.addChildObject('Applications__r', appList.get(0));

    sub = (tffa__Submission__c) asm1.assemble();
    //sub = tffa.SubmissionService.create(sub);
    return sub;
  }

 /* public static tffa__Submission__c createTestSubmission() {
    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '1234';
    prod2.Name = 'Test';
    insert prod2;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = createCheckingProduct();
    tffa__Application__c application = createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = ' ';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = address;
    partyAddressXrefs.add(partyAddressXref0);

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    jointParty = (tffa__Party__c) asmParty1.assemble();

    tffa__Address__c address1 = new tffa__Address__c();
    address1.tffa__Line1__c = '803 Ecostar';
    address1.tffa__Line2__c = ' ';
    address1.tffa__State__c = 'CT1';
    address1.tffa__City__c = 'Darien';
    address1.tffa__Country__c = 'US';
    address1.tffa__ZipCode__c = '06820-41';
    insert address1;

    List<tffa__PartyAddressXref__c> partyAddressXrefs1 = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref01 = new tffa__PartyAddressXref__c();
    partyAddressXref01.tffa__Type__c = 'HOME';
    partyAddressXref01.tffa__Preferred__c = true;
    partyAddressXref01.tffa__Address__r = address1;
    partyAddressXrefs1.add(partyAddressXref01);

    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__BrandCode__c = '118';
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__QualiFileStatus__c = 'PASSED';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    jointParty1.tffa__IDAStatus__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    jointParty1.tffa__Type__c = 'INDIVIDUAL';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty12 = new tffa.SObjectAssembler(jointParty1);
    asmParty12.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs1);
    jointParty1 = (tffa__Party__c) asmParty12.assemble();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__ApplicationPartyXref__c appParty = new tffa__ApplicationPartyXref__c();
    appParty.Name = 'User';
    appParty.tffa__Party__c = partyObj.Id;
    appParty.tffa__Application__c = application.Id;
    appParty.tffa__Primary__c = true;
    appParty.tffa__Type__c = 'INDIVIDUAL';
    insert appParty;

    tffa__SubmissionPartyXref__c xref12 = new tffa__SubmissionPartyXref__c();
    xref12.tffa__Submission__c = submissionObj.id;
    xref12.tffa__Party__r = jointParty1;
    xref12.Name = 'TEst';
    xref12.tffa__IsPresent__c = true;
    xref12.tffa__Primary__c = true;
    xref12.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    return submissionObj;
  }*/

  public static tffa__Party__c createTestPartyWithXrefs() {
    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__LegalName__c = 'John';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.Customer_Number__c = '2324356';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    insert jointParty;

    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__BrandCode__c = '118';
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__QualiFileStatus__c = 'PASSED';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    jointParty1.tffa__IDAStatus__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    jointParty1.Customer_Number__c = '2324356';
    jointParty1.tffa__Type__c = 'INDIVIDUAL';

    insert jointParty1;

    tffa__ApplicantRole__c appRole = new tffa__ApplicantRole__c();
    appRole.Name = 'AUTHORIZED SIGNER';
    appRole.tffa__Category__c = 'SIGNER';
    appRole.tffa__Code__c = 'AUTHORIZEDSIGNER';
    appRole.tffa__Label__c = 'AUTHORIZED SIGNER';
    appRole.CZFISRelationshipCode__c = '124';
    insert appRole;

    tffa__PartyRelationCode__c partyrelnCode = new tffa__PartyRelationCode__c();
    partyrelnCode.CZToRelnCode__c = '203';
    partyrelnCode.tffa__Category__c = 'BUSINESS';
    partyrelnCode.tffa__Label__c = 'Beneficial Owner and Controlling Party';
    partyrelnCode.tffa__PartyType__c = 'INDIVIDUAL';
    partyrelnCode.tffa__RelatedPartyType__c = 'INDIVIDUAL';
    partyrelnCode.tffa__SortOrder__c = 99;
    partyrelnCode.tffa__Value__c = '201';
    insert partyrelnCode;

    tffa__PartyPartyXref__c partyPartyXrefObj = new tffa__PartyPartyXref__c();
    partyPartyXrefObj.Name = 'Beneficial Owner and Controlling Party';
    partyPartyXrefObj.tffa__OwnershipPercentage__c = 50;
    partyPartyXrefObj.tffa__Party__c = jointParty.Id;
    partyPartyXrefObj.tffa__RelatedParty__c = jointParty1.Id;
    partyPartyXrefObj.tffa__RelationCategory__c = 'BUSINESS';
    partyPartyXrefObj.tffa__RelationCode__c = partyrelnCode.Id;
    partyPartyXrefObj.tffa__RelationCodeValue__c = '203';
    partyPartyXrefObj.tffa__Title__c = 'CEO';
    insert partyPartyXrefObj;

    jointParty = FISCCIntegrationLogRepository.findPartydWithChildObjects(new List<Id>{ jointParty.Id })[0];
    return jointParty;
  }

  public static void setTestIntegrationLog(String subId) {
    FISCCIntegrationLogService.setSubmissionObj(subId);
    FISCCIntegrationLogService.setIntegrationLog(subId);
    FISCCIntegrationLogService.setCurrentLog('TEST');
    FISCCIntegrationLogService.setCurrentLogItem('TEST', 'TEST', true);
    FISCCIntegrationLogService.setPartyObjs();
  }
}