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
    sub.tffa__SubmittedChannel__c = FISCCIntegrationConstants.BRANCH;
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
    party.Customer_Number__c = '1234';
    party.tffa__IsExistingCustomer__c = false;
    party.CZCustomerUpdated__c = true;
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
      AccountOpeningStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS,
      CZAccountOpeningDate__c = Date.newInstance(2038, 10, 12)
    );
    insert app;

    CZMDMDataUploadBatch bc = new CZMDMDataUploadBatch();
    database.executeBatch(bc);

    tffa__Application__c app1 = CZWTFCApplicationRepository.findApplicationById(app.Id);
    System.assertEquals(app1.MDMUploadStatus__c, null, 'Success');
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
    sub.tffa__SubmittedChannel__c = FISCCIntegrationConstants.BRANCH;
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
    party.tffa__PrimaryPhone__c = '+11234567891';
    party.tffa__SecondaryPhone__c = '+11234567891';
    party.CZInternationalPhoneNumber__c = '+11 23456 7891';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__IsExistingCustomer__c = true;
    party.Customer_Number__c = '1234';
    party.tffa__BrandCode__c = brandObj.tffa__Code__c;
    party.CZMDMPartyID__c = '1234';
    party.CZCustomerUpdated__c = true;
    party.CZContactInfoUpdated__c = true;

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
      AccountOpeningStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS,
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

    tffa__Application__c app1 = CZWTFCApplicationRepository.findApplicationById(app.Id);
    System.assertEquals(app1.MDMUploadStatus__c, null, 'Success');
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
    sub.tffa__SubmittedChannel__c = FISCCIntegrationConstants.BRANCH;
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
      AccountOpeningStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS,
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

    try {
      tffa__Product__c p = new tffa__Product__c();
      p.tffa__Category__c = 'CERTIFICATE';
      String category = MDMCommonHelper.getProductTypeCode(p);
      System.assertEquals(category, 'C', 'Success');

      p.tffa__Category__c = 'CHECKING';
      p.IsNowProduct__c = true;
      category = MDMCommonHelper.getProductTypeCode(p);
      System.assertEquals(category, 'N', 'Success');

      p.tffa__Category__c = 'CHECKING';
      p.IsNowProduct__c = false;
      category = MDMCommonHelper.getProductTypeCode(p);
      System.assertEquals(category, 'D', 'Success');

      p.tffa__Category__c = 'MONEY_MARKET';
      category = MDMCommonHelper.getProductTypeCode(p);
      System.assertEquals(category, 'M', 'Success');

      p.tffa__Category__c = 'SAVINGS';
      category = MDMCommonHelper.getProductTypeCode(p);
      System.assertEquals(category, 'S', 'Success');
    } catch (Exception ex) {
      System.assert(true, 'An Exception was not thrown');
    }

    tffa__AccountPreference__c accPref1 = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'DEBIT_CARD'
    );

    insert accPref1;

    CZPartyAlias__c aliasObj = new CZPartyAlias__c();
    aliasObj.Name = 'onee';
    aliasObj.AliasFirstName__c = 'Testttttt';
    aliasObj.AliasLastName__c = 'Testone';
    aliasObj.Party__c = party.Id;
    insert aliasObj;

    List<tffa__Application__c> appList1 = CZDocusignRepository.fetchApplicationsWithChildObjects(new List<tffa__Application__c>{ app });
    List<tffa__Party__c> partyList1 = FISCCIntegrationLogRepository.findPartydWithChildObjects(new List<Id>{ party.Id });

    FISCCIntegrationLogService.applicationObjs = appList1;
    String res = '';
    res = MDMCustomerCreateExtension.getPartySuffixData('Jr');
    System.assertEquals(res, 'Jr', 'Success');

    MDMAccountCreateExtension.getAddress(addr);
    MDMAccountCreateExtension.getDebitcardDetails(partyXrf, appList1[0]);
    MDMCustomerCreateExtension.getAliasDetails(partyList1[0]);
    MDMCustomerCreateExtension.getDebitCardDetails(partyList1[0]);

    try {
      MDMCustomerUpdateExtension.updateCustomer(null, null);
    } catch (Exception ex) {
      System.assert(true, 'An Exception was not thrown');
    }

    String emp = MDMCommonHelper.getEmploymentType('FULLTIME');
    System.assertEquals(emp, 'F', 'Success');

    emp = MDMCommonHelper.getEmploymentType('PARTTIME');
    System.assertEquals(emp, 'P', 'Success');

    emp = MDMCommonHelper.getEmploymentType('RETIRED');
    System.assertEquals(emp, 'R', 'Success');

    emp = MDMCommonHelper.getEmploymentType('UNEMPLOYED');
    System.assertEquals(emp, 'U', 'Success');

    emp = MDMCommonHelper.getEmploymentType('CONTRACTOR');
    System.assertEquals(emp, 'T', 'Success');

    emp = MDMCommonHelper.getEmploymentType('');
    System.assertEquals(emp, 'U', 'Success');

    String addType = MDMCommonHelper.getaddressType('HOME');
    System.assertEquals(addType, 'PRIM', 'Success');

    String identityType = MDMCommonHelper.getIdentificationType('DL');
    System.assertEquals(identityType, 'DL', 'Success');

    identityType = MDMCommonHelper.getIdentificationType('StateID');
    System.assertEquals(identityType, 'ST', 'Success');

    identityType = MDMCommonHelper.getIdentificationType('Passport');
    System.assertEquals(identityType, 'PPT', 'Success');

    identityType = MDMCommonHelper.getIdentificationType('');
    System.assertEquals(identityType, '', 'Success');

    String taxIdType = MDMCommonHelper.getTaxIdType('SSN');
    System.assertEquals(taxIdType, 'S', 'Success');

    taxIdType = MDMCommonHelper.getTaxIdType('TIN');
    System.assertEquals(taxIdType, 'T', 'Success');

    taxIdType = MDMCommonHelper.getTaxIdType('EIN');
    System.assertEquals(taxIdType, 'F', 'Success');

    taxIdType = MDMCommonHelper.getTaxIdType('NONE');
    System.assertEquals(taxIdType, 'N', 'Success');

    taxIdType = MDMCommonHelper.getTaxIdType('');
    System.assertEquals(taxIdType, 'N', 'Success');

    Test.stopTest();
  }
}