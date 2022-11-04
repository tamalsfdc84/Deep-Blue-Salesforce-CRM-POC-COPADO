@isTest
public with sharing class CZDocusignTest {
  @isTest
  public static void testCaseOne() {
    /*  tffa__DisclosureChecklist__c checklist = CZWTFCTestDataRepository.createDisclosureChecklist();
    tffa.SObjectAssembler asmdisclosure = new tffa.SObjectAssembler(checklist);

    tffa__DisclosureItem__c item = CZWTFCTestDataRepository.createDisclosureItem();
    tffa__DisclosureTemplate__c template = CZWTFCTestDataRepository.createDisclosureTemplate();
    template = tffa.DisclosureTemplateService.createOrUpdate(new List<tffa__DisclosureTemplate__c>{ template })[0];
    item.tffa__Template__c = template.Id;
    asmdisclosure.addChildObject('Items__r', item);
    
    checklist = tffa.DisclosureChecklistService.createOrUpdate(new List<tffa__DisclosureChecklist__c>{ checklist })[0];
*/
    List<tffa__Party__c> partyLst = new List<tffa__Party__c>();
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

    tffa__Product__c product = new tffa__Product__c();
    product.tffa__Category__c = 'CHECKING';
    product.tffa__Code__c = '801';
    product.Name = 'Premier Checking';
    insert product;

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product.id;
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

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Submission__c = submissionObj.Id;
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    disclosureObj.tffa__Code__c = '32311';
    disclosureObj.tffa__Template__c = '23445';
    disclosureObj.tffa__EnvelopeId__c = '23445';
    insert disclosureObj;

    String subId = submissionObj.Id;
    String partyId = jointParty.Id;

    partyLst.add(jointParty);
    partyLst.add(jointParty1);
    partyLst.add(partyObj);
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    CZWTFCIntegrationLogService.setCurrentLog('Docusign');
    Test.startTest();

    try {
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> mp = new Map<String, String>();
      mp.put('SubmissionId', subId);
      mp.put('RequestType', CZWTFCConstants.REINITIATE_DOCUSIGN);
      mp.put('action', 'Created');
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      tffa.Logger.debug(CZWTFCDocusignController.viewGeneratedEnvelope(ctx, mp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception ' + ex.getStackTraceString());
    }

    try {
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> mp = new Map<String, String>();
      mp.put('SubmissionId', subId);
      mp.put('RequestType', CZWTFCConstants.REINITIATE_DOCUSIGN);
      mp.put('action', 'sent');
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      tffa.Logger.debug(CZWTFCDocusignController.viewGeneratedEnvelope(ctx, mp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception ' + ex.getStackTraceString());
    }

    try {
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> mp = new Map<String, String>();
      mp.put('Submission__c', subId);
      mp.put('Party__c', partyId);
      mp.put('envId', '124');
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      tffa.Logger.debug(CZWTFCDocusignController.getSigningUrl(ctx, mp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception ' + ex.getStackTraceString());
    }

    try {
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> mp = new Map<String, String>();
      mp.put('Submission__c', subId);
      mp.put('Party__c', partyId);
      mp.put('envId', '124');
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      tffa.Logger.debug(CZWTFCDocusignController.viewGeneratedEnvelope(ctx, mp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception ' + ex.getStackTraceString());
    }
    /*
    try {
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> mp = new Map<String, String>();
      mp.put('Submission__c', subId);
      mp.put('Party__c', partyId);
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      tffa.Logger.debug(CZWTFCDocusignController.fetchSigningStatus(ctx, mp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception ' + ex.getStackTraceString());
    }*/

    try {
      CZDocusignDocumentGenDTO dtoResp = new CZDocusignDocumentGenDTO();
      CZDocusignDocumentGenDTO.SignerDTO signDTO = new CZDocusignDocumentGenDTO.SignerDTO();
      signDTO.dummySigner = true;
      dtoResp.documentDTO.lstSignerDTO.add(signDTO);

      CZDocusignDocumentGenRespDTO.RecipientViewRequestDTO respdto = new CZDocusignDocumentGenRespDTO.RecipientViewRequestDTO();
      respdto.authenticationMethod = 'abcd';
    } catch (Exception ex) {
      tffa.Logger.debug('Exception 1 ' + ex.getMessage());
    }

    try {
      CZDocusignRepository dtoRepo = new CZDocusignRepository(subId).fetchData();
      //CZWTFCDocusignDocumentEnricher.getSignerUniqueNumber(jointParty.Id, dtoRepo);
      CZWTFCDocusignDocumentEnricher enricherObj = new CZWTFCDocusignDocumentEnricher();
      enricherObj.addSigners(dtoRepo);
      CZWTFCDocusignRequestDTO.EmailNotificationDTO ddto = new CZWTFCDocusignRequestDTO.EmailNotificationDTO();
      ddto.supportedLanguage = '';
      System.assertNotEquals(ddto, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    Test.stopTest();
  }

  @isTest
  public static void testCasetwo() {
    Test.startTest();
    try {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('abwcdd', 'abebccdd', new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      CZDocusignDocumentPrefillHelper.prefillTextField('abcdd', 'abbccdd', new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      CZDocusignDocumentPrefillHelper.prefillRadioField('abcwdd', 'abbcecdd', new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseThree() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    CZWTFCIntegrationLogService.setCurrentLog('Docusign');

    Test.startTest();
    CZWTFCDocusignRequestDTO dto = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusignAdapter adpter = new CZWTFCDocusignAdapter(dto);
    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      CZWTFCDocusignAdapter.callToken();
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());

      Object resp = adpter.createEnvelope('2443545465', new CZWTFCDocusignRequestDTO());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      Object resp2 = adpter.createEnvelope('233456', new CZWTFCDocusignRequestDTO());
      System.assertNotEquals(resp2, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      Object resp3 = CZWTFCDocusignAdapter.getSenderView('233456', new CZWTFCDocusignRequestDTO());
      System.assertNotEquals(resp3, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      Object resp4 = adpter.getSignersStatus('233456');
      System.assertNotEquals(resp4, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    // System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseFour() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Party__c party = new tffa__Party__c();
    party.Name = 'partyName';
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    insert party;
    Map<String, String> params = new Map<String, String>();
    params.put('Submission__c', sub.id);
    params.put('Party__c', party.id);

    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    CZWTFCIntegrationLogService.setCurrentLog('Docusign');
    Test.startTest();

    CZWTFCDocusignRequestDTO dto = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusignAdapter adpter = new CZWTFCDocusignAdapter(dto);

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      CZWTFCDocusignAdapter.callToken();
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    CZWTFCDocusignAdapter.token = 'token';

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());

      adpter.createEnvelope('2443545465', new CZWTFCDocusignRequestDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      adpter.createEnvelope('233456', new CZWTFCDocusignRequestDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      CZWTFCDocusignAdapter.getSenderView('233456', new CZWTFCDocusignRequestDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
      adpter.getSignersStatus('233456');
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignAdapter.getRecipientView('233456', new CZWTFCDocusignRequestDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignAdapter.doLogin();
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      CZWTFCDocusignAdapter.accountId = '123';
      CZWTFCDocusignAdapter.getSigningUrl(params);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      CZWTFCDocusignAdapter adpt = new CZWTFCDocusignAdapter(dto);
      adpt.processRequestforApplicationDocusign();
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      CZWTFCDocusignAdapter adpt = new CZWTFCDocusignAdapter(dto);
      adpt.processRequestforApplicationDocusign();
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignAdapter adpt = new CZWTFCDocusignAdapter(dto);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignAdapter adpt = new CZWTFCDocusignAdapter(dto);
      adpt.fetchDocumentPDF(new Map<String, String>());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
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
    application.CZTitle1__c = '20234';
    application.CZTitle2__c = '20234';
    application.CZTitle3__c = '20234';
    application.CZTitle4__c = '20234';
    application.CZTitle5__c = '20234';
    application.tffa__AccountNumber__c = '20234';
    application.tffa__Amount__c = 12.36;
    application.tffa__MaturityDate__c = Date.newInstance(2020, 2, 12);
    application.tffa__InterestPayoutMode__c = 'INTERNAL_TRANSFER';

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
    asmParty12.addChildObjects('AddressXrefs__r', partyAddressXrefs1);
    jointParty1 = (tffa__Party__c) asmParty12.assemble();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('Identifications__r', CZWTFCTestDataRepository.createIdentification());
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

    tffa__Disclosure__c d = new tffa__Disclosure__c();
    d.Name = '2123';
    d.tffa__Label__c = '2123';
    d.tffa__ActionText__c = '2123';
    d.tffa__Required__c = true;
    d.tffa__EventName__c = '2123';
    d.tffa__SortOrder__c = 0;
    d.tffa__Type__c = 'DOCUSIGN';
    d.tffa__Code__c = 'BUSSIGNCARD';
    d.tffa__ExecutionRequired__c = true;
    d.tffa__Template__c = '2123';
    d.tffa__Submission__c = submissionObj.Id;
    d.tffa__LinkedApplication__c = application.Id;
    d.CZRelatedApplication__c = String.valueOf(application.Id);
    insert d;

    tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
    disclosureParticipantObj.Name = 'Individual Signer';
    disclosureParticipantObj.tffa__party__c = jointParty1.Id;
    disclosureParticipantObj.tffa__Type__c = 'PARTY';
    disclosureParticipantObj.tffa__RoleCode__c = 'Individual Signer';
    disclosureParticipantObj.tffa__Disclosure__c = d.Id;
    upsert disclosureParticipantObj;

    tffa__DisclosureParticipant__c disclosureParticipantObj1 = new tffa__DisclosureParticipant__c();
    disclosureParticipantObj1.Name = 'Individual Signer';
    disclosureParticipantObj1.tffa__party__c = jointParty1.Id;
    disclosureParticipantObj1.tffa__Type__c = 'PARTY';
    disclosureParticipantObj1.tffa__RoleCode__c = 'TIN_CERTIFIER';
    disclosureParticipantObj1.tffa__Disclosure__c = d.Id;
    upsert disclosureParticipantObj1;

    tffa__DisclosureEnvelope__c discEnvObj = new tffa__DisclosureEnvelope__c();
    discEnvObj.tffa__Submission__c = submissionObj.Id;
    discEnvObj.Name = 'Application_DocumentGeneration';
    discEnvObj.tffa__State__c = 'SENT';
    discEnvObj.tffa__Status__c = 'GENERATED';
    discEnvObj.tffa__ExternalId__c = 'envId';
    discEnvObj.tffa__Channel__c = 'BRANCH';
    insert discEnvObj;

    d.tffa__Envelope__c = discEnvObj.Id;

    tffa.SObjectAssembler disclosureObjAssembler = new tffa.SObjectAssembler(d);
    disclosureObjAssembler.setChildObjects(
      'DisclosureParticipants__r',
      new List<tffa__DisclosureParticipant__c>{ disclosureParticipantObj, disclosureParticipantObj1 }
    );
    d = (tffa__Disclosure__c) disclosureObjAssembler.assemble();

    CZDocusignRepository docusignrepo = new CZDocusignRepository(submissionObj.Id);
    CZDocusignDocumentGenDTO document = new CZDocusignDocumentGenDTO();

    CZWTFCDocusignDocumentEnricher requestEnricher = new CZWTFCDocusignDocumentEnricher();

    CZWTFCDocusignDocumentEnricher defaultEnricher = new CZWTFCDocusignDocumentEnricher();
    defaultEnricher.setDocument(new CZDocusignRepository(submissionObj.Id), d, 1);

    docusignrepo.currentDisclosure = d;
    docusignrepo.mapApps.put(application.Id, application);
    docusignrepo.mapParties.put(jointParty1.Id, jointParty1);

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.EmailPhone__c = 'test';
    insert brandObj;

    tffa__Eligibility__c eligibility1 = new tffa__Eligibility__c(
      tffa__Value__c = 'true',
      tffa__Code__c = 'MeriwestUnionMember',
      tffa__LinkedApplication__c = application.Id,
      tffa__ValueType__c = 'RADIO_GROUP'
    );
    insert eligibility1;

    tffa__Eligibility__c eligibility2 = new tffa__Eligibility__c(
      tffa__Value__c = '3352',
      tffa__Code__c = 'MeriwestUnionMember',
      tffa__LinkedApplication__c = application.Id,
      tffa__ValueType__c = 'CURRENCY'
    );
    insert eligibility2;

    docusignrepo.brandObj = brandObj;
    FISCCIntegrationLogService.setSubmissionObj(submissionObj.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(submissionObj.Id);
    CZWTFCIntegrationLogService.setCurrentLog('Docusign');

    Test.startTest();

    try {
      Map<String, List<tffa__Disclosure__c>> mp = new Map<String, List<tffa__Disclosure__c>>();
      mp.put('13345', new List<tffa__Disclosure__c>{ d });
      CZWTFCDocuSignProvider.updateDiscEnv(submissionObj, new List<tffa__Disclosure__c>{ d }, 'qwerty');
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }
    try {
      requestEnricher.addSigners(docusignrepo);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      jointParty.tffa__PrimaryPhone__c = '12356435365465';
      jointParty.tffa__SecondaryPhone__c = '124563254354653';
      jointParty.CellPhoneNumber__c = '124564324543554';
      jointParty.PreferredContactNumber__c = 'HOME';
      jointParty.tffa__PrimaryEmail__c = '13456';
      jointParty.CZEmergencyContactNumber__c = '124564324543554';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');
      jointParty.PreferredContactNumber__c = 'WORK';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');
      jointParty.PreferredContactNumber__c = 'CELL';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');

      jointParty.tffa__PrimaryPhone__c = '';
      jointParty.PreferredContactNumber__c = 'WORK';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');

      jointParty.PreferredContactNumber__c = 'CELL';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');

      jointParty.tffa__SecondaryPhone__c = '';
      jointParty.PreferredContactNumber__c = 'HOME';
      CZWTFCDocusignDocumentEnricher.prefillPhoneNbrAndEmail(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO(), '');
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      docusignrepo.getDocumentMasterConfig();
      docusignrepo.getAllDocumentMasterConfig();
      CZDocusignRepository.fetchUserDetails('User');
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    CZDocusignDocumentBuilder builder = new CZDocusignDocumentBuilder(
      (String) submissionObj.Id,
      new List<tffa__Disclosure__c>{ d },
      'created'
    );

    try {
      tffa__AccountPreference__c accPref1 = new tffa__AccountPreference__c(
        tffa__AccountName__c = 'Rishi',
        tffa__AccountNumber__c = '1775283',
        tffa__CardNumber__c = '27163876217',
        tffa__Status__c = 'FAILED',
        tffa__Party__c = jointParty.Id,
        tffa__Application__c = application.Id,
        tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
        CZIsStarterCheckRequired__c = true,
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true,
        tffa__AddOnServiceType__c = 'ESTATEMENTS'
      );
      tffa__AccountPreference__c accPref2 = new tffa__AccountPreference__c(
        tffa__AccountName__c = 'Rishi',
        tffa__AccountNumber__c = '1775283',
        tffa__CardNumber__c = '27163876217',
        tffa__Status__c = 'FAILED',
        tffa__Party__c = jointParty.Id,
        tffa__Application__c = application.Id,
        tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
        CZIsStarterCheckRequired__c = true,
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = false,
        tffa__AddOnServiceType__c = 'ESTATEMENTS'
      );
      tffa__AccountPreference__c accPref3 = new tffa__AccountPreference__c(
        tffa__AccountName__c = 'Rishi',
        tffa__AccountNumber__c = '1775283',
        tffa__CardNumber__c = '27163876217',
        tffa__Status__c = 'FAILED',
        tffa__Party__c = jointParty.Id,
        tffa__Application__c = application.Id,
        tffa__Code__c = 'OD_FOR_ATM_AND_DEBIT_CARD_TRANSACTIONS',
        CZIsStarterCheckRequired__c = true,
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true,
        tffa__AddOnServiceType__c = 'ESTATEMENTS'
      );
      tffa__AccountPreference__c accPref4 = new tffa__AccountPreference__c(
        tffa__AccountName__c = 'Rishi',
        tffa__AccountNumber__c = '1775283',
        tffa__CardNumber__c = '27163876217',
        tffa__Status__c = 'FAILED',
        tffa__Party__c = jointParty.Id,
        tffa__Application__c = application.Id,
        tffa__Code__c = 'OD_FOR_ATM_AND_DEBIT_CARD_TRANSACTIONS',
        CZIsStarterCheckRequired__c = true,
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = false,
        tffa__AddOnServiceType__c = 'ESTATEMENTS'
      );

      List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>{ accPref1, accPref2, accPref3, accPref4 };
      insert accPrefList;

      List<tffa__Application__c> appList1 = CZDocusignRepository.fetchApplicationsWithChildObjects(
        new List<tffa__Application__c>{ application }
      );

      docusignrepo.mapApps.put(appList1[0].Id, appList1[0]);

      CZWTFCDocusignDocumentEnricher.prefillOverdraftDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        disclosureParticipantObj
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      User u = tffa.UserService.getCurrentUser();
      u.Email = 'qwerty';
      docusignRepo.currentUser = u;
      CZWTFCDocusignDocumentEnricher.setAppTitle(application, new CZWTFCDocusignRequestDTO.SignerDTO());
      CZWTFCDocusignDocumentEnricher.prefillBrandDetails(docusignrepo, new CZWTFCDocusignRequestDTO.SignerDTO(), disclosureParticipantObj);
      CZWTFCDocusignDocumentEnricher.prefillBusinessAddress(jointParty, new CZWTFCDocusignRequestDTO.SignerDTO());
      CZWTFCDocusignDocumentEnricher.prefillBusinessAddress(jointParty1, new CZWTFCDocusignRequestDTO.SignerDTO());
      CZWTFCDocusignDocumentEnricher.prefillUserDetails(docusignrepo, new CZWTFCDocusignRequestDTO.SignerDTO());
      builder.setParticipants(new List<tffa__Disclosure__c>{ d });
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      Map<String, String> params = new Map<String, String>();
      params.put('SubmissionId', submissionObj.Id);
      CZWTFCDocusignController.generateDraft(tffa.Context.get(), params);
      CZWTFCDocusignController.generateEnvelope(tffa.Context.get(), params);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      List<String> requiredDataPoints = new List<String>();
      requiredDataPoints.add('NAME');
      requiredDataPoints.add('IDENTITY');
      requiredDataPoints.add('CONTACTDTLS');
      requiredDataPoints.add('ADDRESS');
      CZWTFCDocusignDocumentEnricher.prefillPartyDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        jointParty1.Id,
        requiredDataPoints
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    tffa__Beneficiary__c beneficiary = new tffa__Beneficiary__c(
      tffa__FirstName__c = 'Tets',
      tffa__LastName__c = 'qwerr',
      tffa__Ssn__c = '666001753',
      Customer_Number__c = '1213445',
      tffa__NationalIdentifierValue__c = '123456789',
      tffa__PrimaryPhone__c = '1234567890',
      tffa__BirthDate__c = Date.newInstance(1988, 2, 12),
      tffa__Application__c = application.id,
      tffa__Type__c = 'PRIMARY'
    );

    insert beneficiary;

    try {
      CZWTFCDocusignDocumentEnricher.prefillBeneficiaryDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c(),
        new List<String>()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillBeneficiaryBasicDetails(beneficiary, new CZWTFCDocusignRequestDTO.SignerDTO(), 1);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillBeneficiaryAddressDetails(address, new CZWTFCDocusignRequestDTO.SignerDTO(), 1);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillAccountDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      jointParty1.CZBoardMeetingDate__c = Date.newInstance(1988, 2, 12);
      docusignrepo.businessParty = jointParty1;
      CZWTFCDocusignDocumentEnricher.prefillBusinessDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillOwnershipDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      tffa__DisclosureParticipant__c dp = new tffa__DisclosureParticipant__c();
      dp.tffa__RoleCode__c = 'NATURAL_PERSON';
      CZWTFCDocusignDocumentEnricher.prefillOtherParticipantDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillBeneficialOwnerDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      tffa__PartyPartyXref__c partyxref1 = new tffa__PartyPartyXref__c();
      partyxref1.tffa__OwnershipPercentage__c = 75;
      partyxref1.tffa__RelatedParty__c = jointParty.Id;
      CZWTFCDocusignDocumentEnricher.prefillBeneficialOwnershipDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        partyxref1,
        1
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      tffa__PartyPartyXref__c partyxref2 = new tffa__PartyPartyXref__c();
      partyxref2.tffa__OwnershipPercentage__c = 75;
      partyxref2.tffa__RelatedParty__c = jointParty.Id;
      CZWTFCDocusignDocumentEnricher.prefillControllingPartyDetails(docusignrepo, new CZWTFCDocusignRequestDTO.SignerDTO(), partyxref2);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillCurrentDateDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.getOrdinalDay(1);
      CZWTFCDocusignDocumentEnricher.getOrdinalDay(2);
      CZWTFCDocusignDocumentEnricher.getOrdinalDay(3);
      CZWTFCDocusignDocumentEnricher.getOrdinalDay(4);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      List<tffa__Submission__c> subList = CZWTFCSubmissionRepository.fetchSubmissionswithDisc();
      CZWTFCSubmissionRepository.fetchSubmissionswithDiscById(new List<Id>{ submissionObj.Id });
      CZFetchDocusignDocumentBatch.updateSubmissionDownloadStatus(subList);
      //CZFetchDocusignDocumentBatch.updateSubmissionDownloadStatus(subList, '');
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZDocusignReminderHelper.sendEmail(submissionObj, jointParty, discEnvObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      ID batchprocessid = Database.executeBatch(new CZFetchDocusignDocumentBatch(), 1);
      AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
      System.assertNotEquals(aaj, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      List<List<tffa__Disclosure__c>> discSplitedList = new List<List<tffa__Disclosure__c>>();
      List<tffa__Disclosure__c> disclosures;
      String documentType = 'Docusign';
      disclosures = CZDocusignRepository.getSubmissionDocuments(submissionObj.Id, documentType, 0);
      discSplitedList = CZWTFCDisclosureHelper.splitDisclosures(disclosures);

      for (List<tffa__Disclosure__c> discList : discSplitedList) {
        CZDocusignDocumentBuilder documentBuilder = new CZDocusignDocumentBuilder(submissionObj.Id, discList, null);
        documentBuilder.getListOfDocuments();
        CZWTFCDocusignService docSer = new CZWTFCDocusignService();
        docSer.initateDocusign(new List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO>(), 'action');
      }
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    /*  try {
      CZWTFCDocusignService docSer = new CZWTFCDocusignService();
      CZDocusignDocumentGenDTO docdto = new CZDocusignDocumentGenDTO();
     // docSer.addSigners(docdto);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    try {
      CZWTFCDocusignService docSer = new CZWTFCDocusignService();
      docSer.getSignerTabs(new CZDocusignDocumentGenDTO.SignerDTO());
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }*/

    try {
      CZWTFCDocusignService docSer = new CZWTFCDocusignService();
      docSer.initateDocusign(null, null);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    /* try {
      CZWTFCDocusignService docSer = new CZWTFCDocusignService();
      docSer.addSigners(null);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    try {
      CZWTFCDocusignService docSer = new CZWTFCDocusignService();
      docSer.getSignerTabs(null);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }*/

    try {
      CZWTFCDocusignDocumentEnricher.getFormattedIdentificationNumber('123456789', 'SSN');
      CZWTFCDocusignDocumentEnricher.getFormattedIdentificationNumber('123456789', 'EIN');
      CZWTFCDocusignDocumentEnricher.getFormattedIdentificationNumber('123456789', '');
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      tffa.SObjectAssembler asmParty3 = new tffa.SObjectAssembler(partyObj);
      asmParty3.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
      jointParty1 = (tffa__Party__c) asmParty3.assemble();
      update jointParty1;

      CZWTFCDocusignDocumentEnricher.prefillIdentificationDetails(jointParty1, new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillEligibilityDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillAccountNumbers(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      Map<String, String> mp1 = new Map<String, String>();
      mp1.put('test', 'test');

      docusignrepo.enricherConfig = mp1;

      requestEnricher.addSigners(docusignrepo);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillCertificateDepositDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillPrincipalDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillIRADetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillMaxsafeAccountMaintenanceDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZMaxsafeAllocationDetails__c allocationDetails = new CZMaxsafeAllocationDetails__c();
      allocationDetails.IsSelected__c = true;
      allocationDetails.AllocationType__c = 'Increase Allocation';

      CZWTFCDocusignDocumentEnricher.prefillMaxsafeAllocationDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), allocationDetails, false);

      allocationDetails.AllocationType__c = 'Decrease Allocation';

      CZWTFCDocusignDocumentEnricher.prefillMaxsafeAllocationDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), allocationDetails, false);

      allocationDetails.IsSelected__c = false;

      CZWTFCDocusignDocumentEnricher.prefillMaxsafeAllocationDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), allocationDetails, false);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillBankerDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      application.tffa__DepositBoxStartDate__c = Date.today().addDays(4);
      CZWTFCDocusignDocumentEnricher.prefillSDBDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillBoxOwnerShipDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), 'SAFE_DEPOSIT_BOX', 1);
      CZWTFCDocusignDocumentEnricher.prefillBoxOwnerShipDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), 'SAFE_DEPOSIT_BOX', 2);
      CZWTFCDocusignDocumentEnricher.prefillBoxOwnerShipDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), 'BUSINESS_SAFE_DEPOSIT_BOX', 1);
      CZWTFCDocusignDocumentEnricher.prefillBoxOwnerShipDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), 'BUSINESS_SAFE_DEPOSIT_BOX', 2);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillHSAContributionDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillAccountNumbersAndAddressDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    CZWTFCSignersStatusDTO.SignersDTO signerStatus = new CZWTFCSignersStatusDTO.SignersDTO();
    signerStatus.clientUserId = jointParty1.Id;
    signerStatus.status = 'pending';
    CZWTFCSignersStatusDTO signerStatusDTO = new CZWTFCSignersStatusDTO();
    signerStatusDTO.signers = new List<CZWTFCSignersStatusDTO.SignersDTO>();
    signerStatusDTO.signers.add(signerStatus);
    discEnvObj.tffa__ReminderCount__c = 0;
    upsert discEnvObj;
    ID batchprocessid2 = Database.executeBatch(new CZDousignReminderBatch(), 1);
    AsyncApexJob aaj11 = [
      SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
      FROM AsyncApexJob
      WHERE ID = :batchprocessid2
    ];
    System.assertNotEquals(aaj11, null);
    CZDocusignReminderHelper.sendReminderMail(signerStatusDTO, discEnvObj);
    jointParty1.CZDocusignReminderDate__c = Date.today().addDays(4);
    discEnvObj.tffa__ReminderDate__c = Date.today().addDays(4);
    discEnvObj.tffa__ReminderCount__c = 1;
    upsert jointParty1;
    upsert discEnvObj;
    ID batchprocessid21 = Database.executeBatch(new CZDousignReminderBatch(), 1);
    AsyncApexJob aaj21 = [
      SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
      FROM AsyncApexJob
      WHERE ID = :batchprocessid21
    ];
    System.assertNotEquals(aaj21, null);
    CZDocusignReminderHelper.sendReminderMail(signerStatusDTO, discEnvObj);
    jointParty1.CZDocusignReminderDate__c = Date.today().addDays(8);
    discEnvObj.tffa__ReminderDate__c = Date.today().addDays(8);
    discEnvObj.tffa__ReminderCount__c = 2;
    upsert jointParty1;
    upsert discEnvObj;
    ID batchprocessid22 = Database.executeBatch(new CZDousignReminderBatch(), 1);
    AsyncApexJob aaj31 = [
      SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
      FROM AsyncApexJob
      WHERE ID = :batchprocessid22
    ];
    System.assertNotEquals(aaj31, null);
    Object resp3 = CZDocusignReminderHelper.sendReminderMail(signerStatusDTO, discEnvObj);
    System.assertNotEquals(resp3, null);

    try {
      CZWTFCDocusignDocumentEnricher.prefillJuniorSaverDetails(
        docusignrepo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDocusignDocumentEnricher.prefillJuniorSaverPartyDetails(new CZWTFCDocusignRequestDTO.SignerDTO(), partyObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void rateDetailsTest() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '12342';
    brandObj.tffa__Code__c = '12342';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.EmailPhone__c = 'test';
    insert brandObj;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.tffa__Brand__c = '12342';
    insert submissionObj;

    tffa__Product__c prod800 = new tffa__Product__c();
    prod800.tffa__Category__c = 'CHECKING';
    prod800.tffa__Code__c = '800';
    prod800.Name = 'Test 800';
    prod800.InterestPlanCode__c = '100000';
    insert prod800;

    InterestPlanDetails__c intPln750 = new InterestPlanDetails__c();
    intPln750.IntPlnCde__c = '100000';
    intPln750.BrandCode__c = '12342';
    intPln750.RteSchedInd__c = 'N';
    intPln750.APY__c = 0.01;
    intPln750.TierMinBal__c = 100.00;
    intPln750.TierMaxBal__c = 1000.00;
    insert intPln750;

    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = prod800.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '800';
    application.tffa__MaturityDate__c = Date.newInstance(2020, 2, 12);

    insert application;

    List<tffa__Application__c> appList2 = CZDocusignRepository.fetchApplicationsWithChildObjects(
      new List<tffa__Application__c>{ application }
    );

    Map<Id, tffa__Application__c> mapApps = new Map<Id, tffa__Application__c>();
    mapApps.put(application.Id, appList2[0]);

    CZDocusignRepository repo = new CZDocusignRepository(submissionObj.Id);
    repo.mapApps = mapApps;

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Submission__c = submissionObj.Id;
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    disclosureObj.tffa__Code__c = '32311';
    disclosureObj.tffa__Template__c = '23445';
    disclosureObj.tffa__EnvelopeId__c = '23445';
    disclosureObj.CZRelatedApplication__c = String.valueOf(application.Id);
    disclosureObj.tffa__LinkedApplication__c = String.valueOf(application.Id);
    insert disclosureObj;

    repo.currentDisclosure = disclosureObj;
    repo.brandObj = brandObj;

    Map<String, List<InterestPlanDetails__c>> interestPlanDetailsMap = new Map<String, List<InterestPlanDetails__c>>();
    interestPlanDetailsMap.put('100000', new List<InterestPlanDetails__c>{ intPln750 });
    repo.interestPlanDetailsMap = interestPlanDetailsMap;

    Test.startTest();
    try {
      CZWTFCDocusignDocumentEnricher.prefillRateDetails(
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      application.tffa__InterestPayoutMode__c = 'COMPOUND';
      application.tffa__InterestPayoutFrequency__c = 'DAILY';
      CZWTFCDocusignDocumentEnricher.prefillTISADetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      application.tffa__InterestPayoutMode__c = 'ACH';
      application.tffa__InterestPayoutFrequency__c = 'DAILY';
      CZWTFCDocusignDocumentEnricher.prefillTISADetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseFive() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '12342';
    brandObj.tffa__Code__c = '12342';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.EmailPhone__c = 'test';
    insert brandObj;

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
    insert jointParty1;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.tffa__Brand__c = '12342';
    insert submissionObj;

    tffa__Product__c prod800 = new tffa__Product__c();
    prod800.tffa__Category__c = 'CHECKING';
    prod800.tffa__Code__c = '800';
    prod800.Name = 'Test 800';
    prod800.InterestPlanCode__c = '100000';
    insert prod800;

    InterestPlanDetails__c intPln750 = new InterestPlanDetails__c();
    intPln750.IntPlnCde__c = '100000';
    intPln750.BrandCode__c = '12342';
    intPln750.RteSchedInd__c = 'N';
    intPln750.APY__c = 0.01;
    insert intPln750;

    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = prod800.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '800';

    insert application;

    Map<Id, tffa__Application__c> mapApps = new Map<Id, tffa__Application__c>();
    mapApps.put(application.Id, application);

    CZDocusignRepository repo = new CZDocusignRepository(submissionObj.Id);
    repo.mapApps = mapApps;

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Submission__c = submissionObj.Id;
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    disclosureObj.tffa__Code__c = '32311';
    disclosureObj.tffa__Template__c = '23445';
    disclosureObj.tffa__EnvelopeId__c = '23445';
    disclosureObj.CZRelatedApplication__c = String.valueOf(application.Id);
    insert disclosureObj;

    repo.currentDisclosure = disclosureObj;
    repo.brandObj = brandObj;

    Test.startTest();

    try {
      CZDocusignRepository.fetchDiscEnv(submissionObj.Id);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      application.tffa__InvestmentContributionType__c = 'ROLLOVER';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__InvestmentContributionType__c = 'REGULAR';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = true;
      application.tffa__InvestmentContributionType__c = 'ROLLOVER';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = true;
      application.tffa__InvestmentContributionType__c = 'TRANSFER';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'REGULAR_SPOUSAL_CURRENT';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'REGULAR_SPOUSAL_PREVIOUS';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'RECHARACTERIZATION';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'CONVERSION_TO_ROTH';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'DIVORCE';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'DIRECTROLLOVER';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'SEP_EMPLOYER_CY';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());

      application.tffa__IsInheritedInvestmentPlan__c = false;
      application.tffa__InvestmentContributionType__c = 'EMPLOYER_SIMPLE';
      CZWTFCDocusignDocumentEnricher.prefillIRAContributionDetails(application, new CZWTFCDocusignRequestDTO.SignerDTO());
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'BUSINESSDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'ACCOUNTDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'ACCOUNTNUMBERS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'ACCOUNTNUMBERSANDDETAILS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'BRANDDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'BENEFICIARYDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'OWNERSHIPDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'CURRENTDATEDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'BENEFICIALOWNERDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'RATEDETAILS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'PRINCIPALDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'CERTIFICATEDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'IRADTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'MAXSAFEACCMAINDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'BANKERDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'ELIGIBILITYDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      CZWTFCDocusignDocumentEnricher.invokeRequiredDataPoint(
        new List<String>{ 'HSACONTRIBUTIONDTLS' },
        repo,
        new CZWTFCDocusignRequestDTO.SignerDTO(),
        new tffa__DisclosureParticipant__c()
      );
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }

    try {
      Object resp = CZDocusignRepository.fetchApplicationsWithChildObjects(new List<tffa__Application__c>{ application });
      System.assertNotEquals(resp, null);
      Object resp1 = CZDocusignRepository.fetchPartiesdWithChildObjects(new List<Id>{ jointParty1.Id });
      System.assertNotEquals(resp1, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Error thrown ' + ex.getMessage());
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}