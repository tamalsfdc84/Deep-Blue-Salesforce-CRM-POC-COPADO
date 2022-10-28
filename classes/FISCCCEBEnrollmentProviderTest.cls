@isTest
public with sharing class FISCCCEBEnrollmentProviderTest {
  @isTest
  static void testCEBEnroll() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    tffa__Submission__c sub = new tffa__Submission__c();
    sub.tffa__Brand__c = '118';
    insert sub;

    tffa__Party__c objParty = new tffa__party__c();
    String userName = 'rishi';
    String password = 'test';

    objParty.tffa__IsExistingCustomer__c = false;
    objParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    objParty.tffa__Citizenship__c = 'Citizen';
    objParty.tffa__DoNotCall__c = false;
    objParty.tffa__DoNotEmail__c = false;
    objParty.tffa__DoNotText__c = false;
    objParty.tffa__NationalIdentifierValue__c = '123412341';
    objParty.tffa__PrimaryEmail__c = 'a@a.c';

    objParty.tffa__FirstName__c = 'John';
    objParty.tffa__LastName__c = 'May';
    objParty.tffa__QualiFileStatus__c = 'PASSED';
    objParty.tffa__IDVStatus__c = 'PASSED';
    objParty.tffa__IDAStatus__c = 'PASSED';
    objParty.tffa__CDDStatus__c = 'PASSED';
    objParty.tffa__OFACStatus__c = 'PASSED';
    objParty.tffa__Type__c = 'INDIVIDUAL';
    objParty.tffa__BrandCode__c = '118';
    insert objParty;

    try {
      tffa__AdditionalPreference__c test1 = new tffa__AdditionalPreference__c();
      test1.Name = 'abc';
      test1.tffa__Code__c = 'abc';
      test1.tffa__Submission__c = sub.Id;
      test1.tffa__Party__c = objParty.Id;
      test1.tffa__AddOnServiceType__c = 'ONLINE_BANKING';
      insert test1;

      tffa__SubmissionPartyXref__c testXref = new tffa__SubmissionPartyXref__c();
      testXref.tffa__Submission__c = sub.Id;
      testXref.tffa__Party__c = objParty.Id;
      testXref.tffa__Type__c = 'INDIVIDUAL';
      insert testXref;
      //System.debug('SubId :: '+ CZWTFCPartyRepository.findSubPartyById(objParty.Id).tffa__Submission__c);
    } catch (Exception ex) {
      //System.debug('test1 ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }

    Map<String, Object> params = new Map<String, Object>();
    params.put('partyObj', objParty);
    params.put('userName', userName);
    params.put('password', password);
    String validResponse = '{ "Metadata": { "MsgLst": [{ "Type": "Informational Message", "Text": "Success", "Severity": "Info", "Code": 0 } ] }, "Enrollment": { "BankInfo": { "feId": 311 }, "EnrollmentPendingIndicator": false } }';
    String errResponse = '{ "Metadata": { "MsgLst": [ { "Type": "Application Error","Text": "Customer not found", "Severity": "Error", "Code": "-9142" }, { "Type": "Application Error", "Text": "Name not found", "Severity": "Error", "Code": "-9310" } ] }, "Enrollment": { "BankInfo": { "feId": 311 }, "EnrollmentPendingIndicator": false } }';
    Map<String, String> params1 = new Map<String, String>();
    params1.put('partyID', objParty.Id);
    params1.put('userName', userName);
    params1.put('password', password);

    Map<String, String> params2 = new Map<String, String>();
    params2.put('partyID', 'abc212');
    params2.put('userName', userName);
    params2.put('password', password);

    String strDeveloperName = 'CEBEnroll';
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(objParty.tffa__BrandCode__c);
    Test.startTest();

    try {
      FISCCCEBEnrollmentProvider.CEBEnroll(objParty, userName, password);
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    try {
      Test.setMock(HttpCalloutMock.class, new FISCCCEBEnrollmentProviderMockClass());
      Object temp = FISCCCEBEnrollmentExtension.invokeCEBEnroll(params, adapterConfig, charterConfig);
      //System.debug('First invoke test :::' + temp);
      FISCCCEBEnrollmentExtension.invokeCEBEnroll(null, null, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Inside exception');
    }

    FISCCCEBEnrollmentExtension.generateCEBEnrollRequest(params, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    try {
      FISCCCEBEnrollmentExtension.testException = true;
      FISCCCEBEnrollmentExtension.generateCEBEnrollRequest(params, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCCEBEnrollmentExtension.testException = true;
      FISCCCEBEnrollmentExtension.invokeCEBEnroll(params, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
    }

    new FISCCCEBEnrollmentResponseDTO();

    FISCCTransactionResponseBaseDTO tempObj = new FISCCCEBEnrollmentResponseBuilder().build(errResponse, adapterConfig, charterConfig);

    FISCCCEBEnrollmentResponseDTO.parse(validResponse);

    try {
      FISCCCEBEnrollmentResponseBuilder.testException = true;
      tempObj = new FISCCCEBEnrollmentResponseBuilder()
        .build(validResponse, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCCEBEnrollmentResponseBuilder.testException = true;
      Object tobj = new FISCCCEBEnrollmentResponseBuilder()
        .parseResponse(tempObj, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception excp) {
    }
    try {
      FISCCCEBEnrollmentExtension.testException = false;
      FISCCCEBEnrollmentResponseBuilder.testException = false;
      tffa.Response resp = CZWTFCCustomController.enrollForOLB(params1);
      FISCCCEBEnrollmentService serviceObj = new FISCCCEBEnrollmentService();
      serviceObj.enrollForOLB(new Map<String, String>());
      serviceObj.enrollForOLB(params2);
      FISCCCEBEnrollmentService.testException = true;
      serviceObj.enrollForOLB(params2);
      params2.put('userName', 'F');
      serviceObj.enrollForOLB(params2);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }
}