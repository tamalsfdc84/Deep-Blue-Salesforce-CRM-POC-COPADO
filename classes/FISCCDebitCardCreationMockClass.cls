/**
 * @description This is the Mock class for cardCreation call
 */
@isTest
global class FISCCDebitCardCreationMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"card-new":{"CBCrdNbr":"4411250000001000","CBInstnNbr":"547","CBCrdPrfxNbr":"441125"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}