@isTest
global with sharing class CZWTFCOLBEnrollmentCheckTokenMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCOLBEnrollmentCheckTokenMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String successToken = '{"access_token": "mhrjRAhBwdwB24lsN7pJiyMhz57v","token_type": "Bearer","expires_in": 119}';
    String failureToken400 = '{"error": "Bad request"}';
    String failureMessageToken400 = '{"errorMessage": "Bad request"}';
    String failureToken405 = '{"error": "The method specified in the Request-Line is not allowed for the resource identified by the Request-URI"}';
    String failureMessageToken405 = '{"errorMessage": "The method specified in the Request-Line is not allowed for the resource identified by the Request-URI"}';
    String failureToken404 = '{"error": "Requested resource is not found"}';
    String failureMessageToken404 = '{"errorMessage": "Requested resource is not found"}';
    String failureToken408 = '{"error": "Request timeout occurred while processing a message. Please contact support"}';
    String failureMessageToken408 = '{"errorMessage": "Request timeout occurred while processing a message. Please contact support"}';
    String failureToken500 = '{"error": "Internal server error"}';
    String failureMessageToken500 = '{"errorMessage": "Internal server error"}';
    // String failureEmpty = '{}';
    String failureEmpty = '{"error": "","errorMessage": ""}';

    String successAuth = '{"fis_cust_id": "123456","org_id":"889","is_olb_enrolled": true}';
    String failureAuth400 = '{"error": "Bad request"}';
    String failureMessageAuth400 = '{"errorMessage": "Bad request"}';
    String failureAuth401 = '{"error": "Token has been revoked."}';
    String failureMessageAuth401 = '{"errorMessage": "Token has been revoked."}';
    String failureAuth405 = '{"error": "The method specified in the Request-Line is not allowed for the resource identified by the Request-URI"}';
    String failureMessageAuth405 = '{"errorMessage": "The method specified in the Request-Line is not allowed for the resource identified by the Request-URI"}';
    String failureAuth404 = '{"error": "Requested resource is not found"}';
    String failureMessageAuth404 = '{"errorMessage": "Requested resource is not found"}';
    String failureAuth408 = '{"error": "Request timeout occurred while processing a message. Please contact support"}';
    String failureMessageAuth408 = '{"errorMessage": "Request timeout occurred while processing a message. Please contact support"}';
    String failureAuth500 = '{"error": "Unable to fulfill request due to invalid input parameters"}';
    String failureMessageAuth500 = '{"errorMessage": "Unable to fulfill request due to invalid input parameters"}';

    String success = '{"fis_cust_id": "123456","org_id":"889","is_olb_enrolled": true}';
    String failure = '{"fis_cust_id": "123456","org_id":"889","is_olb_enrolled": false}';
    String exceptionCase = '{"error": "No records has been found with the provided 123456 and 889."}';

    HttpResponse res = new HttpResponse();
    if (endPoint.equals('successToken')) {
      res.setBody(successToken);
      res.setStatusCode(200);
    } else if (endPoint.equals('failureToken400')) {
      res.setBody(failureToken400);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureMessageToken400')) {
      res.setBody(failureMessageToken400);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureToken400_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureToken405')) {
      res.setBody(failureToken405);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureMessageToken405')) {
      res.setBody(failureMessageToken405);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureToken405_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureToken404')) {
      res.setBody(failureToken404);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureMessageToken404')) {
      res.setBody(failureMessageToken404);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureToken404_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureToken408')) {
      res.setBody(failureToken408);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureMessageToken408')) {
      res.setBody(failureMessageToken408);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureToken408_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureToken500')) {
      res.setBody(failureToken500);
      res.setStatusCode(500);
    } else if (endPoint.equals('failureMessageToken500')) {
      res.setBody(failureMessageToken408);
      res.setStatusCode(500);
    } else if (endPoint.equals('failureToken500_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(500);
    } else if (endPoint.equals('successAuth')) {
      res.setBody(successAuth);
      res.setStatusCode(200);
    } else if (endPoint.equals('failureAuth400')) {
      res.setBody(failureAuth400);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureMessageAuth400')) {
      res.setBody(failureMessageAuth400);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureAuth400_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(400);
    } else if (endPoint.equals('failureAuth401')) {
      res.setBody(failureAuth401);
      res.setStatusCode(401);
    } else if (endPoint.equals('failureMessageAuth401')) {
      res.setBody(failureMessageAuth401);
      res.setStatusCode(401);
    } else if (endPoint.equals('failureAuth401_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(401);
    } else if (endPoint.equals('failureAuth405')) {
      res.setBody(failureAuth405);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureMessageAuth405')) {
      res.setBody(failureMessageAuth405);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureAuth405_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(405);
    } else if (endPoint.equals('failureAuth404')) {
      res.setBody(failureAuth404);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureMessageAuth404')) {
      res.setBody(failureMessageAuth404);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureAuth404_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(404);
    } else if (endPoint.equals('failureAuth408')) {
      res.setBody(failureAuth408);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureMessageAuth408')) {
      res.setBody(failureMessageAuth408);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureAuth408_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(408);
    } else if (endPoint.equals('failureAuth500')) {
      res.setBody(failureAuth500);
      res.setStatusCode(500);
    } else if (endPoint.equals('failureMessageAuth500')) {
      res.setBody(failureMessageAuth500);
      res.setStatusCode(500);
    } else if (endPoint.equals('failureAuth500_EMPTY')) {
      res.setBody(failureEmpty);
      res.setStatusCode(500);
    } else if (endPoint.equals('success')) {
      res.setBody(success);
      res.setStatusCode(200);
    } else if (endPoint.equals('failure')) {
      res.setBody(failure);
      res.setStatusCode(200);
    } else if (endPoint.equals('exceptionCase')) {
      res.setBody(exceptionCase);
      res.setStatusCode(500);
    }
    return res;
  }
}