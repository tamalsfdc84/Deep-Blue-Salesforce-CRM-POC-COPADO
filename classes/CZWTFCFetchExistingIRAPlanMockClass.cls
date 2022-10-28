global with sharing class CZWTFCFetchExistingIRAPlanMockClass implements HttpCalloutMock {
  global CZWTFCFetchExistingIRAPlanMockClass() {
  }
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"customer-data":{"TaxNbr":"string","CustTaxId":"string","CustNme":"string","CustDOB":"string","CustDecdDte":"string","CustDeathCert":"string","CustNewTaxId":"string","CustLstMaintTmestmp":"string","CustLstMaintDte":"string","CustCurPlnBalTot":0,"CustYTDContributionsTot":0,"CustPRYRContributionsTot":0,"CustYTDDistrbutionsTot":0,"CustPRYRDistributionsTot":0,"NbrPln":0,"MorePages":"N","NextPageCursor":"string"},"customer-plan-dataLst":[{"CustPlnNbr":"string","CustPlnTyp":"string","CustPlnTypNme":"string","CustCurPlnBal":0,"CustYTDContributions":0,"CustPRYRContributions":0,"CustYTDDistrbutions":0,"CustPRYRDistributions":0}]},"Metadata":{"MsgLst":[{"Code":"string","Text":"string","Type":"System Error","Severity":"string"}]}}';
    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}