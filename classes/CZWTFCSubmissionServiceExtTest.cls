@isTest
public with sharing class CZWTFCSubmissionServiceExtTest {
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
    submissionObj.tffa__Brand__c = '1234';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '801';

    insert application;

    applicationobjs.add(application);

    tffa__Application__c application2 = CZWTFCTestDataRepository.createCheckingApplication();
    application2.tffa__Product__c = product1.id;
    application2.tffa__Submission__c = submissionObj.id;
    application2.tffa__ProductCode__c = '801';

    insert application2;
    applicationobjs.add(application2);

    tffa__FundingRequest__c fundingRequest = new tffa__FundingRequest__c();
    fundingRequest.tffa__AccountType__c = 'CHECKING';
    fundingRequest.tffa__Amount__c = 101.0;
    fundingRequest.tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION';
    fundingRequest.tffa__LinkedApplication__c = application.Id;
    fundingRequest.tffa__Purpose__c = 'DEPOSIT';
    insert fundingRequest;
    tffa.SObjectAssembler asm2 = new tffa.SObjectAssembler(application);
    asm2.addChildObject('LinkedFundingRequests__r', fundingRequest);

    asm.addChildObject('Applications__r', application);
    asm.addChildObject('Applications__r', application2);

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

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;

    //tffa__Product__c product2 = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = ';CT;';
    prodMat1.tffa__Product__c = product1.Id;
    insert prodMat1;

    tffa__FundingMatrix__c fundingMatObj = new tffa__FundingMatrix__c();
    fundingMatObj.tffa__Product__c = product1.Id;
    fundingMatObj.tffa__MaxAmount__c = 10000;
    fundingMatObj.tffa__MinAmount__c = 100;
    fundingMatObj.tffa__Type__c = 'ACH';
    insert fundingMatObj;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    Test.startTest();
    try {
      tffa.Context ctx = tffa.Context.get();
      ctx.stage = 'PersonalInfo';
      ctx.eventName = 'verifyFunding';

      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.preCreate(submissionObj);
      subExt.preSubmit(submissionObj.id);
      subExt.postModify(submissionObj);
      subExt.postSubmit(submissionObj);
      subExt.postCreateOrUpdateParties(new List<tffa__SubmissionPartyXref__c>{ partyXRef });
      subExt.postCreateOrUpdateParties(new List<tffa__SubmissionPartyXref__c>{ xref1 });
      subExt.postCreateOrUpdateParties(new List<tffa__SubmissionPartyXref__c>{ xref12 });
      CZWTFCSubmissionServiceExt.throwError('abcd', new List<String>{ '1wqw' });
    } catch (Exception e) {
    }

    try {
      CZWTFCSubmissionRepository.findSubmissionByIds(new List<String>{ submissionObj.Id });
      CZWTFCSubmissionRepository.findSubByIds(new List<String>{ submissionObj.Id });
      CZWTFCSubmissionRepository.findSubmissionByParty(new List<Id>{ jointParty.Id });
      CZWTFCPartyRepository.findAllPartiesWithChildByIds(submissionObj);
      CZWTFCPartyRepository.findPartyObj('a@a.c', 'test', '1234');
    } catch (Exception e) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testcaseTwo() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa__Submission__c submissionObj4 = new tffa__Submission__c();
    submissionObj4.tffa__Status__c = 'IN_PROGRESS';
    submissionObj4.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj4.tffa__State__c = 'PersonalInfo';
    submissionObj4.tffa__HasExistingParty__c = true;
    submissionObj4.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj4;

    tffa__Party__c jointParty12 = new tffa__Party__c();
    jointParty12.tffa__IsExistingCustomer__c = false;
    jointParty12.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty12.tffa__Citizenship__c = 'Citizen';
    jointParty12.tffa__DoNotCall__c = false;
    jointParty12.tffa__DoNotEmail__c = false;
    jointParty12.tffa__DoNotText__c = false;
    jointParty12.tffa__FirstName__c = 'John';
    jointParty12.tffa__LastName__c = 'May';
    jointParty12.tffa__QualiFileStatus__c = 'PASSED';
    jointParty12.tffa__IDVStatus__c = 'PASSED';
    jointParty12.tffa__IDAStatus__c = 'PASSED';
    jointParty12.tffa__CDDStatus__c = 'PASSED';
    jointParty12.tffa__OFACStatus__c = 'PASSED';
    jointParty12.tffa__Type__c = 'INDIVIDUAL';
    jointParty12.tffa__NationalIdentifierValue__c = '123412341';
    jointParty12.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty12.tffa__FirstName__c = 'John';
    jointParty12.tffa__LastName__c = 'May';
    insert jointParty12;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c();
    subPartyXref.tffa__Submission__c = submissionObj.Id;
    subPartyXref.tffa__Party__c = jointParty12.Id;
    subPartyXref.tffa__Primary__c = true;
    subPartyXref.tffa__Party__r = jointParty12;
    subPartyXref.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref;

    tffa__Party__c jointParty14 = new tffa__Party__c();
    jointParty14.tffa__IsExistingCustomer__c = false;
    jointParty14.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty14.tffa__Citizenship__c = 'Citizen';
    jointParty14.tffa__DoNotCall__c = false;
    jointParty14.tffa__DoNotEmail__c = false;
    jointParty14.tffa__DoNotText__c = false;
    jointParty14.tffa__FirstName__c = 'John';
    jointParty14.tffa__LastName__c = 'May';
    jointParty14.tffa__QualiFileStatus__c = 'PASSED';
    jointParty14.tffa__IDVStatus__c = 'PASSED';
    jointParty14.tffa__IDAStatus__c = 'PASSED';
    jointParty14.tffa__CDDStatus__c = 'PASSED';
    jointParty14.tffa__OFACStatus__c = 'PASSED';
    jointParty14.tffa__Type__c = 'INDIVIDUAL';
    jointParty14.tffa__NationalIdentifierValue__c = '123412341';
    jointParty14.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty14.tffa__FirstName__c = 'John';
    jointParty14.tffa__LastName__c = 'May';
    insert jointParty14;

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c();
    subPartyXref2.tffa__Submission__c = submissionObj4.Id;
    subPartyXref2.tffa__Party__c = jointParty14.Id;
    subPartyXref2.tffa__Primary__c = true;
    subPartyXref2.tffa__Party__r = jointParty14;
    subPartyXref2.tffa__Type__c = 'INDIVIDUAL';
    insert subPartyXref2;

    Test.startTest();
    try {
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      Map<String, Object> queryParams = new Map<String, Object>();
      queryParams.put('partyId', jointParty12.Id);
      Map<String, Object> facts = new Map<String, Object>();
      tffa.QueryContext queryCtx = new tffa.QueryContext(queryParams);
      subExt.postReadAll(queryCtx, new List<tffa__Submission__c>{ new tffa__Submission__c() });
    } catch (Exception e) {
    }

    try {
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.postResume(submissionObj4);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void triggerTestCase() {
    Test.startTest();

    tffa__AddOnService__c addOnServiceObj = new tffa__AddOnService__c();
    addOnServiceObj.Name = 'test';
    addOnServiceObj.tffa__CardBINCode__c = '519841';
    addOnServiceObj.tffa__Code__c = 'BARRINGTON_CONSUMER_DEBIT_CARD';
    addOnServiceObj.tffa__Disabled__c = false;
    addOnServiceObj.tffa__EntityType__c = 'PARTY';
    addOnServiceObj.tffa__FullDescription__c = 'Easy access to money in your account.';
    addOnServiceObj.tffa__PartyRoleSet__c = 'CUSTOMER;PROSPECT';
    addOnServiceObj.tffa__Type__c = 'DEBIT_CARD';
    insert addOnServiceObj;

    tffa__AddOnServiceChecklist__c addServicecheckListObj = new tffa__AddOnServiceChecklist__c();
    addServicecheckListObj.Name = 'Test';
    insert addServicecheckListObj;

    tffa__AddOnServiceItem__c addOnServiceItem = new tffa__AddOnServiceItem__c();
    addOnServiceItem.Name = 'test';
    addOnServiceItem.tffa__Service__c = addOnServiceObj.Id;
    addOnServiceItem.tffa__Checklist__c = addServicecheckListObj.Id;
    insert addOnServiceItem;

    tffa__RecommendationConfiguration__c recObj = new tffa__RecommendationConfiguration__c();
    recObj.Name = 'Test';
    insert recObj;

    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '1234';
    prod2.Name = 'Test';
    insert prod2;

    tffa__ProductProductXref__c prodProdXref = new tffa__ProductProductXref__c();
    prodProdXref.tffa__Product__c = product1.Id;
    prodProdXref.tffa__RelatedProduct__c = prod2.Id;
    prodProdXref.tffa__Mandatory__c = true;
    prodProdXref.tffa__RelatedProductCode__c = product1.tffa__Code__c;
    prodProdXref.tffa__SortOrder__c = 1;
    insert prodProdXref;

    tffa__RecommendationConfigurationItem__c recItemObj = new tffa__RecommendationConfigurationItem__c();
    recItemObj.Name = 'Test';
    recItemObj.tffa__Configuration__c = recObj.Id;
    recItemObj.tffa__Product__c = product1.Id;
    insert recItemObj;

    tffa__ProductTerm__c productTermObj = new tffa__ProductTerm__c();
    productTermObj.tffa__Product__c = product1.Id;
    insert productTermObj;

    tffa__ProductFeature__c prodFeatObj = new tffa__ProductFeature__c();
    prodFeatObj.Name = 'Test';
    prodFeatObj.tffa__FieldType__c = 'CHECKBOX';
    prodFeatObj.tffa__Value__c = 'true';
    prodFeatObj.tffa__Product__c = product1.Id;
    prodFeatObj.tffa__Label__c = 'Test';
    insert prodFeatObj;

    tffa__FundingMatrix__c fundingMatObj = new tffa__FundingMatrix__c();
    fundingMatObj.tffa__Product__c = product1.Id;
    fundingMatObj.tffa__MaxAmount__c = 10000;
    fundingMatObj.tffa__MinAmount__c = 100;
    fundingMatObj.tffa__Type__c = 'ACH';
    insert fundingMatObj;

    tffa__Promotion__c promotionObj = new tffa__Promotion__c();
    promotionObj.Name = '1234';
    promotionObj.tffa__Code__c = '1234';
    insert promotionObj;

    tffa__PromotionPlan__c promoPlanObj = new tffa__PromotionPlan__c();
    promoPlanObj.Name = 'Test';
    promoPlanObj.tffa__Product__c = product1.Id;
    promoPlanObj.tffa__Code__c = '1234';
    promoPlanObj.tffa__ChannelSet__c = 'DIGITAL';
    promoPlanObj.tffa__Promotion__c = promotionObj.Id;
    insert promoPlanObj;

    tffa__ProductMatrix__c prodMat = new tffa__ProductMatrix__c();
    prodMat.tffa__Product__c = product1.Id;
    prodMat.tffa__SortOrder__c = 1;
    insert prodMat;

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    SubBrand__c subB = new SubBrand__c();
    subB.Brand__c = brandObj.Id;
    subB.Name = 'Test';
    insert subB;

    Test.stopTest();
  }

  @isTest
  public static void testCaseForPostModify() {
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
    submissionObj.tffa__Brand__c = '1234';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '801';

    insert application;

    applicationobjs.add(application);

    tffa__Application__c application2 = CZWTFCTestDataRepository.createCheckingApplication();
    application2.tffa__Product__c = product1.id;
    application2.tffa__Submission__c = submissionObj.id;
    application2.tffa__ProductCode__c = '801';

    insert application2;
    applicationobjs.add(application2);

    tffa__FundingRequest__c fundingRequest = new tffa__FundingRequest__c();
    fundingRequest.tffa__AccountType__c = 'CHECKING';
    fundingRequest.tffa__Amount__c = 99.0;
    fundingRequest.tffa__VerificationStatus__c = 'PENDING_MANUAL_VERIFICATION';
    fundingRequest.tffa__LinkedApplication__c = application.Id;
    fundingRequest.tffa__Purpose__c = 'DEPOSIT';
    insert fundingRequest;
    tffa.SObjectAssembler asm2 = new tffa.SObjectAssembler(application);
    asm2.addChildObject('LinkedFundingRequests__r', fundingRequest);

    asm.addChildObject('Applications__r', application);
    asm.addChildObject('Applications__r', application2);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__FundingMatrix__c fundingMatObj = new tffa__FundingMatrix__c();
    fundingMatObj.tffa__Product__c = product1.Id;
    fundingMatObj.tffa__MaxAmount__c = 10000;
    fundingMatObj.tffa__MinAmount__c = 100;
    fundingMatObj.tffa__Type__c = 'ACH';
    insert fundingMatObj;

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

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;

    //tffa__Product__c product2 = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = ';CT;';
    prodMat1.tffa__Product__c = product1.Id;
    insert prodMat1;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    Test.startTest();
    try {
      tffa.Context ctx = tffa.Context.get();
      ctx.eventName = 'verifyFunding';

      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.postModify(submissionObj);
    } catch (Exception e) {
    }

    try {
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.postCreateOrUpdateParties(new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
      subExt.postSave(submissionObj);
    } catch (Exception ex) {
    }
    try {
      CZWTFCSubmissionServiceExt.checkDuplicateProduct(new List<tffa__Application__c>{ application });
    } catch (Exception expn) {
    }
    Test.stopTest();
  }

  @isTest
  public static void testcaseErrorPostsave() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    submissionObj.tffa__Brand__c = '1234';
    insert submissionObj;

    Test.startTest();
    try {
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.postSave(submissionObj);
    } catch (Exception e) {
    }
    Test.stopTest();
  }

  @isTest
  public static void testcasePostStart() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
    insert sub;
    Test.startTest();
    tffa.IController controller;
    tffa.Context ctx = tffa.Context.get();
    Map<String, Object> params = new Map<String, Object>();
    params.put('brand', '118');
    params.put('authType', 'ind-1');
    params.put('frstNme', 'JOHN');
    params.put('lstNme', 'SMIYH');
    params.put('birthDte', '2000-02-02');
    params.put('ssnNmb', '122133232');
    params.put('acctNmb', '00001189080');
    params.put('lstDepAmt', '100');
    params.put('debitCrdlast4', '100');
    params.put('debitCrdCvv', '100');
    params.put('debitCrdPin', '100');
    params.put('brandCode', '100');
    params.put('method', 'DP_ACCOUNT');
    params.put('amnt', '100');
    params.put('PartyIdAuth', 'Test');
    try {
      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new CZMDMAuthMockClass());
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      subExt.postStart(sub, params);
    } catch (Exception ex) {
    }

    try {
      String resp = '{"status":"success","prtyId":"4460014","customerInfo":{"frstNme":"THOMAS","mdlNme":"A","lstNme":"HENDRICKS","addrsLn1":"1630 FULTONHAM WAY","city":"ROSEMONT","stateCd":"IL","zipCd":"60018","country":"USA","primPhNmb":"(847) 939-9001","scndryPhNmb":"(847) 939-9001","psnlEmailId":"n@gmail.com","birthDte":"1965-09-07T00:00:00-05:00","idtfrLst":[{"idtfrTypCd":"DL","idtfrNmb":"H47852149658","issueStateCd":"IL","expDte":"2026-09-25T00:00:00-05:00","issueDte":"0001-01-01T00:00:00-06:00"}],"ssnNmb":"345126874","ctzshp":"N","occpCd":"005","emplyNme":"US OLYMPIC COMMITTEE"},"customerRcdLst":[{"cisNmb":"57860","chrtrCd":"889","cisStrtDte":"2021-06-22T06:08:01.494-05:00"},{"cisNmb":"00000066954","chrtrCd":"118","cisStrtDte":"2021-12-09T07:40:55.581-06:00"},{"cisNmb":"66954","chrtrCd":"889","cisStrtDte":"2021-12-10T03:26:23.360-06:00"},{"cisNmb":"67892","chrtrCd":"118","cisStrtDte":"2022-01-28T01:00:54.375-06:00"},{"cisNmb":"67892","chrtrCd":"889","cisStrtDte":"2022-02-03T06:40:39.309-06:00"}],"acctLst":[{"acctNmb":"01676673539","chrtrCd":"889","acctCreationDte":"2018-04-26T00:00:00-05:00","acctCtgry":"DP","pdtCd":"800","pdtNm":"TOTAL ACCESS","acctTyp":"DP|D","acctStatus":"Open","ownrshpCd":"No","rltnshpCd":"022"}]}';
      CZMDMAuthenticationResponseDTO dto = (CZMDMAuthenticationResponseDTO) System.JSON.deserialize(
        resp,
        CZMDMAuthenticationResponseDTO.class
      );

      dto.customerInfo.occpCd = 'H';
      CZWTFCAuthResponse respTest = new CZWTFCAuthResponse();
      respTest = CZWTFCAuthenticationService.parseResponse(respTest, dto);
      CZWTFCSubmissionServiceExt.parseSearchResponse(respTest);
    } catch (Exception ex) {
    }
    Test.stopTest();
  }
}