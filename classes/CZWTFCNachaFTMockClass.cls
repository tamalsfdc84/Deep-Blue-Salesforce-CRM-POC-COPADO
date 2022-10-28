/**
 * @description This is the Mock class for Nacha File transfer API call
 */
@isTest
global class CZWTFCNachaFTMockClass implements HttpCalloutMock {
  private Integer decparam;
  global CZWTFCNachaFTMockClass(Integer decparam) {
    this.decparam = decparam;
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"message": "File uploaded successfully." }';
    HttpResponse res = new HttpResponse();
    if (decparam == 200) {
      res.setStatusCode(200);
      res.setBody(validResponse);
    } else if (decparam == 500) {
      String errResponse = '{"error_message": "Missing file attachment / More than 1 file attached.", "error_code": "500","correlation_id": "000000-0000000-00000000-0000000-000000" }';
      res.setStatusCode(500);
      res.setBody(errResponse);
    } else if (decparam == 400) {
      String errResponse = '{"error_message": "Bad request", "error_code": "400","correlation_id": "000000-0000000-00000000-0000000-000000" }';
      res.setStatusCode(400);
      res.setBody(errResponse);
    } else if (decparam == 401) {
      String errResponse = '{"error_message": "Invalid or null access token", "error_code": "401","correlation_id": "000000-0000000-00000000-0000000-000000" }';
      res.setStatusCode(401);
      res.setBody(errResponse);
    } else if (decparam == 404) {
      String errResponse = '{"error_message": "Requested resource is not found", "error_code": "404","correlation_id": "000000-0000000-00000000-0000000-000000" }';
      res.setStatusCode(404);
      res.setBody(errResponse);
    } else if (decparam == 1) {
      CalloutException e = (CalloutException) CalloutException.class.newInstance();
      e.setMessage('Exception in Nacha API call!!');
      throw e;
    }
    return res;
  }
}