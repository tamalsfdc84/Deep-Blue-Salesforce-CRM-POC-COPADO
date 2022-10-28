/**
 * @description This is the Mock class for CEBEnroll call
 */
@isTest
global class FISCCCEBEnrollmentProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public FISCCCEBEnrollmentProviderMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{ "Metadata": { "MsgLst": [{ "Type": "Informational Message", "Text": "Success", "Severity": "Info", "Code": 0 } ] }, "Enrollment": { "BankInfo": { "feId": 311 }, "EnrollmentPendingIndicator": false } }';

    String errResponse = '{ "Metadata": { "MsgLst": [ { "Type": "Application Error","Text": "Customer not found", "Severity": "Error", "Code": "-9142" }, { "Type": "Application Error", "Text": "Name not found", "Severity": "Error", "Code": "-9310" } ] }, "Enrollment": { "BankInfo": { "feId": 311 }, "EnrollmentPendingIndicator": false } }';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}