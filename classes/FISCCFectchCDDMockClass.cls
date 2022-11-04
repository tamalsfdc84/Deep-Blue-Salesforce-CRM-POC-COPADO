global with sharing class FISCCFectchCDDMockClass implements HttpCalloutMock {
  global FISCCFectchCDDMockClass() {
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"due-diligence-demographics":{"CustNbr":"00000071562","CustType":"O","LstMaintOper":"C889995","LstMaintDte":"2022-06-30","NbrOfDp":56,"TotDpAmt":7,"NbrCashDp":1,"CashDpAmt":2,"NbrOfCashWthdrwl":3,"CashWthdrwlAmt":4,"NbrOfChkWritn":8,"CkAmtWritn":9,"AntWireAct":"N","UsrDefFld21":"N","UsrDefFld22":"N","UsrDefFld27":"N"},"incoming-countries":null,"outgoing-countries":null},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}