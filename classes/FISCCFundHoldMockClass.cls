global with sharing class FISCCFundHoldMockClass implements HttpCalloutMock {
  global FISCCFundHoldMockClass() {
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"holds":{"DPHldDelInd":"N","DPAcctNbr":8144724,"DPHldTyp":1,"DPHldExpireDte":"2021-04-14","DPHldAmt":100,"DPHldDesc":"DESC","DPHldIdNbr":1}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}