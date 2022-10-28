/**
 * @description This is the Mock class for CardCustDemographics call
 */
@isTest
global class FISCCDebitCardExpediteShippingMockClass implements HttpCalloutMock {
  private String endPoint = '';
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"reissue-pinless-card-data":{"CrdNbr":"00547"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}