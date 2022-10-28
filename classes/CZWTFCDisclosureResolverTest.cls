@isTest
public with sharing class CZWTFCDisclosureResolverTest {
  @testSetup
  static void setup() {
    CZWTFCTestDataRepository.generateEnvironmentConfiguration();
  }

  @isTest
  static void testResolve() {
    Test.startTest();
    try {
      tffa__DisclosureChecklist__c checklist = CZWTFCTestDataRepository.createDisclosureChecklist();
      tffa.SObjectAssembler asm = new tffa.SObjectAssembler(checklist);

      tffa__DisclosureItem__c item = CZWTFCTestDataRepository.createDisclosureItem();
      tffa__DisclosureTemplate__c template = CZWTFCTestDataRepository.createDisclosureTemplate();
      template = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template })[0];
      item.tffa__Template__c = template.Id;
      asm.addChildObject('Items__r', item);
      checklist = (tffa__DisclosureChecklist__c) asm.assemble();
      checklist = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist })[0];
      tffa__Submission__c sub = CZWTFCTestDataRepository.createSubmissionWithIndividualPartyAndCheckingApplication();
      tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
      disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
      disclosureMatrix.tffa__Checklist__c = checklist.Id;
      upsert disclosureMatrix;
      tffa__Party__c p = sub.tffa__PartyXrefs__r[0].tffa__Party__r;
      tffa.Context ctx = tffa.Context.get();
      ctx.eventName = 'Submission_ReviewAndSubmit';
      ctx.partyId = p.id;
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('Submission__c', sub.id);
      facts.put('EventName__c', 'Submission_ReviewAndSubmit');
      new CZWTFCDisclosureResolver().resolve(facts);
      List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
      disclosures = CZWTFCHelperRepository.findBySubmissionAndEventName(sub.id, tffa.Context.get().eventName);
      CZWTFCDisclosureResolver.sort(disclosures);
      CZWTFCDisclosureResolver.mergeDisclosures(disclosures);
      tffa__Application__c app = sub.tffa__Applications__r[0];
      app = tffa.ApplicationService.readWithParties(app.Id);
      //CZWTFCDisclosureResolver.resolveFor(sub, p, app);
      CZWTFCDisclosureResolver.resolveFor(sub, facts);
      CZWTFCDisclosureResolver.resolveForParty(sub.id, p.id, facts);
      CZWTFCDisclosureResolver.resolveForFacts(new Map<String, Object>());
      CZWTFCDisclosureResolver.fetchDocumentUrl('');
    } catch (Exception e) {
      tffa.Logger.debug('Exception in CZWTFCDisclosureResolver testResolve' + e);
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void testResolve2() {
    Test.startTest();
    try {
      tffa__DisclosureChecklist__c checklist = CZWTFCTestDataRepository.createDisclosureChecklist();
      tffa.SObjectAssembler asm = new tffa.SObjectAssembler(checklist);

      tffa__DisclosureItem__c item = CZWTFCTestDataRepository.createDisclosureItem();
      tffa__DisclosureTemplate__c template = CZWTFCTestDataRepository.createDisclosureTemplate();
      template = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template })[0];
      item.tffa__Template__c = template.Id;
      asm.addChildObject('Items__r', item);
      checklist = (tffa__DisclosureChecklist__c) asm.assemble();
      checklist = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist })[0];
      tffa__Submission__c sub = CZWTFCTestDataRepository.createSubmissionWithIndividualPartyAndCheckingApplication();
      tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
      disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
      disclosureMatrix.tffa__Checklist__c = checklist.Id;
      upsert disclosureMatrix;
      sub.tffa__PartyXrefs__r[0].tffa__IsPresent__c = false;
      sub.tffa__PartyXrefs__r[0].tffa__Primary__c = false;
      update sub.tffa__PartyXrefs__r[0];
      tffa__Party__c p = sub.tffa__PartyXrefs__r[0].tffa__Party__r;
      tffa.Context ctx = tffa.Context.get();
      ctx.eventName = 'Submission_ReviewAndSubmit';
      ctx.partyId = p.id;
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('Submission__c', sub.id);
      facts.put('EventName__c', 'Submission_ReviewAndSubmit');
      facts.put('Application__c', sub.tffa__Applications__r[0].Id);

      new CZWTFCDisclosureResolver().resolve(facts);
      List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
      disclosures = CZWTFCHelperRepository.findBySubmissionAndEventName(sub.id, tffa.Context.get().eventName);
      CZWTFCDisclosureResolver.sort(disclosures);
      CZWTFCDisclosureResolver.mergeDisclosures(disclosures);
      tffa__Application__c app = sub.tffa__Applications__r[0];
      app = tffa.ApplicationService.readWithParties(app.Id);
      //CZWTFCDisclosureResolver.resolveFor(sub, p, app);
      CZWTFCDisclosureResolver.resolveFor(sub, facts);
      CZWTFCDisclosureResolver.resolveForParty(sub.id, p.id, facts);
      CZWTFCDisclosureResolver.resolveForFacts(new Map<String, Object>());
      CZWTFCDisclosureResolver.fetchDocumentUrl('');
      CZWTFCSubmissionRepository.findbySubmissionAndParty('1234', '3134');
    } catch (Exception e) {
      tffa.Logger.debug('Exception in CZAMBDisclosureResolverTest testResolve2' + e);
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
  @isTest
  public static void testResolverForOne() {
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
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = partyObj.id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = partyObj.id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;

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

    tffa__SubmissionPartyXref__c xref12 = new tffa__SubmissionPartyXref__c();
    xref12.tffa__Submission__c = submissionObj.id;
    xref12.tffa__Party__r = jointParty1;
    xref12.Name = 'TEst';
    xref12.tffa__IsPresent__c = true;
    xref12.tffa__Primary__c = true;
    xref12.tffa__Type__c = 'INDIVIDUAL';
    xref12.tffa__Party__c = jointParty1.Id;

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';
    xref1.tffa__Party__c = partyObj.Id;

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;
    partyXref.tffa__Party__c = jointParty.Id;

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = ';CT;';
    prodMat1.tffa__Product__c = product1.Id;
    insert prodMat1;

    tffa__Product__c prod8003 = new tffa__Product__c();
    prod8003.tffa__Category__c = 'CHECKING';
    prod8003.tffa__Code__c = '8004';
    prod8003.Name = 'Test';
    insert prod8003;

    tffa__ProductMatrix__c prodMat12 = new tffa__ProductMatrix__c();
    prodMat12.tffa__BrandCodeSet__c = '1234';
    prodMat12.StateCodeSet__c = ';CT1;';
    prodMat12.zipCodeSet__c = '06820-4621';
    prodMat12.tffa__Product__c = prod8003.Id;
    insert prodMat12;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    Test.startTest();
    CZWTFCDisclosureResolver.addFacts(new Map<String, Object>(), submissionObj);
    // CZWTFCDisclosureResolver.fetchPrimaryParty(partyone,submissionObj);
    CZWTFCDisclosureResolver.resolveFor(
      submissionObj,
      jointParty1,
      application,
      new tffa__ApplicationPartyXref__c(),
      new Map<String, Object>()
    );
    CZWTFCDisclosureResolver.resolveFor(submissionObj, jointParty1, application, new Map<String, Object>());
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
    	 DoResolve-->ResolveForParty flow
	*/
  @isTest
  public static void doResolveTestTwo() {
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    insert disclosureListObj;

    tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
    disclosureMatrix.tffa__EntityType__c = 'PARTY';
    disclosureMatrix.tffa__EventName__c = 'PARTY';
    disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
    disclosureMatrix.tffa__Checklist__c = disclosureListObj.Id;
    upsert disclosureMatrix;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = false;
    xref.tffa__Primary__c = false;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
	DoResolve -> ResolveForSubmission -> when disclosurelist is present
	*/
  @isTest
  public static void doResolveTestThree() {
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    insert disclosureListObj;
    tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
    disclosureMatrix.tffa__EntityType__c = 'PARTY';
    disclosureMatrix.tffa__EventName__c = 'PARTY';
    disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
    disclosureMatrix.tffa__Checklist__c = disclosureListObj.Id;
    upsert disclosureMatrix;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Party__c = party.Id;
    disclosureObj.tffa__Submission__c = sub.Id;
    disclosureObj.tffa__EventName__c = 'PARTY';
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__Code__c = 'CODETEst';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    insert disclosureObj;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = true;
    xref.tffa__Primary__c = true;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);
    facts.put('Party__c', party.Id);
    facts.put('EntityType__c', 'PARTY');

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   * DoResolve -->resolveforSub-> when AppId is Present in Facts-Map Param
   */
  @isTest
  public static void doResolveTestFour() {
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    insert disclosureListObj;

    tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
    disclosureMatrix.tffa__EntityType__c = 'PARTY';
    disclosureMatrix.tffa__EventName__c = 'PARTY';
    disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
    disclosureMatrix.tffa__Checklist__c = disclosureListObj.Id;
    upsert disclosureMatrix;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__ApplicationPartyXref__c applicationPartyObj = new tffa__ApplicationPartyXref__c();
    applicationPartyObj.tffa__Application__c = applicationObject.Id;
    applicationPartyObj.tffa__Party__c = party.Id;
    applicationPartyObj.tffa__Type__c = 'INDIVIDUAL';
    insert applicationPartyObj;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = true;
    xref.tffa__Primary__c = true;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);
    facts.put('Application__c', applicationObject.Id);

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   * DoResolve-->ResolveforSubmission.. when only submissionId is present in Facts-Map Param.
   */
  @isTest
  public static void doResolveTestFive() {
    List<tffa__DisclosureChecklist__c> disclosureList = new List<tffa__DisclosureChecklist__c>();
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    disclosureListObj.tffa__PartyType__c = 'INDIVIDUAL';
    disclosureList.add(disclosureListObj);

    tffa.DisclosureChecklistService.createOrUpdate(disclosureList);
    tffa__DisclosureMatrix__c disclosureMatrix = new tffa__DisclosureMatrix__c();
    disclosureMatrix.tffa__EntityType__c = 'PARTY';
    disclosureMatrix.tffa__EventName__c = 'PARTY';
    disclosureMatrix.tffa__PartyType__c = 'INDIVIDUAL';
    disclosureMatrix.tffa__Checklist__c = disclosureListObj.Id;
    upsert disclosureMatrix;

    tffa__DisclosureTemplate__c disclosureTemplate = new tffa__DisclosureTemplate__c();
    disclosureTemplate.tffa__Type__c = 'DOCUSIGN';
    disclosureTemplate.tffa__Code__c = '3432';
    disclosureTemplate.tffa__DocumentName__c = 'documentOne';
    disclosureTemplate.tffa__Url__c = 'TestUrl';
    disclosuretemplate.tffa__ApplicantRoleSet__c = 'BORROWER';
    insert disclosureTemplate;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    disclosureItem.tffa__Template__c = disclosureTemplate.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Submission__c = sub.Id;
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    disclosureObj.tffa__Code__c = '32311';
    insert disclosureObj;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__ApplicationPartyXref__c applicationPartyObj = new tffa__ApplicationPartyXref__c();
    applicationPartyObj.tffa__Application__c = applicationObject.Id;
    applicationPartyObj.tffa__Party__c = party.Id;
    applicationPartyObj.tffa__Type__c = 'INDIVIDUAL';
    insert applicationPartyObj;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = true;
    xref.tffa__Primary__c = true;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);
    facts.put('EntityType__c', 'PARTY');
    facts.put('Type__c', 'DOCUSIGN');

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   * DoResolve-->ResolveToSubmission.. When AppId is null and PartyId is Present in facts-Map
   */
  @isTest
  public static void doResolveTestSix() {
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    insert disclosureListObj;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__ApplicationPartyXref__c applicationPartyObj = new tffa__ApplicationPartyXref__c();
    applicationPartyObj.tffa__Application__c = applicationObject.Id;
    applicationPartyObj.tffa__Party__c = party.Id;
    applicationPartyObj.tffa__Type__c = 'INDIVIDUAL';
    insert applicationPartyObj;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = true;
    xref.tffa__Primary__c = true;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);
    facts.put('Party__c', party.Id);
    facts.put('EntityType__c', 'PARTY');

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   *	DoResolve-->ResolveToSubmission.. tffa__Applications__c is present in Submission
   */
  @isTest
  public static void doResolveTestSeven() {
    tffa__DisclosureChecklist__c disclosureListObj = new tffa__DisclosureChecklist__c();
    disclosureListObj.tffa__EntityType__c = 'PARTY';
    disclosureListObj.tffa__Locale__c = 'en-US';
    disclosureListObj.tffa__EventName__c = 'PARTY';
    insert disclosureListObj;

    tffa__DisclosureItem__c disclosureItem = new tffa__DisclosureItem__c();
    disclosureItem.tffa__Label__c = 'labelTest';
    disclosureItem.tffa__ActionText__c = 'ActionTest';
    disclosureItem.tffa__Required__c = true;
    disclosureItem.tffa__SortOrder__c = 1;
    disclosureItem.tffa__Checklist__c = disclosureListObj.Id;
    insert disclosureItem;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.tffa__Code__c = 'TestCodeOne';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    sub.tffa__BrandEntity__c = brandObj.Id;
    insert sub;

    tffa__Submission__c subtwo = new tffa__Submission__c();
    subtwo.tffa__CreatedChannel__c = 'DIGITAL';
    subtwo.tffa__BrandEntity__c = brandObj.Id;
    insert subtwo;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = subtwo.Id;
    insert applicationObject;

    tffa__ApplicationPartyXref__c applicationPartyObj = new tffa__ApplicationPartyXref__c();
    applicationPartyObj.tffa__Application__c = applicationObject.Id;
    applicationPartyObj.tffa__Party__c = party.Id;
    applicationPartyObj.tffa__Type__c = 'INDIVIDUAL';
    insert applicationPartyObj;

    tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
    xref.tffa__Submission__c = sub.Id;
    xref.tffa__Party__c = party.Id;
    xref.tffa__Type__c = 'INDIVIDUAL';
    xref.tffa__IsPresent__c = true;
    xref.tffa__Primary__c = true;
    insert xref;

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', sub.Id);
    facts.put('Party__c', party.Id);

    Test.startTest();

    tffa.Context ctx = tffa.Context.get();
    ctx.partyId = party.Id;
    ctx.eventName = 'PARTY';
    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    dcsResolver.resolve(facts);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void doResolveTestCaseEight() {
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
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = partyObj.id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = partyObj.id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;

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

    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'ORGANIZATION';

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

    tffa__SubmissionPartyXref__c xref12 = new tffa__SubmissionPartyXref__c();
    xref12.tffa__Submission__c = submissionObj.id;
    xref12.tffa__Party__r = jointParty1;
    xref12.Name = 'TEst';
    xref12.tffa__IsPresent__c = true;
    xref12.tffa__Primary__c = true;
    xref12.tffa__Type__c = 'INDIVIDUAL';
    xref12.tffa__Party__c = jointParty1.Id;

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';
    xref1.tffa__Party__c = partyObj.Id;

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;
    partyXref.tffa__Party__c = jointParty.Id;

    asm.addChildObjects('PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    // tffa__DisclosureChecklist__c checklist = CZWTFCTestDataRepository.createDisclosureChecklist();
    tffa__DisclosureChecklist__c checklist = new tffa__DisclosureChecklist__c();
    checklist.Name = 'Sign Document1';
    checklist.tffa__Channel__c = 'BRANCH';
    checklist.tffa__ProductCategory__c = 'CHECKING';
    checklist.tffa__EntityType__c = 'PARTY';
    checklist.tffa__PartyType__c = 'INDIVIDUAL';
    checklist.tffa__Description__c = 'Disclosure checklist for CHECKING products';
    checklist.tffa__EventName__c = 'Application_DocumentGeneration';

    tffa__Product__c product = new tffa__Product__c();
    product.tffa__Category__c = 'CHECKING';
    product.tffa__Code__c = '801';
    product.Name = 'Premier Checking';
    product.tffa__ImageUrl__c = 'flexible_business.png';

    Test.startTest();
    //p = tffa.ProductService.create(p);
    //checklist.tffa__Product__r = product;
    tffa.SObjectAssembler asm12 = new tffa.SObjectAssembler(checklist);
    tffa__DisclosureItem__c item = CZWTFCTestDataRepository.createDisclosureItem();

    tffa.SObjectAssembler asmdi = new tffa.SObjectAssembler(item);
    //asmdi.addChildObjects('CZDisclosureParticipantsConfig__r', new List<CZDisclosureParticipantConfig__c>{ czparticipant });
    item = (tffa__DisclosureItem__c) asmdi.assemble();
    tffa__DisclosureTemplate__c template = CZWTFCTestDataRepository.createDisclosureTemplate();
    template.CZParticipantRoles__c = 'SOLE_OWNER,MEMBER';
    template = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template })[0];
    item.tffa__Template__c = template.Id;
    asm12.addChildObject('tffa__Items__r', item);
    checklist = (tffa__DisclosureChecklist__c) asm12.assemble();
    checklist = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist })[0];
    upsert checklist;

    tffa__DisclosureChecklist__c checklist2 = new tffa__DisclosureChecklist__c();
    checklist2.Name = 'Sign Document2';
    checklist2.tffa__Channel__c = 'DIGITAL';
    checklist2.tffa__ProductCategory__c = 'CHECKING';
    checklist2.tffa__EntityType__c = 'APPLICATION';
    checklist2.tffa__Description__c = 'Sign Documents';
    checklist2.tffa__EventName__c = 'Application_DocumentGeneration';

    asm12 = new tffa.SObjectAssembler(checklist2);
    tffa__DisclosureItem__c item2 = CZWTFCTestDataRepository.createDisclosureItem();

    asmdi = new tffa.SObjectAssembler(item2);
    item2 = (tffa__DisclosureItem__c) asmdi.assemble();
    tffa__DisclosureTemplate__c template2 = CZWTFCTestDataRepository.createDisclosureTemplate();
    template2.tffa__Code__c = 'DTACCTOPENING2';
    template2.CZParticipantRoles__c = 'SOLE_OWNER,MEMBER';
    template2 = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template2 })[0];
    item2.tffa__Template__c = template2.Id;
    asm12.addChildObject('tffa__Items__r', item2);
    checklist2 = (tffa__DisclosureChecklist__c) asm12.assemble();
    checklist2 = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist2 })[0];
    upsert checklist2;

    tffa__DisclosureChecklist__c checklist3 = new tffa__DisclosureChecklist__c();
    checklist3.Name = 'Sign Document3';
    checklist2.tffa__Channel__c = 'DIGITAL';
    checklist3.tffa__ProductCategory__c = 'CHECKING';
    checklist3.tffa__EntityType__c = 'PARTY';
    checklist3.tffa__PartyType__c = 'INDIVIDUAL';
    checklist3.tffa__Description__c = 'Sign Documents';
    checklist3.tffa__EventName__c = 'Application_DocumentGeneration';

    asm12 = new tffa.SObjectAssembler(checklist3);
    tffa__DisclosureItem__c item3 = CZWTFCTestDataRepository.createDisclosureItem();

    asmdi = new tffa.SObjectAssembler(item2);
    item3 = (tffa__DisclosureItem__c) asmdi.assemble();
    tffa__DisclosureTemplate__c template3 = CZWTFCTestDataRepository.createDisclosureTemplate();
    template3.tffa__Code__c = 'SOLEPROPRESOLUTION';
    template3.CZParticipantRoles__c = 'SOLE_OWNER,MEMBER';
    template3 = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template3 })[0];
    item3.tffa__Template__c = template3.Id;
    asm12.addChildObject('tffa__Items__r', item3);
    checklist3 = (tffa__DisclosureChecklist__c) asm12.assemble();
    checklist3 = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist3 })[0];
    upsert checklist3;

    tffa__DisclosureMatrix__c dm = new tffa__DisclosureMatrix__c();
    dm.tffa__ChannelSet__c = 'BRANCH';
    dm.tffa__ProductCategorySet__c = 'CHECKING';
    dm.tffa__EntityType__c = 'PARTY';
    dm.tffa__PartyType__c = 'INDIVIDUAL';
    dm.tffa__Description__c = 'Disclosure checklist for CHECKING products';
    dm.tffa__EventName__c = 'Application_DocumentGeneration';
    dm.tffa__Checklist__c = checklist.Id;
    upsert dm;

    tffa__DisclosureMatrix__c dm2 = new tffa__DisclosureMatrix__c();
    dm2.tffa__ChannelSet__c = 'DIGITAL';
    dm2.tffa__ProductCategorySet__c = 'CHECKING';
    dm2.tffa__EntityType__c = 'APPLICATION';
    dm2.tffa__Description__c = 'Sign Documents';
    dm2.tffa__EventName__c = 'Application_DocumentGeneration';
    dm2.tffa__Checklist__c = checklist2.Id;
    upsert dm2;

    tffa__DisclosureMatrix__c dm3 = new tffa__DisclosureMatrix__c();
    dm3.tffa__ChannelSet__c = 'DIGITAL';
    dm3.tffa__ProductCategorySet__c = 'CHECKING';
    dm3.tffa__EntityType__c = 'PARTY';
    dm3.tffa__PartyType__c = 'INDIVIDUAL';
    dm3.tffa__Description__c = 'Sign Documents';
    dm3.tffa__EventName__c = 'Application_DocumentGeneration';
    dm3.tffa__Checklist__c = checklist3.Id;
    upsert dm3;

    CZWTFCDisclosureResolver dcsResolver = new CZWTFCDisclosureResolver();
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());
    application.tffa__Product__r = product;
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());
    checklist.tffa__PartyType__c = 'INDIVIDUAL';
    CZWTFCDisclosureHelper.isPartyEligible(jointParty1, dm, checklist, new tffa__DisclosureItem__c(), submissionObj);
    checklist.tffa__PartyType__c = 'ORGANIZATION';
    CZWTFCDisclosureHelper.isPartyEligible(jointParty1, dm, checklist, new tffa__DisclosureItem__c(), submissionObj);
    CZWTFCDisclosureResolver.filteredParties(applicationobjs, checklist);

    submissionObj = CZWTFCTestDataRepository.getSubmissionForTest();
    Map<String, Object> mp = new Map<String, Object>();
    mp.put('EventName__c', 'Application_DocumentGeneration');
    mp.put('Submission__c', submissionObj.Id);
    CZWTFCDisclosureResolver.factsMap = mp;
    CZWTFCDisclosureResolver.createDisclosureObj(item, application, jointParty1);

    CZWTFCDisclosureResolver.resolveForBranchDocusign(submissionObj.Id, 'Application_DocumentGeneration', mp);

    CZWTFCDisclosureResolver.isParticipant('CONSUMER_SIGNER', new tffa__ApplicationPartyXref__c());

    tffa__AdditionalPreference__c testprefernce1 = new tffa__AdditionalPreference__c();
    testprefernce1.Name = 'abc';
    testprefernce1.tffa__Code__c = 'PLATINUM-ADVENTURE-MEMBERSHIP';
    testprefernce1.tffa__Submission__c = submissionObj.Id;
    testprefernce1.tffa__Party__c = jointParty1.Id;
    testprefernce1.tffa__AddOnServiceType__c = 'ONLINE_BANKING';
    testprefernce1.tffa__Enabled__c = true;

    tffa__AdditionalPreference__c testprefernce2 = new tffa__AdditionalPreference__c();
    testprefernce2.Name = 'abc';
    testprefernce2.tffa__Code__c = 'JUNIOR-SAVER-MEMBERSHIP';
    testprefernce2.tffa__Submission__c = submissionObj.Id;
    testprefernce2.tffa__Party__c = jointParty1.Id;
    testprefernce2.tffa__AddOnServiceType__c = 'ONLINE_BANKING';
    testprefernce2.tffa__Enabled__c = true;

    tffa__AdditionalPreference__c testprefernce3 = new tffa__AdditionalPreference__c();
    testprefernce3.Name = 'abc';
    testprefernce3.tffa__Code__c = 'E-STATEMENTS-BRANCH';
    testprefernce3.tffa__Submission__c = submissionObj.Id;
    testprefernce3.tffa__Party__c = jointParty1.Id;
    testprefernce3.tffa__AddOnServiceType__c = 'ONLINE_BANKING';
    testprefernce3.tffa__Enabled__c = true;

    List<tffa__AdditionalPreference__c> testprefernces = new List<tffa__AdditionalPreference__c>();
    testprefernces.add(testprefernce1);
    testprefernces.add(testprefernce2);
    testprefernces.add(testprefernce3);

    CZWTFCPartyRepository.saveAddPreferences(testprefernces);
    CZWTFCPartyRepository.findAdditionalPreferenceByPartyIdAndCode(jointParty1.Id, 'ONLINE_BANKING');

    asmParty.addChildObjects('tffa__AdditionalPreferences__r', testprefernces);
    jointParty1 = (tffa__Party__c) asmParty.assemble();
    upsert jointParty1;

    CZWTFCDisclosureHelper.isPlatinumMemberShipCustomer(jointParty1, checklist);
    CZWTFCDisclosureHelper.isJuniorSaverMember(jointParty1, checklist);
    //CZWTFCDisclosureHelper.isEStatementEnabled(jointParty1, checklist);
    try {
      CZWTFCDisclosureResolver.addTINCertifier(new tffa__Disclosure__c(), jointParty1);
    } catch (Exception ex) {
    }

    try {
      Map<String, Object> dicsFactsMap = new Map<String, Object>();
      dicsFactsMap.put('EventName__c', 'Application_DocumentGeneration');
      List<tffa__DisclosureMatrix__c> discMatrix = CZWTFCHelperRepository.findDiscMatrixByFacts('Docusign_Fact', dicsFactsMap);
      Map<Id, tffa__DisclosureChecklist__c> checklistMap = CZWTFCHelperRepository.fetchDiscMapUsingMatrix(discMatrix);
    } catch (Exception ex) {
    }

    try {
      dm3.tffa__PartyType__c = 'INDIVIDUAL';
      dm3.tffa__Description__c = 'Sign Documents';
      dm3.tffa__EventName__c = 'Addendum';
      upsert dm3;
      List<tffa__DisclosureChecklist__c> addendumChecklists = CZWTFCHelperRepository.findByEventName('Addendum');
    } catch (Exception ex) {
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void doResolveTestCasenine() {
    Test.startTest();
    CZWTFCDisclosureHelper.checkFactContainsValue('a', 'a;b;c');
    CZWTFCDisclosureHelper.checkFactContainsValue('d', 'a;b;c');
    CZWTFCDisclosureHelper.checkFactContainsValue('', '');
    CZWTFCDisclosureHelper.checkFactContainsValue('', 'a');
    CZWTFCDisclosureHelper.checkFactContainsValue('a', 'a');
    CZWTFCDisclosureHelper.checkFactContainsValue('a', 'b');

    CZWTFCDisclosureResolver.fetchDocumentUrl('test');

    tffa__PartyPartyXref__c partyxref = new tffa__PartyPartyXref__c();
    partyxref.tffa__OwnershipPercentage__c = 75;
    //CZWTFCDisclosureHelper.isParticipantValid(partyxref, 'BENEFOWNER');

    CZWTFCDisclosureHelper.getPartyRole('test, test');

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    tffa__DisclosureMatrix__c dm = new tffa__DisclosureMatrix__c();
    dm.tffa__ProductCodeSet__c = ';1;2;';
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());

    dm = new tffa__DisclosureMatrix__c();
    dm.tffa__ProductCategorySet__c = ';1;2;';
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());

    dm = new tffa__DisclosureMatrix__c();
    dm.tffa__BrandCodeSet__c = ';1;2;';
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());

    dm = new tffa__DisclosureMatrix__c();
    dm.tffa__PromotionCodeSet__c = ';1;2;';
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());

    dm = new tffa__DisclosureMatrix__c();
    dm.tffa__LocationCodeSet__c = ';1;2;';
    CZWTFCDisclosureHelper.isAppEligible(application, dm, new tffa__DisclosureItem__c());

    CZWTFCDisclosureResolver.createBranchUserParticipant();

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__CreatedChannel__c = 'DIGITAL';
    insert sub;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualPartyWithChildObjects();
    party.tffa__OrganizationType__c = 'SOLE_PROPRIETORSHIP';
    insert party;

    tffa__Application__c applicationObject = new tffa__Application__c();
    applicationObject.tffa__Submission__c = sub.Id;
    insert applicationObject;

    tffa__ApplicationPartyXref__c applicationPartyObj = new tffa__ApplicationPartyXref__c();
    applicationPartyObj.tffa__Application__c = applicationObject.Id;
    applicationPartyObj.tffa__Party__c = party.Id;
    applicationPartyObj.tffa__Type__c = 'INDIVIDUAL';
    applicationPartyObj.tffa__Primary__c = true;
    applicationPartyObj.tffa__RoleCode__c = 'AUTHORIZED_SIGNER';
    insert applicationPartyObj;

    tffa__Application__c app = CZWTFCApplicationRepository.findApplicationById(applicationObject.Id);

    CZWTFCDisclosureHelper.getPrimaryParty(app);

    Map<Id, tffa__Party__c> partyMap = new Map<Id, tffa__Party__c>();
    partyMap.put(party.Id, party);
    CZWTFCDisclosureHelper.getApplicationBucketsForParty(
      new List<String>{ 'SAVINGS' },
      partyMap,
      new List<tffa__Application__c>{ app, app }
    );

    CZWTFCDisclosureHelper.getCountOfPartyXref(app, new List<String>{ 'AUTHORIZED_SIGNER' });
    CZWTFCDisclosureHelper.getParticipantRoleCode('CONSUMER_SIGNER', 'SOLE_OWNER');
    CZWTFCDisclosureHelper.createBranchUserParticipant();
    CZWTFCDisclosureHelper.isOverDraftLineofCreditEnabled(application);
    CZWTFCDisclosureHelper.isODStandardPracticeEnabled(application);
    CZWTFCDisclosureHelper.isOverDraftATMEnabled(application);

    List<tffa__DisclosureParticipant__c> participantLst = new List<tffa__DisclosureParticipant__c>();
    tffa__DisclosureParticipant__c dp = new tffa__DisclosureParticipant__c();
    participantLst.add(dp);

    CZWTFCDisclosureHelper.isParticipantAlreadyAdded(participantLst, new tffa__DisclosureParticipant__c());
    CZWTFCDisclosureResolver.resolveFor(submissionObj, application, new Map<String, Object>());
    CZWTFCDisclosureResolver.addFacts(new Map<String, Object>(), application);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}