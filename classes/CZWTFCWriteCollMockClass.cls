/**
 * @description This is the Mock class for adobe campaign write collection api
 */
@isTest
global with sharing class CZWTFCWriteCollMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global CZWTFCWriteCollMockClass(String endPoint) {
    this.endPoint = endPoint;
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:ns=\'urn:wpp:default\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><WriteResponse xmlns=\'urn:wpp:default\' SOAP-ENV:encodingStyle=\'http://schemas.xmlsoap.org/soap/encoding/\'></WriteResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    String errResponse = '<?xml version=\'1.0\'?><SOAP-ENV:Envelope xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:SOAP-ENV=\'http://schemas.xmlsoap.org/soap/envelope/\'><SOAP-ENV:Body><SOAP-ENV:Fault><faultcode>SOAP-ENV:Server</faultcode><faultstring xsi:type=\'xsd:string\'>SOP-330011 Error while executing the method \'Write\' of service \'xtk:persist\'.</faultstring><detail xsi:type=\'xsd:string\'>PGS-220000 PostgreSQL error: ERROR:  duplicate key value violates unique constraint "tffaterafinasubmission_id"</detail></SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>';

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