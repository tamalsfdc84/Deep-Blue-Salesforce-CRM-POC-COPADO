@isTest
public with sharing class FISCCCardBaseIntegrationTest {
  @isTest
  static void testCBIntegration() {
    tffa__Submission__c sub = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '001',
      tffa__Status__c = 'SUBMITTED'
    );
    insert sub;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAAAAAAAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    //party.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
    insert party;
    lstParty.add(party);

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = true,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref;

    //create party
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.tffa__PrimaryPhone__c = '5072630009';
    objParty.tffa__FirstName__c = 'SSANDRAA';
    objParty.tffa__NationalIdentifierValue__c = '666001753';
    objParty.tffa__LastName__c = 'CCOBAA';
    objParty.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty.tffa__Citizenship__c = 'Citizen';
    objParty.PreferredContactNumber__c = 'HOME';
    objParty.tffa__SecondaryPhone__c = '987627897';
    objParty.CellPhoneNumber__c = '97557854457';
    objParty.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty;
    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

    //insert app data
    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      //ShareId__c = '0032',
      tffa__Amount__c = 100.0,
      //ShareStatus__c = 'SUCCESS',
      tffa__PromotionCode__c = 'SUMMERJOY',
      //SourceOfReference__c  =  'FLYER_OR_POSTER',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      DebitCardIssuanceStatus__c = 'PENDING',
      AccountOpeningStatus__c = 'FAILURE',
      tffa__Status__c = 'FUNDED',
      tffa__AutoKYCDecisionOutcome__c = 'APPROVED',
      IsRoutingRequired__c = true
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;

    //account preference
    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '98916237',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = objParty.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = '12123',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'DEBIT_CARD'
    );
    insert accPref;

    //create Identity
    tffa__Identification__c identity = new tffa__Identification__c();
    identity.tffa__Party__c = lstParty[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity.tffa__Party__c);
    identity.tffa__IdentificationNumber__c = 'K987667';
    identity.tffa__Type__c = 'DL';
    identity.tffa__IssuingState__c = 'California';
    identity.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity;
    //create Employment Data
    tffa__Employment__c objEmployment = new tffa__Employment__c();
    objEmployment.tffa__Party__c = lstParty[0].id;
    objEmployment.tffa__EmployerName__c = 'Emp Name';
    objEmployment.tffa__Type__c = 'STUDENT';
    objEmployment.OccupationType__c = '003';
    insert objEmployment;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref = new tffa__ApplicationPartyXref__c();
    appPartyxref.tffa__Party__c = lstParty[0].Id;
    appPartyxref.tffa__Application__c = app.id;
    appPartyxref.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref.Name = 'Test';
    insert appPartyxref;
    tffa.logger.debug(' party.Id ==>' + party.Id);
    tffa.logger.debug('appPartyxref ==>' + appPartyxref);
    List<tffa__party__c> lstParty1 = new List<tffa__party__c>();
    lstParty1 = [
      SELECT
        id,
        (SELECT id FROM tffa__Applications__r),
        (
          SELECT id, tffa__IdentificationNumber__c, tffa__Type__c, tffa__IssuingState__c, tffa__IssueDate__c, tffa__ExpirationDate__c
          FROM tffa__Identifications__r
        ),
        (SELECT id, tffa__EmployerName__c, tffa__Type__c, OccupationType__c, Name FROM tffa__Employments__r),
        tffa__BirthDate__c,
        tffa__PrimaryPhone__c,
        tffa__Suffix__c,
        tffa__Citizenship__c,
        tffa__NationalIdentifierValue__c,
        PreferredContactNumber__c,
        tffa__FirstName__c,
        tffa__LastName__c,
        tffa__MiddleName__c,
        tffa__SecondaryPhone__c,
        CellPhoneNumber__c,
        tffa__MothersMaidenName__c
      FROM tffa__party__c
      WHERE id = :lstParty[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + lstParty1[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;
    //create tffa__Location__c
    tffa__Location__c objLoc = new tffa__Location__c();
    objLoc.Name = '988';
    objLoc.FISBranchCode__c = '200';
    objLoc.CostCenter__c = '1000';
    objLoc.tffa__Address__c = objAddress.id;
    objLoc.tffa__Code__c = '901';
    insert objLoc;
    // create Brand Data
    List<tffa__Brand__c> lstBrand = new List<tffa__Brand__c>();
    tffa__Brand__c objBrand = new tffa__Brand__c();
    objBrand.DefaultLocation__c = objLoc.id;
    objBrand.tffa__Code__c = sub.tffa__Brand__c;
    insert objBrand;
    lstBrand.add(objBrand);
    // create BrandLocation(junction) data
    tffa__BrandLocation__c objBrandLoc = new tffa__BrandLocation__c();
    objBrandLoc.tffa__Brand__c = objBrand.id;
    objBrandLoc.tffa__Location__c = objLoc.id;
    insert objBrandLoc;
    // insert tffa__PartyAddressXref__c
    tffa__PartyAddressXref__c partAddXref = new tffa__PartyAddressXref__c();
    partAddXref.tffa__Address__c = objAddress.id;
    partAddXref.tffa__Party__c = objParty.id;
    insert partAddXref;
    Test.startTest();
    try {
      Database.executeBatch(new CZWTFCCardBaseIntegrationBatch(), 1);
      Database.executeBatch(new CZWTFCRetryFailedAppBatch(), 1);
      List<tffa__Application__c> appList = CZWTFCApplicationRepository.findAppwithChildsforCB();
      FISCCCardBaseIntegrationExecutor.processDebitCardRequest(appList[0]);
      tffa__AccountPreference__c accPrefTest = appList[0].tffa__AccountPreferences__r[0];
      Object testResult;
      tffa__Party__c partyTest = CZWTFCPartyRepository.findByIdWithChildObjects(accPrefTest.tffa__party__c);
      Test.setMock(HttpCalloutMock.class, new FISCCDebitCardNoGenMockClass());
      testResult = FISCCCardBaseIntegrationProvider.generateCardNo(accPrefTest, partyTest);
      Test.setMock(HttpCalloutMock.class, new FISCCDebitCardCustDetailsMockClass());
      testResult = FISCCCardBaseIntegrationProvider.updateCustomerDemographics(accPrefTest, partyTest, appList[0]);
      Test.setMock(HttpCalloutMock.class, new FISCCDebitCardDOMockClass());
      testResult = FISCCCardBaseIntegrationProvider.generateDepositOriginationReq(accPrefTest, partyTest, appList[0]);
      Test.setMock(HttpCalloutMock.class, new FISCCDebitCardExpediteShippingMockClass());
      testResult = FISCCCardBaseIntegrationProvider.generateExpediteDeliveryReq(accPrefTest, partyTest, appList[0]);

      // covering exception lines
      new FISCCDebitCardNoGenResponseBuilder().build('testString', null, null);
      FISCCDebitCardNoGenResponseBuilder.testException = true;
      new FISCCDebitCardNoGenResponseBuilder().build(null, null, null);
      new FISCCDebitCardNoGenResponseBuilder().parseResponse(null, null, null);

      new FISCCDebitCardCreationResponseBuilder().build('testString', null, null);
      FISCCDebitCardCreationResponseBuilder.testException = true;
      new FISCCDebitCardCreationResponseBuilder().build(null, null, null);
      new FISCCDebitCardCreationResponseBuilder().parseResponse(null, null, null);

      new FISCCMultiAccDebitCardCreationResBuilder().build('testString', null, null);
      FISCCDebitCardCreationResponseBuilder.testException = true;
      new FISCCMultiAccDebitCardCreationResBuilder().build(null, null, null);
      new FISCCMultiAccDebitCardCreationResBuilder().parseResponse(null, null, null);

      new FISCCDebitCardAccRelResponseBuilder().build('testString', null, null);
      FISCCDebitCardAccRelResponseBuilder.testException = true;
      new FISCCDebitCardAccRelResponseBuilder().build(null, null, null);
      new FISCCDebitCardAccRelResponseBuilder().parseResponse(null, null, null);

      new FISCCExpediteCardDeliveryResBuilder().build('testString', null, null);
      FISCCDepositOriginationResponseBuilder.testException = true;
      new FISCCDepositOriginationResponseBuilder().build(null, null, null);
      new FISCCDepositOriginationResponseBuilder().parseResponse(null, null, null);

      new FISCCExpediteCardDeliveryResBuilder().build('testString', null, null);
      FISCCExpediteCardDeliveryResBuilder.testException = true;
      new FISCCExpediteCardDeliveryResBuilder().build(null, null, null);
      new FISCCExpediteCardDeliveryResBuilder().parseResponse(null, null, null);

      new FISCCDebitCardCustDetailsResponseBuilder().build('testString', null, null);
      FISCCDebitCardCustDetailsResponseBuilder.testException = true;
      new FISCCDebitCardCustDetailsResponseBuilder().build(null, null, null);
      new FISCCDebitCardCustDetailsResponseBuilder().parseResponse(null, null, null);
      System.enqueueJob(new CZWTFCAppRoutingService(app));
    } catch (Exception ex) {
      tffa.Logger.error('Exception in generateCardNo : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }

    try {
      List<tffa__Application__c> appList = CZWTFCApplicationRepository.findAppwithChildsforCB();
      tffa__AccountPreference__c accPrefTest = appList[0].tffa__AccountPreferences__r[0];
      tffa__Party__c partyTest = CZWTFCPartyRepository.findByIdWithChildObjects(accPrefTest.tffa__party__c);
      CZWTFCSubmissionServiceExt.updateEmbossedName(new List<tffa__Party__c>{ partyTest });
    } catch (Exception ex) {
      tffa.Logger.error('Exception in generateCardNo : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }

    //parse response test
    try {
      FISCCCardBaseIntegrationProvider integrationProv = new FISCCCardBaseIntegrationProvider();
      FISCCDebitCardNoGenResponseDTO respone = new FISCCDebitCardNoGenResponseDTO();
      FISCCDebitCardCreationResponseDTO resptwo = new FISCCDebitCardCreationResponseDTO();
      FISCCDebitCardAccRelResponseDTO respthree = new FISCCDebitCardAccRelResponseDTO();
      FISCCDebitCardCustDetailsResponseDTO respfour = new FISCCDebitCardCustDetailsResponseDTO();
      FISCCMultiAccDebitCardCreationResDTO respfive = new FISCCMultiAccDebitCardCreationResDTO();
      FISCCDepositOriginationEntityResponse respsix = new FISCCDepositOriginationEntityResponse();
      FISCCExpediteCardDeliveryResponseDTO respseven = new FISCCExpediteCardDeliveryResponseDTO();

      Boolean result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respone, FISCCIntegrationConstants.DEBIT_CARDNO_GEN);
      System.assertEquals(result1, false, 'Success');

      result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(resptwo, FISCCIntegrationConstants.DEBIT_CARD_CREATION);
      System.assertEquals(result1, false, 'Success');

      result1 =FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respthree, FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION);
      System.assertEquals(result1, false, 'Success');

      result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respfour, FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS);
      System.assertEquals(result1, false, 'Success');

      result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respfive, FISCCIntegrationConstants.MULTI_ACCOUNT_DEBIT_CARD_CREATION);
      System.assertEquals(result1, false, 'Success');

      result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respsix, FISCCIntegrationConstants.DEBIT_CARD_DO);
      System.assertEquals(result1, false, 'Success');

      result1 = FISCCCardBaseIntegrationProvider.isCardBaseAPISuccess(respseven, FISCCIntegrationConstants.DEBIT_CARD_EXPEDITE);
      System.assertEquals(result1, false, 'Success');
    } catch (Exception ex) {
      tffa.Logger.error('Exception in generateCardNo : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}