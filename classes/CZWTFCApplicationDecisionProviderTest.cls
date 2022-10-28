@isTest
public with sharing class CZWTFCApplicationDecisionProviderTest {
  @isTest
  static void testManualUpdateApprove() {
    tffa__Submission__c submissionObj = getTestSubmission();
    submissionObj.tffa__Applications__r[0].tffa__KYCDecisionOutcome__c = 'APPROVED';
    Map<String, Object> params = new Map<String, Object>{ 'Type__c' => 'KYC' };

    Test.startTest();

    try {
      List<tffa__Application__c> appObjs = (new CZWTFCApplicationDecisionProvider()
        .updateDecision(submissionObj.tffa__Applications__r, params));
    } catch (Exception ex) {
    }
    Test.stopTest();
  }

  @isTest
  static void testManualUpdateDecline() {
    tffa__Submission__c submissionObj = getTestSubmission();
    submissionObj.tffa__Applications__r[0].tffa__KYCDecisionOutcome__c = 'DECLINED';
    submissionObj.tffa__Applications__r[0].tffa__KYCDeclinedReason__c = 'DOCUMENTS_DO_NOT_MATCH';
    Map<String, Object> params = new Map<String, Object>{ 'Type__c' => 'KYC' };
    Test.startTest();

    try {
      List<tffa__Application__c> appObjs = (new CZWTFCApplicationDecisionProvider()
        .updateDecision(submissionObj.tffa__Applications__r, params));
    } catch (Exception ex) {
    }
    //system.assertNotEquals(appObjs, null);
    Test.stopTest();
  }

  static tffa__Submission__c getTestSubmission() {
    tffa__Submission__c submissionObj = CZWTFCTestDataRepository.createSubmission();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application1 = CZWTFCTestDataRepository.createCheckingApplication();
    application1.tffa__Product__c = product1.id;
    application1.tffa__Submission__c = submissionObj.id;

    //    application1.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert application1;

    applicationobjs.add(application1);

    asm.addChildObject('Applications__r', application1);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();
    //partyObj.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
    insert partyObj;

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();
    partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c = 'AZ';
    partyObj.tffa__IDVStatus__c = 'PASSED';
    partyObj.tffa__DebitBureauStatus__c = 'PASSED';

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    tffa__Party__c partyObj2 = CZWTFCTestDataRepository.createIndividualParty();
    //    partyObj2.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
    insert partyObj2;
    tffa.SObjectAssembler asmParty2 = new tffa.SObjectAssembler(partyObj2);
    asmParty2.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty2.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());

    partyObj2 = (tffa__Party__c) asmParty2.assemble();

    tffa__SubmissionPartyXref__c xref2 = new tffa__SubmissionPartyXref__c();
    xref2.tffa__Party__r = partyObj2;
    xref2.tffa__Primary__c = true;
    xref2.tffa__Type__c = 'INDIVIDUAL';

    asm.addChildObject('tffa__PartyXrefs__r', xref2);
    submissionObj = (tffa__Submission__c) asm.assemble();
    // submissionObj = tffa.SubmissionService.create(submissionObj);

    return submissionObj;
  }
  @isTest
  static void testDoDecision() {
    tffa__Submission__c submissionObj = getTestSubmissionForDODec();

    List<tffa__Application__c> appobjs = submissionObj.tffa__Applications__r;
    CZWTFCApplicationDecisionProvider testProvider = new CZWTFCApplicationDecisionProvider();
    CZWTFCApplicationDecisionProvider.testSubmissionObj = submissionObj;
    insertAppDecMatrix();
    Test.startTest();
    tffa.Context tx = tffa.Context.get();
    tx.Id = submissionObj.Id;
    appobjs = testProvider.doDecision(appobjs, new Map<String, Object>());

    CZWTFCApplicationDecisionProvider.testSubmissionObj = null;
    appobjs = testProvider.doDecision(appobjs, new Map<String, Object>());

    Test.stopTest();
  }

  static tffa__Submission__c getTestSubmissionForDODec() {
    try {
      tffa__Product__c prod2 = new tffa__Product__c();
      prod2.tffa__Category__c = 'CHECKING';
      prod2.tffa__Code__c = '1234';
      prod2.Name = 'Test';
      prod2.IsStudentProduct__c = true;
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
      product1.IsStudentProduct__c = true;
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

      jointParty.tffa__IDVStatus__c = 'PASSED';
      jointParty.tffa__DebitBureauStatus__c = 'PASSED';
      jointParty.TotalAmountApplicantOwes__c = 60.0;
      jointParty.NumberOfInquires__c = 5;
      jointParty.tffa__IsMinor__c = true;
      jointParty.tffa__PrefillSource__c = 'IDScan';
      jointParty.tffa__Prefilled__c = true;
      jointParty.tffa__IDAStatus__c = 'PASSED';
      jointParty.IsSsnMatch__c = true;
      jointParty.IsDobMatch__c = true;
      jointParty.tffa__OFACStatus__c = 'PASSED';
      insert jointParty;
      tffa__Employment__c empObj = CZWTFCTestDataRepository.createEmployment();
      empObj.tffa__Party__c = jointparty.Id;
      empObj.tffa__Type__c = 'STUDENT';
      insert empObj;
      tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
      asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
      asmParty1.addChildObjects('tffa__Employments__r', new List<tffa__Employment__c>{ empObj });
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
      jointParty1.tffa__IDVStatus__c = 'PASSED';
      jointParty1.tffa__DebitBureauStatus__c = 'PASSED';
      jointParty1.TotalAmountApplicantOwes__c = 6.0;
      jointParty1.NumberOfInquires__c = 5;
      jointParty1.tffa__IsMinor__c = false;
      jointParty1.tffa__PrefillSource__c = '';
      jointParty1.tffa__Prefilled__c = false;
      jointParty1.tffa__IDAStatus__c = 'PASSED';
      jointParty1.IsSsnMatch__c = false;
      jointParty1.IsDobMatch__c = false;
      jointParty1.tffa__OFACStatus__c = 'PASSED';
      insert jointParty1;
      tffa__Employment__c empObj1 = CZWTFCTestDataRepository.createEmployment();
      empObj1.tffa__Party__c = jointparty1.Id;
      empObj1.tffa__Type__c = 'STUDENT';
      insert empObj1;
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

      tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
      xref1.tffa__Submission__c = submissionObj.id;
      xref1.tffa__Party__r = jointParty;
      xref1.tffa__IsPresent__c = true;
      xref1.Name = 'TEst';
      xref1.tffa__Primary__c = false;
      xref1.tffa__Type__c = 'INDIVIDUAL';

      asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ xref1, xref12 });
      submissionObj = (tffa__Submission__c) asm.assemble();
      //System.debug('****'+CZWTFCPartyRepository.findEmploymentByPartyID(jointParty1.Id).tffa__Type__c);
      return submissionObj;
    } catch (Exception ex) {
      // System.debug(' Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return null;
  }

  static void insertAppDecMatrix() {
    List<tffa__ApplicationDecisionMatrix__c> appDMatrixList = new List<tffa__ApplicationDecisionMatrix__c>();
    // appDMatrixList.add(
    //   new tffa__ApplicationDecisionMatrix__c(
    //     tffa__Outcome__c = 'APPROVED',
    //     tffa__Description__c = 'Approve All For Now',
    //     tffa__SortOrder__c = 0,
    //     tffa__Type__c = 'KYC',
    //     tffa__AdverseActionNoticeRequired__c = false
    //   )
    // );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'APPROVED',
        tffa__Description__c = 'No KYC for Minor. Decisioning to be done based on KYC of Joint Holder.',
        tffa__SortOrder__c = 10,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        IsMinor__c = 'Yes'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'APPROVED',
        tffa__Description__c = 'For Students only OFAC, SSN & DOB to be checked.',
        tffa__SortOrder__c = 20,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        IsMinor__c = 'No',
        IsStudentProduct__c = 'Yes',
        IsPrimaryApplicant__c = 'Yes',
        OFACStatus__c = 'PASSED',
        IsSsnMatch__c = 'Yes',
        IsDobMatch__c = 'Yes',
        Occupation__c = 'STUDENT'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'Declined for IDA, if ID is not uploaded.',
        tffa__SortOrder__c = 30,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        IsMinor__c = 'No',
        IsIDUploaded__c = 'No',
        IDAStatus__c = 'DECLINED'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'Declined for IDV',
        tffa__SortOrder__c = 49,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        IsPrimaryApplicant__c = 'No',
        tffa__IDVStatus__c = 'DECLINED'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'Declined for OFAC',
        tffa__SortOrder__c = 50,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        OFACStatus__c = 'FAILED'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'Declined for Qualifile',
        tffa__SortOrder__c = 60,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        tffa__DebitBureauStatus__c = 'DECLINED'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'If all FIS DSS outcomes are PASS but the applicant owes more than $50 at another FI.',
        tffa__SortOrder__c = 70,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        ChargeAmountExceeded__c = 'Yes'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'DECLINED',
        tffa__Description__c = 'If all FIS DSS outcomes are PASS but the applicant has 4 or more inquiries within the Qualifile report, please decline',
        tffa__SortOrder__c = 80,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        InquiryCountExceeded__c = 'Yes'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'REVIEW',
        tffa__Description__c = 'Sent to review, as customer failed IDA ONLY when an ID has been uploaded as well.',
        tffa__SortOrder__c = 90,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        IDAStatus__c = 'DECLINED',
        IsIDUploaded__c = 'Yes',
        ChargeAmountExceeded__c = 'Yes'
      )
    );
    appDMatrixList.add(
      new tffa__ApplicationDecisionMatrix__c(
        tffa__Outcome__c = 'APPROVED',
        tffa__Description__c = 'Approve if all FIS DSS outcomes are PASS and open the account.',
        tffa__SortOrder__c = 100,
        tffa__Type__c = 'KYC',
        tffa__AdverseActionNoticeRequired__c = false,
        isMinor__c = 'No',
        IDAStatus__c = 'PASSED',
        IsIDUploaded__c = 'Yes',
        tffa__DebitBureauStatus__c = 'PASSED',
        tffa__IDVStatus__c = 'PASSED',
        OFACStatus__c = 'PASSED'
      )
    );

    insert appDMatrixList;
  }

  @isTest
  public static void counterOfferTest() {
    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Category__c = 'CHECKING';
    prod1.tffa__Code__c = '1234';
    prod1.Name = 'Test';
    insert prod1;

    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '12345';
    prod2.Name = 'Test1';
    insert prod2;

    tffa__CounterOfferItem__c counteroffer1 = new tffa__CounterOfferItem__c();
    counteroffer1.tffa__Product__c = prod1.Id;
    counteroffer1.tffa__SortOrder__c = 1;

    tffa__CounterOfferItem__c counteroffer2 = new tffa__CounterOfferItem__c();
    counteroffer2.tffa__Product__c = prod2.Id;
    counteroffer2.tffa__SortOrder__c = 2;

    List<tffa__CounterOfferItem__c> counteritemlist = new List<tffa__CounterOfferItem__c>();
    counteritemlist.add(counteroffer1);
    counteritemlist.add(counteroffer2);

    Test.startTest();

    try {
      CZWTFCApplicationDecisionProvider.getCounterOfferItems(counteritemlist);
    } catch (Exception ex) {
      tffa.Logger.debug(' Exception in testclass for getCounterOfferItems : ' + ex.getMessage() + ' ' + ex.getLineNumber());
    }

    Test.stopTest();
  }

  @isTest
  public static void isIdUploadedTest() {
    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    insert jointParty1;
    Test.startTest();
    tffa__Submission__c submissionObj = getTestSubmissionForDODec();
    try {
      CZWTFCApplicationDecisionProvider.isIdUploaded(jointParty1.Id);
      CZWTFCApplicationDecisionProvider.isIdUploaded('1234');
    } catch (Exception ex) {
    }
    Test.stopTest();
  }
}