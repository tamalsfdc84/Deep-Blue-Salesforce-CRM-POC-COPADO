/**
 * @description This is the Mock class for MX Get API token
 */
@isTest
global class CZWTFCMXGetAPITokenProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXGetAPITokenProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse =
      ' <?xml version="1.0" encoding="UTF-8"?>' +
      '<api_token>' +
      '<token>VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M=</token>' +
      '</api_token>';

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