global with sharing class CZDeluxeMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"online-dollar-transaction":{"DPRetAcctWithholdingAmt":0,"TxnSecurityInd":2,"DPTxnCde":115,"DPAcctNbr":4337878,"DPTxnSrcCde":527,"GLBranch":0,"DPCat":"M","DPLogTyp":"L","GLAcctType":0,"DPGLAcctNbr":2006512,"DPRetAcctWithholdingTxnCde":0,"DPDolrTxnOrigTxnCde":0,"DPHiddenSrcCde":527,"DPGLCstCntr":8114,"ShrtNme":"KCHECK LAPTOP","DPDolrSrlNbr":0,"DPDolrTxnAmt":50,"DPTxnCntlNbr":994000524075857}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"DPOD052-USER DEFINED STATUS CODE 2","Severity":"Info","Code":"D600052"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    req.setHeader('headerKey', 'https://google.com');
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}