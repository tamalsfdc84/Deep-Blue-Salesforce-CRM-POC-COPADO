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
}