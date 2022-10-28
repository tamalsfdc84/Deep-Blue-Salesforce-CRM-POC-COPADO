global with sharing class CZCustomerAliasMockClass implements HttpCalloutMock {
  global CZCustomerAliasMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"customer-alias-new":{"NmeAddrStandOvrideInd":"Y","CustNbr":"00000069208","AlNme":"BATMANNN","AlPrcsTme":"05:19:22"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}