/**
 * @description This is the Mock class for MX  Create  User  API Call
 */
@isTest
global class CZWTFCMXCreateUserProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXCreateUserProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"user":{"id":"a1C2f000006USS1EA3","birthdate":"1992-07-02","gender":"FEMALE","logged_in_at":null,"credit_score":718,"email":"sayli.sawant@terafinainc.com","first_name":"Sayli","guid":"USR-f89d239a-29ce-4c50-bc81-9d06e2146d47","is_disabled":false,"last_name":"Sawant","metadata":"Additional Information","phone":"15055551234","zip_code":"87101"}}';

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