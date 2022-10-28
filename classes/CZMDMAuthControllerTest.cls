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
      CZWTFCAuthenticationController.authenticateParty(ctx, params);
    } catch (Exception ex) {
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
    }

    CZWTFCAuthenticationService.generateRespDTO(params, 'ind-2');
    CZWTFCAuthenticationService.generateRespDTO(params, 'ind-3');

    try {
      new CZWTFCAuthenticationController(controller);
      CZWTFCAuthenticationController.authenticateParty(ctx, new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCAuthenticationService.testException = true;
      CZWTFCAuthenticationService.verifyUser(params);
    } catch (Exception ex) {
    }
    try {
      CZWTFCAuthenticationService.testException = true;
      CZWTFCAuthenticationService.generateRespDTO(params, '');
    } catch (Exception ex) {
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
    }

    CZMDMAuthenticationResponseDTO dto = new CZMDMAuthenticationResponseDTO();
    Test.stopTest();
  }
}