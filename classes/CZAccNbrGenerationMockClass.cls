global with sharing class CZAccNbrGenerationMockClass implements HttpCalloutMock {
  global CZAccNbrGenerationMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"account_number":{"DPAcctTyp":803,"GenDPAcctNbr":72024674,"GenDPApplID":"DP","DPAcctBrnch":5}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}