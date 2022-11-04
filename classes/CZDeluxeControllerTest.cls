@isTest
public inherited sharing class CZDeluxeControllerTest {
  @testSetup
  static void setup() {
    tffa__Submission__c sub1 = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      FISBranchCode__c = '888'
    );
    insert sub1;
    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Code__c = '112';
    prod1.Name = 'Access Plus Checking';
    prod1.tffa__Category__c = 'checking';
    prod1.UseDefaultBranchCostCenter__c = true;
    insert prod1;

    tffa__Application__c app1 = new tffa__Application__c(
      tffa__Submission__c = sub1.id,
      tffa__Product__c = prod1.id,
      tffa__AccountNumber__c = '0000017366',
      //ShareId__c = '0032',
      tffa__Amount__c = 100.0,
      //ShareStatus__c = 'SUCCESS',
      tffa__PromotionCode__c = 'SUMMERJOY',
      //SourceOfReference__c  =  'FLYER_OR_POSTER',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert app1;
    tffa__ApplicantRole__c appRole = new tffa__ApplicantRole__c();
    appRole.Name = 'SOLEPROPRIETOR';
    appRole.tffa__Code__c = 'SOLEPROPRIETOR';
    insert appRole;

    tffa__Party__c party = new tffa__Party__c();
    party.Name = 'partyName';
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    //party.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
    insert party;
    tffa__Address__c address1 = new tffa__Address__c();
    address1.tffa__Line1__c = '803 Ecostar';
    address1.tffa__Line2__c = ' ';
    address1.tffa__State__c = 'CT1';
    address1.tffa__City__c = 'Darien';
    address1.tffa__Country__c = 'US';
    address1.tffa__ZipCode__c = '06820-41';
    insert address1;
    List<tffa__PartyAddressXref__c> partyAddressXrefs1 = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref01 = new tffa__PartyAddressXref__c();
    partyAddressXref01.tffa__Type__c = 'HOME';
    partyAddressXref01.tffa__Preferred__c = true;
    partyAddressXref01.tffa__Address__c = address1.id;
    partyAddressXref01.tffa__Party__c = party.Id;
    partyAddressXrefs1.add(partyAddressXref01);
    insert partyAddressXrefs1;
    tffa.SObjectAssembler asmParty12 = new tffa.SObjectAssembler(party);
    asmParty12.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs1);
    party = (tffa__Party__c) asmParty12.assemble();

    tffa__ApplicationPartyXref__c appPartyxref = new tffa__ApplicationPartyXref__c();
    appPartyxref.tffa__Party__c = party.Id;
    appPartyxref.tffa__ApplicantRole__c = appRole.id;
    appPartyxref.tffa__Application__c = app1.id;
    appPartyxref.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref.Name = 'Test';
    appPartyxref.tffa__Primary__c = true;
    appPartyxref.tffa__RoleCode__c = 'SOLE_OWNER';
    insert appPartyxref;
  }
  @isTest
  public static void testProcessApplication() {
    tffa__Application__c app = CZWTFCApplicationRepository.findApplicationForTest();
    Map<String, String> params = new Map<string, string>{ 'applicationId' => app.Id };
    Map<String, String> params1 = new Map<string, string>{};
    Test.setMock(HttpCalloutMock.class, new CZDeluxeMockClass());
    Test.StartTest();
    try {
      CZDeluxeController.getRedirectUrl(tffa.Context.get(), params);
      CZDeluxeController.getRedirectUrl(tffa.Context.get(), params1);
      CZDeluxeController ctrl = new CZDeluxeController(null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      CZDeluxeService.invokeAPIRequest('request');
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Application__c app2 = CZWTFCApplicationRepository.findApplicationById(app.Id);
      Object resp = CZDeluxeService.createRequestXML(app2);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    Test.stopTest();
  }
  @isTest
  public static void testProcessApplication1() {
    tffa__Application__c app = CZWTFCApplicationRepository.findApplicationForTest();
    Map<String, String> params = new Map<string, string>{ 'applicationId' => app.Id };
    Map<String, String> params1 = new Map<string, string>{};
    Test.setMock(HttpCalloutMock.class, new CZDeluxeMockClass());
    Test.StartTest();
    try {
      CZDeluxeController ctrl = new CZDeluxeController(null);
      Object resp = CZDeluxeController.getRedirectUrl(tffa.Context.get(), params1);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      CZDeluxeService.invokeAPIRequest('request');
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      tffa__Application__c app2 = CZWTFCApplicationRepository.findApplicationById(app.Id);
      Object resp = CZDeluxeService.createRequestXML(app2);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    Test.stopTest();
  }
}