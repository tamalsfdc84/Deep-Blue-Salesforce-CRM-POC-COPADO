global with sharing class CZInquireCustRelnMockClass implements HttpCalloutMock {
  global CZInquireCustRelnMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"query-parameters-customer-customer-relationships":{"CustNbr":"00000071404","CIMoreToBeReturnedInd":"N","CINbrCustRltRtrn":2},"customer-customer-relationships-dataLst":[{"CIRltCusttApplCde":"CUST","RltCustNbr":"00000071405","CIRltCustBnkNbr":889,"EffDte":"2022-06-20","ExpDte":"0000-00-00","E1toE2Cde":101,"E2toE1Cde":201,"RltPercentOwner":50.00,"CIPrspctInd":"C","CICurStdNme1":"PRADEEP SIGNER JR","CIRltCustLstNme":"SIGNER","CIRltCustFrstNme":"PRADEEP","RltBeneTitle":"A","PriPercentOwner":0.00},{"CIRltCusttApplCde":"CUST","RltCustNbr":"00000071406","CIRltCustBnkNbr":889,"EffDte":"2022-06-20","ExpDte":"0000-00-00","E1toE2Cde":103,"E2toE1Cde":203,"RltPercentOwner":50.00,"CIPrspctInd":"C","CICurStdNme1":"PRADEEP OWNER SR","CIRltCustLstNme":"OWNER","CIRltCustFrstNme":"PRADEEP","RltBeneTitle":"CEO","PriPercentOwner":0.00}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}