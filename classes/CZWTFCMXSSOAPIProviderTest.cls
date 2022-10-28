@isTest
public with sharing class CZWTFCMXSSOAPIProviderTest {
  @isTest
  static void testCreateUser() {
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

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXSSOAPIProviderMockClass('testSuccess'));
    try {
      CZWTFCMXSoapApiProvider.generateURL(party.id, new Map<String, String>());
      CZWTFCMXSSOAPIHelper.onError(new Map<String, Object>());
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    try {
      CZWTFCMXSSOAPIAdapter.testException = true;
      CZWTFCMXSSOAPIAdapter.execute('', '');
    } catch (Exception zx) {
    }

    try {
      CZWTFCMXSSOAPIServiceProvider.testException = true;
      CZWTFCMXSSOAPIServiceProvider.invokeAPI(new Map<String, String>());
    } catch (Exception eex) {
    }

    try {
      CZWTFCMXSSOAPIService.testException = true;
      CZWTFCMXSSOAPIService.execute(new Map<String, String>());
    } catch (Exception exx) {
    }

    try {
      CZWTFCMXSoapApiProvider.testException = true;
      CZWTFCMXSoapApiProvider.generateURL(party.id, new Map<String, String>());
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testone() {
    Test.startTest();
    String responseXML = '<?xml version=\'1.0\' encoding=\'utf-8\'?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header><efxhdr:EFXHdr xmlns:efxhdr=\"http://Hdr.EFX.integration.fiserv.com/V1_2\"><efxhdr:Version>1.2</efxhdr:Version><efxhdr:Service><efxhdr:SvcName>AcctAdd</efxhdr:SvcName><efxhdr:Version>9.2</efxhdr:Version></efxhdr:Service><efxhdr:Client><efxhdr:Organization><efxhdr:OrgId>002568616TF</efxhdr:OrgId></efxhdr:Organization><efxhdr:ClientAppIdent>WEB</efxhdr:ClientAppIdent><efxhdr:ClientDt>2020-07-31 10:31:05</efxhdr:ClientDt></efxhdr:Client><efxhdr:Tracking><efxhdr:TrnId>aaf05405-ec74-a2e3-c334-19d5981890b4</efxhdr:TrnId></efxhdr:Tracking></efxhdr:EFXHdr></soapenv:Header><soapenv:Body><ns1:AcctAddRs xmlns:ns1=\"http://EFX.integration.fiserv.com/V1_0\"><ns1:Status><ns1:StatusCode>0</ns1:StatusCode><ns1:StatusDesc>Success</ns1:StatusDesc><ns1:Severity>Info</ns1:Severity><ns1:SvcProviderName>Premier</ns1:SvcProviderName><ns1:ServerStatusCode>9999</ns1:ServerStatusCode><ns1:ServerStatusDesc>No Name On File </ns1:ServerStatusDesc></ns1:Status></ns1:AcctAddRs></soapenv:Body></soapenv:Envelope>';
    CZWTFCXmlDom test1 = new CZWTFCXmlDom(responseXML);
    new CZWTFCXmlDom();
    test1.toXmlString();
    test1.dumpAll();

    Object t = new List<Object>();
    Object t1 = null;
    CZWTFCMXSSOAPIHelper.checkForInstance(t);
    CZWTFCMXSSOAPIHelper.checkForInstance(t1);
    Test.stopTest();
  }
}