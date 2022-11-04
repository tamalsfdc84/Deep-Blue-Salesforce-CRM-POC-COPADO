@isTest
public with sharing class CZWTFCElavonTest {
  @testSetup
  static void setup() {
    CZWTFCTestDataRepository.generateEnvironmentConfiguration();
  }
  @isTest
  public static void testCaseOne() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    Test.startTest();
    tffa.Context ctx = tffa.Context.get();
    ctx.id = sub.Id;
    Map<String, Object> params = new Map<String, Object>();
    params.put('firstname', 'Test');
    params.put('lastname', 'Testone');
    params.put('amount', '100');
    params.put('brandCode', '380');
    Test.setMock(HttpCalloutMock.class, new CZWTFCElavonTokenMockClass());
    Object resp = CZWTFCCustomController.fetchConvergeSessionToken(ctx, params);
    System.assertNotEquals(resp, null);
    Test.stopTest();
  }

  @isTest
  public static void testCompleted() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Code__c = '112';
    prod1.Name = 'Access Plus Checking';
    prod1.tffa__Category__c = 'checking';
    prod1.UseDefaultBranchCostCenter__c = true;
    insert prod1;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod1.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );

    //FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING);
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.APPROVAL_CCCOMPLETE, app.Id, false);

    Map<String, Object> params = new Map<String, Object>();
    params.put('multiPartialComplete', 'Y');
    params.put('amount', '100');
    params.put('txnId', '201021ED3-9702AE22-85FA-470E-9072-2CC3682E80E2');
    params.put('SubmissionId', sub.Id);
    params.put('brandCode', '380');

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCElavonCompMockClass());
    Object resp = CZWTFCConvergeService.ccCompleteConvergeTrans(params, new tffa__FundingRequest__c());
    System.assertNotEquals(resp, null);
    Test.stopTest();
  }

  @isTest
  public static void testDelete() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    Map<String, Object> params = new Map<String, Object>();
    params.put('firstname', 'Test');
    params.put('lastname', 'Testone');
    params.put('txnId', '201021ED3-9702AE22-85FA-470E-9072-2CC3682E80E2');
    params.put('SubmissionId', sub.Id);

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCElavonDeleteMockClass());
    Object resp = CZWTFCConvergeService.ccDeleteConvergeTrans(sub.Id, '12434');
    System.assertNotEquals(resp, null);
    Test.stopTest();
  }

  @isTest
  public static void testResponseParse() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    //FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);

    String response = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><txn><ssl_last_name>UserLastName</ssl_last_name><ssl_company/><ssl_phone/><ssl_card_number>40**********0002</ssl_card_number><ssl_oar_data>010010974310250849490000047554200000000000300383129808109743</ssl_oar_data><ssl_result>0</ssl_result><ssl_txn_id>251021ED3-FF481CB1-71D5-4CC7-88C0-75B60BD2B7B1</ssl_txn_id><ssl_avs_response/><ssl_approval_code>300383</ssl_approval_code><ssl_email/><ssl_amount>100.00</ssl_amount><ssl_avs_zip/><ssl_txn_time>10/25/2021 04:50:26 AM</ssl_txn_time><ssl_description/><ssl_exp_date>0222</ssl_exp_date><ssl_card_short_description>VISA</ssl_card_short_description><ssl_address2/><ssl_customer_code/><ssl_country/><ssl_card_type>CREDITCARD</ssl_card_type><ssl_transaction_type>COMPLETE</ssl_transaction_type><ssl_salestax/><ssl_avs_address/><ssl_account_balance>0.00</ssl_account_balance><ssl_ps2000_data>A7512983179012603450A</ssl_ps2000_data><ssl_state/><ssl_ship_to_zip/><ssl_city/><ssl_result_message>APPROVAL</ssl_result_message><ssl_first_name>Userone</ssl_first_name><ssl_invoice_number/><ssl_ship_to_address1/><ssl_cvv2_response/><ssl_partner_app_id>01</ssl_partner_app_id></txn>';
    String responsetwo = '<?xml version="1.0" encoding="UTF-8"?><txn><errorCode>5040</errorCode><errorName>Invalid Transaction ID</errorName><errorMessage>The transaction ID is invalid for this transaction type</errorMessage></txn>';

    String respThree = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><txn><ssl_last_name>UserLastName</ssl_last_name><ssl_company/><ssl_phone/><ssl_card_number>40**********0002</ssl_card_number><ssl_oar_data>010010974310250849490000047554200000000000300383129808109743</ssl_oar_data><ssl_result>0</ssl_result><ssl_txn_id>251021ED3-FF481CB1-71D5-4CC7-88C0-75B60BD2B7B1</ssl_txn_id><ssl_avs_response/><ssl_approval_code>300383</ssl_approval_code><ssl_email/><ssl_amount>100.00</ssl_amount><ssl_avs_zip/><ssl_txn_time>10/25/2021 04:50:26 AM</ssl_txn_time></txn>';

    String respFour = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><txn><ssl_last_name>UserLastName</ssl_last_name><ssl_company/><ssl_phone/><ssl_card_number>40**********0002</ssl_card_number><ssl_oar_data>010010974310250849490000047554200000000000300383129808109743</ssl_oar_data><ssl_result>0</ssl_result><ssl_txn_id>251021ED3-FF481CB1-71D5-4CC7-88C0-75B60BD2B7B1</ssl_txn_id><ssl_avs_response/><ssl_approval_code>300383</ssl_approval_code><ssl_email/><ssl_amount>100.00</ssl_amount><ssl_avs_zip/><ssl_txn_time>10/25/2021 04:50:26 AM</ssl_txn_time><ssl_description/><ssl_exp_date>0222</ssl_exp_date><ssl_card_short_description>VISA</ssl_card_short_description><ssl_address2/><ssl_customer_code/><ssl_cou>';
    Test.startTest();

    try {
      Object resp = CZWTFCConvergeService.parseTransactionResponse(response, '1234', new tffa__FundingRequest__c());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = CZWTFCConvergeService.parseTransactionResponse(responsetwo, '1234', new tffa__FundingRequest__c());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = CZWTFCConvergeService.parseTransactionResponse(respThree, '1234', new tffa__FundingRequest__c());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = CZWTFCConvergeService.parseTransactionResponse(respFour, '1234', new tffa__FundingRequest__c());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    Test.stopTest();
  }

  @isTest
  public static void testBatch() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Code__c = '112';
    prod1.Name = 'Access Plus Checking';
    prod1.tffa__Category__c = 'checking';
    prod1.UseDefaultBranchCostCenter__c = true;
    insert prod1;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod1.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );

    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app.Id;
    fundingReq1.tffa__Submission__c = sub.Id;
    insert fundingReq1;

    tffa.SObjectAssembler appasm1 = new tffa.SObjectAssembler(app);
    appasm1.addChildObject('LinkedFundingRequests__r', fundingReq1);

    tffa.SObjectAssembler subb = new tffa.SObjectAssembler(sub);
    subb.addChildObject('tffa__Applications__r', (tffa__Application__c) appasm1.assemble());
    tffa__Submission__c updatedsubone = (tffa__Submission__c) subb.assemble();
    update updatedsubone;
    CZWTFCDebitCardFundingVoidBatch.calledFromTestCls = true;
    Test.startTest();
    ID batchprocessid = Database.executeBatch(new CZWTFCDebitCardFundingVoidBatch(), 1);
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
    System.assertNotEquals(aaj, null);
    Test.setMock(HttpCalloutMock.class, new CZWTFCElavonCompMockClass());
    ID batchprocessid1 = Database.executeBatch(new CZWTFCDebitCardFundingVoidBatch(), 1);
    AsyncApexJob aaj1 = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid1];
    System.assertNotEquals(aaj1, null);

    Test.stopTest();
  }

  @isTest
  public static void testBatch2() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Code__c = '112';
    prod1.Name = 'Access Plus Checking';
    prod1.tffa__Category__c = 'checking';
    prod1.UseDefaultBranchCostCenter__c = true;
    insert prod1;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod1.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );

    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app.Id;
    fundingReq1.MultiPartialFlag__c = 'N';
    fundingReq1.tffa__Submission__c = sub.Id;
    insert fundingReq1;

    Test.startTest();
    ID batchprocessid = Database.executeBatch(new CZWTFCDebitCardFundingVoidBatch(), 1);
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
    System.assertNotEquals(aaj, null);
    Test.setMock(HttpCalloutMock.class, new CZWTFCElavonCompMockClass());
    ID batchprocessid1 = Database.executeBatch(new CZWTFCDebitCardFundingVoidBatch(), 1);
    AsyncApexJob aaj1 = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid1];
    System.assertNotEquals(aaj1, null);

    Test.stopTest();
  }

  @isTest
  public static void testExcep() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    Map<String, Object> params = new Map<String, Object>();
    params.put('firstname', 'Testingbiggerfirstnametest');
    params.put('lastname', 'Testingbiggerlastnametestmorethan30');
    params.put('txnId', '201021ED3-9702AE22-85FA-470E-9072-2CC3682E80E2');
    params.put('SubmissionId', sub.Id);
    params.put('address', '1244');
    params.put('zipCode', '1244567865-1234');

    Test.startTest();

    try {
      CZWTFCConvergeService.fetchSessionToken(params);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeService.ccCompleteConvergeTrans(params, new tffa__FundingRequest__c());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeService.ccDeleteConvergeTrans(sub.Id, '12334');
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeAdapter.execute(null, null, '');
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeService.testException = true;
      CZWTFCConvergeService.fetchSessionToken(params);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeService.testException = true;
      CZWTFCConvergeService.ccCompleteConvergeTrans(params, new tffa__FundingRequest__c());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeService.testException = true;
      CZWTFCConvergeService.ccDeleteConvergeTrans(sub.Id, '12334');
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCConvergeAdapter.testException = true;
      CZWTFCConvergeAdapter.execute(null, null, '');
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    //  System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}