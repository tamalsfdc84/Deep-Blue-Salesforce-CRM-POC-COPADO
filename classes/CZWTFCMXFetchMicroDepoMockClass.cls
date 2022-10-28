global with sharing class CZWTFCMXFetchMicroDepoMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"account_verifications":[{"account_name":"Checking (...6789)","account_number":"123456789","account_number_guid":null,"account_type":1,"account_type_name":"CHECKING","created_at":"2021-05-05T17:55:54+00:00","member_guid":null,"micro_deposit_guid":"MIC-02b39978-060d-4154-8acd-a81f9086b89e","micro_deposit_status":0,"micro_deposit_status_name":"INITIATED","routing_number":"222222226","updated_at":"2021-05-05T17:55:56+00:00","verification_method":1,"verification_method_name":"MICRO_DEPOSIT"}]}';

    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}