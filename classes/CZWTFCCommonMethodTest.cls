@isTest
public with sharing class CZWTFCCommonMethodTest {
  @isTest
  public static void cardRequestGenTest() {
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
    application.tffa__Term__c = 12;
    application.InterestPlanCode__c = '123';
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

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = jointParty1.Id,
      tffa__Application__c = application.Id,
      tffa__Code__c = '12123',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;

    List<FISCC_Charter_Config__mdt> lstCharterConfig1 = FISCCTestRepositoryHelper.getCharterConfigMetadata1('Brand_118');

    tffa__FundingRequest__c fundingReqInternal = new tffa__FundingRequest__c();
    fundingReqInternal.Name = '';
    fundingReqInternal.tffa__Status__c = 'IN_PROGRESS';
    fundingReqInternal.tffa__Type__c = 'INTERNAL_TRANSFER';
    fundingReqInternal.tffa__Amount__c = 122;
    fundingReqInternal.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReqInternal.CZSourceAccountBrand__c = '380';
    fundingReqInternal.tffa__LinkedApplication__c = application.Id;
    insert fundingReqInternal;

    tffa.SObjectAssembler asmappInternal = new tffa.SObjectAssembler(application);
    asmappInternal.addChildObjects('LinkedFundingRequests__r', new List<tffa__FundingRequest__c>{ fundingReqInternal });
    tffa__Application__c appObjInternal = (tffa__Application__c) asmappInternal.assemble();

    tffa__ApplicationPartyXref__c appPartyxref2 = new tffa__ApplicationPartyXref__c();
    appPartyxref2.tffa__Party__c = partyObj.Id;
    appPartyxref2.tffa__Application__c = appObjInternal.id;
    appPartyxref2.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref2.Name = 'Test';
    insert appPartyxref2;

    Test.startTest();
    FISCCDOPhoneNumberRequest phoneNoDto = new FISCCDOPhoneNumberRequest();
    //Test case for update customer info
    try {
      FISCCIntegrationLogService.setSubmissionObj(submissionObj.Id);
      CZWTFCIntegrationLogService.setIntegrationLog(submissionObj.Id);
      FISCCIntegrationLogService.setCurrentLog('Test');
      CZWTFCIntegrationLogService.setCurrentLogItem('Test', jointParty1.Id, false);
      FISCCDepositOriginationProvider.updateCustomerInformation(jointParty1);
    } catch (Exception ex) {
    }

    //Test case for card creation request
    try {
      FISCCCardBaseIntegrationHelper.getCardCreationRequest(partyObj, accPref, application, lstCharterConfig1[0]);
      FISCCCardBaseIntegrationExtension.invokeCardCreation(
        partyObj,
        accPref,
        application,
        new FISCC_Adapter_Configs__mdt(),
        lstCharterConfig1[0]
      );
    } catch (Exception ex) {
    }
    //Test case for card and customer reln request
    try {
      FISCCCardBaseIntegrationHelper.getCardToCustRelationRequest(partyObj, accPref, application);
      FISCCCardBaseIntegrationExtension.invokeCardToAccRelation(
        partyObj,
        accPref,
        application,
        new FISCC_Adapter_Configs__mdt(),
        lstCharterConfig1[0]
      );
    } catch (Exception ex) {
    }

    //Test case for card no generation request
    try {
      FISCCCardBaseIntegrationHelper.getGenerateCardNoRequest(partyObj, accPref, lstCharterConfig1[0]);
    } catch (Exception ex) {
    }

    //Test case for cust demographics request
    try {
      FISCCCardBaseIntegrationHelper.getUpdateCustDemographicsRequest(partyObj, accPref, application);
      FISCCCardBaseIntegrationExtension.invokeupdateCustomerDemographics(
        partyObj,
        accPref,
        application,
        new FISCC_Adapter_Configs__mdt(),
        lstCharterConfig1[0]
      );
    } catch (Exception ex) {
    }

    try {
      FISCCCardBaseIntegrationHelper.isAPICallSuccess(new List<FISCCMsgListDTO>());
      FISCCMetaDataDTO msgDTO = new FISCCMetaDataDTO();
      WTFCObjectManagerRepository repo = new WTFCObjectManagerRepository();
      WTFCObjectManagerRepository.doUpsertObject(fundingReqInternal);
    } catch (Exception ex) {
    }

    //Test case for deposit creation request and response
    try {
      FISCCCDDepositCreationExtension.testConfigFlow = true;
      FISCCCDDepositCreationExtension.generateRequest(appObjInternal);
      FISCCDepositCreationResponseDTO dto = new FISCCDepositCreationResponseDTO();
      dto.entity.newCertificateDeposit.DPTDId = 124;
      FISCCCDDepositCreationExtension.parseCDDepositResponse(dto, appObjInternal);
      FISCCCDDepositCreationExtension.parseCDDepositResponse('1334', appObjInternal);
    } catch (Exception ex) {
    }

    //submission repo test
    try {
      CZWTFCSubmissionRepository.findSubmissionAndDisclosure();
      CZWTFCSubmissionRepository.getAccountDetailsOdDisclosures(submissionObj.Id);
    } catch (Exception ex) {
    }

    try {
      StipCustomMetadataRepository.getAppPartyStip(partyObj.Id);
    } catch (Exception ex) {
    }

    try {
      Blob body = Blob.valueOf('test');
      ACHContentHelper achContentHelper = new ACHContentHelper();
      achContentHelper.uploadFile(body, 'filename', 'foldername', 'id');
    } catch (Exception ex) {
    }

    try {
      tffa__Brand__c brandObj = new tffa__Brand__c();
      brandObj.Name = '118';
      brandObj.tffa__Code__c = '118';
      brandObj.FooterLogo__c = 'test';
      brandObj.HeaderLogo__c = 'test';
      insert brandObj;

      Database.executeBatch(new ACHFileGenBatch(), 1);

      SubBrand__c subB = new SubBrand__c();
      subB.Brand__c = brandObj.Id;
      subB.Name = 'Test';
      insert subB;

      subB.Name = 'Test1';
      update subB;

      StipCustomMetadataRepository.getStipulation('id');
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.generateCustomerCreateRequest(submissionObj, partyObj);
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getPartyDetails(partyObj);
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getIdentifiers(partyObj);
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getCommunication(partyObj);
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getAccountRelationShip(appObjInternal, partyObj);
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getAddress(partyObj);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  //Test case for mock callout classes
  @isTest
  public static void calloutTestCase() {
    Test.startTest();

    HttpRequest req = new HttpRequest();
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    req.setEndpoint('test');
    req.setMethod('POST');

    try {
      Test.setMock(HttpCalloutMock.class, new FISCCCDDepositMockClass());

      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new FISCCDlrTransMockClass());
      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new FISCCFundHoldMockClass());
      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new FISSCCCreateDDMockClass());
      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new FISPasswordChangeMockClass());
      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new FISCCImmediateTfrMockClass());
      res = h.send(req);
      Test.setMock(HttpCalloutMock.class, new CZWTFCElavonTokenMockClass());
      res = h.send(req);

      String json = '{"member":{"aggregated_at":"12345","connection_status":"pass"}}';
      FISCCDebitCardAccRelResponseDTO.parse(json);
      FISCCDebitCardNoGenResponseDTO.parse(json);
      FISCCDebitCardCustDetailsResponseDTO.parse(json);
      FISCCDebitCardCreationResponseDTO.parse(json);
      FISCCMultiKeywordsResponseDTO.parse(json);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void pdfConverterTestCls() {
    Test.startTest();
    ApexPages.StandardController stdController;
    CZWTFCDisclosurePdfExtension pdfExt = new CZWTFCDisclosurePdfExtension(stdController);
    CZWTFCDisclosurePdfExtension.testException = true;
    CZWTFCDisclosurePdfExtension pdfExt1 = new CZWTFCDisclosurePdfExtension(stdController);
    Test.stopTest();
  }

  @isTest
  public static void testMethod1() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Address__c addr = new tffa__Address__c();
    addr.tffa__Line1__c = '2311 Main Street';
    addr.tffa__Line2__c = '';
    addr.tffa__State__c = 'GA';
    addr.tffa__City__c = 'Columbus';
    addr.tffa__ZipCode__c = '31901345';
    insert addr;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(party);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());

    asmParty.addChildObject('tffa__Employments__r', CZWTFCTestDataRepository.createEmployment());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    party = (tffa__Party__c) asmParty.assemble();
    insert party;

    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    partyList.add(party);

    tffa__Identification__c identification = new tffa__Identification__c();
    identification.tffa__IssuingState__c = 'CA';
    identification.tffa__IdentificationNumber__c = 'Y3676237';
    identification.tffa__ExpirationDate__c = Date.newInstance(2038, 10, 12);
    identification.tffa__IssueDate__c = Date.newInstance(2014, 4, 12);
    identification.tffa__Party__c = party.id;
    identification.tffa__Type__c = 'DL';
    insert identification;

    tffa__PartyAddressXref__c partyAddrXref = new tffa__PartyAddressXref__c();
    partyAddrXref.tffa__Party__c = party.id;
    partyAddrXref.tffa__Type__c = 'Home';
    partyAddrXref.tffa__Address__c = addr.id;
    insert partyAddrXref;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Type__c = 'INDIVIDUAL',
      tffa__Primary__c = true
    );
    insert subPartyXref;

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c(tffa__Submission__c = sub.id, tffa__Amount__c = 100.0);
    insert fundingReq;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED',
      tffa__AdverseActionNoticeRequired__c = true
    );
    insert app;

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

    FISCCObjectManagerRepository.doUpsertAccountPrefObj(new List<tffa__AccountPreference__c>{ accPref });

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.CIPrmyOffcrNbr__c = '1000';
    insert brandObj;

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

    Test.startTest();

    try {
      CZWTFCApplicationEventExtension obj1 = new CZWTFCApplicationEventExtension();
      obj1.fetchOnlineBankingText('ONLINE_BANKING_SUCCESS_TEXT', brandObj);
      obj1.fetchOnlineBankingText('ONLINE_BANKING_FAILURE_TEXT', brandObj);
      obj1.fetchOnlineBankingText('ONLINE_BANKING_JOINT_NOT_PRESENT_TEXT', brandObj);
      obj1.fetchOnlineBankingText('test', brandObj);
    } catch (Exception ex) {
    }

    try {
      CZWTFCAuthenticationService.getLoginType('DP_ACCOUNT');
      CZWTFCAuthenticationService.getLoginType('LOAN_ACCOUNT');
      CZWTFCAuthenticationService.getLoginType('DEBIT_CARD');
      CZWTFCAuthenticationService.getLoginType('CUSTOMER_SEARCH');
      CZWTFCAuthenticationService.getLoginType('test');
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXSSOAPIHelper.onError(new Map<String, Object>());
    } catch (Exception ex) {
    }

    try {
      FISCCTestRepositoryHelper.getAdapterConfigMetadata('test');
      FISCCDOCustomerEmailExtension.customerEmailRequest(null, null, null);
      FISCCDOGenerateDepositAccNumberExtension.createDepositAccountNumberRequest(null, null, null, null);
      CZWTFCMXOpenNexusServiceProvider.invokeAPI(null);
      CZWTFCMXCreateUserServiceProvider.invokeCreateUserAPI(null);
      CZWTFCMXCreateUserService.parseResponse('test');
    } catch (Exception ex) {
    }

    try {
      MDMCustomerCreateExtension.getPartySuffixData('I');
      MDMCustomerCreateExtension.getPartySuffixData('Jr');
      MDMCustomerCreateExtension.isPreferredContactNumber('MOBILE', 'MBL');
      MDMCustomerCreateExtension.isPreferredContactNumber('WORK', 'WRK');
      MDMCustomerCreateExtension.createCustomer(null, null);
    } catch (Exception ex) {
    }

    try {
      String json = '{"user":{"id":"12345"}, "error":{"message":"12345"}}';
      CZWTFCMXCreateUserService.parseResponse(json);
    } catch (Exception ex) {
    }

    try {
      FISCCIntegrationLogRepository.findApplicationPartyXrefWithId('test');
      FISCCIntegrationLogRepository.findBrandWithChildObjects(new List<Id>{ brandObj.Id });
      FISCCIntegrationLogRepository.findCharterConfig('test');
      FISCCIntegrationLogRepository.findLocationByLocationIDs(new List<String>{ objLoc.Id });
    } catch (Exception ex) {
    }

    try {
      tffa__Disclosure__c disObj = new tffa__Disclosure__c();
      disObj.tffa__EventName__c = 'AccountDetails_OD';
      disObj.tffa__Label__c = '<div>{Product_Name}</div> <div>Standard Overdraft Practice: <b>{STD_OPT}</b> </div> <div>ATM and Non-Recurring Debit Card Transactions: <b>{ATM_OPT}</b></div> <div>Overdraft Protection from another Deposit Account: <b>{OD_OPT}</b></div>';
      disObj.tffa__Type__c = 'INTERNAL_CONTENT';
      disObj.tffa__Code__c = 'eSignDisclosure_AllProd_AllBrand';
      disObj.tffa__Submission__c = sub.Id;
      disObj.tffa__Accepted__c = true;
      disObj.tffa__DocumentUrl__c = '/file-asset/dt_eSignDisclosureAllProdAllBrand?v=1&oid=00D3F000000bB4uUAE';
      insert disObj;

      FCMHelperRepository.findContentVersionBySubmissionId(new List<String>{ sub.Id });
    } catch (Exception ex) {
    }

    try {
      new CZWTFCSubmissionEventExtension('Submission_Submitted').post(sub);
    } catch (Exception ex) {
    }

    try {
      FISCCIntegrationLogService.setSubmissionObj(sub.Id);
      FISCCIntegrationLogService.auth = 'test.auth';
      FISCCIntegrationLogService.contentVersionData = Blob.valueOf('test');
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('UploadFCMDocument');
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');
      FISCCCoreAPICall.execute('test', adapterConfig, charterConfig);
    } catch (Exception ex) {
    }

    try {
      FISCCIntegrationLogService.setSubmissionObj(sub.Id);
      FISCCIntegrationLogService.auth = 'test.auth';
      FISCCIntegrationLogService.applicationCode = 'FCM';
      FISCCIntegrationLogService.contentVersionData = Blob.valueOf('test');
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('AuthorizationToken');
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');
      adapterConfig.LogRequest__c = true;
      adapterConfig.IsEncrypted__c = true;
      adapterConfig.IsIBSAuthRequired__c = true;
      adapterConfig.IsEncrypted__c = true;
      FISCCCoreAPICall.execute(null, adapterConfig, charterConfig);

      adapterConfig.IsEncrypted__c = false;
      FISCCCoreAPICall.execute(null, adapterConfig, charterConfig);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testMethod3() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED',
      tffa__AdverseActionNoticeRequired__c = true,
      FISBranchCode__c = '1'
    );
    insert app;
    Test.startTest();
    FISCCDOGenerateDepositAccNumberExtension.createDepositAccountNumberRequest(
      sub,
      app,
      new FISCC_Adapter_Configs__mdt(),
      new FISCC_Charter_Config__mdt()
    );
    FISCCDOGenerateDepositAccNumberExtension.createDepositAccountNumberRequest(
      sub,
      null,
      new FISCC_Adapter_Configs__mdt(),
      new FISCC_Charter_Config__mdt()
    );
    Test.stopTest();
  }

  @isTest
  public static void testMethod4() {
    Test.startTest();
    new CZMDMCustomerCreationResponseDTO();
    new MDMAccountCreateRequest();
    CZNCRD3PartyAuthenticationExt authExt = new CZNCRD3PartyAuthenticationExt();
    try {
      authExt.authenticate(new Map<String, Object>());
    } catch (Exception ex) {
    }

    try {
      Map<String, Object> mp = new Map<String, Object>();
      mp.put('UserId__c', '1234');
      mp.put('OnlineBankingEntityId__c', '1234');
      authExt.initialize(mp);
    } catch (Exception ex) {
    }

    try {
      Map<String, Object> mp = new Map<String, Object>();
      mp.put('UserId__c', '1234');
      mp.put('OnlineBankingEntityId__c', '1234');
      authExt.validateOnlineBankingUserId(mp);
    } catch (Exception ex) {
    }
    Test.stopTest();
  }

  @isTest
  public static void dueDiligenceServiceExtTest() {
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
    jointParty.tffa__FraudStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    insert jointParty;

    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    dueDiligence.Name = 'FIS OOW';
    dueDiligence.tffa__Type__c = 'IDA';
    dueDiligence.tffa__Status__c = 'CHALLENGED';
    dueDiligence.tffa__Provider__c = 'FIS IDA';
    dueDiligence.tffa__ExternalQuestionnaireId__c = '12323';
    dueDiligence.tffa__ConversationId__c = '1233';
    dueDiligence.tffa__Party__c = jointParty.Id;
    insert dueDiligence;

    Test.startTest();
    try {
      /**
       * Test case for CZWTFCDueDiligenceServiceExt
       */
      CZWTFCDueDiligenceServiceExt ddServiceExt = new CZWTFCDueDiligenceServiceExt();
      ddServiceExt.postVerify(new List<tffa__Party__c>{ jointParty }, new Map<String, Object>());
      ddServiceExt.postUpdateStatus(new List<tffa__DueDiligence__c>{ dueDiligence }, new Map<String, Object>());
    } catch (Exception ex) {
    }
  }
}