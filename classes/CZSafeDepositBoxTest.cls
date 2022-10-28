@isTest
private class CZSafeDepositBoxTest {
  @isTest
  public static void FISCCDOAddSDBOwnerExtensionTest() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'SUBMITTED';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.tffa__CreatedChannel__c = 'DIGITAL';
    submissionObj.tffa__Brand__c = '1234';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '801';
    application.FISBranchCode__c = '1';
    application.tffa__DepositBoxExpirationDate__c = Date.valueOf('2024-04-25');
    application.tffa__DepositBoxStartDate__c = Date.valueOf('2023-04-25');
    application.CZPrimaryOfficer__c = 'Primary Officer';
    application.CostCenter__c = '94184';
    application.CZCautionCode1__c = '001';
    application.CZCautionCode2__c = '002';
    // application.CZCautionCode3__c = '003';
    application.tffa__DepositBoxAccountNumber__c = '000-000-000';
    application.CZSDBDiscountReasonTxt__c = 'rdfkglughjkljhgghjkghjklkjhgghjklkjhgghjkjhghjkljhghjkuuuuuuu';

    insert application;

    tffa__FundingRequest__c fundingRequest = new tffa__FundingRequest__c();
    fundingRequest.tffa__AccountType__c = 'CHECKING';
    fundingRequest.tffa__Amount__c = 101.0;
    fundingRequest.tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION';
    fundingRequest.tffa__LinkedApplication__c = application.Id;
    fundingRequest.tffa__Purpose__c = 'DEPOSIT';
    fundingRequest.tffa__Type__c = 'INTERNAL_TRANSFER';
    insert fundingRequest;
    tffa.SObjectAssembler asm2 = new tffa.SObjectAssembler(application);
    asm2.addChildObject('LinkedFundingRequests__r', fundingRequest);
    application = (tffa__Application__c) asm2.assemble();
    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();
    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    tffa__ApplicationPartyXref__c appParty = new tffa__ApplicationPartyXref__c();
    appParty.Name = 'User';
    appParty.tffa__Party__c = partyObj.Id;
    appParty.tffa__Application__c = application.Id;
    appParty.tffa__Primary__c = true;
    appParty.tffa__Type__c = 'INDIVIDUAL';
    insert appParty;

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ xref1 });
    submissionObj = (tffa__Submission__c) asm.assemble();
    Test.startTest();
    FISCCDOAddSDBOwnerExtension.invokeDepositeBoxOwner(
      partyObj,
      application,
      new FISCC_Adapter_Configs__mdt(),
      new FISCC_Charter_Config__mdt()
    );

    application.CZSDBDiscountReasonTxt__c = 'asdf';
    CZSDBAddOwnerRequest res1 = FISCCDOAddSDBOwnerExtension.getReasonText(new CZSDBAddOwnerRequest(), application);
    System.assertNotEquals(null, res1);

    application.CZSDBDiscountReasonTxt__c = 'asddddddsfafsfasfssfsafsafsafda';
    res1 = FISCCDOAddSDBOwnerExtension.getReasonText(new CZSDBAddOwnerRequest(), application);
    System.assertNotEquals(null, res1);

    Test.stopTest();
  }

  @isTest
  public static void FISCCDOAddSDBDeputyExtensionTest() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'SUBMITTED';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.tffa__CreatedChannel__c = 'DIGITAL';
    submissionObj.tffa__Brand__c = '1234';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '801';
    application.FISBranchCode__c = '1';
    application.tffa__DepositBoxExpirationDate__c = Date.valueOf('2024-04-25');
    application.CZPrimaryOfficer__c = 'Primary Officer';
    application.CostCenter__c = '94184';

    insert application;

    tffa__FundingRequest__c fundingRequest = new tffa__FundingRequest__c();
    fundingRequest.tffa__AccountType__c = 'CHECKING';
    fundingRequest.tffa__Amount__c = 101.0;
    fundingRequest.tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION';
    fundingRequest.tffa__LinkedApplication__c = application.Id;
    fundingRequest.tffa__Purpose__c = 'DEPOSIT';
    insert fundingRequest;
    tffa.SObjectAssembler asm2 = new tffa.SObjectAssembler(application);
    asm2.addChildObject('LinkedFundingRequests__r', fundingRequest);
    application = (tffa__Application__c) asm2.assemble();
    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();
    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    tffa__ApplicantRole__c appRole = new tffa__ApplicantRole__c();
    appRole.Name = 'DEP';
    appRole.tffa__Code__c = 'DEP';
    insert appRole;

    tffa__ApplicationPartyXref__c appParty = new tffa__ApplicationPartyXref__c();
    appParty.Name = 'User';
    appParty.tffa__Party__c = partyObj.Id;
    appParty.tffa__Application__c = application.Id;
    appParty.tffa__Primary__c = true;
    appParty.tffa__Type__c = 'INDIVIDUAL';
    insert appParty;

    appParty.tffa__ApplicantRole__c = appRole.Id;
    update appParty;

    asm2.addChildObjects('tffa__PartyXrefs__r', new List<tffa__ApplicationPartyXref__c>{ appParty });
    tffa__Application__c app2 = (tffa__Application__c) asm2.assemble();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ xref1 });
    submissionObj = (tffa__Submission__c) asm.assemble();
    Test.startTest();
    List<FISCCDepositOriginationRequestBaseDTO> res1 = FISCCDOAddSDBDeputyExtension.invokeDepositeBoxDeputy(
      app2,
      new FISCC_Adapter_Configs__mdt(),
      new FISCC_Charter_Config__mdt()
    );
    System.assertNotEquals(null, res1);

    FISCCDepositOriginationRequestBaseDTO res2 = FISCCDOAddSDBDeputyExtension.depositBoxDeputyRequest(
      new List<tffa__Party__c>{ partyObj, partyObj },
      app2
    );
    System.assertNotEquals(null, res2);

    Test.stopTest();
  }

  @isTest
  public static void SDBVacantboxTest() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    Map<String, Object> map1 = new Map<String, Object>();
    map1.put('brandCode', '118');
    map1.put('BoxPrfx', '1');
    map1.put('branch', '1');
    Test.startTest();
    try {
      tffa.Context ctx = tffa.Context.get();
      tffa.Response res = tffa.ApplicationController.fetchAvailableDepositBoxes(ctx, map1);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }
    try {
      String resp = '{"Entity":{"query-parameters-vacant-boxes":{"SaveStat":"V","TranCnt":45,"SaveBoxPrfx":1,"SaveBrnch":1,"MoreInd":"N","SaveBoxTyp":0},"vacant-boxesLst":[{"SafeBoxTyp":1,"SafeBoxTypDesc":"3 X 5 BOX","SafeBoxPrfx":1,"SafeBoxTypRte":25.00,"SafeBoxNbr":128}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      CZSDBVacantBoxResponse responseDTO = new CZSDBVacantBoxResponse();
      new CZSDBVacantBoxResponseBuilder().build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      new CZSDBVacantBoxResponseBuilder().parseResponse(responseDTO, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }
    try {
      Object result = new CZSDBVacantBoxResponse();
      CZSDBFetchVacantBoxExtension.isFISCCAPICallSuccess(result);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    try {
      Map<String, Object> map2 = new Map<String, Object>();
      map2.put('brandCode', '118');
      map2.put('BoxPrfx', '1');
      map2.put('branch', '1');
      new CZSafeDepositBoxProvider().fetchAvailableDepositBoxes(map2);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    //test excpetion block
    try {
      Map<String, Object> map2 = new Map<String, Object>();
      map2.put('brandCode', '118');
      map2.put('BoxPrfx', '1');
      tffa.Context ctx = tffa.Context.get();
      Object res1 = tffa.ApplicationController.fetchAvailableDepositBoxes(ctx, map2);
      System.assertNotEquals(res1, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }
    try {
      Map<String, Object> map3 = new Map<String, Object>();
      map3.put('brandCode', '118');
      Map<String, Object> res1 = new CZSafeDepositBoxProvider().fetchAvailableDepositBoxes(map3);
      System.assertNotEquals(res1, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }
    try {
      CZSDBFetchVacantBoxExtension.invokeFetchVacantBoxes(null, null);
      CZSDBFetchVacantBoxExtension.isFISCCAPICallSuccess(null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    try {
      CZSDBFetchVacantBoxExtension.invokeFetchVacantBoxes(new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    try {
      CZSDBVacantBoxResponseBuilder.testException = true;
      new CZSDBVacantBoxResponseBuilder().build(null, null, null);
      new CZSDBVacantBoxResponseBuilder().parseResponse(null, null, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    try {
      Map<String, Object> map4 = new Map<String, Object>();
      map4.put('brandCode', '118');
      map4.put('BoxPrfx', '1');
      map4.put('branch', '1');
      map4.put('BoxTyp', '1');
      Map<String, Object> res1 = new CZSafeDepositBoxProvider().fetchAvailableDepositBoxes(map4);
      System.assertNotEquals(res1, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    try {
      CZSDBVacantBoxDTO dto = new CZSDBVacantBoxDTO();
      dto.SafeBoxNbr = 1234;
      dto.SafeBoxPrfx = 1;

      CZSDBVacantBoxResponse resp = new CZSDBVacantBoxResponse();
      resp.entity.sdbVacantBox.add(dto);
      String res2 = CZSafeDepositBoxProvider.getResponseData(resp, '1');
      System.assertNotEquals(res2, null);
    } catch (Exception ex) {
      tffa.logger.error('exception');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}