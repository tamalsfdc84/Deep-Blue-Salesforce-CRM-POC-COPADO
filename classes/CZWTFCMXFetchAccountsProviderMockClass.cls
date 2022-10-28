/**
 * @description This is the Mock class for MX Fetch accounts Call
 */
@isTest
global class CZWTFCMXFetchAccountsProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXFetchAccountsProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"account_numbers":[{"guid":"ACN-af481a37-8600-4c56-8751-2d6b7f1409b3","user_guid":"USR-681bfb32-7acb-4918-8d81-a792cd26003b","member_guid":"MBR-5c34705d-4bab-492c-8c0b-be6025738e3a","account_guid":"ACT-5b234820-05a9-4ecf-ac15-655830378356","account_number":"7395421551","routing_number":"61100606","transit_number":null,"institution_number":null},{"guid":"ACN-266bb6da-0e12-44bc-976b-599641f0e154","user_guid":"USR-681bfb32-7acb-4918-8d81-a792cd26003b","member_guid":"MBR-5c34705d-4bab-492c-8c0b-be6025738e3a","account_guid":"ACT-2466fa24-ccf1-4cd4-8442-61f30af3ab3c","account_number":"7880500311","routing_number":"61100606","transit_number":null,"institution_number":null}]}';

    String errResponse = '{"error":{"code":null,"message":"That id is already in use, please use a unique id."}}';

    HttpResponse res = new HttpResponse();
    if (endPoint.equals('FaultCode')) {
      res.setBody(errResponse);
      res.setStatusCode(500);
    } else if (endPoint.equals('testSuccess')) {
      res.setBody(validResponse);
      res.setStatusCode(200);
    }
    return res;
  }
}