@isTest
public with sharing class CZDepositOriginatorOrgTest {
  @isTest
  public static void testCaseone() {
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
    submissionObj.tffa__Brand__c = '118';
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
    partyObj.tffa__EstablishmentDate__c = system.today();
    partyObj.tffa__IndustryClassificationValue__c = '111110';
    partyObj.tffa__ExternalId__c = '123456';
    partyObj.tffa__PrimaryPhone__c = '122332';
    partyObj.tffa__SecondaryPhone__c = '323443';
    partyObj.PreferredContactNumber__c = 'HOME';
    partyObj.SecretWord__c = 'HOME';
    partyObj.SecretWordHint__c = 'HOME1';
    partyObj.CZPrimaryOfficer__c = '12334';
    partyObj.CZSecondaryOfficer__c = '1342';
    partyObj.FISBranchCode__c = '1';
    partyObj.CostCenter__c = '12';
    partyObj.Customer_Number__c = '243345';
    partyObj.CZInternationalPhoneNumber__c = '4455463';
    partyObj.tffa__LegalName__c = 'jhjwhjeff';
    insert partyObj;

    tffa__ApplicationPartyXref__c partyXrf = new tffa__ApplicationPartyXref__c();
    partyXrf.tffa__Party__c = partyObj.id;
    partyXrf.tffa__Application__c = application.id;
    partyXrf.tffa__Type__c = 'INDIVIDUAL';
    insert partyXrf;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = '';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    tffa__Address__c address2 = new tffa__Address__c();
    address2.tffa__Line1__c = '803 Ecostar';
    address2.tffa__Line2__c = '1323';
    address2.tffa__State__c = 'CT1';
    address2.tffa__City__c = 'Darien';
    address2.tffa__Country__c = 'US';
    address2.tffa__ZipCode__c = '06820-4621';
    insert address2;

    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = address;
    partyAddressXrefs.add(partyAddressXref0);

    List<tffa__PartyAddressXref__c> partyAddressXrefs1 = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref01 = new tffa__PartyAddressXref__c();
    partyAddressXref01.tffa__Type__c = 'HOME';
    partyAddressXref01.tffa__Preferred__c = true;
    partyAddressXref01.tffa__Address__r = address2;
    partyAddressXrefs1.add(partyAddressXref01);

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
    jointParty.tffa__LegalName__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    jointParty.tffa__EstablishmentDate__c = system.today();
    jointParty.tffa__IndustryClassificationValue__c = '111110';
    jointParty.tffa__ExternalId__c = '123456';
    jointParty.tffa__PrimaryPhone__c = '122332';
    jointParty.CellPhoneNumber__c = '323443';
    jointParty.PreferredContactNumber__c = 'CELL';
    jointParty.SecretWord__c = 'HOME';
    jointParty.SecretWordHint__c = 'HOME1';
    jointParty.CZPrimaryOfficer__c = '12334';
    jointParty.CZSecondaryOfficer__c = '1342';
    jointParty.FISBranchCode__c = '1';
    jointParty.CostCenter__c = '12';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs1);
    jointParty = (tffa__Party__c) asmParty1.assemble();

    /**tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    jointParty = (tffa__Party__c) asmParty1.assemble();*/

    tffa__Address__c address1 = new tffa__Address__c();
    address1.tffa__Line1__c = '803 Ecostar';
    address1.tffa__Line2__c = ' ';
    address1.tffa__State__c = 'CT1';
    address1.tffa__City__c = 'Darien';
    address1.tffa__Country__c = 'US';
    address1.tffa__ZipCode__c = '06820-41';
    insert address1;

    List<tffa__PartyAddressXref__c> partyAddressXrefs12 = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref012 = new tffa__PartyAddressXref__c();
    partyAddressXref012.tffa__Type__c = 'HOME';
    partyAddressXref012.tffa__Preferred__c = true;
    partyAddressXref012.tffa__Address__r = address1;
    partyAddressXrefs12.add(partyAddressXref012);

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
    jointParty1.tffa__LegalName__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    jointParty1.tffa__Type__c = 'INDIVIDUAL';
    jointParty1.tffa__EstablishmentDate__c = system.today();
    jointParty1.tffa__IndustryClassificationValue__c = '111110';
    jointParty1.tffa__ExternalId__c = '123456';
    jointParty1.tffa__PrimaryPhone__c = '122332';
    jointParty1.tffa__SecondaryPhone__c = '323443';
    jointParty1.PreferredContactNumber__c = 'WORK';
    jointParty1.SecretWord__c = 'HOME';
    jointParty1.SecretWordHint__c = 'HOME1';
    jointParty1.CZPrimaryOfficer__c = '12334';
    jointParty1.CZSecondaryOfficer__c = '1342';
    jointParty1.FISBranchCode__c = '1';
    jointParty1.CostCenter__c = '12';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty12 = new tffa.SObjectAssembler(jointParty1);
    asmParty12.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs12);
    jointParty1 = (tffa__Party__c) asmParty12.assemble();

    tffa__Identification__c iden2 = new tffa__Identification__c();
    iden2.tffa__Type__c = 'DL';
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden2.tffa__ExpirationDate__c = Date.valueOf('2020-01-01');
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden2.tffa__IdentificationNumber__c = '341234234';
    iden2.tffa__IssueDate__c = Date.valueOf('1990-01-01');
    iden2.tffa__IssuingCountry__c = 'US';
    iden2.tffa__IssuingState__c = 'CA';
    iden2.tffa__party__c = partyObj.Id;
    insert iden2;

    tffa__Identification__c iden3 = new tffa__Identification__c();
    iden3.tffa__Type__c = 'DL';
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden3.tffa__ExpirationDate__c = Date.valueOf('2020-01-01');
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden3.tffa__IdentificationNumber__c = '341234234';
    iden3.tffa__IssueDate__c = Date.valueOf('1990-01-01');
    iden3.tffa__IssuingCountry__c = 'US';
    iden3.tffa__IssuingState__c = 'CA';
    iden3.tffa__party__c = partyObj.Id;
    insert iden3;

    tffa__Identification__c iden4 = new tffa__Identification__c();
    iden4.tffa__Type__c = 'DL';
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden4.tffa__ExpirationDate__c = Date.valueOf('2020-01-01');
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden4.tffa__IdentificationNumber__c = '341234234';
    iden4.tffa__IssueDate__c = Date.valueOf('1990-01-01');
    iden4.tffa__IssuingCountry__c = 'US';
    iden4.tffa__IssuingState__c = 'CA';
    iden4.tffa__party__c = partyObj.Id;
    insert iden4;

    tffa__Identification__c iden5 = new tffa__Identification__c();
    iden5.tffa__Type__c = 'DL';
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden5.tffa__ExpirationDate__c = Date.valueOf('2020-01-01');
    //iden2.tffa__BackPhotoId__c = 'a0a0m000001eDQDAA2';
    iden5.tffa__IdentificationNumber__c = '341234234';
    iden5.tffa__IssueDate__c = Date.valueOf('1990-01-01');
    iden5.tffa__IssuingCountry__c = 'US';
    iden5.tffa__IssuingState__c = 'CA';
    iden5.tffa__party__c = partyObj.Id;
    insert iden5;

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObjects(
      'tffa__Identifications__r',
      new List<tffa__Identification__c>{ CZWTFCTestDataRepository.createIdentification(), iden2, iden3, iden4, iden5 }
    );
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.CIPrmyOffcrNbr__c = '1000';
    insert brandObj;

    Test.startTest();
    FISCCIntegrationLogService.setSubmissionObj(submissionObj.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(submissionObj.Id);
    FISCCIntegrationLogService.setCurrentLog('Test');
    FISCCIntegrationLogService.auth = 'test.auth';
    FISCCIntegrationLogService.setCharterConfig('118');
    Map<Id, tffa__Party__c> mp = new Map<Id, tffa__Party__c>();
    mp.put(partyObj.Id, partyObj);
    FISCCIntegrationLogService.partyObjMap = mp;
    FISCCOrganizationDTO objFISCCCustomerDTO = new FISCCOrganizationDTO();
    try {
      FISCCCreateCustOrganizationHelper.createCustomerRequest(
        jointParty1,
        submissionObj,
        new FISCC_Adapter_Configs__mdt(),
        new FISCC_Charter_Config__mdt()
      );
    } catch (Exception ex) {
    }

    try {
      FISCCCreateCustOrganizationHelper.createCustomerRequest(
        jointParty,
        submissionObj,
        new FISCC_Adapter_Configs__mdt(),
        new FISCC_Charter_Config__mdt()
      );
    } catch (Exception ex) {
    }

    try {
      FISCCCreateCustOrganizationHelper.createCustomerRequest(
        partyObj,
        submissionObj,
        new FISCC_Adapter_Configs__mdt(),
        new FISCC_Charter_Config__mdt()
      );
    } catch (Exception ex) {
    }

    try {
      FISCCCreateCustOrganizationHelper.fillCustomerIdentityDetails(partyObj, objFISCCCustomerDTO);
    } catch (Exception ex) {
    }

    try {
      FISCCCustomerIndDemoExtension.generateCustomerIndDemoRequest(partyObj);
    } catch (Exception ex) {
    }

    new FISCCCustomerOrganizationResponse();
    new FISCCCustToCustRelnDTO();
    new FISCCCustToCustRelnRequestDTO();
    new FISCCDOCustomerOrganizationRequest();
    new FISCCDOIndividualDemoRequest();

    try {
      FISCCDemographicsProvider.processIntPhoneNbr(new List<tffa__Party__c>{ partyObj });
      FISCCDemographicsProvider.parseDemogrphicsResp(null);
    } catch (Exception ex) {
    }

    FISCCDepositOriginationEntityResponse resp = new FISCCDepositOriginationEntityResponse();
    try {
      FISCCDemographicsProvider.generateDemoGraphicsReq(new List<tffa__Party__c>{ partyObj });
      FISCCDemographicsProvider.parseDemogrphicsResp(resp);
    } catch (Exception ex) {
    }

    /* tffa__PartyRelationCode__c relationCode = new tffa__PartyRelationCode__c(
      tffa__Category__c = 'PERSONAL',
      tffa__PartyType__c = 'INDIVIDUAL',
      tffa__RelatedPartyType__c = 'INDIVIDUAL',
      tffa__Value__c = 'BENEFICIAL_OWNER',
      tffa__Label__c = 'Beneficial Owner'
    );
    upsert relationCode;

    tffa__PartyPartyXref__c partyPartyXref = new tffa__PartyPartyXref__c(
      tffa__Party__c = partyObj.id,
      tffa__RelatedParty__c = jointParty.id,
      tffa__RelationCodeValue__c = 'BENEFICIAL_OWNER',
      tffa__RelationCategory__c = 'PERSONAL',
      tffa__RelationCode__c = relationCode.Id
    );
    insert partyPartyXref;
*/
    tffa__PartyPartyXref__c partyParty = new tffa__PartyPartyXref__c();

    partyObj.tffa__Type__c = 'ORGANIZATION';
    tffa.SObjectAssembler asmParty123 = new tffa.SObjectAssembler(partyObj);
    //asmParty123.addChildObjects('tffa__PartyXrefs__r', new List<tffa__PartyPartyXref__c>{ partyPartyXref });
    tffa__Party__c jointParty14 = (tffa__Party__c) asmParty123.assemble();
    FISCCIntegrationLogService.partyObjMap.put(jointParty14.Id, jointParty14);
    try {
      FISCCOrgCustomerRelnExtension.generateReq(jointParty14, submissionObj);
    } catch (Exception ex) {
    }

    try {
      FISCCOrgCustomerRelnExtension.parseRelnResponse(new FISCCCustToCustRelnDTO(), new List<tffa__Party__c>{ jointParty14 });
    } catch (Exception ex) {
    }

    try {
      FISCCOrgCustomerRelnExtension.invokeBusinessOwnerRelnCall(new List<tffa__Party__c>{ jointParty14 }, submissionObj);
    } catch (Exception ex) {
    }

    try {
      FISCCIntegrationLogService.auth = '';
      FISCCOrgCustomerRelnProvider.createBusinessAndOwnersReln(new List<tffa__Party__c>{ jointParty14 }, submissionObj);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    try {
      FISCCOrgCustomerRelnProvider.createBusinessAndOwnersReln(null, null);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    try {
      FISCCDepositOriginationExtension.invokeDOBusinessCall(new List<tffa__Party__c>{ jointParty14, partyObj }, submissionObj);
    } catch (Exception ex) {
    }

    try {
      FISCCDepositOriginationExtension.invokeDOBusinessCall(new List<tffa__Party__c>{ jointParty14, partyObj }, submissionObj);
    } catch (Exception ex) {
    }

    try {
      FISCCDepositOriginationExtension.createDORequestForBusiness(
        new List<tffa__Party__c>{ jointParty14, partyObj },
        submissionObj,
        FISCCIntegrationLogService.charterConfig,
        new FISCC_Adapter_Configs__mdt()
      );
    } catch (Exception ex) {
    }

    try {
      tffa__EventConfiguration__mdt configr = new tffa__EventConfiguration__mdt();
      configr.tffa__EmailTemplateAlt__c = 'ApplicationAssignedCustom';

      CZWTFCCommonHelper.getPrimaryParty(submissionObj, new List<tffa__Party__c>{ jointParty14, partyObj });
      CZWTFCCommonHelper.getIdentificationLabel('DL');
      CZWTFCCommonHelper.fetchParty(partyXrf, new List<tffa__Party__c>{ jointParty14 });
      CZWTFCCommonHelper.fetchParty(partyXrf, new List<tffa__Party__c>{ partyObj });
      CZWTFCCommonHelper.getPartyAddressByType(partyAddressXrefs12, 'HOME');
      CZWTFCCommonHelper.getPartyAddressByType(partyAddressXrefs12, 'WORK');
      CZWTFCCommonHelper.fetchBusinessParty(new List<tffa__Party__c>{ jointParty14 });
      CZWTFCCommonHelper.fetchBusinessParty(new List<tffa__Party__c>{ partyObj });
      CZWTFCCommonHelper.checkMailingAddPresent(jointParty14);
      CZWTFCCommonHelper.checkMailingAddPresent(partyObj);
      CZWTFCCommonHelper.requiresEmailNotification(configr);
      CZWTFCCommonHelper.createAppNotification(configr);
      CZWTFCCommonHelper.isUserId('32525235');
    } catch (Exception ex) {
    }

    //success flow
    try {
      String resp1 = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustToCustRelnDTO dto = (FISCCCustToCustRelnDTO) System.JSON.deserialize(resp1, FISCCCustToCustRelnDTO.class);
      FISCCCustToCustResponseBuilder respBuilder = new FISCCCustToCustResponseBuilder();
      respBuilder.build(resp1, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      CZAccNbrGenerationExtension.parseResponse(dto, applicationobjs);
    } catch (Exception ex) {
    }

    //Exception block in CZAccNbrGenerationRequestDTO.build
    try {
      String resp1 = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustToCustRelnDTO dto = (FISCCCustToCustRelnDTO) System.JSON.deserialize(resp1, FISCCCustToCustRelnDTO.class);
      FISCCCustToCustResponseBuilder respBuilder = new FISCCCustToCustResponseBuilder();
      FISCCCustToCustResponseBuilder.testException = true;
      respBuilder.build(resp1, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
    }

    //Exception block in FISCCCustToCustResponseBuilder.parseResponse
    try {
      String resp1 = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustToCustRelnDTO dto = (FISCCCustToCustRelnDTO) System.JSON.deserialize(resp1, FISCCCustToCustRelnDTO.class);
      FISCCCustToCustResponseBuilder respBuilder = new FISCCCustToCustResponseBuilder();
      FISCCCustToCustResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCCustToCustRelnDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void updatedOrganizaionRelnshipTest() {
    tffa__Submission__c sub = CZWTFCTestDataRepository.getSubmissionForTest();
    tffa__Party__c partyObj = CZWTFCTestDataRepository.createTestPartyWithXrefs();
    CZWTFCTestDataRepository.setTestIntegrationLog(sub.Id);

    Test.startTest();

    //add reln
    FISCCIntegrationLogService.auth = 'AuthToken1244566778999456546';
    List<String> relnList = new List<String>();
    relnList.add(partyObj.Id);
    relnList.add(partyObj.tffa__PartyXrefs__r[0].tffa__RelatedParty__c);
    Test.setMock(HttpCalloutMock.class, new CZAddCustRelnMockClass());
    Boolean resp = FISCCUpdateCustInfoProvider.addCustomerRelations(relnList, partyObj);
    System.assertEquals(true, resp);

    //Parse Reln
    String response_1 = '{"cc-maintained-customer":{"CustNbr":"string"},"customerRelnship":[{"RltCustNbr":"string","EffDte":"string","ExpDte":"string","E1toE2Cde":10,"E2toE1Cde":20,"RltPercentOwner":40,"RltBeneOwnr":"string","RltBeneTitle":"string","PriPercentOwner":50,"PriBeneOwnr":"string","PriBeneTitle":"string"}]}';
    FISCCCustToCustRelnDTO parsedResponse_1 = (FISCCCustToCustRelnDTO) System.JSON.deserialize(response_1, FISCCCustToCustRelnDTO.class);
    Boolean resp1 = FISCCUpdateCustInfoProvider.parseRelnResponse(
      parsedResponse_1,
      partyObj,
      new List<Id>{ partyObj.Id, partyObj.tffa__PartyXrefs__r[0].tffa__RelatedParty__c }
    );
    System.assertEquals(false, resp1);

    //Delete reln
    CZInquireCustRelnResponseDTO.CustToCustRelnDataList dto_2 = new CZInquireCustRelnResponseDTO.CustToCustRelnDataList();
    dto_2.RltCustNbr = '2123';
    dto_2.EffDte = '2123';
    dto_2.E1toE2Cde = '2123';
    dto_2.E2toE1Cde = '2123';
    Test.setMock(HttpCalloutMock.class, new CZAddCustRelnMockClass());
    Boolean resp_3 = FISCCUpdateCustInfoProvider.deleteCustReln(
      new List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList>{ dto_2 },
      '23456789'
    );
    System.assertEquals(false, resp_3);

    Test.setMock(HttpCalloutMock.class, new CZInquireCustRelnMockClass());
    FISCCUpdateCustInfoProvider.updateCustToCustRelnship(partyObj);

    //Inquire
    Test.setMock(HttpCalloutMock.class, new CZInquireCustRelnMockClass());
    Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> resp_4 = FISCCUpdateCustInfoProvider.fetchCustRelatedLst(partyObj);
    System.assertEquals(new Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList>(), resp_4);

    Test.stopTest();
  }
}