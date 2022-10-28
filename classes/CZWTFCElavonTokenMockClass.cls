global with sharing class CZWTFCElavonTokenMockClass implements HttpCalloutMock {
  global CZWTFCElavonTokenMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"data":{"StatusCode":200,"SessionToken":"zT+AL8dWSMyg+ZiuIivoQQAAAXyT+gl9"}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(500);

    return res;
  }
}