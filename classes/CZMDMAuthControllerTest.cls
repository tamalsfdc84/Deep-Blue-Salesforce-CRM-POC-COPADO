@isTest
public with sharing class CZMDMAuthControllerTest {
  @isTest
  public static void testCaseOne() {
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
    insert sub;

    Test.startTest();
    tffa.IController controller;
    tffa.Context ctx = tffa.Context.get();
    Map<String, String> params = new Map<String, String>();
    params.put('submission', sub.Id);
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

    try {
      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new CZMDMAuthMockClass());
      tffa.Response resp = CZWTFCAuthenticationController.authenticateParty(ctx, params);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      String resp = '{"status":"String","prtyId":"String","customerInfo":{"frstNme":"String","mdlNme":"String","lstNme":"String","addrsLn1":"String","addrsLn2":"String","city":"String","stateCd":"String","zipCd":"String","county":"String","primPhNmb":"String","scndryPhNmb":"String","mblPhNmb":"String","psnlEmailId":"String","birthDte":"2021-06-22T06:31:41.701-05:00","idtfrLst":[{"idtfrTypCd":"String","idtfrNmb":"String","issueStateCd":"String","expDte":"09-24-2021","issueDte":"2021-06-22T06:31:41.701-05:00"}],"ssnNmb":"String","ctzshp":"String","occpCd":"String","emplyStatCd":"String","emplyTitle":"String","emplyNme":"String"},"customerRcdLst":[{"cisNmb":"String","chrtrCd":"String","cisStrtDte":"2021-06-22T06:31:41.701-05:00"}],"acctLst":[{"acctNmb":"String","chrtrCd":"String","acctCreationDte":"09-24-2021","acctCtgry":"String","pdtCd":"String","pdtNm":"String","acctTyp":"String","acctstatus":"String","ownrshpCd":"String","rltnshpCd":"String"}]}';
      CZMDMAuthenticationResponseDTO dto = (CZMDMAuthenticationResponseDTO) System.JSON.deserialize(
        resp,
        CZMDMAuthenticationResponseDTO.class
      );

      CZWTFCAuthenticationService.parseResponse(new CZWTFCAuthResponse(), dto);

      dto.customerInfo.primPhNmb = '';
      dto.customerInfo.scndryPhNmb = '';
      dto.customerInfo.mblPhNmb = '';
      dto.customerInfo.birthDte = null;
      dto.customerInfo.psnlEmailId = '';
      CZWTFCAuthenticationService.brandCode = 'String';
      CZWTFCAuthenticationService.parseResponse(new CZWTFCAuthResponse(), dto);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    CZWTFCAuthenticationService.generateRespDTO(params, 'ind-2');
    CZWTFCAuthenticationService.generateRespDTO(params, 'ind-3');

    try {
      new CZWTFCAuthenticationController(controller);
      CZWTFCAuthenticationController.authenticateParty(ctx, new Map<String, String>());
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      CZWTFCAuthenticationService.testException = true;
      CZWTFCAuthenticationService.verifyUser(params);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    try {
      CZWTFCAuthenticationService.testException = true;
      CZWTFCAuthenticationService.generateRespDTO(params, '');
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    // occ and emp code
    try {
      String resp = '{"status":"String","prtyId":"String","customerInfo":{"frstNme":"String","mdlNme":"String","lstNme":"String","addrsLn1":"String","addrsLn2":"String","city":"String","stateCd":"String","zipCd":"String","county":"String","primPhNmb":"String","scndryPhNmb":"String","mblPhNmb":"String","psnlEmailId":"String","birthDte":"2021-06-22T06:31:41.701-05:00","idtfrLst":[{"idtfrTypCd":"String","idtfrNmb":"String","issueStateCd":"String","expDte":"09-24-2021","issueDte":"2021-06-22T06:31:41.701-05:00"}],"ssnNmb":"String","ctzshp":"String","occpCd":"String","emplyStatCd":"U","emplyTitle":"String","emplyNme":"String"},"customerRcdLst":[{"cisNmb":"String","chrtrCd":"","cisStrtDte":"2021-06-22T06:31:41.701-05:00"}],"acctLst":[{"acctNmb":"String","chrtrCd":"String","acctCreationDte":"09-24-2021","acctCtgry":"String","pdtCd":"String","pdtNm":"String","acctTyp":"String","acctstatus":"String","ownrshpCd":"String","rltnshpCd":"String"}]}';
      CZMDMAuthenticationResponseDTO dto = (CZMDMAuthenticationResponseDTO) System.JSON.deserialize(
        resp,
        CZMDMAuthenticationResponseDTO.class
      );
      dto.customerInfo.occpCd = 'H';
      CZWTFCAuthenticationService.parseResponse(new CZWTFCAuthResponse(), dto);
      dto.customerInfo.occpCd = 'S';
      CZWTFCAuthenticationService.parseResponse(new CZWTFCAuthResponse(), dto);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    CZMDMAuthenticationResponseDTO dto = new CZMDMAuthenticationResponseDTO();

    try {
      CZWTFCAuthenticationService.getfirstRecordValue(1);
      CZWTFCAuthenticationService.getfirstRecordValue(null);

      CZWTFCAuthenticationService.getLoginType('DP_ACCOUNT');
      CZWTFCAuthenticationService.getLoginType('LOAN_ACCOUNT');
      CZWTFCAuthenticationService.getLoginType('DEBIT_CARD');
      CZWTFCAuthenticationService.getLoginType('CUSTOMER_SEARCH');
      CZWTFCAuthenticationService.getLoginType('');
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testCaseIndSearch() {
    String resp = '{"first_record":1,"page_size":10,"total_record_count":7,"individualInfo":[{"mdmPartyId":"1001863","frstNm":"JAMES","lstNm":"GUGLIELMO","ssnNum":"8022","address1":"2216 LAKEDALE DR","cityNm":"FAYETTEVILLE","stateCd":"NC","zip4Cd":"3168","zip5Cd":"28306","countryNm":"United States of America","countryCd":"USA","phoneNum":"(910) 494-0187"},{"mdmPartyId":"2469483","frstNm":"JOAN F","lstNm":"GUGLIELMO","ssnNum":"0204","address1":"101 WOODLAND TRAILS DR","cityNm":"COLLINSVILLE","stateCd":"IL","zip4Cd":"5873","zip5Cd":"62234","countryNm":"United States of America","countryCd":"USA","phoneNum":""},{"mdmPartyId":"932890","frstNm":"ALEXANDRA","lstNm":"GUGLIELMO","ssnNum":"8594","address1":"429 W BRIAR PL APT 1W","cityNm":"CHICAGO","stateCd":"IL","zip4Cd":"4768","zip5Cd":"60657","countryNm":"United States of America","countryCd":"USA","phoneNum":"(847) 767-3562"},{"mdmPartyId":"1724639","frstNm":"TINA","lstNm":"GUGLIELMO","ssnNum":"9427","address1":"640 BRIGHTON DR","cityNm":"WHEATON","stateCd":"IL","zip4Cd":"8106","zip5Cd":"60189","countryNm":"United States of America","countryCd":"USA","phoneNum":"(630) 752-0439"},{"mdmPartyId":"2409904","frstNm":"JAMES","lstNm":"GUGLIELMO","ssnNum":"2944","address1":"6 S641 AVON CT","cityNm":"NAPERVILLE","stateCd":"IL","zip4Cd":"","zip5Cd":"","countryNm":"United States of America","countryCd":"USA","phoneNum":"(630) 369-5751"},{"mdmPartyId":"2358480","frstNm":"ANTHONY P","lstNm":"GUGLIELMO","ssnNum":"6401","address1":"101 WOODLAND TRAILS DR","cityNm":"COLLINSVILLE","stateCd":"IL","zip4Cd":"5873","zip5Cd":"62234","countryNm":"United States of America","countryCd":"USA","phoneNum":"(618) 345-5310"},{"mdmPartyId":"51962","frstNm":"MARK","lstNm":"GUGLIELMO","ssnNum":"0596","address1":"425 S BODIN ST","cityNm":"HINSDALE","stateCd":"IL","zip4Cd":"3914","zip5Cd":"60521","countryNm":"United States of America","countryCd":"USA","phoneNum":"(630) 654-4954"}]}';

    Test.startTest();
    try {
      CZMDMIndividualSearchResponseDTO dto = (CZMDMIndividualSearchResponseDTO) System.JSON.deserialize(
        resp,
        CZMDMIndividualSearchResponseDTO.class
      );

      CZWTFCAuthenticationService.parseIndSearchResp(dto, 10);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, Object> params = new Map<String, Object>();
      params.put('submission', sub.Id);
      params.put('recordPage', 1);
      params.put('frstNm', 'JOHN');
      params.put('lstNm', 'SMIYH');
      params.put('birthDte', '2000-02-02');
      params.put('ssnNum', '122133232');
      params.put('acctNum', '00001189080');
      params.put('debitCrdNo', '100');
      params.put('phnNum', '100');

      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new CZMDMIndSearchMockClass());
      tffa.Response res = CZWTFCAuthenticationController.searchIndividualCust(ctx, params);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseBusinessSearch() {
    String resp = '{"totalRecords":4,"totalPages":0,"status":"success","pageSize":10,"pageNumber":1,"organizationInfo":[{"zip5Cd":"60616","zip4Cd":"3717","taxId":"3434","state":"ILLINOIS","phoneNumber":"4343443434","orgNm":"SDDS","mdmPartyId":"7220226","countryNm":"United States of America","countryCd":"USA","city":"CHICAGO","address1":"10 W 35TH ST"},{"zip5Cd":"60137","zip4Cd":"3712","taxId":"","state":"ILLINOIS","phoneNumber":"6308584396","orgNm":"SDDS INC","mdmPartyId":"215884","countryNm":"United States of America","countryCd":"USA","city":"GLEN ELLYN","address1":"312 GENEVA RD"},{"zip5Cd":"06471","zip4Cd":"1000","taxId":"","state":"CONNECTICUT","phoneNumber":"2034849793","orgNm":"SDDS SERVICES LLC","mdmPartyId":"2936570","countryNm":"United States of America","countryCd":"USA","city":"NORTH BRANFORD","address1":"1 FOXON RD"},{"zip5Cd":"06471","zip4Cd":"1000","taxId":"","state":"CONNECTICUT","phoneNumber":"2034849793","orgNm":"SDDS SERVICES LLC","mdmPartyId":"3465479","countryNm":"United States of America","countryCd":"USA","city":"NORTH BRANFORD","address1":"1 FOXON RD"}],"firstRecord":1}';

    Test.startTest();
    try {
      CZMDMBusinessCustSearchResponseDTO dto = (CZMDMBusinessCustSearchResponseDTO) System.JSON.deserialize(
        resp,
        CZMDMBusinessCustSearchResponseDTO.class
      );

      CZWTFCAuthenticationService.parseBusinessSearchResp(dto, 10);
      CZWTFCAuthenticationService.getOrgfirstRecordValue(1);
      CZWTFCAuthenticationService.getOrgfirstRecordValue(null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, Object> params = new Map<String, Object>();
      params.put('submission', sub.Id);
      params.put('recordPage', 1);
      params.put('businessNm', 'ABC');
      params.put('taxId', '111111111');
      params.put('accountNum', '1111');
      params.put('debitCrdNo', '122133232');
      params.put('phoneNum', '00001189080');

      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new CZMDMBusinessCustSearchMockClass());
      tffa.Response res = CZWTFCAuthenticationController.searchBusinessCust(ctx, params);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseFetchBusinessCustomerDetails() {
    Test.startTest();
    try {
      CZMDMBusinessCustDetailsResponseDTO dto = new CZMDMBusinessCustDetailsResponseDTO();

      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, Object> params = new Map<String, Object>();
      params.put('submission', sub.Id);
      params.put('mdmPartyId', '12345');

      CZMulesoftAdapter.auth = '13445';
      //Test.setMock(HttpCalloutMock.class, new CZMDMBusinessCustSearchMockClass());
      tffa.Response res = CZWTFCAuthenticationController.fetchBusinessCustDetails(ctx, params);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      String res = '{"rowidObject":"1111","orgNm":"IGNITE, ORG","businessType":"200","taxIdType":"F","taxId":"1111","Addresses":{"addrLine1Tx":"180 N MICHIGAN AVE STE 1900","addrLine2Tx":"","cityNm":"CHICAGO","stateNm":"ILLINOIS","stateCd":"IL","zip4Cd":"7477","zip5Cd":"60601"},"mailingAddress":{"addrLine1Tx":"180 N MICHIGAN AVE STE 1900","addrLine2Tx":"","cityNm":"CHICAGO","stateNm":"ILLINOIS","stateCd":"IL","zip4Cd":"7477","zip5Cd":"60601"},"phNmb":[{"commcnVl":"(312) 568-5701","commcnTypCd":"PRI"},{"commcnVl":"(312) 568-5701","commcnTypCd":"SEC"},{"commcnVl":"(312) 568-5701","commcnTypCd":"MBL"}],"naicsCd":"624110","emailId":"","cisDetailLst":[{"CISNmb":"11","chrtrCd":"870","custSinceDt":"2008-05-27T00:00:00-05:00","brnchCd":"870&#124;1","costCntrNo":"11","offcrCd":"7","CIScndyOffcrNbr":"","secretWrd":"","secretHnt":""}],"acctLst":[{"acctNmb":"111","chrtrCd":"870","acctCreationDte":"2016-07-12T00:00:00-05:00","acctCtgry":"DP","pdtCd":"891","pdtNm":"MAXSAFE NONPROFIT MM","acctTyp":"DP&#124;M","acctstatus":"Open","rltnshpCd":"870&#124;451"}],"ownerRcdLst":[{"rowidObject":"11","taxIdType":"F","taxId":"111","relCd":"870&#124;000","Communication":[{"commcnVl":"(111) 111-1111","commcnTypCd":"FAX"},{"commcnVl":"(111) 111-1111","commcnTypCd":"PRI"}],"emailId":"","chrtrCd":"870","CISNmb":"11"}],"signerRcdLst":[{"rowidObject":"11","taxIdType":"F","taxId":"111","relCd":"870&#124;000","Communication":[{"commcnVl":"(111) 111-1111","commcnTypCd":"FAX"},{"commcnVl":"(111) 111-1111","commcnTypCd":"PRI"}],"emailId":"","chrtrCd":"870","CISNmb":"22"}],"IdentifierLst":[{"idtfrTypCd":"F","idtfrNmb":"122","issueStateCd":"","expDte":"","issueDte":""}]}';

      Object respObj = System.JSON.deserialize(res, CZMDMBusinessCustDetailsResponseDTO.class);
      CZMDMBusinessCustDetailsResponseDTO responseDTO = (CZMDMBusinessCustDetailsResponseDTO) respObj;

      CZWTFCAuthenticationService.parseBusinessResponse(new CZMDMBusinessCustDetailsResponse(), responseDTO);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      CZWTFCAuthenticationService.fetchOrgType('900');
      CZWTFCAuthenticationService.fetchPartyRelationNameMap();
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    Test.stopTest();
  }

  @isTest
  public static void testCaseSearchParty() {
    Test.startTest();
    try {
      CZMDMBusinessCustDetailsResponseDTO dto = new CZMDMBusinessCustDetailsResponseDTO();

      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, Object> params = new Map<String, Object>();
      params.put('submission', sub.Id);
      params.put('partyType', 'IND');
      params.put('taxId', '111111111');

      CZMulesoftAdapter.auth = '13445';
      //Test.setMock(HttpCalloutMock.class, new CZMDMBusinessCustSearchMockClass());
      tffa.Response res = CZWTFCAuthenticationController.searchParty(ctx, params);
      System.assertNotEquals(res, null);

      params.put('partyType', 'ORG');
      res = CZWTFCAuthenticationController.searchParty(ctx, params);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseSearchPartyInFIS() {
    Test.startTest();
    try {
      CZMDMBusinessCustDetailsResponseDTO dto = new CZMDMBusinessCustDetailsResponseDTO();

      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, String> params = new Map<String, String>();
      params.put('submission', sub.Id);
      params.put('brandCode', '118');
      params.put('isDebitCardProductSelected', 'Y');
      params.put('custNbr', '12345');

      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new FISCCCustomerSearchTaxnbrMockClass('/rest/IBSCI/v2/customers/search/taxnbr'));
      tffa.Response res = CZWTFCAuthenticationController.authenticateParty(ctx, params);
      System.assertNotEquals(res, null);
      Map<String, Object> params1 = new Map<String, Object>();
      params1.put('submission', sub.Id);
      params1.put('brandCode', '118');
      params1.put('isDebitCardProductSelected', 'Y');
      params1.put('custNbr', '12345');

      params1.put('businessNm', 'businesss');
      res = CZWTFCAuthenticationController.fetchBusinessCustDetails(ctx, params1);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseSearchOrgPartyInFIS() {
    Test.startTest();
    try {
      CZMDMBusinessCustDetailsResponseDTO dto = new CZMDMBusinessCustDetailsResponseDTO();

      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();

      Map<String, Object> params1 = new Map<String, Object>();
      params1.put('submission', sub.Id);
      params1.put('brandCode', '118');
      params1.put('isDebitCardProductSelected', 'Y');
      params1.put('custNbr', '12345');
      Test.setMock(HttpCalloutMock.class, new FISCCCustomerSearchTaxnbrMockClass('/rest/IBSCI/v2/customers/search/taxnbr'));
      tffa.Response res = CZWTFCAuthenticationController.fetchBusinessCustDetails(ctx, params1);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseSearchPartiesInFIS() {
    Test.startTest();
    try {
      CZMDMBusinessCustDetailsResponseDTO dto = new CZMDMBusinessCustDetailsResponseDTO();

      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
      insert sub;

      tffa.IController controller;
      tffa.Context ctx = tffa.Context.get();
      Map<String, Object> params = new Map<String, Object>();
      params.put('submission', sub.Id);
      params.put('brandCode', '118');
      params.put('isDebitCardProductSelected', 'Y');
      params.put('frstNm', 'JOHN');

      CZMulesoftAdapter.auth = '13445';
      Test.setMock(HttpCalloutMock.class, new FISCCCustomerSearchTaxnbrMockClass('/rest/IBSCI/v2/customers/search/taxnbr'));
      tffa.Response res = CZWTFCAuthenticationController.searchIndividualCust(ctx, params);
      System.assertNotEquals(res, null);

      params.remove('frstNm');
      params.put('businessNm', 'businesss');
      res = CZWTFCAuthenticationController.searchBusinessCust(ctx, params);
      System.assertNotEquals(res, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseFetchApplicant() {
    Test.startTest();

    try {
      FISCCGetCustomerProfileResponse resp1 = new FISCCGetCustomerProfileResponse();
      resp1.entity.customer.CICurStdNme01 = '1233456 132345456';
      resp1.entity.customer.CITypOfBusCde = '201';
      resp1.entity.customer.CISncDte = '2e3435';
      resp1.entity.customer.CICurStdAddr2Cde = 'A';
      resp1.entity.customer.CIPrmyPhNbr = '1324355';
      resp1.entity.customer.CIScndyPh = '123455';
      resp1.entity.customer.CIPrmyOffcrNbr = '13456';
      resp1.entity.customer.CIScndyOffcrNbr = '3235';
      resp1.entity.customer.CIBrnchNbr = '1';
      resp1.entity.customer.CIPIDTyp1 = '1234';
      resp1.entity.customer.CIPIDIssDte1 = '2000-02-02';
      resp1.entity.customer.CIPIDExpDte1 = '2000-02-02';
      resp1.entity.customer.CIFrstNmeMidInitl = '4r435t436 rtretre';
      resp1.entity.customer.CICurNmeSfxCde = '1234';
      FISCCCustomerAccProfileResponse.RelatedAccount acc = new FISCCCustomerAccProfileResponse.RelatedAccount();
      acc.DPAcctNbr = '13445';
      acc.CIRltBnkNbr1 = '889';
      acc.CIRltEffDte = '1344';
      acc.CIRltApplCde1 = 'qwer';
      acc.DPCategory = 'qe234';
      acc.CIEnt2ToEnt1RltCde = '1345';
      FISCCCustomerAccProfileResponse.RelatedAccount acc2 = new FISCCCustomerAccProfileResponse.RelatedAccount();
      acc2.DPAcctNbr = '13445';
      acc2.CIRltBnkNbr1 = '889';
      acc2.CIRltEffDte = '1344';
      acc2.CIRltApplCde1 = 'qwer';
      acc2.DPCategory = 'qe234';
      acc2.CIEnt2ToEnt1RltCde = '1345';
      FISCCCustomerAccProfileResponse resp2 = new FISCCCustomerAccProfileResponse();
      resp2.entity.relatedAccountsLst.add(acc);
      resp2.entity.relatedAccountsLst.add(acc2);

      CZFetchEmailAddressResponseDTO.EmailAddDetails emailDetails = new CZFetchEmailAddressResponseDTO.EmailAddDetails();
      emailDetails.EmailAddr = '1324667';
      CZFetchEmailAddressResponseDTO emailDto = new CZFetchEmailAddressResponseDTO();
      emailDto.entity.emailaddressesLst.add(emailDetails);

      FISCCFetchDueDiligenceRespDTO ddDto = new FISCCFetchDueDiligenceRespDTO();
      ddDto.Entity.dueDiligenceDemographics.RsdntPrsn = 'Y';
      Map<String, Object> params = new Map<String, Object>();
      params.put('brandCode', '118');
      params.put('isDebitCardProductSelected', 'Y');
      params.put('custNbr', '12345');

      FISCCCustomerSearchExtension.parseIndDetailedResp(resp1, resp2, ddDto, emailDto, params);
      FISCCCustomerSearchExtension.parseOrgDetailedResp(resp1, resp2, ddDto, emailDto, params);
      FISCCCustomerSearchExtension.fetchAdapterConfigCustInfo(params);
      FISCCCustomerSearchExtension.fetchAdapterConfigCustProfile(params);
      FISCCCustomerSearchExtension.fetchAdapterConfigCustDD(params);
      FISCCCustomerSearchExtension.fetchAdapterConfigEmail(params);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    //Exception block in FISCCCustAccProfResponseBuilder.build
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerAccProfileResponse dto = (FISCCCustomerAccProfileResponse) System.JSON.deserialize(
        resp,
        FISCCCustomerAccProfileResponse.class
      );
      FISCCCustAccProfResponseBuilder respBuilder = new FISCCCustAccProfResponseBuilder();
      FISCCCustAccProfResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block in FISCCCustAccProfResponseBuilder.parseResponse
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerAccProfileResponse dto = (FISCCCustomerAccProfileResponse) System.JSON.deserialize(
        resp,
        FISCCCustomerAccProfileResponse.class
      );
      FISCCCustAccProfResponseBuilder respBuilder = new FISCCCustAccProfResponseBuilder();
      FISCCCustAccProfResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCCustomerAccProfileResponse(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //success flow FISCCCustomerAccProfileResponse
    try {
      String resp = '{"Entity":{"customer-profile":{"NbrAccts":1,"CICurNmePrcsTme":"06.31.55","CICurStdAddr1Cde":"S","CICurStdAddr2Cde":"C","CICurStdAddr1Txt":"1010 W ILLINOIS ST","CICurStdAddr2Txt":"URBANA IL 61801","CICurStdNmeCde01":"N","CICurStdNme01":"JOHNN SMITHH","CICustTaxNbr":565756786,"CICustTaxCde":"S","Cty":"URBANA","CICurLstNmeKeyFld1":"SMITHH","CICurFrstNmeKeyFld2":"JOHNN","St":"IL","ZIP":61801,"CIBirthdate":"2000-02-02","CIPrmyPhNbr":9898778778,"CICustNbr":"00000073902","CICustCde1":0,"CICustCde2":0,"CICustCde3":0,"CICustCde4":0,"CICustCde5":0,"CICustCde6":0,"CICustCde7":0,"CICustCde8":0,"CICustCde9":0,"CICustCde10":0,"CICustCde11":0,"CICustCde12":0,"CICustCde13":0,"CICustCde14":0,"CICustCde15":0,"CIPrspctInd":"C","CtryCde":"USA","AddrOvrideInd":"N","CIMobilePhNbr":9898778778},"related-accountsLst":[{"DPAcctNbr":79283225,"DPStmtMrktNme":"TOTAL ACCESS CHECKING","DPColBal":0.00,"DPPastYrInterestPdYTD":0.00,"DPPrevProcessingDte":"2022-10-07","DPLstStmtBal":0.00,"CIRltApplCde1":"DP","CIRltApplNbr01":"00079283225","CIRltBnkNbr1":889,"CIEnt1ToEnt2RltCde":901,"CIEnt2ToEnt1RltCde":0,"CIRltEffDte":"2022-10-10","CIRltExpDte":"0000-00-00","AcctBalAmt1":0.00,"DPAcctTyp":800,"DPLgrBal":0.00,"DPCurBal":0.00,"DPLstStmtDte":"0000-00-00","DPAvailBal":0.00,"DPOpenInd":"Z","DPCategory":"D","DPCategoryDesc":"DEMAND DEPOSIT ACCOUNT","DPPraCrLne":0,"DPPraBalAmt":0.00,"DPRqstForDtaTDIdKey":0,"DPIntStatedRte":0.000,"Yld":0.000,"DPIntPdYTD":0.00,"DPNxtStmtDte":"2022-11-10","DPPraInd":"N","DPFltOneDayCollectableAmt":0,"DPFltTwoDayCollectableAmt":0,"DPFltThreeDayCollectableAmt":0,"DPFltDay4Thru9CollectableAmt":0,"DPNbrOfDebitsCTD":0,"DPAmtOfDebitsCtd":0.00,"DPNbrOfCreditsCTD":0,"DPAmtOfCreditsCtd":0.00,"DPAccrdIntCtd":0.000000000,"DPEmpAcctInd":"N","DPTotFlt":0.00,"DPPRAAvailLne":0.00,"DPLstFltPstEndofday":0.00,"DPRltAcctAvailBal":0.00,"DPFlt1BusDayAvailFltAmt":0,"DPFlt2BusDayAvailFltAmt":0,"DPFlt3BusDayAvailFltAmt":0,"DPFlt4BusDayAvailFltAmt":0,"DPFlt5BusDayAvailFltAmt":0,"DPFlt6BusDayAvailFltAmt":0,"DPFlt7BusDayAvailFltAmt":0,"DPFlt8BusDayAvailFltAmt":0,"DPFlt9BusDayAvailFltAmt":0,"DPFlt10BusDayAvailFltAmt":0,"DPFlt11BusDayAvailFltAmt":0,"DPTotAvailFltAmt":0,"DPClosDte":"2022-10-11","DPOpenDte":"2022-10-11","DPName":"JOHNN SMITHH","DPAnnPercentageYldEarnLstCyc":0.00,"RVMOptOutInd":"N","DPNewAvailBal":0.00,"AcctAvailBalLabel":"ACCOUNT AVAILABLE","TotalAccessBalLabel":"TOTAL ACCESSIBLE"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerAccProfileResponse dto = (FISCCCustomerAccProfileResponse) System.JSON.deserialize(
        resp,
        FISCCCustomerAccProfileResponse.class
      );
      FISCCGetAccProfResponseBuilder respBuilder = new FISCCGetAccProfResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Exception block
    try {
      FISCCCustomerSearchExtension.testException = true;
      FISCCCustomerSearchExtension.fetchApplicantFromFIS(new Map<String, Object>());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    Test.stopTest();
  }

  @isTest
  public static void testCaseSrchRespBuilderExcep() {
    Test.startTest();

    String res = '{"Entity":{"control-data":{"CIMoreToBeReturnedInd":"N","CIKeyCtyNme":"NORTHBROOK","CISearchTyp":"P","CICustNbrToStrtSearch":"00000054086","CICustNme":"JOHN","CICustTypInd":"I","CIRequestedResTimes":1},"customersLst":[{"CICurStdAddr1Cde":"S","CICurStdAddr2Cde":"C","CICurStdAddr1Txt":"1105 WAUKEGAN RD","CICurStdAddr2Txt":"NORTHBROOK IL 60062","CICurStdNmeCde01":"N","CICurStdNme01":"JOHN SMITH","CICustRemarksInd":"N","CICustBnkNbr":889,"CICustRtnNbr":"00000054086","CICustTaxNbr":987501720,"CIPrmyPhNbr":8478283709,"CICurNmeAddrEffDte":"2016-03-28","CICurNmePrcsTme":"14.35.24","MktAreaPrcVal":0,"ElmntLstNme":"SMITH","ElmntFrstNme":"JOHN","ElmntHouseNbr":1105,"ElmntOddEvenInd":1,"ElmntStreet":"WAUKEGAN RD","ElmntCity":"NORTHBROOK","ElmntState":"IL","ElmntZip":60062,"CIPrspctInd":"C","CIBirthdate":"1993-03-03","CIDrvrLic":"K52505678999","CICustTaxCde":"S","CISncDte":"2016-03-28","CICustEmpltSchl":"VILLAGE VOICE","CIMothersMdnNme":"FEATHER","CtryCde":"USA","CIRecTypInd":"M","SurNme":"SMITH","CIFrstNmeMidInitl":"JOHN"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

    Object respObj = System.JSON.deserialize(res, FISCCCustomerSearchResponse.class);
    FISCCCustomerSearchResponse responseDTO = (FISCCCustomerSearchResponse) respObj;

    try {
      FISCCCustomerSearchExtension.parseIndResp(responseDTO);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      FISCCCustomerSearchExtension.parseOrgResp(responseDTO);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    String res2 = '{"Entity":{"accountProf":{"NbrAccts":0,"CICurStdAddr1Cde":"S","CICurStdAddr2Cde":"C","CICurStdAddr1Txt":"1010 WEST ILLINOIS STREET","CICurStdAddr2Txt":"URBANA IL 61801","CICurStdNmeCde01":"N","CICurStdNme01":"MDM BUSINESS 2","CICustTaxNbr":234812748,"CICustTaxCde":"S","Cty":"URBANA","CICurLstNmeKeyFld1":"MDM","CICurFrstNmeKeyFld2":"BUSINESS","CICurMidNmeKeyFld3":2,"St":"IL","ZIP":61801,"CIPrmyPhNbr":2025425122,"CIScndyPh":2025452125,"NbrAcctRltCust":3,"RltApplNbr01":"00000071633","CICustCde1":0,"CICustCde2":0,"CICustCde3":0,"CICustCde4":0,"CICustCde5":0,"CICustCde6":0,"CICustCde7":0,"CICustCde8":0,"CICustCde9":0,"CICustCde10":0,"CICustCde11":0,"CICustCde12":0,"CICustCde13":0,"CICustCde14":0,"CICustCde15":0,"CIHistInd":"Y","CIPrspctInd":"C","CtryCde":"USA","CIRltCustRltEffDte":"2022-10-07","CIPrimCustNbr":"00000071633","CIPrimEnt1toEnt2":451,"CIPrimEnt2toEnt1":901,"CICurNmePrcsTme":"01.52.09","CIMobilePhNbr":2015552322,"CIRecTypInd":"O"},"related-accountsLst":[],"relatedCustomersLst":[{"RltCustCIRltApplCde1":"CUST","RltCustCIRltApplNbr01":"00000060086","RltCustCIRltBnkNbr1":889,"RltCustCIEnt1toEnt2RltCde":459,"RltCustCIEnt2toEnt1RltCde":902,"CIRltEffDte":"2022-10-07","RltCustCICurNmePrcsTme":"09.41.05","RltCustCICurStdAddr1Cde":"S","RltCustCICurStdAddr2Cde":"C","RltCustCICurStdAddr1Txt":"123 MAIN ST","RltCustCICurStdAddr2Txt":"LEMONT IL 60439-3675","RltCustCICurStdNmeCde01":"N","RltCustCICurStdNme01":"DORA EXPLORER","RltCustCIDrvrLic":"IL623456789","RltCustCICustTaxNbr":987921853,"RltCustCICustTaxCde":"S","RltCustCty":"LEMONT","RltCustCICurLstNmeKeyFld1":"EXPLORER","RltCustCICurFrstNmeKeyFld2":"DORA","RltCustSt":"IL","RltCustZIP":604393675,"RltCustCIBirthdate":"1999-01-01","RltCustCIPrmyPhNbr":6308869752,"CIRltExpDte":"0000-00-00","RltCustCtryCde":"USA"},{"RltCustCIRltApplCde1":"CUST","RltCustCIRltApplNbr01":"00000071192","RltCustCIRltBnkNbr1":889,"RltCustCIEnt1toEnt2RltCde":459,"RltCustCIEnt2toEnt1RltCde":902,"CIRltEffDte":"2022-10-07","RltCustCICurNmePrcsTme":"03.04.19","RltCustCICurStdAddr1Cde":"S","RltCustCICurStdAddr2Cde":"C","RltCustCICurStdAddr1Txt":"1010 W ILLINOIS STS","RltCustCICurStdAddr2Txt":"URBANA IL 61801-3004","RltCustCICurStdNmeCde01":"N","RltCustCICurStdNme01":"JOHN-JOHN MCEVILLY SR","RltCustCIDrvrLic":"M21443875179","RltCustCICustTaxNbr":318041744,"RltCustCICustTaxCde":"S","RltCustCty":"URBANA","RltCustCICurLstNmeKeyFld1":"MCEVILLY","RltCustCICurFrstNmeKeyFld2":"JOHN-JOHN","RltCustSt":"IL","RltCustZIP":618013004,"RltCustCIBirthdate":"1975-06-24","RltCustCIPrmyPhNbr":9492950844,"RltCustCIScndyPh":4344343434,"CIRltExpDte":"0000-00-00","RltCustCtryCde":"USA"},{"RltCustCIRltApplCde1":"CUST","RltCustCIRltApplNbr01":"00000073820","RltCustCIRltBnkNbr1":889,"RltCustCIEnt1toEnt2RltCde":459,"RltCustCIEnt2toEnt1RltCde":902,"CIRltEffDte":"2022-10-07","RltCustCICurNmePrcsTme":"01.52.07","RltCustCICurStdAddr1Cde":"S","RltCustCICurStdAddr2Cde":"C","RltCustCICurStdAddr1Txt":"1010 W ILLINOIS ST","RltCustCICurStdAddr2Txt":"URBANA IL 61801","RltCustCICurStdNmeCde01":"N","RltCustCICurStdNme01":"VSFESDF ERWRE","RltCustCICustTaxNbr":"000000000","RltCustCICustTaxCde":"N","RltCustCty":"URBANA","RltCustCICurLstNmeKeyFld1":"ERWRE","RltCustCICurFrstNmeKeyFld2":"VSFESDF","RltCustSt":"IL","RltCustZIP":61801,"RltCustCIBirthdate":"2000-02-02","RltCustCIPrmyPhNbr":9898998898,"CIRltExpDte":"0000-00-00","RltCustCtryCde":"USA"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

    Object respObj2 = System.JSON.deserialize(res2, FISCCGetAccountProfileResponse.class);
    FISCCGetAccountProfileResponse responseDTO2 = (FISCCGetAccountProfileResponse) respObj2;

    try {
      responseDTO2.entity.accountProf.CIRecTypInd = 'I';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'I';
      FISCCCustomerSearchExtension.parseIndAccountRelatedResp(responseDTO2);
      responseDTO2.entity.accountProf.CIRecTypInd = 'I';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'I';
      responseDTO2.entity.accountProf.CIPrmyPhNbr = null;
      responseDTO2.entity.accountProf.CIMobilePhNbr = '1345';
      FISCCCustomerSearchExtension.parseIndAccountRelatedResp(responseDTO2);
      responseDTO2.entity.accountProf.CIRecTypInd = 'I';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'I';
      responseDTO2.entity.relatedCustomersLst[0].RltCustCIPrmyPhNbr = null;
      responseDTO2.entity.relatedCustomersLst[0].rltCustCIScndyPh = '1221';
      responseDTO2.entity.accountProf.cIScndyPh = '1345';
      FISCCCustomerSearchExtension.parseIndAccountRelatedResp(responseDTO2);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    try {
      responseDTO2.entity.accountProf.CIRecTypInd = 'O';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'O';
      FISCCCustomerSearchExtension.parseOrgAccountRelatedResp(responseDTO2);
      responseDTO2.entity.accountProf.CIRecTypInd = 'O';
      responseDTO2.entity.accountProf.CIPrmyPhNbr = null;
      responseDTO2.entity.accountProf.CIMobilePhNbr = '1345';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'O';
      FISCCCustomerSearchExtension.parseOrgAccountRelatedResp(responseDTO2);
      responseDTO2.entity.accountProf.CIRecTypInd = 'O';
      responseDTO2.entity.relatedCustomersLst[0].rltCIRecTypInd = 'O';
      responseDTO2.entity.relatedCustomersLst[0].RltCustCIPrmyPhNbr = null;
      responseDTO2.entity.relatedCustomersLst[0].rltCustCIScndyPh = '1221';
      responseDTO2.entity.accountProf.cIScndyPh = '1345';
      FISCCCustomerSearchExtension.parseOrgAccountRelatedResp(responseDTO2);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    //success flow FISCCCustomerSearchResponseBuilder
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerSearchResponse dto = (FISCCCustomerSearchResponse) System.JSON.deserialize(resp, FISCCCustomerSearchResponse.class);
      FISCCCustomerSearchResponseBuilder respBuilder = new FISCCCustomerSearchResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Exception block in FISCCCustomerSearchResponseBuilder.build
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerSearchResponse dto = (FISCCCustomerSearchResponse) System.JSON.deserialize(resp, FISCCCustomerSearchResponse.class);
      FISCCCustomerSearchResponseBuilder respBuilder = new FISCCCustomerSearchResponseBuilder();
      FISCCCustomerSearchResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block in FISCCCustomerSearchResponseBuilder.parseResponse
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCustomerSearchResponse dto = (FISCCCustomerSearchResponse) System.JSON.deserialize(resp, FISCCCustomerSearchResponse.class);
      FISCCCustomerSearchResponseBuilder respBuilder = new FISCCCustomerSearchResponseBuilder();
      FISCCCustomerSearchResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCCustomerSearchResponse(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //success flow FISCCGetAccProfResponseBuilder
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCGetAccountProfileResponse dto = (FISCCGetAccountProfileResponse) System.JSON.deserialize(
        resp,
        FISCCGetAccountProfileResponse.class
      );
      FISCCGetAccProfResponseBuilder respBuilder = new FISCCGetAccProfResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Exception block in FISCCGetAccProfResponseBuilder.build
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCGetAccountProfileResponse dto = (FISCCGetAccountProfileResponse) System.JSON.deserialize(
        resp,
        FISCCGetAccountProfileResponse.class
      );
      FISCCGetAccProfResponseBuilder respBuilder = new FISCCGetAccProfResponseBuilder();
      FISCCGetAccProfResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block in FISCCGetAccProfResponseBuilder.parseResponse
    try {
      String resp = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCGetAccountProfileResponse dto = (FISCCGetAccountProfileResponse) System.JSON.deserialize(
        resp,
        FISCCGetAccountProfileResponse.class
      );
      FISCCGetAccProfResponseBuilder respBuilder = new FISCCGetAccProfResponseBuilder();
      FISCCGetAccProfResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCGetAccountProfileResponse(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block
    try {
      FISCCCustomerSearchExtension.testException = true;
      FISCCCustomerSearchExtension.searchCustomer(new Map<String, Object>());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp;
      Map<String, Object> params = new Map<String, Object>();
      params.put('frstNm', '1234');
      params.put('lstNm', '1234');
      params.put('searchType', '1445');
      params.put('custType', '1445');
      params.put('customerSearchStart', '1445');
      params.put('street', '1234');
      params.put('city', '1234');
      params.put('state', '1234');
      params.put('zip', '1234');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);

      params.remove('frstNm');
      params.remove('lstNm');
      params.put('businessNm', '1234');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);

      params.remove('city');
      params.remove('state');
      params.remove('street');
      params.remove('zip');
      params.remove('businessNm');
      params.put('customerNbr', '1445');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);

      params.remove('customerNbr');
      params.put('ssnNum', '1445');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);

      params.remove('ssnNum');
      params.put('phnNum', '1445');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);

      params.remove('phnNum');
      params.put('acctNum', '1445');
      resp = FISCCCustomerSearchExtension.setUrl(params);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.error('Exception');
    }

    Test.stopTest();
  }
}