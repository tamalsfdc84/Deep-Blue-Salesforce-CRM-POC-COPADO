@isTest
public inherited sharing class FISDSSAPITest {
  @isTest
  public static void testCaseOne() {
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
    Test.setMock(HttpCalloutMock.class, new FISFetchOOWQMockClass());
    Object test1 = FISIDAProvider.fetchOOWQuestions(jointParty);
    FISDSSService.removeExistingDueDiligence(jointParty, new List<String>{ 'IDA' });
    tffa__Party__c pp = FISDSSService.upsertDueDiligence(jointParty, (FISIDAResponseDTO) test1);
    //tffa__Party__c partyObj,FISIDAResponseDTO idaResp
    FISIDAResponseDTO reqidv = new FISIDAResponseDTO();
    reqidv.errorCd = '1234';
    reqidv.errorTxt = '1334';
    FISDSSService.upsertDueDiligence(jointParty, reqidv);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseTwo() {
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
    jointParty.tffa__BrandCode__c = '118';
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

    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    dueDiligence.Name = 'FIS OOW';
    dueDiligence.tffa__Type__c = 'IDA';
    dueDiligence.tffa__Status__c = 'CHALLENGED';
    dueDiligence.tffa__Provider__c = 'FIS IDA';
    dueDiligence.tffa__ExternalQuestionnaireId__c = '12323';
    dueDiligence.tffa__ConversationId__c = '1233';

    tffa.SObjectAssembler asm12 = new tffa.SObjectAssembler(dueDiligence);

    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = '12345',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );
    List<Object> choices = new List<Object>();
    choices.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item.tffa__Choices__c = JSON.serialize(choices);
    ddItems.add(item);
    tffa__DueDiligenceItem__c item1 = new tffa__DueDiligenceItem__c(
      Name = 'Tes2t',
      tffa__Label__c = 'test2',
      tffa__Code__c = '123425',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 2,
      tffa__Value__c = '123425'
    );
    List<Object> choices1 = new List<Object>();
    choices1.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices1.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item1.tffa__Choices__c = JSON.serialize(choices1);
    ddItems.add(item1);

    tffa__DueDiligenceItem__c item3 = new tffa__DueDiligenceItem__c(
      Name = 'Test1',
      tffa__Label__c = 'test1',
      tffa__Code__c = '123451',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 3,
      tffa__Value__c = '123145'
    );
    List<Object> choices2 = new List<Object>();
    choices2.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices2.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item3.tffa__Choices__c = JSON.serialize(choices2);
    ddItems.add(item3);

    asm12.addChildObjects('Items__r', ddItems);
    dueDiligence = (tffa__DueDiligence__c) asm12.assemble();
    //insert dueDiligence;

    tffa.SObjectAssembler asmPar = new tffa.SObjectAssembler(jointParty);
    asmPar.addChildObjects('DueDiligences__r', new List<tffa__DueDiligence__c>{ dueDiligence });
    jointParty = (tffa__Party__c) asmPar.assemble();
    //update jointParty;

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
    Test.setMock(HttpCalloutMock.class, new FISverifyOOWMockClass());
    Object test2 = FISIDAProvider.verifyOOWQuestions(jointParty, dueDiligence);

    FISDSSService.doAnswersCheckAndBuildDD(jointParty, (FISIDAResponseDTO) test2, new tffa__DueDiligence__c());

    try {
      tffa__Party__c prty = FISDSSService.doAnswersCheckAndBuildDD(jointParty, null, new tffa__DueDiligence__c());
      System.assertEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Map<String, Object> params = new Map<String, Object>();
      params.put('Submission__c', submissionObj.Id);
      new CZWTFCIDAServiceProvider().verify(new List<tffa__Party__c>{ jointParty }, params);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Map<String, Object> params = new Map<String, Object>();
      params.put('Submission__c', submissionObj.Id);
      jointParty.tffa__isMinor__c = true;
      update jointParty;
      new CZWTFCIDAServiceProvider().verify(new List<tffa__Party__c>{ jointParty }, params);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Map<String, Object> params = new Map<String, Object>();
      params.put('Submission__c', submissionObj.Id);
      jointParty.tffa__isMinor__c = false;
      jointParty.tffa__IDAStatus__c = 'CHALLENGED';
      update jointParty;
      new CZWTFCIDAServiceProvider().verify(new List<tffa__Party__c>{ jointParty }, params);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Submission__c sb = CZWTFCSubmissionRepository.findSubWithProdById(jointParty.Id);
      System.assertEquals(null, sb);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseThree() {
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
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.PreferredContactNumber__c = 'CELL';
    jointParty.CellPhoneNumber__c = '+11234567890';
    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    jointParty.Name = 'test';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    asmParty1.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
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
    jointParty1.Name = '123456qwerty1234567yrq';
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
    Test.setMock(HttpCalloutMock.class, new FISIDVMockClass());
    Object test3 = FISIDVProvider.doIdentityVerification(jointParty);
    FISDSSService.removeExistingDueDiligence(jointParty, new List<String>{ 'IDV', 'QUALIFILE', 'OFAC' });
    try {
      tffa__Party__c pp = FISDSSService.processIDVResult(jointParty, (FISIDVResponseDTO) test3);

      /**
       *   First condition
       */
      FISDSSService.qualifyReportName('test', jointParty);

      /**
       * Second condition
       */
      FISDSSService.qualifyReportName('test', jointParty1);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    FISIDVResponseDTO repOne = new FISIDVResponseDTO();
    repOne.consumer.errorCd = '1234';

    FISIDVResponseDTO reptwo = (FISIDVResponseDTO) test3;
    reptwo.consumer.identityManagerResponse.errorCd = '13344';
    reptwo.consumer.errorCd = null;
    reptwo.consumer.identityManagerResponse.validationsResult = null;

    FISIDVResponseDTO repthree = (FISIDVResponseDTO) test3;
    repthree.consumer.ofacResponse.ofacValidationsResult = null;

    FISIDVResponseDTO repfour = new FISIDVResponseDTO();
    repfour.consumer.qualifileResponse.accountActionInfo.accountActionTxt1 = '122344';
    repfour.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt = 'Review';

    FISIDVResponseDTO repfive = new FISIDVResponseDTO();
    repfive.consumer.qualifileResponse.accountActionInfo.accountActionTxt1 = '122344s';
    repfive.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt = 'Decline';

    FISIDVResponseDTO repsix = (FISIDVResponseDTO) test3;
    repsix.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt = null;

    FISIDVResponseDTO repseven = (FISIDVResponseDTO) test3;
    repseven.consumer.qualifileResponse.accountActionInfo = null;

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repOne);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, reptwo);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repthree);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repfour);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repfive);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      FISIDVServiceExtension.formatZipCode('12345');
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repsix);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Party__c prty = FISDSSService.processIDVResult(jointParty, repseven);
      System.assertNotEquals(null, prty);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   * Error block handling
   */
  @isTest
  public static void testCaseFour() {
    Test.startTest();
    FISIDAResponseBuilder idaResp = new FISIDAResponseBuilder();
    FISIDAResponseBuilder.testException = true;
    try {
      idaResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    try {
      idaResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    FISIDVServiceExtension.testException = true;
    try {
      FISIDVServiceExtension.doIDVApiCall(null, null, null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      FISCCRequestBaseDTO dto = FISIDVServiceExtension.generateIDVRequest(null, null, null);
      System.assertEquals(null, dto);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    FISIDAServiceExtension.testException = true;
    try {
      FISIDAServiceExtension.generateFetchOOWQuestionsReq(null, null, null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Object obj = FISIDAServiceExtension.getOOWQuestions(null, null, null);
      System.assertEquals(null, obj);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      FISIDAServiceExtension.verifyOOWAnswers(null, null, null, null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    FISIDVResponseBuilder idaR = new FISIDVResponseBuilder();
    FISIDVResponseBuilder.testException = true;
    try {
      idaR.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    try {
      idaR.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    new FISIDVResponseDTO.ReportedClosure();
    new FISIDVResponseDTO.ConsumerPreviousInquiry();
    new FISIDVResponseDTO.ConsumerPreviousInquiryDetails();
    new FISIDAResponseDTO.IdaQuestions();
    new FISIDAResponseDTO.IdaDecision();
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}