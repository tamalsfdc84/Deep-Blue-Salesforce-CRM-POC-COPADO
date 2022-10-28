/**
 *
 * @description This is the test class of CZWTFCSubmissionControllerTest
 */

@isTest
public class CZWTFCSubmissionControllerTest {
  @testSetup
  static void setup() {
    CZWTFCTestDataRepository.generateEnvironmentConfiguration();
  }
  /**
   * @description Test using salescontroller init
   **
  @isTest
  static void testInit() {
    Test.startTest();
    PageReference pageRef = Page.sales;

    Test.setCurrentPage(pageRef);

    tffa.ApexPageUtils.setPageParameter('source', 'Website');

    //tffa.SalesController ctrl = new tffa.SalesController();

    //ctrl.init();
    Cookie sessionCookie = tffa.ApexPageUtils.getCookie('sessionToken');

    tffa.Context ctx = tffa.Context.get();

    tffa.Response response = tffa.SubmissionController.read(ctx);
    Map<String, Object> subMap = (Map<String, Object>) response.data;
    tffa.Logger.debug('subMap' + subMap);
    CZWTFCTestDataRepository.generateSystemLogs();
    String id = (String) subMap.get('Id');
    //System.assertNotEquals(null, id);
    String source = (String) subMap.get('AdditionalSource__c');
    //System.assertEquals('CZCustom', source);

    System.assertEquals('1', '1', 'Success');
Test.stopTest();
  }*/
  /**
   * @description Test using Submissionservice init
   **/
  /*@isTest
  static void testCreate() {
    CZWTFCTestDataRepository.createCheckingProduct();
    try {
      tffa__Submission__c submission = CZWTFCTestDataRepository.createSubmissionWithIndividualPartyAndCheckingApplication();
    } finally {
      CZWTFCTestDataRepository.generateSystemLogs();
    }

    Test.startTest();
    tffa.Context ctx = tffa.Context.get();
    tffa.Response response = tffa.SubmissionController.read(ctx);

    response = tffa.SubmissionController.modify(ctx, JSON.serialize(response.data));
    Map<String, Object> subMap = (Map<String, Object>) response.data;
    tffa.Logger.debug('subMap' + subMap);

    String id = (String) subMap.get('Id');
    //System.assertNotEquals(null, id);
    String source = (String) subMap.get('AdditionalSource__c');
    //System.assertEquals('CZCustom', source);

    //  response = tffa.SubmissionController.save(ctx, JSON.serialize(response.data));

    System.assertEquals('1', '1', 'Success');
Test.stopTest();
  }*/

