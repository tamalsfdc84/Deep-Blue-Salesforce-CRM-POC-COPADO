@isTest
public with sharing class CZWTFCAdobeCampaignTest {
  @isTest
  public static void generateToken() {
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

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c(tffa__Submission__c = sub.id, tffa__Amount__c = 100.0);
    insert fundingReq;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id
    );
    insert app;

    List<tffa__Application__c> appList = new List<tffa__Application__c>();
    appList.add(app);

    tffa__AccountPreference__c accountPreference = new tffa__AccountPreference__c(
      tffa__Application__c = app.id,
      tffa__Code__c = '03',
      tffa__Type__c = 'ADD_ON_SERVICE'
    );
    insert accountPreference;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';

    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.AdobeCampaignRetryCount__c = 2;
    insert submissionObj;

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    insert jointParty;

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = jointParty;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Party__c = jointParty.Id;
    xref1.tffa__Type__c = 'INDIVIDUAL';
    insert xref1;

    tffa__Submission__c submissionObj4 = new tffa__Submission__c();
    submissionObj4.tffa__Status__c = 'IN_PROGRESS';
    submissionObj4.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj4;

    List<tffa__Submission__c> subObjList = new List<tffa__Submission__c>();
    List<tffa__Submission__c> subObjList2 = new List<tffa__Submission__c>();

    String resp = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:ns=\'urn:xtk:session\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><LogonResponse xmlns=\'urn:xtk:session\' SOAP-ENV:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'><pstrSessionToken xsi:type=\'xsd:string\'>___ebfa4df7-e73e-46b3-8e22-968e56040070</pstrSessionToken></LogonResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    String errorresp = 'lns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:ns=\'urn:xtk:session\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><LogonResponse xmlns=\'urn:xtk:session\' SOAP-ENV:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'><pstrSessionTe56040070</pstrSessionToken></LogonResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    subObjList.add(submissionObj);

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCGenerateTokenMockClass());

    CZWTFCAdobeCampaignService acc = new CZWTFCAdobeCampaignService();
    CZWTFCACCInvokeTokenApiService apiToken = new CZWTFCACCInvokeTokenApiService();

    acc.processExpiredSubmissions(subObjList);
    apiToken.parseResponse(resp);

    //Test Error block
    try {
      acc.transferExpiredSubs(submissionObj4, '1234');
      CZWTFCACCInvokeTokenApiService apiToken2 = new CZWTFCACCInvokeTokenApiService();
      apiToken2.parseResponse(errorresp);
    } catch (Exception e) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testCaseTwo() {
    tffa__Submission__c submissionObj4 = new tffa__Submission__c();
    submissionObj4.tffa__Status__c = 'IN_PROGRESS';
    submissionObj4.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj4;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';

    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.AdobeCampaignRetryCount__c = 2;
    insert submissionObj;

    AdobeCampaign__c acc = new AdobeCampaign__c();
    acc.TerafinaFieldName__c = 'tffa__Status__c';
    acc.TerafinaObjectName__c = 'tffa__Submission__c';
    acc.AdobeFieldName__c = 'aa';
    acc.AdobeSchemaName__c = 'aa';
    acc.Name = '123';
    insert acc;

    AdobeCampaign__c acc2 = new AdobeCampaign__c();
    acc2.TerafinaFieldName__c = 'AdobeCampaignRetryCount__c';
    acc2.TerafinaObjectName__c = 'tffa__Submission__c';
    acc2.AdobeFieldName__c = 'aa';
    acc2.AdobeSchemaName__c = 'aa';
    acc2.Name = '12355';
    insert acc2;

    AdobeCampaign__c acc3 = new AdobeCampaign__c();
    acc3.TerafinaFieldName__c = 'tffa__HasExistingParty__c';
    acc3.TerafinaObjectName__c = 'tffa__Submission__c';
    acc3.AdobeFieldName__c = 'aa';
    acc3.AdobeSchemaName__c = 'aa';
    acc3.Name = '1235';
    insert acc3;

    Test.startTest();

    try {
      CZWTFCACCTransferObjectService acctransfer = new CZWTFCACCTransferObjectService();
      acctransfer.expiredObjects(new List<SObject>{ submissionObj }, 'token');
    } catch (Exception ex) {
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZWTFCWriteCollMockClass('testSuccess'));
      CZWTFCAccWriteCollectionService writeColl = new CZWTFCAccWriteCollectionService();
      writeColl.callApi('test', new AdobeCampaignConfiguration__mdt());
    } catch (Exception e) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testCaseThree() {
    String validResponse = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:ns=\'urn:wpp:default\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><WriteResponse xmlns=\'urn:wpp:default\' SOAP-ENV:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'></WriteResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    String errResponse = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><SOAP-ENV:Fault><faultcode>SOAP-ENV:Server</faultcode><faultstring xsi:type=\'xsd:string\'>SOP-330011 Error while executing the method \'Write\' of service \'xtk:persist\'.</faultstring><detail xsi:type=\'xsd:string\'>PGS-220000 PostgreSQL error: ERROR:  duplicate key value violates unique constraint "tffaterafinasubmission_id"</detail></SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    Test.startTest();
    CZWTFCAccWriteCollectionService acw = new CZWTFCAccWriteCollectionService();
    acw.parseResponse(validResponse);
    acw.parseResponse(errResponse);
    Test.stopTest();
  }

  @isTest
  public static void TestCaseFour() {
    tffa__Submission__c submissionObj4 = new tffa__Submission__c();
    submissionObj4.tffa__Status__c = 'EXPIRED';
    submissionObj4.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj4.IsAccTransferred__c = false;
    submissionObj4.AdobeCampaignRetryCount__c = 1;
    insert submissionObj4;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCGenerateTokenMockClass());
    Database.executeBatch(new CZWTFCACCBatch());
    Test.stopTest();
  }
}