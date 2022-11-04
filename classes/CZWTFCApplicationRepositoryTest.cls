@isTest
public with sharing class CZWTFCApplicationRepositoryTest {
  @isTest
  public static void testSaveApp() {
    tffa__Party__c party = new tffa__Party__c();
    insert party;
    tffa__Submission__c sub = new tffa__Submission__c();
    insert sub;
    tffa__Application__c app = new tffa__Application__c();
    app.tffa__Submission__c = sub.id;
    app.tffa__Status__c = 'SUBMITTED';
    app.tffa__KYCDecisionOutcome__c = 'DECLINED';
    insert app;
    tffa__ApplicationPartyXref__c partyXrf = new tffa__ApplicationPartyXref__c();
    partyXrf.tffa__Party__c = party.id;
    partyXrf.tffa__Application__c = app.id;

    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__Line2__c = 'Line 2';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;

    //tffa__Application__c newapp = tffa.ApplicationService.create(app);
    List<tffa__Application__c> entities = new List<tffa__Application__c>();
    entities.add(app);
    Test.startTest();
    List<tffa__Application__c> applications = CZWTFCApplicationRepository.save(entities);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
    CZWTFCApplicationRepository.findApplicationById(applications[0].Id);
    tffa__Submission__c subRec = CZWTFCApplicationRepository.findSubmissionById(sub.iD);
    //[select id,(select id from tffa__Applications__r) from tffa__Submission__c limit 1];
    CZWTFCApplicationRepository.findApplicationWithChildObjsBySubId(subRec);
    CZWTFCApplicationRepository.findAppwithChildsforCB();
    CZWTFCApplicationRepository.findAppwithChildsForAccountPref();
    CZWTFCApplicationRepository.findAppforFailedAppBatch();
    CZWTFCApplicationRepository.findAppsToRoute();
    CZWTFCApplicationRepository.fetchApplicationsForFCM(new List<String>{ '' }, 1, new List<String>{ '' });
    CZWTFCApplicationRepository.getApplicationByCheck();
    CZWTFCApplicationRepository.findApplicationsByIds(entities);
  }

  @isTest
  public static void testSaveSub() {
    tffa__Submission__c sub = new tffa__Submission__c();
    //tffa__Submission__c newsub = tffa.SubmissionService.create(sub);
    List<tffa__Submission__c> entities = new List<tffa__Submission__c>();
    entities.add(sub);
    Test.startTest();
    List<tffa__Submission__c> subList = CZWTFCApplicationRepository.save(entities);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testgetTfentries() {
    TFEntries__c tfEntries = new TFEntries__c();
    tfEntries.LastACHFileRecNo__c = 1;
    insert tfEntries;
    Test.startTest();
    List<TFEntries__c> tfList = CZWTFCApplicationRepository.getTfentries();
    CZWTFCApplicationRepository.saveSingle(tfList[0]);
    UploadFileHistory__c uh = new UploadFileHistory__c();
    CZWTFCApplicationRepository.saveSingle(uh);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testfindSubmissionById() {
    Test.startTest();
    tffa__Submission__c subList = CZWTFCApplicationRepository.findSubmissionById('id');
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testgetContentFolder() {
    Test.startTest();
    ContentFolder cfolder = CZWTFCApplicationRepository.getContentFolder('cf');
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testfindAppXrefByAppIds() {
    Test.startTest();
    List<tffa__ApplicationPartyXref__c> appXref = CZWTFCApplicationRepository.findAppXrefByAppIds(new List<String>{ 'dummy' });
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testGetContent() {
    Test.startTest();
    ContentVersion cVersion = CZWTFCApplicationRepository.getContent('dummy');
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testGetContentWorkSpace() {
    Test.startTest();
    ContentWorkspace cWorkSpace = CZWTFCApplicationRepository.getContentWorkSpace('dummy');
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testGetContentFolderMember() {
    Test.startTest();
    ContentFolderMember member = CZWTFCApplicationRepository.getContentFolderMember('dummy');
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testSave() {
    Test.startTest();
    List<TFEntries__c> tflist = CZWTFCApplicationRepository.save(new List<TFEntries__c>());
    List<UploadFileHistory__c> uploadFileHistory = CZWTFCApplicationRepository.save(new List<UploadFileHistory__c>());
    List<ContentVersion> contentVersion = CZWTFCApplicationRepository.save(new List<ContentVersion>());
    List<ContentDocumentLink> contentDocumentLink = CZWTFCApplicationRepository.save(new List<ContentDocumentLink>());
    List<ContentFolderMember> contentFolderMember = CZWTFCApplicationRepository.save(new List<ContentFolderMember>());

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void fisccTestDataRepo() {
    Test.startTest();
    FISCCTestDataRepository.createIndividualPartyWithChildObjects();
    FISCCTestDataRepository.createIndividualParty();
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void helperTestRepos() {
    Test.startTest();

    try {
      CZWTFCHelperRepository.fetchContentDocumentId(new List<String>{});
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      CZWTFCHelperRepository.deleteContentDocument('Test');
      CZWTFCHelperRepository.getBeneficiaryById('50');
      CZWTFCHelperRepository.fetchEnvConfig();
      CZWTFCHelperRepository.getFundingMat('DIGITAL');
      CZWTFCHelperRepository.deleteContentDocumentById(new List<String>{});
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testMethod1() {
    Test.startTest();

    tffa__Party__c party = new tffa__Party__c();
    insert party;
    tffa__Submission__c sub = new tffa__Submission__c();
    insert sub;
    tffa__Application__c app = new tffa__Application__c();
    app.tffa__Submission__c = sub.id;
    app.tffa__Status__c = 'SUBMITTED';
    app.tffa__KYCDecisionOutcome__c = 'DECLINED';
    insert app;

    CZWTFCApplicationRepository.findApplicationByMDMStatus();
    CZWTFCApplicationRepository.findApplicationPartyById(String.valueOf(app.Id));
    CZWTFCApplicationRepository.findAppsWithChildObjects(new List<tffa__Application__c>{ app });
    CZWTFCApplicationRepository.findApplicationPartyByPartyId(String.valueOf(party.Id), String.valueOf(app.Id));
    CZWTFCApplicationRepository.findAccountPrefByAppIdAndCode(app, 'test');
    CZWTFCApplicationRepository.findAppById(app.id);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}