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

    //tffa__Application__c newapp = tffa.ApplicationService.create(app);
    List<tffa__Application__c> entities = new List<tffa__Application__c>();
    entities.add(app);
    Test.startTest();
    List<tffa__Application__c> applications = CZWTFCApplicationRepository.save(entities);
    Test.stopTest();
  }

  @isTest
  public static void testSaveSub() {
    tffa__Submission__c sub = new tffa__Submission__c();
    //tffa__Submission__c newsub = tffa.SubmissionService.create(sub);
    List<tffa__Submission__c> entities = new List<tffa__Submission__c>();
    entities.add(sub);
    Test.startTest();
    List<tffa__Submission__c> subList = CZWTFCApplicationRepository.save(entities);
    Test.stopTest();
  }

  @isTest
  public static void testgetTfentries() {
    Test.startTest();
    List<TFEntries__c> tfList = CZWTFCApplicationRepository.getTfentries();
    Test.stopTest();
  }

  @isTest
  public static void testfindSubmissionById() {
    Test.startTest();
    tffa__Submission__c subList = CZWTFCApplicationRepository.findSubmissionById('id');
    Test.stopTest();
  }

  @isTest
  public static void testgetContentFolder() {
    Test.startTest();
    ContentFolder cfolder = CZWTFCApplicationRepository.getContentFolder('cf');
    Test.stopTest();
  }

  @isTest
  public static void testfindAppXrefByAppIds() {
    Test.startTest();
    List<tffa__ApplicationPartyXref__c> appXref = CZWTFCApplicationRepository.findAppXrefByAppIds(new List<String>{ 'dummy' });
    Test.stopTest();
  }

  @isTest
  public static void testGetContent() {
    Test.startTest();
    ContentVersion cVersion = CZWTFCApplicationRepository.getContent('dummy');
    Test.stopTest();
  }

  @isTest
  public static void testGetContentWorkSpace() {
    Test.startTest();
    ContentWorkspace cWorkSpace = CZWTFCApplicationRepository.getContentWorkSpace('dummy');
    Test.stopTest();
  }

  @isTest
  public static void testGetContentFolderMember() {
    Test.startTest();
    ContentFolderMember member = CZWTFCApplicationRepository.getContentFolderMember('dummy');
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

    Test.stopTest();
  }

  // @isTest
  // public static void testSaveSingle() {
  //   Test.startTest();

  //   tffa__Submission__c submissionObj = CZWTFCTestDataRepository.makeData();
  //   submissionObj.tffa__Status__c = CZWTFCKYCConstants.SUBMISSION_IN_PROGRESS;
  //   update submissionObj;

  //   tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

  //   //Inserting products
  //   createCheckingProduct1();

  //   //tffa__Application__c checkingApp = CZWTFCTestDataRepository.createCheckingApplication();
  //   tffa__Application__c checkingApp = new tffa__Application__c();
  //   checkingApp.tffa__ProductCategory__c = 'CHECKING';
  //   checkingApp.tffa__ProductCode__c = '54';
  //   checkingApp.tffa__Submission__c = submissionObj.id;
  //   insert checkingApp;
  //   tffa__Application__c app = CZWTFCApplicationRepository.findApplicationWithId(checkingApp.Id);
  //   Test.stopTest();
  // }

  @isTest
  public static tffa__Product__c createCheckingProduct1() {
    tffa__Product__c product = new tffa__Product__c();
    product.tffa__Category__c = 'CHECKING';
    product.tffa__Code__c = '54';
    product.Name = 'Super Checking';
    product.tffa__ImageUrl__c = 'flexible_business.png';
    product.tffa__Description__c = '&#10003 Interest Bearing Checking<br/><br/>&#10003 $100 Minimum Opening Deposit<br/><br/>&#10003 No Minimum Balance Requirement<br/><br/>&#10003 No Monthly Service Fee<br/><br/>&#10003 Checks are Optional<br/><br/>&#10003 No Charge at Bank ATMs';
    product.tffa__FullDescription__c = '&#10003 Interest Bearing Checking<br/><br/>&#10003 $100 Minimum Opening Deposit<br/><br/>&#10003 No Minimum Balance Requirement<br/><br/>&#10003 No Monthly Service Fee<br/><br/>&#10003 Checks are Optional<br/><br/>&#10003 No Charge at Bank ATMs';
    product = tffa.ProductService.create(product);
    return product;
  }

  @isTest
  public static void fisccTestDataRepo() {
    Test.startTest();
    FISCCTestDataRepository.createIndividualPartyWithChildObjects();
    FISCCTestDataRepository.createIndividualParty();
    Test.stopTest();
  }

  @isTest
  public static void helperTestRepos() {
    Test.startTest();

    try {
      CZWTFCHelperRepository.fetchContentDocumentId(new List<String>{});
    } catch (Exception ex) {
    }

    try {
      CZWTFCHelperRepository.deleteContentDocument('Test');
      CZWTFCHelperRepository.getBeneficiaryById('50');
      CZWTFCHelperRepository.fetchEnvConfig();
      CZWTFCHelperRepository.getFundingMat();
      CZWTFCHelperRepository.deleteContentDocumentById(new List<String>{});
    } catch (Exception ex) {
    }

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
    CZWTFCApplicationRepository.findApplicationPartyByPartyId(String.valueOf(party.Id), String.valueOf(app.Id));
    CZWTFCApplicationRepository.findAccountPrefByAppIdAndCode(app, 'test');
    CZWTFCApplicationRepository.findAppById(app.id);

    Test.stopTest();
  }
}