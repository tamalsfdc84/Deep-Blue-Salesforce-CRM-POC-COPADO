@isTest
private class CZWTFCCustomMetadataRepositoryTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    Nacha_Config__mdt result1 = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
    System.assertNotEquals(result1, null);
    Test.stopTest();
  }

  @isTest
  public static void testHelperRepository() {
    tffa__Promotion__c promo = new tffa__Promotion__c();
    promo.tffa__Code__c = 'Test';
    promo.InterestPlanCode__c = '1244';
    promo.Name = 'Test';
    insert promo;

    tffa__Promotion__c promo1 = new tffa__Promotion__c();
    promo1.tffa__Code__c = 'Test1';
    promo1.Name = 'Test1';
    insert promo1;

    Test.startTest();
    tffa__ProductTerm__c term = CZWTFCHelperRepository.findProductTerms('qwrtty', 12.0);
    System.assertEquals(null, null);

    String result = CZWTFCHelperRepository.fetchPromotionPlanCode('Test1');
    System.assertEquals(null, null);

    result = CZWTFCHelperRepository.fetchPromotionPlanCode('Test');
    System.assertNotEquals(result, null);
    Test.stopTest();
  }

  @isTest
  public static void helperRepoTest() {
    InterestPlanDetails__c intPln750 = new InterestPlanDetails__c();
    intPln750.IntPlnCde__c = '750';
    intPln750.BrandCode__c = '1234';
    intPln750.RteSchedInd__c = 'N';
    intPln750.APY__c = 0.01;
    insert intPln750;

    Test.startTest();
    CZWTFCHelperRepository.fetchLocationById('qwrtty');
    CZWTFCHelperRepository.fetchBrandById('Test1');
    CZWTFCHelperRepository.fetchSubBrandByextId('test', 'Test');
    CZWTFCHelperRepository.fetchSubBrandByBrand('qwrtty');
    CZWTFCHelperRepository.fetchBrandLocByBrand('Test1');
    CZWTFCHelperRepository.fetchBrandLocByLoc('Test');
    CZWTFCHelperRepository.fetchBrandLocByextId('qwrtty');
    CZWTFCHelperRepository.fetchProductById('Test1');
    CZWTFCHelperRepository.fetchfundMatByextId('Test', 'Test1', 'Test2', 1);

    CZWTFCHelperRepository.fetchProdMatByextId('Test1');
    CZWTFCHelperRepository.fetchAppDecMatBySort(12, 'Test');
    CZWTFCHelperRepository.fetchpromoById('qwrtty');
    CZWTFCHelperRepository.fetchPromoPlan('Test1', 'Test2', 'test');
    CZWTFCHelperRepository.fetchPromoPlanByPromo('Test');

    CZWTFCHelperRepository.fetchLocationByAddAndCode('Test1', 'test');
    CZWTFCHelperRepository.fetchAddById('122');
    CZWTFCHelperRepository.fetchAddByExtId('qwrtty');
    CZWTFCHelperRepository.fetchRecommendConfigByName('Test1', 'Testt');
    CZWTFCHelperRepository.fetchdiscCheckListByName('Test', 'test');

    CZWTFCHelperRepository.fetchdiscCheckListById('122');
    CZWTFCHelperRepository.fetchdiscTempById('qwrtty');
    CZWTFCHelperRepository.fetchdiscTempByExtId('Test1', 'testt');
    CZWTFCHelperRepository.fetchAddOnServListByName('Test', 'Test');

    CZWTFCHelperRepository.fetchAddOnServListById('122');
    CZWTFCHelperRepository.fetchAddOnServById('qwrtty');
    CZWTFCHelperRepository.fetchRecommendConfigById('Test1');
    CZWTFCHelperRepository.fetchRecommendItemByExtId('Test', 'Test');

    CZWTFCHelperRepository.fetchAddOnServiceItemByExtId('122', 'test');

    CZWTFCHelperRepository.fetchProdXrefById('Test', 'Test');

    CZWTFCHelperRepository.fetchProdMatById('122', 'test', 1);

    CZWTFCHelperRepository.getFundingMat('Test Chanel');
    CZWTFCHelperRepository.fetchConvergeConfig('Test Chanel');
    CZWTFCHelperRepository.fetchUniqueInterestPlanCodes();
    CZWTFCHelperRepository.getIntPlanDtlsNonTiered('Test Chanel', '', '');
    CZWTFCHelperRepository.getIntPlanDtlsTiered('Test Chanel', '', '', 2, 2);
    CZWTFCHelperRepository.fetchInterestPlanDetailsOrderByMinBal('750', '1234');
    CZWTFCHelperRepository.deleteUnusedInterestPlanDetails('1234', new List<String>{ '1234' });
    CZWTFCHelperRepository.fetchInterestPlanDetails('', '');
    CZWTFCHelperRepository.fetchMulesoftAdapterConfig('');
    CZWTFCHelperRepository.getTFndFISMapping('', '');
    CZWTFCHelperRepository.getTFndFISMappingByType('');

    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';

    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;
    CZWTFCHelperRepository.fetchAccountPrefByType(new List<tffa__Party__c>{ partyObj }, 'Test type');
    CZWTFCHelperRepository.fetchConvergeCharterConfig('Test');
    CZWTFCHelperRepository.getAgentDetailsByUserId(userinfo.getuserId());
    CZWTFCHelperRepository.fetchOfficerDetails('1234');
    CZWTFCHelperRepository.getBrandLocations();
    CZWTFCHelperRepository.fetchUploadFileHistory('', '');
    CZWTFCHelperRepository.fetchApplicantRoleMap();
    list<tffa__DisclosureParticipant__c> dpList = new List<tffa__DisclosureParticipant__c>();
    CZWTFCHelperRepository.saveDisclosureParticipant(dpList);
    CZWTFCHelperRepository.findByFacts('New event');
    CZWTFCHelperRepository.fetchFISHolidayDetails('');
    Deluxe_Creds__mdt DeluxeCreds = CZWTFCHelperRepository.fetchDeluxeConfig('');
    System.assertEquals(DeluxeCreds, null);
    Test.stopTest();
  }
  @isTest
  public static void testDocumentCreateTest() {
    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';

    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;

    ContentVersion contentVersion = new ContentVersion(
      Title = 'Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert contentVersion;
    List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

    //create ContentDocumentLink  record
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.LinkedEntityId = partyObj.id;
    cdl.ContentDocumentId = documents[0].Id;
    cdl.shareType = 'V';
    insert cdl;
    Test.startTest();
    CZWTFCHelperRepository.getDoc('Penguins');
    CZWTFCHelperRepository.fetchContentDocumentId(new List<String>{ documents[0].id });
    CZWTFCHelperRepository.getFolder('test floder');

    CZWTFCHelperRepository.deleteContentDocument('Penguins');
    CZWTFCHelperRepository.deleteContentDocumentById(new List<String>{ documents[0].id });
    System.assertNotEquals(cdl, null);
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
    tffa__Submission__c subRec = [
      SELECT id, (SELECT id FROM tffa__Applications__r), (SELECT id, tffa__Party__c FROM tffa__PartyXrefs__r)
      FROM tffa__Submission__c
      LIMIT 1
    ];
    CZWTFCHelperRepository.findAppPartyByApp(subRec);
    CZWTFCHelperRepository.findAccountPrefBySub(subRec);
    CZWTFCHelperRepository.findAdditionalPrefBySub(subRec.Id);
    //CZWTFCHelperRepository.findAddOnServiceByCodeandType('Test','Test');
    CZWTFCHelperRepository.findAdditionalPrefByParty(partyObj.Id);
    CZWTFCHelperRepository.findStipByParty(partyObj.Id);
    CZWTFCHelperRepository.fetchCampaignConfigs('Test');
    CZWTFCHelperRepository.fetchAdobeCampaignApiConfig('test');
    CZWTFCHelperRepository.fetchWintrustEnvConfig();
    CZWTFCHelperRepository.fetchEnvConfig();
    CZWTFCHelperRepository.removeDDByPartyId(partyObj.Id, new List<String>{ 'test type' });
    CZWTFCHelperRepository.fetchDSSConfig('Test');
    CZWTFCHelperRepository.getDueDiligenceList(partyObj.Id);
    CZWTFCHelperRepository.getDueDiligenceObj('Test', partyObj.Id);
    CZWTFCHelperRepository.getBeneficiaryById('');

    System.assertEquals(null, null, 'Success');
    Test.stopTest();
  }
}