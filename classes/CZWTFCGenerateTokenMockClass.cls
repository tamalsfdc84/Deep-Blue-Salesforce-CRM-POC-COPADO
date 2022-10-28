@isTest
global with sharing class CZWTFCGenerateTokenMockClass implements HttpCalloutMock {
  global CZWTFCGenerateTokenMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:ns=\'urn:xtk:session\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><LogonResponse xmlns=\'urn:xtk:session\' SOAP-ENV:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'><pstrSessionToken xsi:type=\'xsd:string\'>___ebfa4df7-e73e-46b3-8e22-968e56040070</pstrSessionToken></LogonResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(500);

    return res;
  }
}