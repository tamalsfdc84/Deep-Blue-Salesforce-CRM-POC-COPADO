@isTest
public inherited sharing class FISCCDepositOriginationTest {
  @isTest
  public static void testProcessApplication() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '001'
    );
    insert sub;

    tffa__Submission__c sub1 = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      FISBranchCode__c = '888'
    );
    insert sub1;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
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
    lstParty.add(party);

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = true,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref;

    //create party
    List<tffa__Party__c> lstobjParty = new List<tffa__Party__c>();
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.Name = 'partyName1';
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
    lstobjParty.add(objParty);

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref1;

    //create party
    List<tffa__Party__c> lstobjParty1 = new List<tffa__Party__c>();
    tffa__Party__c objParty1 = new tffa__Party__c();
    objParty1.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty1.Name = 'partyName1';
    objParty1.tffa__PrimaryPhone__c = '5072630009';
    objParty1.tffa__FirstName__c = 'SSANDRAA';
    objParty1.tffa__NationalIdentifierValue__c = '666001753';
    objParty1.tffa__LastName__c = 'CCOBAA';
    objParty1.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty1.tffa__Citizenship__c = 'Citizen';
    objParty1.PreferredContactNumber__c = 'HOME';
    objParty1.tffa__SecondaryPhone__c = '987627897';
    objParty1.CellPhoneNumber__c = '97557854457';
    objParty1.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty1;
    lstobjParty1.add(objParty1);

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty1.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref2;

    List<tffa__Party__c> lstobjParty2 = new List<tffa__Party__c>();
    tffa__Party__c objParty2 = new tffa__Party__c();
    objParty2.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty2.Name = 'partyName1';
    objParty2.tffa__PrimaryPhone__c = '5072630009';
    objParty2.tffa__FirstName__c = 'SSANDRAA';
    objParty2.tffa__NationalIdentifierValue__c = '666001753';
    objParty2.tffa__LastName__c = 'CCOBAA';
    objParty2.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty2.tffa__Citizenship__c = 'Citizen';
    objParty2.PreferredContactNumber__c = 'HOME';
    objParty2.tffa__SecondaryPhone__c = '987627897';
    objParty2.CellPhoneNumber__c = '97557854457';
    objParty2.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty2;
    lstobjParty2.add(objParty2);

    tffa__SubmissionPartyXref__c subPartyXref3 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty2.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref3;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

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
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    //app1.tffa__LinkedFundingRequests__r = fundingReq;
    insert app1;
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
      tffa__Status__c = 'APPROVED'
    );
    // app.tffa__LinkedFundingRequests__r = fundingReq;
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app1.Id;
    insert fundingReq1;

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c();
    fundingReq.Name = '';
    fundingReq.tffa__Status__c = 'IN_PROGRESS';
    fundingReq.tffa__Type__c = 'ACH';
    fundingReq.tffa__Amount__c = 122;
    fundingReq.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq.tffa__LinkedApplication__c = app.Id;
    insert fundingReq;

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
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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

    tffa__Identification__c identity1 = new tffa__Identification__c();
    identity1.tffa__Party__c = lstobjParty[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity1.tffa__Party__c);
    identity1.tffa__IdentificationNumber__c = 'K987667';
    identity1.tffa__Type__c = 'DL';
    identity1.tffa__IssuingState__c = 'California';
    identity1.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity1.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity1;
    //create Employment Data
    tffa__Employment__c objEmployment1 = new tffa__Employment__c();
    objEmployment1.tffa__Party__c = lstobjParty[0].id;
    objEmployment1.tffa__EmployerName__c = 'Emp Name';
    objEmployment1.tffa__Type__c = 'STUDENT';
    objEmployment1.OccupationType__c = '003';
    insert objEmployment1;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref1 = new tffa__ApplicationPartyXref__c();
    appPartyxref1.tffa__Party__c = lstobjParty[0].Id;
    appPartyxref1.tffa__Application__c = app.id;
    appPartyxref1.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref1.Name = 'Test';
    insert appPartyxref1;

    tffa.logger.debug('appPartyxref1 ==>' + appPartyxref);
    List<tffa__party__c> lstobjParty_App1 = new List<tffa__party__c>();
    lstobjParty_App1 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + lstobjParty_App1[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__Line2__c = 'Line 2';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;

    tffa__Address__c objAddress1 = new tffa__Address__c();
    objAddress1.Name = 'Address Name';
    objAddress1.tffa__Line1__c = 'Line 1';
    objAddress1.tffa__Line2__c = 'Line 2';
    objAddress1.tffa__City__c = 'city';
    objAddress1.tffa__ZipCode__c = '1234';
    objAddress1.tffa__State__c = 'WI';
    objAddress1.tffa__Country__c = 'US';
    insert objAddress1;
    //
    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = lstobjParty1[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = lstobjParty1[0].id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref2 = new tffa__ApplicationPartyXref__c();
    appPartyxref2.tffa__Party__c = lstobjParty1[0].Id;
    appPartyxref2.tffa__Application__c = app.id;
    appPartyxref2.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref2.Name = 'Test';
    insert appPartyxref2;

    tffa.logger.debug('appPartyxref2 ==>' + appPartyxref);
    List<tffa__party__c> App2_lstobjParty2 = new List<tffa__party__c>();
    App2_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty1[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App2_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress2 = new tffa__Address__c();
    objAddress2.Name = 'Address Name';
    objAddress2.tffa__Line1__c = 'Line 1';
    objAddress2.tffa__Line2__c = 'Line 2';
    objAddress2.tffa__City__c = 'city';
    objAddress2.tffa__ZipCode__c = '1234';
    objAddress2.tffa__State__c = 'WI';
    objAddress2.tffa__Country__c = 'US';
    insert objAddress2;
    //
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
    partAddXref.tffa__Party__c = lstParty1[0].id;
    insert partAddXref;

    tffa__PartyAddressXref__c partAddXref1 = new tffa__PartyAddressXref__c();
    partAddXref1.tffa__Address__c = objAddress1.id;
    partAddXref1.tffa__Party__c = lstobjParty_App1[0].id;
    insert partAddXref1;

    tffa__PartyAddressXref__c partAddXref2 = new tffa__PartyAddressXref__c();
    partAddXref2.tffa__Address__c = objAddress2.id;
    partAddXref2.tffa__Party__c = App2_lstobjParty2[0].id;
    insert partAddXref2;
    //
    tffa__Identification__c identity3 = new tffa__Identification__c();
    identity3.tffa__Party__c = lstobjParty2[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity3.tffa__Party__c);
    identity3.tffa__IdentificationNumber__c = 'K987667';
    identity3.tffa__Type__c = 'DL';
    identity3.tffa__IssuingState__c = 'California';
    identity3.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity3.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity3;
    //create Employment Data
    tffa__Employment__c objEmployment3 = new tffa__Employment__c();
    objEmployment3.tffa__Party__c = lstobjParty1[0].id;
    objEmployment3.tffa__EmployerName__c = 'Emp Name';
    objEmployment3.tffa__Type__c = 'STUDENT';
    objEmployment3.OccupationType__c = '003';
    insert objEmployment3;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref3 = new tffa__ApplicationPartyXref__c();
    appPartyxref3.tffa__Party__c = lstobjParty2[0].Id;
    appPartyxref3.tffa__Application__c = app.id;
    appPartyxref3.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref3.Name = 'Test';
    insert appPartyxref3;

    tffa.logger.debug('appPartyxref3 ==>' + appPartyxref);
    List<tffa__party__c> App3_lstobjParty2 = new List<tffa__party__c>();
    App3_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty2[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App3_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress3 = new tffa__Address__c();
    objAddress3.Name = 'Address Name';
    objAddress3.tffa__Line1__c = 'Line 1';
    objAddress3.tffa__Line2__c = 'Line 2';
    objAddress3.tffa__City__c = 'city';
    objAddress3.tffa__ZipCode__c = '1234';
    objAddress3.tffa__State__c = 'WI';
    objAddress3.tffa__Country__c = 'US';
    insert objAddress3;

    tffa__PartyAddressXref__c partAddXref3 = new tffa__PartyAddressXref__c();
    partAddXref3.tffa__Address__c = objAddress3.id;
    partAddXref3.tffa__Party__c = App3_lstobjParty2[0].id;
    insert partAddXref3;
    //
    IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id, FlowName__c = 'Deposit Originator FLOW');
    insert log;

    IntegrationLogItem__c logItems = new IntegrationLogItem__c(
      Name = 'Test',
      IntegrationLog__c = log.Id,
      status__c = 'Failure',
      ApiName__c = 'Test'
    );
    insert logItems;
    Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
    logItemsMap.put(logItems.Name, logItems);

    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig = FISCCTestRepositoryHelper.getAdapterConfigMetadata('AccessToken');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig1 = FISCCTestRepositoryHelper.getAdapterConfigMetadata('SearchCustomerTaxnbr');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer = FISCCTestRepositoryHelper.getAdapterConfigMetadata('CreateCustomer');
    List<FISCC_Charter_Config__mdt> lstCharterConfig1 = FISCCTestRepositoryHelper.getCharterConfigMetadata1('BA_889');
    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer_DO = FISCCTestRepositoryHelper.getAdapterConfigMetadata(
      'DepositOrigination'
    );

    tffa__AccountPreference__c odAccountPreference = new tffa__AccountPreference__c(
      tffa__Application__c = app.id,
      tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__AddOnServiceType__c = 'OD_PROTECTION_STANDARD',
      tffa__Enabled__c = true
    );

    insert odAccountPreference;

    //tffa__Party__c party = FISCCTestDataRepository.createIndividualPartyWithChildObjects();
    //insert party;
    /*
    
        tffa__Party__c jointParty = new tffa__Party__c();
        jointParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
        jointParty.tffa__PrimaryPhone__c = '5072630009';
        jointParty.tffa__FirstName__c = 'SSANDRAA';
        jointParty.tffa__NationalIdentifierValue__c = '666001753';
        jointParty.tffa__LastName__c = 'CCOBAA';
        jointParty.tffa__MiddleName__c = '';
        jointParty.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
        insert jointParty;
    
        tffa__SubmissionPartyXref__c partyXref = new tffa__SubmissionPartyXref__c(
          tffa__Party__c = jointParty.id,
          tffa__Submission__c = sub.id,
          tffa__Type__c = 'INDIVIDUAL'
        );
        insert partyXref;
    
        
    
        tffa__Beneficiary__c beneficiary = new tffa__Beneficiary__c(
          tffa__FirstName__c = 'Prashant',
          tffa__LastName__c = 'More',
          tffa__Ssn__c = '666001753',
          tffa__SharePercentage__c = 100,
          tffa__BirthDate__c = Date.newInstance(1988, 2, 12),
          tffa__Application__c = app.id
        );
    
        insert beneficiary;
    
        tffa__AccountPreference__c od_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'OVERDRAFT-PROTECTION',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__AccountNumber__c = '0009846662'
        );
    
        insert od_accountPreference;
    
        tffa__AccountPreference__c check_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'CHECK-ORDER',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert check_accountPreference;
    
        tffa__AccountPreference__c enotice_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'E_NOTICES',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert enotice_accountPreference;
    
        tffa__AccountPreference__c eStatement_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'E-STATEMENTS',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert eStatement_accountPreference;
    
        tffa__AccountPreference__c card_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'ORANGE-DEBIT-CARD',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__Description__c = 'Checking account debit card',
          tffa__AddOnServiceType__c = 'DEBIT_CARD'
          //IssuerCode__c   = '01'
        );
    
        insert card_accountPreference;
    
        tffa__AccountPreference__c bounceProtection_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'BOUNCE_PROTECTION',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__Description__c = 'Checking account BOUNCE PROTECTION',
          tffa__AddOnServiceType__c = 'BOUNCE_PROTECTION'
          //IssuerCode__c   = '01'
        );
    
        insert bounceProtection_accountPreference;
    
        tffa__Eligibility__c eligibility = new tffa__Eligibility__c(
          tffa__Value__c = '3352',
          tffa__Code__c = 'MeriwestUnionMember',
          tffa__LinkedApplication__c = app.id
        );
        insert eligibility;
    
        IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id);
        insert log;
    
        IntegrationLogItem__c logItems = new IntegrationLogItem__c(
          Name = 'Test',
          IntegrationLog__c = log.Id,
          status__c = 'Failure',
          ApiName__c = 'DEPOSIT'
        );
        insert logItems;
    
        Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
        logItemsMap.put(logItems.Name, logItems);
        Map<string, String> fundTransferParams = new Map<String, String>();*/
    // List<String> mockConditions = new List<String>{ 'failureEndPoint', 'emptyEndPoint', 'successEndPoint' };
    List<String> mockConditions = new List<String>{ 'successEndPoint' };

    Test.startTest();
    //set submission obj in factory
    for (String condition : mockConditions) {
      //try {
      Test.setMock(HttpCalloutMock.class, new FISCCMockResponseClass());
      FISCCSubmissionExecutor.processApplication(sub.id);
      CZWTFCIntegrationLogService.currentLogItem = logItems;
      // FISCCIntegrationLogService.isLogItemNewOrFailed('Test');

      // FISCCIntegrationLogService.setLogFailed('failed');
      //FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr(lstParty,lstAdaptrConfig1[0],lstCharterConfig1[0]);
      FISCCDepositOriginationResponseBuilder objFISCCDepositOriginationResponseBuilder = new FISCCDepositOriginationResponseBuilder();
      FISCCCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCCustomerIndividualRequest();
      objFISCCDepositOriginationResponseBuilder.build(null, null, null);
      FISCCDepositOriginationEntityResponse objFISCCDepositOriginationEntityResponse = new FISCCDepositOriginationEntityResponse();

      FISCCGenerateDepositAccNumberDTO objFISCCGenerateDepositAccNumberDTO = new FISCCGenerateDepositAccNumberDTO();
      FISCCCreateNewDepositAccDTO objFISCCCreateNewDepositAccDTO = new FISCCCreateNewDepositAccDTO();
      FISCCHostAdapter.processHostRequest(null, null, null);
      FISCCMsgListDTO objFISCCMsgListDTO = new FISCCMsgListDTO();
      // FISCCDepositOriginationProvider.createDepositOrigination(lstParty1,lstCharterConfig1[0]);

      //
    }
    //Test.stopTest();

    // Test.startTest();
    //set submission obj in factory

    Test.stopTest();
  }

  @isTest
  public static void testProcessApplication1() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '001'
    );
    insert sub;

    tffa__Submission__c sub1 = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      FISBranchCode__c = '888'
    );
    insert sub1;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
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

    party.IsAuthenticatedCustomer__c = true;
    party.tffa__IsExistingCustomer__c = true;
    party.IsDobMissing__c = true;

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
    List<tffa__Party__c> lstobjParty = new List<tffa__Party__c>();
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.Name = 'partyName1';
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
    lstobjParty.add(objParty);

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref1;

    //create party
    List<tffa__Party__c> lstobjParty1 = new List<tffa__Party__c>();
    tffa__Party__c objParty1 = new tffa__Party__c();
    objParty1.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty1.Name = 'partyName1';
    objParty1.tffa__PrimaryPhone__c = '5072630009';
    objParty1.tffa__FirstName__c = 'SSANDRAA';
    objParty1.tffa__NationalIdentifierValue__c = '666001753';
    objParty1.tffa__LastName__c = 'CCOBAA';
    objParty1.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty1.tffa__Citizenship__c = 'Citizen';
    objParty1.PreferredContactNumber__c = 'HOME';
    objParty1.tffa__SecondaryPhone__c = '987627897';
    objParty1.CellPhoneNumber__c = '97557854457';
    objParty1.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty1;
    lstobjParty1.add(objParty1);

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty1.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref2;

    List<tffa__Party__c> lstobjParty2 = new List<tffa__Party__c>();
    tffa__Party__c objParty2 = new tffa__Party__c();
    objParty2.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty2.Name = 'partyName1';
    objParty2.tffa__PrimaryPhone__c = '5072630009';
    objParty2.tffa__FirstName__c = 'SSANDRAA';
    objParty2.tffa__NationalIdentifierValue__c = '666001753';
    objParty2.tffa__LastName__c = 'CCOBAA';
    objParty2.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty2.tffa__Citizenship__c = 'Citizen';
    objParty2.PreferredContactNumber__c = 'HOME';
    objParty2.tffa__SecondaryPhone__c = '987627897';
    objParty2.CellPhoneNumber__c = '97557854457';
    objParty2.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty2;
    lstobjParty2.add(objParty2);

    tffa__SubmissionPartyXref__c subPartyXref3 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty2.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref3;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

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
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    //app1.tffa__LinkedFundingRequests__r = fundingReq;
    insert app1;
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
      tffa__Status__c = 'APPROVED'
    );
    // app.tffa__LinkedFundingRequests__r = fundingReq;
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app1.Id;
    insert fundingReq1;

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c();
    fundingReq.Name = '';
    fundingReq.tffa__Status__c = 'IN_PROGRESS';
    fundingReq.tffa__Type__c = 'ACH';
    fundingReq.tffa__Amount__c = 122;
    fundingReq.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq.tffa__LinkedApplication__c = app.Id;
    insert fundingReq;

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
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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

    tffa__Identification__c identity1 = new tffa__Identification__c();
    identity1.tffa__Party__c = lstobjParty[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity1.tffa__Party__c);
    identity1.tffa__IdentificationNumber__c = 'K987667';
    identity1.tffa__Type__c = 'DL';
    identity1.tffa__IssuingState__c = 'California';
    identity1.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity1.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity1;
    //create Employment Data
    tffa__Employment__c objEmployment1 = new tffa__Employment__c();
    objEmployment1.tffa__Party__c = lstobjParty[0].id;
    objEmployment1.tffa__EmployerName__c = 'Emp Name';
    objEmployment1.tffa__Type__c = 'STUDENT';
    objEmployment1.OccupationType__c = '003';
    insert objEmployment1;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref1 = new tffa__ApplicationPartyXref__c();
    appPartyxref1.tffa__Party__c = lstobjParty[0].Id;
    appPartyxref1.tffa__Application__c = app.id;
    appPartyxref1.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref1.Name = 'Test';
    insert appPartyxref1;

    tffa.logger.debug('appPartyxref1 ==>' + appPartyxref);
    List<tffa__party__c> lstobjParty_App1 = new List<tffa__party__c>();
    lstobjParty_App1 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + lstobjParty_App1[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__Line2__c = 'Line 2';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;

    tffa__Address__c objAddress1 = new tffa__Address__c();
    objAddress1.Name = 'Address Name';
    objAddress1.tffa__Line1__c = 'Line 1';
    objAddress1.tffa__Line2__c = 'Line 2';
    objAddress1.tffa__City__c = 'city';
    objAddress1.tffa__ZipCode__c = '1234';
    objAddress1.tffa__State__c = 'WI';
    objAddress1.tffa__Country__c = 'US';
    insert objAddress1;
    //
    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = lstobjParty1[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = lstobjParty1[0].id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref2 = new tffa__ApplicationPartyXref__c();
    appPartyxref2.tffa__Party__c = lstobjParty1[0].Id;
    appPartyxref2.tffa__Application__c = app.id;
    appPartyxref2.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref2.Name = 'Test';
    insert appPartyxref2;

    tffa.logger.debug('appPartyxref2 ==>' + appPartyxref);
    List<tffa__party__c> App2_lstobjParty2 = new List<tffa__party__c>();
    App2_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty1[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App2_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress2 = new tffa__Address__c();
    objAddress2.Name = 'Address Name';
    objAddress2.tffa__Line1__c = 'Line 1';
    objAddress2.tffa__Line2__c = 'Line 2';
    objAddress2.tffa__City__c = 'city';
    objAddress2.tffa__ZipCode__c = '1234';
    objAddress2.tffa__State__c = 'WI';
    objAddress2.tffa__Country__c = 'US';
    insert objAddress2;
    //
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
    partAddXref.tffa__Party__c = lstParty1[0].id;
    insert partAddXref;

    tffa__PartyAddressXref__c partAddXref1 = new tffa__PartyAddressXref__c();
    partAddXref1.tffa__Address__c = objAddress1.id;
    partAddXref1.tffa__Party__c = lstobjParty_App1[0].id;
    insert partAddXref1;

    tffa__PartyAddressXref__c partAddXref2 = new tffa__PartyAddressXref__c();
    partAddXref2.tffa__Address__c = objAddress2.id;
    partAddXref2.tffa__Party__c = App2_lstobjParty2[0].id;
    insert partAddXref2;
    //
    tffa__Identification__c identity3 = new tffa__Identification__c();
    identity3.tffa__Party__c = lstobjParty2[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity3.tffa__Party__c);
    identity3.tffa__IdentificationNumber__c = 'K987667';
    identity3.tffa__Type__c = 'DL';
    identity3.tffa__IssuingState__c = 'California';
    identity3.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity3.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity3;
    //create Employment Data
    tffa__Employment__c objEmployment3 = new tffa__Employment__c();
    objEmployment3.tffa__Party__c = lstobjParty1[0].id;
    objEmployment3.tffa__EmployerName__c = 'Emp Name';
    objEmployment3.tffa__Type__c = 'STUDENT';
    objEmployment3.OccupationType__c = '003';
    insert objEmployment3;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref3 = new tffa__ApplicationPartyXref__c();
    appPartyxref3.tffa__Party__c = lstobjParty2[0].Id;
    appPartyxref3.tffa__Application__c = app.id;
    appPartyxref3.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref3.Name = 'Test';
    insert appPartyxref3;

    tffa.logger.debug('appPartyxref3 ==>' + appPartyxref);
    List<tffa__party__c> App3_lstobjParty2 = new List<tffa__party__c>();
    App3_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty2[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App3_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress3 = new tffa__Address__c();
    objAddress3.Name = 'Address Name';
    objAddress3.tffa__Line1__c = 'Line 1';
    objAddress3.tffa__Line2__c = 'Line 2';
    objAddress3.tffa__City__c = 'city';
    objAddress3.tffa__ZipCode__c = '1234';
    objAddress3.tffa__State__c = 'WI';
    objAddress3.tffa__Country__c = 'US';
    insert objAddress3;

    tffa__PartyAddressXref__c partAddXref3 = new tffa__PartyAddressXref__c();
    partAddXref3.tffa__Address__c = objAddress3.id;
    partAddXref3.tffa__Party__c = App3_lstobjParty2[0].id;
    insert partAddXref3;
    //
    IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id, FlowName__c = 'Deposit Originator FLOW');
    insert log;

    IntegrationLogItem__c logItems = new IntegrationLogItem__c(
      Name = 'Test',
      IntegrationLog__c = log.Id,
      status__c = 'Failure',
      ApiName__c = 'Test'
    );
    insert logItems;
    Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
    logItemsMap.put(logItems.Name, logItems);

    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig = FISCCTestRepositoryHelper.getAdapterConfigMetadata('AccessToken');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig1 = FISCCTestRepositoryHelper.getAdapterConfigMetadata('SearchCustomerTaxnbr');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer = FISCCTestRepositoryHelper.getAdapterConfigMetadata('CreateCustomer');
    List<FISCC_Charter_Config__mdt> lstCharterConfig1 = FISCCTestRepositoryHelper.getCharterConfigMetadata1('BA_889');
    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer_DO = FISCCTestRepositoryHelper.getAdapterConfigMetadata(
      'DepositOrigination'
    );

    tffa__AccountPreference__c odAccountPreference = new tffa__AccountPreference__c(
      tffa__Application__c = app.id,
      tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__AddOnServiceType__c = 'OD_PROTECTION_STANDARD',
      tffa__Enabled__c = true
    );

    insert odAccountPreference;

    //tffa__Party__c party = FISCCTestDataRepository.createIndividualPartyWithChildObjects();
    //insert party;
    /*
    
        tffa__Party__c jointParty = new tffa__Party__c();
        jointParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
        jointParty.tffa__PrimaryPhone__c = '5072630009';
        jointParty.tffa__FirstName__c = 'SSANDRAA';
        jointParty.tffa__NationalIdentifierValue__c = '666001753';
        jointParty.tffa__LastName__c = 'CCOBAA';
        jointParty.tffa__MiddleName__c = '';
        jointParty.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
        insert jointParty;
    
        tffa__SubmissionPartyXref__c partyXref = new tffa__SubmissionPartyXref__c(
          tffa__Party__c = jointParty.id,
          tffa__Submission__c = sub.id,
          tffa__Type__c = 'INDIVIDUAL'
        );
        insert partyXref;
    
        
    
        tffa__Beneficiary__c beneficiary = new tffa__Beneficiary__c(
          tffa__FirstName__c = 'Prashant',
          tffa__LastName__c = 'More',
          tffa__Ssn__c = '666001753',
          tffa__SharePercentage__c = 100,
          tffa__BirthDate__c = Date.newInstance(1988, 2, 12),
          tffa__Application__c = app.id
        );
    
        insert beneficiary;
    
        tffa__AccountPreference__c od_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'OVERDRAFT-PROTECTION',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__AccountNumber__c = '0009846662'
        );
    
        insert od_accountPreference;
    
        tffa__AccountPreference__c check_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'CHECK-ORDER',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert check_accountPreference;
    
        tffa__AccountPreference__c enotice_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'E_NOTICES',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert enotice_accountPreference;
    
        tffa__AccountPreference__c eStatement_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'E-STATEMENTS',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true
        );
    
        insert eStatement_accountPreference;
    
        tffa__AccountPreference__c card_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'ORANGE-DEBIT-CARD',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__Description__c = 'Checking account debit card',
          tffa__AddOnServiceType__c = 'DEBIT_CARD'
          //IssuerCode__c   = '01'
        );
    
        insert card_accountPreference;
    
        tffa__AccountPreference__c bounceProtection_accountPreference = new tffa__AccountPreference__c(
          tffa__Application__c = app.id,
          tffa__Code__c = 'BOUNCE_PROTECTION',
          tffa__Type__c = 'ADD_ON_SERVICE',
          tffa__Enabled__c = true,
          tffa__Description__c = 'Checking account BOUNCE PROTECTION',
          tffa__AddOnServiceType__c = 'BOUNCE_PROTECTION'
          //IssuerCode__c   = '01'
        );
    
        insert bounceProtection_accountPreference;
    
        tffa__Eligibility__c eligibility = new tffa__Eligibility__c(
          tffa__Value__c = '3352',
          tffa__Code__c = 'MeriwestUnionMember',
          tffa__LinkedApplication__c = app.id
        );
        insert eligibility;
    
        IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id);
        insert log;
    
        IntegrationLogItem__c logItems = new IntegrationLogItem__c(
          Name = 'Test',
          IntegrationLog__c = log.Id,
          status__c = 'Failure',
          ApiName__c = 'DEPOSIT'
        );
        insert logItems;
    
        Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
        logItemsMap.put(logItems.Name, logItems);
        Map<string, String> fundTransferParams = new Map<String, String>();*/
    // List<String> mockConditions = new List<String>{ 'failureEndPoint', 'emptyEndPoint', 'successEndPoint' };
    List<String> mockConditions = new List<String>{ 'successEndPoint' };

    Test.startTest();
    //set submission obj in factory
    for (String condition : mockConditions) {
      //try {
      Test.setMock(HttpCalloutMock.class, new FISCCMockResponseClass());
      FISCCSubmissionExecutor.processApplication(sub.id);
      CZWTFCIntegrationLogService.currentLogItem = logItems;
      // FISCCIntegrationLogService.isLogItemNewOrFailed('Test');

      // FISCCIntegrationLogService.setLogFailed('failed');
      //FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr(lstParty,lstAdaptrConfig1[0],lstCharterConfig1[0]);
      FISCCDepositOriginationResponseBuilder objFISCCDepositOriginationResponseBuilder = new FISCCDepositOriginationResponseBuilder();
      FISCCCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCCustomerIndividualRequest();
      objFISCCDepositOriginationResponseBuilder.build(null, null, null);
      FISCCDepositOriginationEntityResponse objFISCCDepositOriginationEntityResponse = new FISCCDepositOriginationEntityResponse();

      FISCCGenerateDepositAccNumberDTO objFISCCGenerateDepositAccNumberDTO = new FISCCGenerateDepositAccNumberDTO();
      FISCCCreateNewDepositAccDTO objFISCCCreateNewDepositAccDTO = new FISCCCreateNewDepositAccDTO();
      FISCCHostAdapter.processHostRequest(null, null, null);
      FISCCMsgListDTO objFISCCMsgListDTO = new FISCCMsgListDTO();
      // FISCCDepositOriginationProvider.createDepositOrigination(lstParty1,lstCharterConfig1[0]);

      //
    }
    //Test.stopTest();

    // Test.startTest();
    //set submission obj in factory

    Test.stopTest();
  }

  @isTest
  public static void testProcessApplicationError() {
    tffa__Submission__c sub = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '001'
    );
    insert sub;
    tffa__Submission__c sub1 = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      FISBranchCode__c = '888'
    );
    insert sub1;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
    tffa__Party__c party = new tffa__Party__c();
    party.Name = 'partyName';
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAA';
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
    List<tffa__Party__c> lstobjParty = new List<tffa__Party__c>();
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.Name = 'partyName1';
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
    lstobjParty.add(objParty);

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref1;

    //create party
    List<tffa__Party__c> lstobjParty1 = new List<tffa__Party__c>();
    tffa__Party__c objParty1 = new tffa__Party__c();
    objParty1.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty1.Name = 'partyName1';
    objParty1.tffa__PrimaryPhone__c = '5072630009';
    objParty1.tffa__FirstName__c = 'SSANDRAA';
    objParty1.tffa__NationalIdentifierValue__c = '666001753';
    objParty1.tffa__LastName__c = 'CCOBAA';
    objParty1.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty1.tffa__Citizenship__c = 'Citizen';
    objParty1.PreferredContactNumber__c = 'HOME';
    objParty1.tffa__SecondaryPhone__c = '987627897';
    objParty1.CellPhoneNumber__c = '97557854457';
    objParty1.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty1;
    lstobjParty1.add(objParty1);

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty1.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref2;

    List<tffa__Party__c> lstobjParty2 = new List<tffa__Party__c>();
    tffa__Party__c objParty2 = new tffa__Party__c();
    objParty2.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty2.Name = 'partyName1';
    objParty2.tffa__PrimaryPhone__c = '5072630009';
    objParty2.tffa__FirstName__c = 'SSANDRAA';
    objParty2.tffa__NationalIdentifierValue__c = '666001753';
    objParty2.tffa__LastName__c = 'CCOBAA';
    objParty2.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty2.tffa__Citizenship__c = 'Citizen';
    objParty2.PreferredContactNumber__c = 'HOME';
    objParty2.tffa__SecondaryPhone__c = '987627897';
    objParty2.CellPhoneNumber__c = '97557854457';
    objParty2.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty2;
    lstobjParty2.add(objParty2);

    tffa__SubmissionPartyXref__c subPartyXref3 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty2.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref3;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

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
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app1;
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
      tffa__Status__c = 'APPROVED'
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;
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
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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

    tffa__Identification__c identity1 = new tffa__Identification__c();
    identity1.tffa__Party__c = lstobjParty[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity1.tffa__Party__c);
    identity1.tffa__IdentificationNumber__c = 'K987667';
    identity1.tffa__Type__c = 'DL';
    identity1.tffa__IssuingState__c = 'California';
    identity1.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity1.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity1;
    //create Employment Data
    tffa__Employment__c objEmployment1 = new tffa__Employment__c();
    objEmployment1.tffa__Party__c = lstobjParty[0].id;
    objEmployment1.tffa__EmployerName__c = 'Emp Name';
    objEmployment1.tffa__Type__c = 'STUDENT';
    objEmployment1.OccupationType__c = '003';
    insert objEmployment1;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref1 = new tffa__ApplicationPartyXref__c();
    appPartyxref1.tffa__Party__c = lstobjParty[0].Id;
    appPartyxref1.tffa__Application__c = app.id;
    appPartyxref1.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref1.Name = 'Test';
    insert appPartyxref1;

    tffa.logger.debug('appPartyxref1 ==>' + appPartyxref);
    List<tffa__party__c> lstobjParty_App1 = new List<tffa__party__c>();
    lstobjParty_App1 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + lstobjParty_App1[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__Line2__c = 'Line 2';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;

    tffa__Address__c objAddress1 = new tffa__Address__c();
    objAddress1.Name = 'Address Name';
    objAddress1.tffa__Line1__c = 'Line 1';
    objAddress1.tffa__Line2__c = 'Line 2';
    objAddress1.tffa__City__c = 'city';
    objAddress1.tffa__ZipCode__c = '1234';
    objAddress1.tffa__State__c = 'WI';
    objAddress1.tffa__Country__c = 'US';
    insert objAddress1;
    //
    tffa__Identification__c identity2 = new tffa__Identification__c();
    identity2.tffa__Party__c = lstobjParty1[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity2.tffa__Party__c);
    identity2.tffa__IdentificationNumber__c = 'K987667';
    identity2.tffa__Type__c = 'DL';
    identity2.tffa__IssuingState__c = 'California';
    identity2.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity2.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity2;
    //create Employment Data
    tffa__Employment__c objEmployment2 = new tffa__Employment__c();
    objEmployment2.tffa__Party__c = lstobjParty1[0].id;
    objEmployment2.tffa__EmployerName__c = 'Emp Name';
    objEmployment2.tffa__Type__c = 'STUDENT';
    objEmployment2.OccupationType__c = '003';
    insert objEmployment2;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref2 = new tffa__ApplicationPartyXref__c();
    appPartyxref2.tffa__Party__c = lstobjParty1[0].Id;
    appPartyxref2.tffa__Application__c = app.id;
    appPartyxref2.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref2.Name = 'Test';
    insert appPartyxref2;

    tffa.logger.debug('appPartyxref2 ==>' + appPartyxref);
    List<tffa__party__c> App2_lstobjParty2 = new List<tffa__party__c>();
    App2_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty1[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App2_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress2 = new tffa__Address__c();
    objAddress2.Name = 'Address Name';
    objAddress2.tffa__Line1__c = 'Line 1';
    objAddress2.tffa__Line2__c = 'Line 2';
    objAddress2.tffa__City__c = 'city';
    objAddress2.tffa__ZipCode__c = '1234';
    objAddress2.tffa__State__c = 'WI';
    objAddress2.tffa__Country__c = 'US';
    insert objAddress2;
    //
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
    partAddXref.tffa__Party__c = lstParty1[0].id;
    insert partAddXref;

    tffa__PartyAddressXref__c partAddXref1 = new tffa__PartyAddressXref__c();
    partAddXref1.tffa__Address__c = objAddress1.id;
    partAddXref1.tffa__Party__c = lstobjParty_App1[0].id;
    insert partAddXref1;

    tffa__PartyAddressXref__c partAddXref2 = new tffa__PartyAddressXref__c();
    partAddXref2.tffa__Address__c = objAddress2.id;
    partAddXref2.tffa__Party__c = App2_lstobjParty2[0].id;
    insert partAddXref2;
    //
    tffa__Identification__c identity3 = new tffa__Identification__c();
    identity3.tffa__Party__c = lstobjParty2[0].id;
    tffa.logger.debug('identity.tffa__Party__c ==>' + identity3.tffa__Party__c);
    identity3.tffa__IdentificationNumber__c = 'K987667';
    identity3.tffa__Type__c = 'DL';
    identity3.tffa__IssuingState__c = 'California';
    identity3.tffa__IssueDate__c = Date.newInstance(2020, 2, 12);
    identity3.tffa__ExpirationDate__c = Date.newInstance(2023, 2, 12);
    insert identity3;
    //create Employment Data
    tffa__Employment__c objEmployment3 = new tffa__Employment__c();
    objEmployment3.tffa__Party__c = lstobjParty1[0].id;
    objEmployment3.tffa__EmployerName__c = 'Emp Name';
    objEmployment3.tffa__Type__c = 'STUDENT';
    objEmployment3.OccupationType__c = '003';
    insert objEmployment3;
    //cretae AppPartyXref data
    tffa__ApplicationPartyXref__c appPartyxref3 = new tffa__ApplicationPartyXref__c();
    appPartyxref3.tffa__Party__c = lstobjParty2[0].Id;
    appPartyxref3.tffa__Application__c = app.id;
    appPartyxref3.tffa__Type__c = 'INDIVIDUAL';
    appPartyxref3.Name = 'Test';
    insert appPartyxref3;

    tffa.logger.debug('appPartyxref3 ==>' + appPartyxref);
    List<tffa__party__c> App3_lstobjParty2 = new List<tffa__party__c>();
    App3_lstobjParty2 = [
      SELECT
        id,
        Name,
        tffa__PrimaryEmail__c,
        SecretWord__c,
        SecretWordHint__c,
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
      WHERE id = :lstobjParty2[0].id
    ];
    tffa.logger.debug('party.tffa__Applications__r ==> ' + App3_lstobjParty2[0].tffa__Applications__r);

    //create Address
    tffa__Address__c objAddress3 = new tffa__Address__c();
    objAddress3.Name = 'Address Name';
    objAddress3.tffa__Line1__c = 'Line 1';
    objAddress3.tffa__Line2__c = 'Line 2';
    objAddress3.tffa__City__c = 'city';
    objAddress3.tffa__ZipCode__c = '1234';
    objAddress3.tffa__State__c = 'WI';
    objAddress3.tffa__Country__c = 'US';
    insert objAddress3;

    tffa__PartyAddressXref__c partAddXref3 = new tffa__PartyAddressXref__c();
    partAddXref3.tffa__Address__c = objAddress3.id;
    partAddXref3.tffa__Party__c = App3_lstobjParty2[0].id;
    insert partAddXref3;
    //
    IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id, FlowName__c = 'Deposit Originator FLOW');
    insert log;

    IntegrationLogItem__c logItems = new IntegrationLogItem__c(
      Name = 'Test',
      IntegrationLog__c = log.Id,
      status__c = 'Failure',
      ApiName__c = 'Test'
    );
    insert logItems;
    Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
    logItemsMap.put(logItems.Name, logItems);

    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig = FISCCTestRepositoryHelper.getAdapterConfigMetadata('AccessToken');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig1 = FISCCTestRepositoryHelper.getAdapterConfigMetadata('SearchCustomerTaxnbr');
    // List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer = FISCCTestRepositoryHelper.getAdapterConfigMetadata('CreateCustomer');
    List<FISCC_Charter_Config__mdt> lstCharterConfig1 = FISCCTestRepositoryHelper.getCharterConfigMetadata1('BA_889');
    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer_DO = FISCCTestRepositoryHelper.getAdapterConfigMetadata(
      'DepositOrigination'
    );

    tffa__AccountPreference__c odAccountPreference = new tffa__AccountPreference__c(
      tffa__Application__c = app.id,
      tffa__Code__c = 'OD_FOR_STANDARD_TRANSACTIONS',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__AddOnServiceType__c = 'OD_PROTECTION_STANDARD',
      tffa__Enabled__c = false
    );

    insert odAccountPreference;

    //tffa__Party__c party = FISCCTestDataRepository.createIndividualPartyWithChildObjects();
    //insert party;
    /*
  
      tffa__Party__c jointParty = new tffa__Party__c();
      jointParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
      jointParty.tffa__PrimaryPhone__c = '5072630009';
      jointParty.tffa__FirstName__c = 'SSANDRAA';
      jointParty.tffa__NationalIdentifierValue__c = '666001753';
      jointParty.tffa__LastName__c = 'CCOBAA';
      jointParty.tffa__MiddleName__c = '';
      jointParty.RecordTypeId = TestRepositoryHelper.getPartyRecordType();
      insert jointParty;
  
      tffa__SubmissionPartyXref__c partyXref = new tffa__SubmissionPartyXref__c(
        tffa__Party__c = jointParty.id,
        tffa__Submission__c = sub.id,
        tffa__Type__c = 'INDIVIDUAL'
      );
      insert partyXref;
  
      
  
      tffa__Beneficiary__c beneficiary = new tffa__Beneficiary__c(
        tffa__FirstName__c = 'Prashant',
        tffa__LastName__c = 'More',
        tffa__Ssn__c = '666001753',
        tffa__SharePercentage__c = 100,
        tffa__BirthDate__c = Date.newInstance(1988, 2, 12),
        tffa__Application__c = app.id
      );
  
      insert beneficiary;
  
      tffa__AccountPreference__c od_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'OVERDRAFT-PROTECTION',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true,
        tffa__AccountNumber__c = '0009846662'
      );
  
      insert od_accountPreference;
  
      tffa__AccountPreference__c check_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'CHECK-ORDER',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true
      );
  
      insert check_accountPreference;
  
      tffa__AccountPreference__c enotice_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'E_NOTICES',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true
      );
  
      insert enotice_accountPreference;
  
      tffa__AccountPreference__c eStatement_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'E-STATEMENTS',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true
      );
  
      insert eStatement_accountPreference;
  
      tffa__AccountPreference__c card_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'ORANGE-DEBIT-CARD',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true,
        tffa__Description__c = 'Checking account debit card',
        tffa__AddOnServiceType__c = 'DEBIT_CARD'
        //IssuerCode__c   = '01'
      );
  
      insert card_accountPreference;
  
      tffa__AccountPreference__c bounceProtection_accountPreference = new tffa__AccountPreference__c(
        tffa__Application__c = app.id,
        tffa__Code__c = 'BOUNCE_PROTECTION',
        tffa__Type__c = 'ADD_ON_SERVICE',
        tffa__Enabled__c = true,
        tffa__Description__c = 'Checking account BOUNCE PROTECTION',
        tffa__AddOnServiceType__c = 'BOUNCE_PROTECTION'
        //IssuerCode__c   = '01'
      );
  
      insert bounceProtection_accountPreference;
  
      tffa__Eligibility__c eligibility = new tffa__Eligibility__c(
        tffa__Value__c = '3352',
        tffa__Code__c = 'MeriwestUnionMember',
        tffa__LinkedApplication__c = app.id
      );
      insert eligibility;
  
      IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id);
      insert log;
  
      IntegrationLogItem__c logItems = new IntegrationLogItem__c(
        Name = 'Test',
        IntegrationLog__c = log.Id,
        status__c = 'Failure',
        ApiName__c = 'DEPOSIT'
      );
      insert logItems;
  
      Map<String, IntegrationLogItem__c> logItemsMap = new Map<String, IntegrationLogItem__c>();
      logItemsMap.put(logItems.Name, logItems);
      Map<string, String> fundTransferParams = new Map<String, String>();*/
    // List<String> mockConditions = new List<String>{ 'failureEndPoint', 'emptyEndPoint', 'successEndPoint' };
    List<String> mockConditions = new List<String>{ 'failureEndPoint' };

    tffa__Application__c app5 = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      //ShareId__c = '0032',
      tffa__Amount__c = 100.0,
      tffa__Term__c = 12,
      //ShareStatus__c = 'SUCCESS',
      tffa__PromotionCode__c = 'SUMMERJOY',
      //SourceOfReference__c  =  'FLYER_OR_POSTER',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app5;

    Test.startTest();

    //set submission obj in factory
    for (String condition : mockConditions) {
      //try {
      Test.setMock(HttpCalloutMock.class, new FISCCMockResponseClass('failureEndPoint'));
      FISCCSubmissionExecutor.processApplication(sub.id);
      CZWTFCIntegrationLogService.currentLogItem = logItems;
      //FISCCIntegrationLogService.isLogItemNewOrFailed('Test');

      // FISCCIntegrationLogService.setLogFailed('failed');
      //FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr(lstParty,lstAdaptrConfig1[0],lstCharterConfig1[0]);
      FISCCDepositOriginationResponseBuilder objFISCCDepositOriginationResponseBuilder = new FISCCDepositOriginationResponseBuilder();
      FISCCCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCCustomerIndividualRequest();
      objFISCCDepositOriginationResponseBuilder.build(null, null, null);
      FISCCDepositOriginationEntityResponse objFISCCDepositOriginationEntityResponse = new FISCCDepositOriginationEntityResponse();

      FISCCGenerateDepositAccNumberDTO objFISCCGenerateDepositAccNumberDTO = new FISCCGenerateDepositAccNumberDTO();
      FISCCCreateNewDepositAccDTO objFISCCCreateNewDepositAccDTO = new FISCCCreateNewDepositAccDTO();
      FISCCHostAdapter.processHostRequest(null, null, null);
    }
  }

  @isTest
  public static void fundHoldTest() {
    tffa__Submission__c sub = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '118'
    );
    insert sub;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

    tffa__Application__c app5 = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      //ShareId__c = '0032',
      tffa__Amount__c = 100.0,
      tffa__Term__c = 12,
      //ShareStatus__c = 'SUCCESS',
      tffa__PromotionCode__c = 'SUMMERJOY',
      //SourceOfReference__c  =  'FLYER_OR_POSTER',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app5;

    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new FISCCFundHoldMockClass());
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FundingHold');
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(app5.tffa__Brand__c);
    FISCCFundingHoldExtension.invokeApiCall(app5, adapterConfig, charterConfig);
    FISCCFundingHoldProvider.holdFunds(app5);
    new FISCCFundHoldResponseDTO();
    Test.stopTest();
  }

  @isTest
  public static void onlineDLRTest() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '001');
    insert sub;

    tffa__Submission__c sub1 = new tffa__Submission__c(FISBranchCode__c = '888');
    insert sub1;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
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
    List<tffa__Party__c> lstobjParty = new List<tffa__Party__c>();
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.Name = 'partyName1';
    objParty.tffa__PrimaryPhone__c = '5072630009';
    objParty.tffa__FirstName__c = 'SSANDRAA';
    objParty.tffa__NationalIdentifierValue__c = '666001753';
    objParty.tffa__LastName__c = 'CCOBAA';
    objParty.tffa__MiddleName__c = '';
    objParty.tffa__Citizenship__c = 'Citizen';
    objParty.PreferredContactNumber__c = 'HOME';
    objParty.tffa__SecondaryPhone__c = '987627897';
    objParty.CellPhoneNumber__c = '97557854457';
    objParty.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty;
    lstobjParty.add(objParty);

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref1;

    //create party
    List<tffa__Party__c> lstobjParty1 = new List<tffa__Party__c>();
    tffa__Party__c objParty1 = new tffa__Party__c();
    objParty1.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty1.Name = 'partyName1';
    objParty1.tffa__PrimaryPhone__c = '5072630009';
    objParty1.tffa__FirstName__c = 'SSANDRAA';
    objParty1.tffa__NationalIdentifierValue__c = '666001753';
    objParty1.tffa__LastName__c = 'CCOBAA';
    objParty1.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty1.tffa__Citizenship__c = 'Citizen';
    objParty1.PreferredContactNumber__c = 'HOME';
    objParty1.tffa__SecondaryPhone__c = '987627897';
    objParty1.CellPhoneNumber__c = '97557854457';
    objParty1.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty1;
    lstobjParty1.add(objParty1);

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty1.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref2;

    List<tffa__Party__c> lstobjParty2 = new List<tffa__Party__c>();
    tffa__Party__c objParty2 = new tffa__Party__c();
    objParty2.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty2.Name = 'partyName1';
    objParty2.tffa__PrimaryPhone__c = '5072630009';
    objParty2.tffa__FirstName__c = 'SSANDRAA';
    objParty2.tffa__NationalIdentifierValue__c = '666001753';
    objParty2.tffa__LastName__c = 'CCOBAA';
    objParty2.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty2.tffa__Citizenship__c = 'Citizen';
    objParty2.PreferredContactNumber__c = 'HOME';
    objParty2.tffa__SecondaryPhone__c = '987627897';
    objParty2.CellPhoneNumber__c = '97557854457';
    objParty2.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty2;
    lstobjParty2.add(objParty2);

    tffa__SubmissionPartyXref__c subPartyXref3 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty2.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref3;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

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
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );

    insert app1;
    //insert app data
    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app1.Id;
    insert fundingReq1;

    tffa.SObjectAssembler appasm1 = new tffa.SObjectAssembler(app);
    appasm1.addChildObject('LinkedFundingRequests__r', fundingReq1);

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c();
    fundingReq.Name = '';
    fundingReq.tffa__Status__c = 'IN_PROGRESS';
    fundingReq.tffa__Type__c = 'ACH';
    fundingReq.tffa__Amount__c = 122;
    fundingReq.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq.tffa__LinkedApplication__c = app.Id;
    insert fundingReq;

    tffa__Application__c apptwo = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert apptwo;

    tffa__FundingRequest__c fundingReqthree = new tffa__FundingRequest__c();
    fundingReqthree.Name = '';
    fundingReqthree.tffa__Status__c = 'IN_PROGRESS';
    fundingReqthree.tffa__Type__c = 'DEBIT_CARD';
    fundingReqthree.tffa__Amount__c = 122;
    fundingReqthree.tffa__TransactionReferenceId__c = '1234556';
    fundingReqthree.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReqthree.tffa__LinkedApplication__c = apptwo.Id;
    insert fundingReqthree;

    tffa.SObjectAssembler asmapp2 = new tffa.SObjectAssembler(apptwo);
    asmapp2.addChildObject('LinkedFundingRequests__r', fundingReqthree);

    Test.startTest();
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING);
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.APPROVAL_CCCOMPLETE, app.Id, false);
    Test.setMock(HttpCalloutMock.class, new FISCCDlrTransMockClass());
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('DollarTransaction');
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(app1.tffa__Brand__c);
    FISCCDollarTransactionExtension.testConfigFlow = true;
    FISCCDollarTransactionExtension.invokeApiCall(app1, adapterConfig, charterConfig, 'ACH');
    FISCCApplicationFundingProvider.processFunding((tffa__Application__c) appasm1.assemble());
    FISCCApplicationFundingProvider.processFunding((tffa__Application__c) asmapp2.assemble());
    FISCCDollarTransactionExtension.invokeApiCall(apptwo, adapterConfig, charterConfig, 'DEBIT_CARD');
    Test.stopTest();
  }

  @isTest
  public static void cdDepositTest() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Submission__c sub1 = new tffa__Submission__c(FISBranchCode__c = '888');
    insert sub1;
    List<tffa__Party__c> lstParty = new List<tffa__Party__c>();
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
    List<tffa__Party__c> lstobjParty = new List<tffa__Party__c>();
    tffa__Party__c objParty = new tffa__Party__c();
    objParty.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty.Name = 'partyName1';
    objParty.tffa__PrimaryPhone__c = '5072630009';
    objParty.tffa__FirstName__c = 'SSANDRAA';
    objParty.tffa__NationalIdentifierValue__c = '666001753';
    objParty.tffa__LastName__c = 'CCOBAA';
    objParty.tffa__MiddleName__c = '';
    objParty.tffa__Citizenship__c = 'Citizen';
    objParty.PreferredContactNumber__c = 'HOME';
    objParty.tffa__SecondaryPhone__c = '987627897';
    objParty.CellPhoneNumber__c = '97557854457';
    objParty.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty;
    lstobjParty.add(objParty);

    tffa__SubmissionPartyXref__c subPartyXref1 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref1;

    //create party
    List<tffa__Party__c> lstobjParty1 = new List<tffa__Party__c>();
    tffa__Party__c objParty1 = new tffa__Party__c();
    objParty1.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty1.Name = 'partyName1';
    objParty1.tffa__PrimaryPhone__c = '5072630009';
    objParty1.tffa__FirstName__c = 'SSANDRAA';
    objParty1.tffa__NationalIdentifierValue__c = '666001753';
    objParty1.tffa__LastName__c = 'CCOBAA';
    objParty1.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty1.tffa__Citizenship__c = 'Citizen';
    objParty1.PreferredContactNumber__c = 'HOME';
    objParty1.tffa__SecondaryPhone__c = '987627897';
    objParty1.CellPhoneNumber__c = '97557854457';
    objParty1.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty1;
    lstobjParty1.add(objParty1);

    tffa__SubmissionPartyXref__c subPartyXref2 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty1.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref2;

    List<tffa__Party__c> lstobjParty2 = new List<tffa__Party__c>();
    tffa__Party__c objParty2 = new tffa__Party__c();
    objParty2.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    objParty2.Name = 'partyName1';
    objParty2.tffa__PrimaryPhone__c = '5072630009';
    objParty2.tffa__FirstName__c = 'SSANDRAA';
    objParty2.tffa__NationalIdentifierValue__c = '666001753';
    objParty2.tffa__LastName__c = 'CCOBAA';
    objParty2.tffa__MiddleName__c = '';
    // objParty.MembershipNumber__c = '0000017365';
    objParty2.tffa__Citizenship__c = 'Citizen';
    objParty2.PreferredContactNumber__c = 'HOME';
    objParty2.tffa__SecondaryPhone__c = '987627897';
    objParty2.CellPhoneNumber__c = '97557854457';
    objParty2.tffa__MothersMaidenName__c = 'Mother Name';
    insert objParty2;
    lstobjParty2.add(objParty2);

    tffa__SubmissionPartyXref__c subPartyXref3 = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = objParty2.id,
      tffa__Submission__c = sub.id,
      tffa__Primary__c = false,
      tffa__Type__c = 'INDIVIDUAL'
    );
    insert subPartyXref3;

    //create product data
    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

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
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );

    insert app1;
    //insert app data
    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert app;

    tffa__FundingRequest__c fundingReq1 = new tffa__FundingRequest__c();
    fundingReq1.Name = '';
    fundingReq1.tffa__Status__c = 'IN_PROGRESS';
    fundingReq1.tffa__Type__c = 'ACH';
    fundingReq1.tffa__Amount__c = 122;
    fundingReq1.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq1.tffa__LinkedApplication__c = app1.Id;
    insert fundingReq1;

    tffa.SObjectAssembler appasm1 = new tffa.SObjectAssembler(app1);
    appasm1.addChildObject('LinkedFundingRequests__r', fundingReq1);

    tffa__Application__c apptwo = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert apptwo;

    tffa__FundingRequest__c fundingReqthree = new tffa__FundingRequest__c();
    fundingReqthree.Name = '';
    fundingReqthree.tffa__Status__c = 'IN_PROGRESS';
    fundingReqthree.tffa__Type__c = 'DEBIT_CARD';
    fundingReqthree.tffa__Amount__c = 122;
    fundingReqthree.tffa__TransactionReferenceId__c = '1234556';
    fundingReqthree.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReqthree.tffa__LinkedApplication__c = apptwo.Id;
    insert fundingReqthree;

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c();
    fundingReq.Name = '';
    fundingReq.tffa__Status__c = 'IN_PROGRESS';
    fundingReq.tffa__Type__c = 'ACH';
    fundingReq.tffa__Amount__c = 122;
    fundingReq.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReq.tffa__LinkedApplication__c = app.Id;
    insert fundingReq;

    tffa.SObjectAssembler asmapp2 = new tffa.SObjectAssembler(apptwo);
    asmapp2.addChildObject('LinkedFundingRequests__r', fundingReqthree);

    tffa__Application__c appCert = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert appCert;

    tffa__FundingRequest__c fundingReqCert = new tffa__FundingRequest__c();
    fundingReqCert.Name = '';
    fundingReqCert.tffa__Status__c = 'IN_PROGRESS';
    fundingReqCert.tffa__Type__c = 'ACH';
    fundingReqCert.tffa__Amount__c = 122;
    fundingReqCert.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReqCert.tffa__LinkedApplication__c = appCert.Id;
    insert fundingReqCert;

    tffa.SObjectAssembler asmappCert = new tffa.SObjectAssembler(appCert);
    asmappCert.addChildObject('LinkedFundingRequests__r', fundingReqCert);

    tffa__Application__c appInternal = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Submission__r = sub,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '0000017365',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'APPROVED'
    );
    insert appInternal;

    tffa__FundingRequest__c fundingReqInternal = new tffa__FundingRequest__c();
    fundingReqInternal.Name = '';
    fundingReqInternal.tffa__Status__c = 'IN_PROGRESS';
    fundingReqInternal.tffa__Type__c = 'INTERNAL_TRANSFER';
    fundingReqInternal.tffa__Amount__c = 122;
    fundingReqInternal.tffa__VerificationStatus__c = 'VERIFIED';
    fundingReqInternal.CZSourceAccountBrand__c = '380';
    fundingReqInternal.tffa__LinkedApplication__c = appInternal.Id;
    insert fundingReqInternal;

    tffa.SObjectAssembler asmappInternal = new tffa.SObjectAssembler(appInternal);
    asmappInternal.addChildObjects('LinkedFundingRequests__r', new List<tffa__FundingRequest__c>{ fundingReqInternal });
    tffa__Application__c appObjInternal = (tffa__Application__c) asmappInternal.assemble();
    Test.startTest();
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    CZWTFCIntegrationLogService.setIntegrationLog(sub.Id);
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING);
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.APPROVAL_CCCOMPLETE, app.Id, false);
    Test.setMock(HttpCalloutMock.class, new FISCCCDDepositMockClass());
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('CDDeposit');
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(app1.tffa__Brand__c);
    FISCCCDDepositCreationExtension.testConfigFlow = true;
    FISCCApplicationFundingProvider.testFlow = true;

    FISCCCDDepositCreationExtension.invokeApiCall(app1, adapterConfig, charterConfig);
    FISCCApplicationFundingProvider.processFunding((tffa__Application__c) appasm1.assemble());
    FISCCApplicationFundingProvider.processFunding((tffa__Application__c) asmapp2.assemble());
    FISCCApplicationFundingProvider.processFunding((tffa__Application__c) asmappCert.assemble());
    FISCCApplicationFundingProvider.processFunding(CZWTFCApplicationRepository.findApplicationById(appObjInternal.Id));
    //  FISCCDollarTransactionExtension.invokeApiCall(app1, adapterConfig, charterConfig);
    FISCCDollarTransactionExtension.invokeApiCall(
      (tffa__Application__c) asmappInternal.assemble(),
      adapterConfig,
      charterConfig,
      'INTERNAL_TRANSFER_SOURCE'
    );
    FISCCDollarTransactionExtension.invokeApiCall(
      (tffa__Application__c) asmappInternal.assemble(),
      adapterConfig,
      charterConfig,
      'INTERNAL_TRANSFER_DESTINATION'
    );
    FISCCDollarTransactionExtension.maskString('123455667889');
    FISCCDollarTransactionExtension.maskString('12');
    //FISCCApplicationFundingProvider.doPartial(new List<tffa__Application__c>{ app1, apptwo }, app1.Id);
    FISCCCDDepositCreationExtension.invokeApiCall(apptwo, adapterConfig, charterConfig);

    Test.stopTest();
  }

  /**
   * Error block handling
   */
  @isTest
  public static void testCaseFour() {
    String resp = '{"Entity":{"online-dollar-transaction":{"DPRetAcctWithholdingAmt":0,"TxnSecurityInd":2,"DPTxnCde":115,"DPAcctNbr":4337878,"DPTxnSrcCde":527,"GLBranch":0,"DPCat":"M","DPLogTyp":"L","GLAcctType":0,"DPGLAcctNbr":2006512,"DPRetAcctWithholdingTxnCde":0,"DPDolrTxnOrigTxnCde":0,"DPHiddenSrcCde":527,"DPGLCstCntr":8114,"ShrtNme":"KCHECK LAPTOP","DPDolrSrlNbr":0,"DPDolrTxnAmt":50,"DPTxnCntlNbr":994000524075857}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"DPOD052-USER DEFINED STATUS CODE 2","Severity":"Info","Code":"D600052"}]}}';

    Test.startTest();
    FISCCDollarTransResponseBuilder dlrResp = new FISCCDollarTransResponseBuilder();
    //FISIDAResponseBuilder.testException= true;
    try {
      dlrResp.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      dlrResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCCreateDDResponseBuilder cdDepoResp = new FISCCCreateDDResponseBuilder();
    //FISIDAResponseBuilder.testException= true;
    try {
      cdDepoResp.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      cdDepoResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCFundHoldResponseBuilder fundHoldResp = new FISCCFundHoldResponseBuilder();
    //FISIDAResponseBuilder.testException= true;
    try {
      fundHoldResp.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      fundHoldResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCDepositCreationResponseBuilder depoResp = new FISCCDepositCreationResponseBuilder();
    //FISIDAResponseBuilder.testException= true;
    try {
      depoResp.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      depoResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCDepositCreationResponseBuilder depoResp1 = new FISCCDepositCreationResponseBuilder();
    FISCCDollarTransResponseBuilder.testException = true;
    try {
      depoResp1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      depoResp1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCDollarTransResponseBuilder dlrResp1 = new FISCCDollarTransResponseBuilder();
    FISCCDollarTransResponseBuilder.testException = true;
    try {
      dlrResp1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      dlrResp1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCCreateDDResponseBuilder cdDepoResp1 = new FISCCCreateDDResponseBuilder();
    FISCCCreateDDResponseBuilder.testException = true;
    try {
      cdDepoResp1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      cdDepoResp1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    FISCCFundHoldResponseBuilder fundHoldResp1 = new FISCCFundHoldResponseBuilder();
    FISCCFundHoldResponseBuilder.testException = true;
    try {
      fundHoldResp1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      fundHoldResp1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }

    Test.stopTest();
  }

  @isTest
  public static void commonFisDoTestCase() {
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

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = 'qwerty';
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
    jointParty.tffa__BrandCode__c = '118';
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
    jointParty1.tffa__BrandCode__c = '118';
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

    tffa__Address__c address2 = new tffa__Address__c();
    address2.tffa__Line1__c = '803 Ecostar';
    address2.tffa__State__c = 'CT1';
    address2.tffa__City__c = 'Darien';
    address2.tffa__Country__c = 'US';
    address2.tffa__ZipCode__c = '06820-41';
    insert address2;

    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    partyList.add(partyObj);
    partyList.add(jointParty);

    List<tffa__Party__c> partyList1 = new List<tffa__Party__c>();
    partyList1.add(partyObj);

    Test.startTest();
    FISCCCustomerAccountRelationHelper.fillPartyAndAddressDetails(
      partyList,
      partyObj,
      address1,
      new FISCCCustomerAccountRelationDTO(),
      true
    );

    FISCCCustomerAccountRelationHelper.fillPartyAndAddressDetails(
      partyList,
      partyObj,
      address2,
      new FISCCCustomerAccountRelationDTO(),
      false
    );

    FISCCCustomerAccountRelationHelper.fillPartyAndAddressDetails(
      partyList1,
      partyObj,
      address1,
      new FISCCCustomerAccountRelationDTO(),
      true
    );

    FISCCCustomerAccountRelationHelper.fillPartyAndAddressDetails(
      partyList1,
      partyObj,
      address2,
      new FISCCCustomerAccountRelationDTO(),
      false
    );

    FISCCDepositNameAddressHelper.fillPartyAndAddressDetails(partyList, partyObj, address1, new FISCCDepositNameAddressDTO(), true);

    FISCCDepositNameAddressHelper.fillPartyAndAddressDetails(partyList, partyObj, address2, new FISCCDepositNameAddressDTO(), false);

    FISCCDepositNameAddressHelper.fillPartyAndAddressDetails(partyList1, partyObj, address1, new FISCCDepositNameAddressDTO(), true);

    FISCCDepositNameAddressHelper.fillPartyAndAddressDetails(partyList1, partyObj, address2, new FISCCDepositNameAddressDTO(), false);

    address1.tffa__Line2__c = 'AddressTest';
    FISCCCustomerAccountRelationHelper.fillAddress(partyList1, address1, new FISCCCustomerAccountRelationDTO());
    FISCCDepositNameAddressHelper.fillAddress(partyList1, address1, new FISCCDepositNameAddressDTO());
    Test.stopTest();
  }

  @isTest
  public static void mockTestCase() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISCCDlrTransMockClass());

    Test.setMock(HttpCalloutMock.class, new FISCCCDDepositMockClass());

    Object testObj;
    FISCCDollarTransactionExtension.parseDollarTransResponse(testObj);
    Test.stopTest();
  }
}