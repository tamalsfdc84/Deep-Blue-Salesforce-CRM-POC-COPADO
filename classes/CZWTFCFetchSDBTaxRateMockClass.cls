global with sharing class CZWTFCFetchSDBTaxRateMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"branches-detail":{"Addr3":"ROSEMONT, IL 60018","StmtDeptCntc":"CUSTOMER SERVICE","Addr1":"WINTRUST TEST BANK","LNStmtDeptCntc":"LOAN OPERATION BRANCH 1","Addr2":"9801 W HIGGINS, BOX 32","LocalServChrgSalesTax":0,"CorspdtNbr":0,"TellerCashDrawerHighRng":0,"OdNotcDeptCntc":"CUSTOMER SERVICE","LNStmtTeleNbr":"847 842-4500","TeleNbr":"847 842-4500","DPEoyCntcTeleNbr2":4500,"DPEoyCntcTeleNbr1":842,"ShrtNme":"BARRINGTON B&T","OdNotcTeleNbr":"(847) 842-4500","EffDte":"02/22/22","FedResrvAba4":0,"FedResrvAba3":0,"FedResrvAba2":0,"FedResrvAba1":71925651,"RetDeptCntc":"PERSONAL BANKING","BnkWebSite":"www.barringtonbank.com","RetTeleNbr":"847 842-4500","LoansEoyCntcTeleNbr1":842,"StServChrgSalesTax":0,"CstCntr":8114,"BrchNbr":1,"PstlBarCdeInd":"Y","IntRatesTeleNbr":"847 842-4500","LoansEoyCntcTeleNbr2":4500,"SafeDPBoxSalesTaxPct":9,"StmtTeleNbr":"(847) 842-4500","TellerCashDrawerLowRng":0,"TellerInd":0,"DPEoyCntcTeleNbrAreaCde":847,"LoansEoyCntcTeleNbrAreaCde":847,"DelInd":0}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}