  @isTest
  static void testQueryBuilder() {
    Test.startTest();
    // simple filter criteria
    String id = '12';
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(id);

    // multiple filter criteria
    String role = 'APPLICANT';
    List<String> ids = new List<String>();
    ids.add(id);
    List<tffa__Submission__c> subs = CZWTFCSubmissionRepository.findByPartyRoleAndId(role, ids);
    List<tffa__Submission__c> subs2 = CZWTFCSubmissionRepository.findByPartyRoleAndId(role, ids);

    // delete
    CZWTFCSubmissionRepository.remove(subs2);

    // save
    subs = CZWTFCSubmissionRepository.save(subs);
    System.assertNotEquals(subs, null);
    //System.assertEquals('CZCustom', 'CZCustom');
    // System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  /**
   * Test case moved to event ext test class
   */

  // @isTest
  // static void testOTP() {
  //   Test.StartTest();

  //   tffa__Submission__c submission = CZWTFCTestDataRepository.createSubmission();
  //   submission = tffa.SubmissionService.create(submission);
  //   tffa.Context ctx = tffa.Context.get();

  //   tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();
  //   product = tffa.ProductService.create(product);

  //   tffa__Application__c app = CZWTFCTestDataRepository.createCheckingApplication();
  //   app.tffa__Submission__c = submission.id;
  //   app.tffa__Product__c = product.id;
  //   app.tffa__ProductCategory__c = product.tffa__Category__c;

  //   tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submission);
  //   asm.addChildObject('Applications__r', app);

  //   tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
  //   tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
  //   party = tffa.PartyService.create(party);
  //   xref.tffa__Party__c = party.Id;
  //   xref.tffa__Party__r = party;
  //   asm.addChildObject('PartyXrefs__r', xref);

  //   submission = (tffa__Submission__c) asm.assemble();

  //   tffa.Response response = tffa.SubmissionController.modify(ctx, tffa.SObjectMapper.serialize(submission));
  //   Map<String, Object> subMap = (Map<String, Object>) response.data;

  //   System.assert(subMap.get('Id') != null, 'Submission record should be created');
  //   // generate otp
  //   Map<String, Object> facts = new Map<String, Object>();
  //   facts.put('PrimaryEmail__c', party.tffa__PrimaryEmail__c);
  //   response = tffa.PartyController.generateOTP(ctx, facts);
  //   System.assert(response != null, 'OTP should be generated');

  //   System.assertEquals('1', '1', 'Success');
  // }

  // @isTest
  // static void testPartyEventExtension() {
  //   Test.StartTest();

  //   tffa__Submission__c submission = CZWTFCTestDataRepository.createSubmission();
  //   submission = tffa.SubmissionService.create(submission);
  //   tffa.Context ctx = tffa.Context.get();

  //   tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();
  //   product = tffa.ProductService.create(product);

  //   tffa__Application__c app = CZWTFCTestDataRepository.createCheckingApplication();
  //   app.tffa__Submission__c = submission.id;
  //   app.tffa__Product__c = product.id;
  //   app.tffa__ProductCategory__c = product.tffa__Category__c;

  //   tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submission);
  //   asm.addChildObject('Applications__r', app);

  //   tffa__SubmissionPartyXref__c xref = new tffa__SubmissionPartyXref__c();
  //   tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
  //   party = tffa.PartyService.create(party);
  //   xref.tffa__Party__c = party.Id;
  //   xref.tffa__Party__r = party;
  //   asm.addChildObject('PartyXrefs__r', xref);

  //   submission = (tffa__Submission__c) asm.assemble();

  //   tffa.Response response = tffa.SubmissionController.modify(ctx, tffa.SObjectMapper.serialize(submission));
  //   Map<String, Object> subMap = (Map<String, Object>) response.data;

  //   System.assert(subMap.get('Id') != null, 'Submission record should be created');
  //   // generate otp
  //   Map<String, Object> facts = new Map<String, Object>();
  //   facts.put('PrimaryEmail__c', party.tffa__PrimaryEmail__c);
  //   response = tffa.PartyController.generateOTP(ctx, facts);
  //   System.assert(response != null, 'OTP should be generated');

  //   CZWTFCPartyEventExtension ext = new CZWTFCPartyEventExtension('Party_OTP_Generated');
  //   Object obj = (tffa__Party__c) party;
  //   ext.post(obj);

  //   System.assertEquals('1', '1', 'Success');

  // }

  @isTest
  public static void testMethod1() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      tffa__SubmissionDate__c = Date.today()
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

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c(
      tffa__Submission__c = sub.id,
      tffa__Amount__c = 100.0,
      tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION'
    );
    insert fundingReq;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id
    );
    insert app;

    sub.NextFundingVerificationReminderDate__c = Date.today();
    update sub;

    Test.startTest();
    CZWTFCMDPendingReminderBatch M1 = new CZWTFCMDPendingReminderBatch();
    ID batchprocessid = Database.executeBatch(M1);
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
    System.assertNotEquals(aaj, null);
    Test.stopTest();
  }

  @isTest
  public static void testMethod2() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
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

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c(
      tffa__Submission__c = sub.id,
      tffa__Amount__c = 100.0,
      tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION'
    );
    insert fundingReq;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id
    );
    insert app;

    Test.startTest();
    CZWTFCMDPendingReminderBatch M1 = new CZWTFCMDPendingReminderBatch();
    ID batchprocessid = Database.executeBatch(M1);

    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
    System.assertNotEquals(aaj, null);

    sub.tffa__SubmissionDate__c = Date.today();

    CZWTFCMDPendingReminderBatch M2 = new CZWTFCMDPendingReminderBatch();
    ID batchprocessid1 = Database.executeBatch(M2);
    AsyncApexJob aaj1 = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid1];
    System.assertNotEquals(aaj1, null);
    Test.stopTest();
  }
}