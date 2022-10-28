/**
 * @description This is the Mock class for MX Check verification status call
 */
@isTest
global class CZWTFCMXCheckVerStatusProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXCheckVerStatusProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"member":{"aggregated_at":"2015-04-13T12:01:23-06:00","connection_status":"CONNECTED","connection_status_id":6,"connection_status_message":"Connected to Wells Fargo Bank","external_guid":null,"guid":"MBR-7aa13bdb-2866-ba38-b326-d9fb32268f9b","institution_guid":"INS-33a533a9-9ead-540c-d17d-bdc92c96be17","is_being_aggregated":false,"is_managed_by_user":true,"is_manual":false,"is_user_created":true,"metadata":"Additional information","most_recent_job_guid":"JOB-cc7ac3f1-351a-667f-be7c-93a484df6ebf","name":"Wells Fargo Bank","needs_updated_credentials":false,"revision":42,"successfully_aggregated_at":"2015-04-13T12:01:23-06:00","user_guid":"USR-d2219ed6-7d5d-2fad-c332-17fb9bafcefa"}}';

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