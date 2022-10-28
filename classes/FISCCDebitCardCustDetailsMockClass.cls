/**
 * @description This is the Mock class for CardCustDemographics call
 */
@isTest
global class FISCCDebitCardCustDetailsMockClass implements HttpCalloutMock {
  private String endPoint = '';
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"cards-cardholder-address":{"InstnNbr":"00547","CrdNbr":4411090000000089,"ShrtNmeLst":"GEORGE","StrAddrLne2":"2ND FLOOR","CrdNmeLne2":"JP","StrAddrLne1":"55 N BROWN","ShrtNmeFrst":"JOHN","ZipCde":53223,"CrdStatCde":1,"CtyNme":"MILWAUKEE","StAbbr":"WI","CrdNmeLne1":"JOHN GEORGE","CtryCde":"USA"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}