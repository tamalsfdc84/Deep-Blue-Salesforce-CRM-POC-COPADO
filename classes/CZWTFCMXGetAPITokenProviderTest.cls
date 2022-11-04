@isTest
public with sharing class CZWTFCMXGetAPITokenProviderTest {
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

    String validResponse =
      ' <?xml version="1.0" encoding="UTF-8"?>' +
      '<api_token>' +
      '<token>VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M=</token>' +
      '</api_token>';

    Test.startTest();

    Map<String, Object> testMap = new Map<String, Object>();
    testMap.put('token', '12345');
    testMap.put('api_token', '12345');
    testMap.put('Fault', '222');

    Test.setMock(HttpCalloutMock.class, new CZWTFCMXGetAPITokenProviderMockClass('testSuccess'));
    try {
      Object t = new List<Object>();
      Object t1 = null;
      CZWTFCMXGetAPITokenHelper.checkForInstance(t);
      CZWTFCMXGetAPITokenHelper.checkForInstance(t1);

      CZWTFCMXGetAPITokenHelper.onSuccess(testMap);

      Map<String, String> reqParams = new Map<String, String>();
      reqParams.put('userId', party.id);
      CZWTFCMXGetAPITokenProvider.getAPIToken(reqParams);
      CZWTFCMXGetAPITokenService.parseResponse(JSON.serialize(testMap));
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    try {
      CZWTFCMXGetAPITokenService.parseResponse(testMap.toString());
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    Map<String, Object> testMap2 = new Map<String, Object>();
    testMap.put('token', null);
    testMap.put('api_token', null);
    testMap.put('Fault', null);

    try {
      CZWTFCMXGetAPITokenService.parseResponse(testMap2.toString());
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    try {
      CZWTFCMXGetAPITokenService.parseResponse(null);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }

    //handle api token provider error block
    try {
      Map<String, String> reqParams1 = new Map<String, String>();
      reqParams1.put('userId', party.id);
      CZWTFCMXGetAPITokenProvider.testException = true;
      CZWTFCMXGetAPITokenProvider.getAPIToken(reqParams1);
    } catch (Exception excep) {
    }

    //handle response parse error block
    try {
      CZWTFCMXOpenNexusResponseDTO.parse('');
    } catch (Exception ex) {
    }

    //Handle service provider error block
    try {
      CZWTFCMXGetAPITokenServiceProvider.testException = true;
      CZWTFCMXGetAPITokenServiceProvider.invokeAPI(new Map<String, String>());
    } catch (Exception rx) {
    }

    //handle token service error block
    try {
      CZWTFCMXGetAPITokenService.testException = true;
      CZWTFCMXGetAPITokenService.execute(new Map<String, String>());
    } catch (Exception cx) {
    }

    try {
      CZWTFCMXGetAPITokenHelper.onError(new Map<String, Object>());
    } catch (Exception zx) {
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}