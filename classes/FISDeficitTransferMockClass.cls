global with sharing class FISDeficitTransferMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"deficit-transfers-new":{"FMDfctTrsfrSeqNbr":"001","FMMaintainedBal":0,"FMThrshldBal":0,"FMItmByItmTrsfr":"N","FMEndDte":"9999-12-31","FMStrtDte":"2021-10-13","FMDPSysReceivingAcctNbr":"00000000000004303445","RcvAcctSysCde":"DP","CalcPassMultBal":"N","FMTrsfrIncmt":0,"FMMinTrsfrAmt":0,"FMMinTrsfrTyp":"N","FMBalTyp":"A"},"deficit-transfers-sendersLst":[{"FMOverdrawBalTyp":"L","FMNotc":"N","FMOrd":1,"FMNoteNbrOrDPId":"0000000000","FMNotcServChrgTyp":"N","FMAcctNbr":1022032,"FMOverdrawInd":"A","FMFmsTyp":"000","FMSysCde":"DP","FMDfctTrsfrAvailBalToTeller":"N"}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}