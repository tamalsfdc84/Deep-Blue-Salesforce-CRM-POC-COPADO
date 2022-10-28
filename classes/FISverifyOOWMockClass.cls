global with sharing class FISverifyOOWMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"base":4,"decision":"Fail","idaOid":"2148340393","idaQuiz":null,"score":1,"userReferenceText1":null,"userReferenceText2":null,"userReferenceText3":null}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}