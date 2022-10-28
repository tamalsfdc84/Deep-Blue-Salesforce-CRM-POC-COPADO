@isTest
public inherited sharing class FISCCCreateCustomerTest {
  @isTest
  public static void testProcessApplication() {
    tffa__Submission__c sub = new tffa__Submission__c(
      //tffa__Status__c = 'REVIEW',
      //tffa__State__c = 'ReviewSubmit',
      //FundingType__c = 'PAYPAL'
      tffa__Brand__c = '118'
    );
    insert sub;
    tffa__Submission__c sub1 = new tffa__Submission__c();
    //tffa__Status__c = 'REVIEW',
    //tffa__State__c = 'ReviewSubmit',
    //FundingType__c = 'PAYPAL'
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
    party.PreferredContactNumber__c = 'Work';
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
      tffa__KYCDecisionOutcome__c = 'APPROVED'
    );
    //app.RecordTypeId = TestRepositoryHelper.getApplicationRecordType();
    insert app;
    //create Identity
    tffa__Identification__c identity = new tffa__Identification__c();
    identity.tffa__Party__c = lstParty[0].id;
    tffa.Logger.debug('identity.tffa__Party__c ==>' + identity.tffa__Party__c);
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
    tffa.Logger.debug(' party.Id ==>' + party.Id);
    tffa.Logger.debug('appPartyxref ==>' + appPartyxref);
    List<tffa__party__c> lstParty1 = new List<tffa__party__c>();
    lstParty1 = [
      SELECT
        id,
        Name,
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
    tffa.Logger.debug('party.tffa__Applications__r ==> ' + lstParty1[0].tffa__Applications__r);

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

    IntegrationLog__c log = new IntegrationLog__c(Submission__c = sub.id, FlowName__c = 'Create Customer FLOW');
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
    List<FISCC_Adapter_Configs__mdt> lstAdaptrConfig_createCustomer = FISCCTestRepositoryHelper.getAdapterConfigMetadata('CreateCustomer');
    List<FISCC_Charter_Config__mdt> lstCharterConfig1 = FISCCTestRepositoryHelper.getCharterConfigMetadata1('BA_889');
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
      // FISCCSubmissionExecutor.processApplication(sub.id);
      /*  FISCCIntegrationLogService.currentLogItem = logItems;
            FISCCIntegrationLogService.isLogItemNewOrFailed();  
            FISCCIntegrationLogService.setLogItemMessage('Success');
            FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.CREATE_CUSTOMER_FLOW);
            FISCCIntegrationLogService.setLogItemOk('APIName', 'failed');
            FISCCIntegrationLogService.setLogItemFailed(lstParty1[0].Name);
            FISCCIntegrationLogService.setLogItemFailed(lstParty1[0].Name, 'failed');
            FISCCSubmissionExecutor.processApplication(sub1.id); */
      // FISCCIntegrationLogService.setLogFailed('failed');
      FISCCIntegrationLogService.setSubmissionObj(sub.id);
      FISCCIntegrationLogService.setIntegrationLog(sub.id);
      FISCCIntegrationLogService.isLogNewOrFailed('Create Customer FLOW');
      FISCCIntegrationLogService.setCurrentLog('Create Customer FLOW');
      CZWTFCIntegrationLogService.currentLogItem = logItems;
      FISCCIntegrationLogService.isLogItemNewOrFailed();
      FISCCIntegrationLogService.setLogItemMessage('Success');
      FISCCIntegrationLogService.isLogOk('Create Customer FLOW');
      FISCCIntegrationLogService.setLogItemOk('APIName', 'failed');
      FISCCIntegrationLogService.setLogItemFailed(lstParty1[0].Name);
      FISCCIntegrationLogService.setLogItemFailed(lstParty1[0].Name, 'failed');
      //FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr(lstParty,lstAdaptrConfig1[0],lstCharterConfig1[0]);
      FISCCCustomerDTO objFISCCCustomerDTO = new FISCCCustomerDTO();

      object response;
      // FISCCCustomerEmailExtension.isFISCCAPICallSuccess(response,lstParty1);
      // FISCCCreateCustomerExtension.invokeCreateCustomer(null,lstAdaptrConfig_createCustomer[0],lstCharterConfig1[0]);
      FISCCCreateCustomerResponseBuilder objFISCCCreateCustomerResponseBuilder = new FISCCCreateCustomerResponseBuilder();
      objFISCCCreateCustomerResponseBuilder.build(null, null, null);
      objFISCCCreateCustomerResponseBuilder.parseResponse(null, null, null);
      FISCCCreateCustomerDTO objFISCCCreateCustomerDTO = new FISCCCreateCustomerDTO();
      FISCCDepositOriginationResponse objFISCCResponseDepositOrigination = new FISCCDepositOriginationResponse();
      FISCCCreateCustomerEntityResponse objFISCCCustomerSearchTaxnbrEntityResponse = new FISCCCreateCustomerEntityResponse();
      //FISCCCustomerSearchTaxnbrResponse objFISCCCustomerSearchTaxnbrResponse = new FISCCCustomerSearchTaxnbrResponse();
      FISCCDOCustomerDTO objFISCCDOCustomerDTO = new FISCCDOCustomerDTO();
      FISCCGetAccessTokenResponse objFISCCGetAccessTokenResponse = new FISCCGetAccessTokenResponse();
      /* FISCCCustomerEmailResponseBuilder objFISCCCustomerEmailResponseBuilder = new FISCCCustomerEmailResponseBuilder();
            FISCCCustomerEmailEntityResponse objFISCCCustomerEmailEntityResponse = new FISCCCustomerEmailEntityResponse();
            FISCCCreateEmailAddressesDTO objFISCCCreateEmailAddressesDTO = new FISCCCreateEmailAddressesDTO();
            objFISCCCustomerEmailResponseBuilder.build(null,null,null);*/
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');
      FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
    }

    Test.stopTest();
  }
}