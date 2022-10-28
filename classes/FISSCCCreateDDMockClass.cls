global with sharing class FISSCCCreateDDMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"due-diligence-demographics":{"OccpnDesc":26,"CustNbr":"00000063254","FullTime":"U","InqUpdtInd":"U"},"incoming-countriesLst":[],"outgoing-countriesLst":[]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}