@isTest
public with sharing class CZWTFCSubmissionPurgeTest {
  @isTest
  public static void testCaseOne() {
    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '1234';
    prod2.Name = 'Test';
    insert prod2;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = partyObj.id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = partyObj.id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = ' ';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = address;
    partyAddressXrefs.add(partyAddressXref0);

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';

    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    jointParty = (tffa__Party__c) asmParty1.assemble();

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
    partyAddressXref01.tffa__Address__r = address1;
    partyAddressXrefs1.add(partyAddressXref01);

    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__QualiFileStatus__c = 'PASSED';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    jointParty1.tffa__IDAStatus__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    jointParty1.tffa__Type__c = 'INDIVIDUAL';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty12 = new tffa.SObjectAssembler(jointParty1);
    asmParty12.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs1);
    jointParty1 = (tffa__Party__c) asmParty12.assemble();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__SubmissionPartyXref__c xref12 = new tffa__SubmissionPartyXref__c();
    xref12.tffa__Submission__c = submissionObj.id;
    xref12.tffa__Party__r = jointParty1;
    xref12.Name = 'TEst';
    xref12.tffa__IsPresent__c = true;
    xref12.tffa__Primary__c = true;
    xref12.tffa__Type__c = 'INDIVIDUAL';
    xref12.tffa__Party__c = jointParty1.Id;

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';
    xref1.tffa__Party__c = partyObj.Id;

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;
    partyXref.tffa__Party__c = jointParty.Id;

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = ';CT;';
    prodMat1.tffa__Product__c = product1.Id;
    insert prodMat1;

    tffa__Product__c prod8003 = new tffa__Product__c();
    prod8003.tffa__Category__c = 'CHECKING';
    prod8003.tffa__Code__c = '8004';
    prod8003.Name = 'Test';
    insert prod8003;

    tffa__ProductMatrix__c prodMat12 = new tffa__ProductMatrix__c();
    prodMat12.tffa__BrandCodeSet__c = '1234';
    prodMat12.StateCodeSet__c = ';CT1;';
    prodMat12.zipCodeSet__c = '06820-4621';
    prodMat12.tffa__Product__c = prod8003.Id;
    insert prodMat12;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    IntegrationLog__c log = new IntegrationLog__c(Submission__c = submissionObj.id, FlowName__c = 'Create Customer FLOW');
    insert log;

    IntegrationLogItem__c logItems = new IntegrationLogItem__c(
      Name = 'Test',
      IntegrationLog__c = log.Id,
      status__c = 'Failure',
      ApiName__c = 'Test'
    );
    insert logItems;

    Test.startTest();

    CZWTFCPurgeSubmissionBatch.calledFromTestCls = true;

    CZWTFCPurgeSubmissionHelper.calledFromTestCls = true;
    try {
      CZWTFCPurgeSubmissionHelper.getPurgeSub();
      CZWTFCPurgeSubmissionHelper.deletePartyAndItsChildObj(submissionObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCHelperRepository.removeStip(new List<tffa__Stipulation__c>{});
      CZWTFCHelperRepository.removeAddPref(new List<tffa__AdditionalPreference__c>{});
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCHelperRepository.removeAddress(new List<tffa__Address__C>{});
      CZWTFCHelperRepository.removePartyAddress(new List<tffa__PartyAddressXref__c>{});
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      ID batchprocessid = Database.executeBatch(new CZWTFCPurgeSubmissionBatch(), 1);
      AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
      System.assertNotEquals(aaj, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCRetryFailedAppBatch.calledFromTestCls = true;
      ID batchprocessid = Database.executeBatch(new CZWTFCRetryFailedAppBatch(), 1);
      AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchprocessid];
      System.assertNotEquals(aaj, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    Test.stopTest();
  }
}