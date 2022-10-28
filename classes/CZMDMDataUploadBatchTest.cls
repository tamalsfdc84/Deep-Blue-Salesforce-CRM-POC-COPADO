@isTest
public class CZMDMDataUploadBatchTest {
  @isTest
  public static void testMethod1() {
    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('successToken'));

    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true,
      tffa__Brand__c = '118'
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Address__c addr = new tffa__Address__c();
    addr.tffa__Line1__c = '2311 Main Street';
    addr.tffa__Line2__c = '';
    addr.tffa__State__c = 'GA';
    addr.tffa__City__c = 'Columbus';
    addr.tffa__ZipCode__c = '31901-3450';
    insert addr;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.CIPrmyOffcrNbr__c = '1000';
    insert brandObj;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
    party.tffa__OnboardingDate__c = Date.newInstance(2038, 10, 12);
    party.CellPhoneNumber__c = '+11234567891';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '+11234567892';
    party.Customer_Number__c = '1234';
    party.tffa__BrandCode__c = brandObj.tffa__Code__c;

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
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED',
      MDMUploadStatus__c = null,
      CZAccountOpeningDate__c = Date.newInstance(2038, 10, 12)
    );
    insert app;

    CZMDMDataUploadBatch bc = new CZMDMDataUploadBatch();
    database.executeBatch(bc);

    Test.stopTest();
  }

  @isTest
  public static void testMethod2() {
    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('successToken'));

    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true,
      tffa__Brand__c = '118'
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Address__c addr = new tffa__Address__c();
    addr.tffa__Line1__c = '2311 Main Street';
    addr.tffa__Line2__c = '';
    addr.tffa__State__c = 'GA';
    addr.tffa__City__c = 'Columbus';
    addr.tffa__ZipCode__c = '31901-3450';
    insert addr;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.CIPrmyOffcrNbr__c = '1000';
    insert brandObj;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
    party.tffa__OnboardingDate__c = Date.newInstance(2038, 10, 12);
    party.CellPhoneNumber__c = '+11234567891';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__IsExistingCustomer__c = true;
    party.Customer_Number__c = '1234';
    party.tffa__BrandCode__c = brandObj.tffa__Code__c;

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
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED',
      MDMUploadStatus__c = null,
      CZAccountOpeningDate__c = Date.newInstance(2038, 10, 12)
    );
    insert app;

    tffa__ApplicationPartyXref__c partyXrf = new tffa__ApplicationPartyXref__c();
    partyXrf.tffa__Party__c = party.id;
    partyXrf.tffa__Application__c = app.id;
    partyXrf.tffa__Type__c = 'INDIVIDUAL';
    insert partyXrf;

    CZMDMDataUploadBatch bc = new CZMDMDataUploadBatch();
    database.executeBatch(bc);

    Test.stopTest();
  }

  @isTest
  public static void testMethod3() {
    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('successToken'));

    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Address__c addr = new tffa__Address__c();
    addr.tffa__Line1__c = '2311 Main Street';
    addr.tffa__Line2__c = '';
    addr.tffa__State__c = 'GA';
    addr.tffa__City__c = 'Columbus';
    addr.tffa__ZipCode__c = '31901-3450';
    insert addr;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
    party.tffa__OnboardingDate__c = Date.newInstance(2038, 10, 12);
    party.CellPhoneNumber__c = '+11234567891';
    party.PreferredContactNumber__c = 'HOME';
    party.IsCrossCharterCustomer__c = false;
    party.tffa__IsExistingCustomer__c = true;

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
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED',
      MDMUploadStatus__c = null,
      CZAccountOpeningDate__c = Date.newInstance(2038, 10, 12)
    );
    insert app;

    tffa__ApplicationPartyXref__c partyXrf = new tffa__ApplicationPartyXref__c();
    partyXrf.tffa__Party__c = party.id;
    partyXrf.tffa__Application__c = app.id;
    partyXrf.tffa__Type__c = 'INDIVIDUAL';
    insert partyXrf;

    CZMDMDataUploadBatch bc = new CZMDMDataUploadBatch();
    database.executeBatch(bc);

    Test.stopTest();
  }
}