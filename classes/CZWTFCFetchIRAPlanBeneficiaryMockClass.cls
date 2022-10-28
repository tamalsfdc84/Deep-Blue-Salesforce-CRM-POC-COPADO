global with sharing class CZWTFCFetchIRAPlanBeneficiaryMockClass implements HttpCalloutMock {
  global CZWTFCFetchIRAPlanBeneficiaryMockClass() {
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"plan-beneficiaries":{"PlnNbr":"string"},"plan-beneficiaries-dataLst":[{"Nme":"string"}]},"Metadata":{"MsgLst":[{"Code":"string","Text":"string","Type":"System Error","Severity":"string"}]}}';
    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}