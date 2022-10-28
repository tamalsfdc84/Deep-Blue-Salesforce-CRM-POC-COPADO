/**
 * @description This is the Mock class for CardGeneration call
 */
@isTest
global class FISCCDebitCardNoGenMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Metadata":{"MsgLst":[{"Text":"Success","Severity":"Info","Type":"Informational Message","Code":"0"}]},"Entity":{"card-number":{"CBInstnNbr":"00840","CBCrdPrfxNbr":131312,"CBCrdNbr":1313120001182589}}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}