@isTest
public with sharing class CZAccNbrGenerationTest {
  @isTest
  public static void GenerateAccNbr() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
    insert sub;

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = sub.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    FISCCIntegrationLogService.auth = '1234';
    Map<String, String> mp = new Map<String, String>();
    mp.put('submission', sub.Id);
    mp.put('applicationName', 'TAC');
    mp.put('branch', '5');
    mp.put('productCode', '803');
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZAccNbrGenerationMockClass());
    CZAccNbrGenerationProvider.generateAccountNbr(applicationobjs);

    try {
      CZAccNbrGenerationMockClass accMockCls = new CZAccNbrGenerationMockClass();
      accMockCls.respond(new HttpRequest());
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //test excpetion block in provider
    try {
      CZAccNbrGenerationProvider.testException = true;
      Object resp = CZAccNbrGenerationProvider.generateAccountNbr(applicationobjs);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }
    //test excpetion block in extension invoke api
    try {
      CZAccNbrGenerationExtension.testException = true;
      Object resp = CZAccNbrGenerationExtension.invokeApiCall(
        new FISCC_Adapter_Configs__mdt(),
        new FISCC_Charter_Config__mdt(),
        applicationobjs
      );
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }
    //test excpetion block in extension generate request
    try {
      CZAccNbrGenerationExtension.testException = true;
      Object resp = CZAccNbrGenerationExtension.generateRequest(applicationobjs);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    Test.stopTest();
  }

  @isTest
  public static void accNbrgeneRespBuilderTestCase() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
    insert sub;

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = sub.id;
    application.tffa__KYCDecisionOutcome__c = 'APPROVED';
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);
    Test.startTest();
    //success flow
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      CZAccNbrGenerationResponseDTO dto = (CZAccNbrGenerationResponseDTO) System.JSON.deserialize(
        resp,
        CZAccNbrGenerationResponseDTO.class
      );
      CZAccNbrGenResponseBuilder respBuilder = new CZAccNbrGenResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp1 = CZAccNbrGenerationExtension.parseResponse(dto, applicationobjs);
      System.assertNotEquals(resp1, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Exception block in CZAccNbrGenerationRequestDTO.build
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      CZAccNbrGenerationResponseDTO dto = (CZAccNbrGenerationResponseDTO) System.JSON.deserialize(
        resp,
        CZAccNbrGenerationResponseDTO.class
      );
      CZAccNbrGenResponseBuilder respBuilder = new CZAccNbrGenResponseBuilder();
      CZAccNbrGenResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block in CZAccNbrGenResponseBuilder.parseResponse
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      CZAccNbrGenerationResponseDTO dto = (CZAccNbrGenerationResponseDTO) System.JSON.deserialize(
        resp,
        CZAccNbrGenerationResponseDTO.class
      );
      CZAccNbrGenResponseBuilder respBuilder = new CZAccNbrGenResponseBuilder();
      CZAccNbrGenResponseBuilder.testException = true;
      respBuilder.parseResponse(new CZAccNbrGenerationResponseDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    // System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}