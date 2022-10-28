/**
 * @description This is the Mock class for E-Statement Registration call
 */
@isTest
global class FISCCEstmtRegistrationMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"keywordsLst":[{"DPKywrdCde":"PAPERF","DPOrgNbr":889,"DPKywrdOldVal":"N","DPAcctNbr":1775283,"DPKywrdVal":"N","DPKywrdAlertMsg":"PAPERF=N & BULKFL NOT T, STMT ENCL SORT ERROR MAY OCCUR","DPOrgNme":"WITS TRAINING","DPKywrdNewLitTxt":"NEW","DPKywrdOldLitTxt":"OLD"},{"DPKywrdCde":"ELECTF","DPOrgNbr":889,"DPKywrdOldVal":"Y","DPAcctNbr":1775283,"DPKywrdVal":"Y","DPOrgNme":"WITS TRAINING","DPKywrdNewLitTxt":"NEW","DPKywrdOldLitTxt":"OLD"}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}