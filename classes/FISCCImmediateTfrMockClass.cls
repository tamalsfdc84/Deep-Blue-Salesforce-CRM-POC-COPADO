global with sharing class FISCCImmediateTfrMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    //response.setHeader('Content-Type', 'application/json');
    response.setBody(
      '{"Entity":{"immediate-transfers":{"FMLogTyp":"L","TxnSecurityInd":3,"FMTrsfrFromDPId":0,"FMTrsfrWithholdingTranAmt":0,"FMTrsfrToAcct":8666856,"FMTrsfrFromHSACde":0,"FMOvrideInfo":" ","FMTrsfrToHSACde":0,"FMTrsfrFromSys":"DP","FMTrsfrAmt":100,"FMTrsfrToDPId":0,"FMTrsfrFromRaCde":0,"FMTrsfrToSys":"DP","FMTrsfrDte":"2021-11-16","FMTrsfrCstCntrDr":8114,"FMTrsfrToRaCde":0,"FMTrsfrOfstCr":2006512,"FMTrsfrFromAcct":2095086,"FMTrsfrOfstDr":2006512,"FMTrsfrCstCntrCr":8114,"FMTrsfrWithholdingRaCde":0}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"DPOD043-TRANSACTION AMOUNT EXCEEDS ACCOUNTS CURRENT BALANCE.","Severity":"Info","Code":"D600043"},{"Type":"Informational Message","Text":"DPOD047-NO SIGNATURE CARD ON FILE.","Severity":"Info","Code":"D600047"},{"Type":"Informational Message","Text":"DPOD052-USER DEFINED STATUS CODE 2","Severity":"Info","Code":"D600052"},{"Type":"Informational Message","Text":"TRANSFER             PROCESSED      BY OVERRIDE      FINAL LOGGED","Severity":"Info","Code":"FM0"}]}}'
    );
    response.setStatusCode(200);
    return response;
  }
}