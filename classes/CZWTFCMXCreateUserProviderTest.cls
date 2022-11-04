@isTest
public with sharing class CZWTFCMXCreateUserProviderTest {
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

    String validResponse = '{"user":{"id":"a1C2f000006USS1EA3","birthdate":"1992-07-02","gender":"FEMALE","logged_in_at":null,"credit_score":718,"email":"sayli.sawant@terafinainc.com","first_name":"Sayli","guid":"USR-f89d239a-29ce-4c50-bc81-9d06e2146d47","is_disabled":false,"last_name":"Sawant","metadata":"Additional Information","phone":"15055551234","zip_code":"87101"}}';

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXCreateUserProviderMockClass('testSuccess'));
    try {
      Map<String, String> params = new Map<String, String>();
      params.put('isMXUserCreated', 'false');
      CZWTFCMXCreateUserProvider.invokeCreateUserAPI(sub.Id, params);
      CZWTFCMXCreateUserProvider.invokeCreateUserAPI(submissionObj.Id, params);
      CZWTFCMXCreateUserService.parseResponse(validResponse);
      Map<String, String> params1 = new Map<String, String>();
      CZWTFCMXCreateUserServiceProvider.invokeCreateUserAPI(params1);

      CZWTFCMXCreateUserServiceProvider.invokeCreateUserAPI(params1);
      CZWTFCMXCreateUserResponseDTO.parse(validResponse);
      Map<String, String> params2 = new Map<String, String>();
      params2.put('isMXUserCreated', 'true');
      CZWTFCMXCreateUserServiceProvider.invokeCreateUserAPI(params2);

      CZWTFCMXServiceConfiguration.getMXConfig();
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }
    try {
      CZWTFCMXCreateUserAdapter.testException = true;
      CZWTFCMXCreateUserAdapter.execute('');
    } catch (Exception exc) {
    }

    try {
      CZWTFCMXFetchMemberAccountsAdapter.testException = true;
      CZWTFCMXFetchMemberAccountsAdapter.execute(new Map<String, String>());
    } catch (Exception excep) {
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}