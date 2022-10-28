global with sharing class CZMDMAuthMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"status":"String","prtyId":"String","customerInfo":{"frstNme":"String","mdlNme":"String","lstNme":"String","addrsLn1":"String","addrsLn2":"String","city":"String","stateCd":"String","zipCd":"String","county":"String","primPhNmb":"String","scndryPhNmb":"String","mblPhNmb":"String","psnlEmailId":"String","birthDte":"2021-06-22T06:31:41.701-05:00","idtfrLst":[{"idtfrTypCd":"String","idtfrNmb":"String","issueStateCd":"String","expDte":"09-24-2021","issueDte":"2021-06-22T06:31:41.701-05:00"}],"ssnNmb":"String","ctzshp":"String","occpCd":"String","emplyStatCd":"String","emplyTitle":"String","emplyNme":"String"},"customerRcdLst":[{"cisNmb":"String","chrtrCd":"String","cisStrtDte":"2021-06-22T06:31:41.701-05:00"}],"acctLst":[{"acctNmb":"String","chrtrCd":"String","acctCreationDte":"09-24-2021","acctCtgry":"String","pdtCd":"String","pdtNm":"String","acctTyp":"String","acctstatus":"String","ownrshpCd":"String","rltnshpCd":"String"}]}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}