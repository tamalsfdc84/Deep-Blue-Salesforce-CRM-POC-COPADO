@isTest
global with sharing class FISAddBenefRelnMockTest implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"customer-account-relationshipsLst":[{"AcNbr2":"00000062996","E2ToE1RlCd":902,"E1ToE2RlCd":411},{"AcNbr2":"00000062997","E2ToE1RlCd":902,"E1ToE2RlCd":411},{"AcNbr2":"00000062998","E2ToE1RlCd":902,"E1ToE2RlCd":411}],"ca-maintained-account":{"ApCd1":"DP","ApNbr1":6882029}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}