global with sharing class FISPasswordChangeMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"racf-password":{"NewPwd":"********"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"00000-OK","Severity":"Info","Code":"SZ00000"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}