/**
 * @description This is the Mock class for MX SSO API Call
 */
@isTest
global class CZWTFCMXSSOAPIProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  global CZWTFCMXSSOAPIProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse =
      '<?xml version="1.0" encoding="UTF-8"?>' +
      '<url>' +
      '<url>https://int-widgets.moneydesktop.com/md/connect/xfcgtnhp6wb0yvg1yp234fhw53Zbt4879mzfsg3t7g186wpl0g0b1dqfrkbnbpmc6fprf9wkqAsgwvlk89hzA442lvwt435n0zhl8cz7nldgAzhwqxfAn3yxA5qgwl7sbnhhzf41w57zr932r2t5czA6dn7ryms27rt0r2ych30tyvq42gm6bcA6qx000gA8g6y6lgbptqdkfz1l00wlmAgzl670rtk757mzp3j7f0c8bAn76tgvmvfd3d3svm9rhj8z2h738hk679v6lm0bw3gbn18n0plyn45nhxwj8v5717ngw2xcs25ngppkfdkmmz156k0k7527nykq341qkljqllff7bx8nb7qAwfy/eyJpc19tb2JpbGVfd2VidmlldyI6InRydWUiLCJtb2RlIjoidmVyaWZpY2F0aW9uIn0%3D</url>' +
      '<type>connect_widget</type>' +
      '<user_id>a1C2f000006USS1EA3</user_id>' +
      ' </url>';

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