/**
 * @description This is the Mock class for MX Open nexus token
 */
@isTest
global class CZWTFCMXOpenNexusProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXOpenNexusProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"session":{"token":"de2uS4jEwSYN7W0eoF_ZiLJQ7rtQaDbA9NkCZr_U4gujctbMw_WZYz7u6q3NMDlTYYCSSR7O3ec1fOP2wArN0g"}}';

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