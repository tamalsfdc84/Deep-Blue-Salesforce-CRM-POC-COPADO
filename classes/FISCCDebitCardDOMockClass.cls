/**
 * @description This is the Mock class for CardCustDemographics call
 */
@isTest
global class FISCCDebitCardDOMockClass implements HttpCalloutMock {
  private String endPoint = '';
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"Deposit-OriginationLst":[{"SvcID":"CB100","card-new":{"CBExpDte":"2026-03-31","OptInSrcInd":"R","CBCrdAddrFIConfigInd":"N","CBCtyNme":"AS","CBCrdStatCde":7,"CBInstnNbr":"00889","CBPinOfst":"0000","CBPrmyDdaAcctNbr":8185873,"CBPrmySsn":"000000984","CBCrdNmeLne1":"DORA A EXPLORER","CBZIP":57421,"CBShrtNmeLst":"EXPLORER","CBShrtNmeFrst":"DORA","CBBrnchNbr":1,"CBCrdPrfxNbr":99519841,"CBStrAddrLne1":"LINE 1","CustNbr":"00000065881","CBStrAddrLne2":"LINE 2","CBCrdNbr":9951984100003131,"CBStAbbr":"IL","NmeEmbossOnCard":"DORA A EXPLORER","CtryCde":"USA"}},{"SvcID":"CI009","customer-accounts":{"BnkNbr":889,"NmeAddrLne01":"DORA A EXPLORER","NmeAddrLne03":"CHICAGO IL 60606","AcctNbr":9951984100003131,"NmeAddrLne02":"15523 HERO","ApplCde":"CBM","CIRmrkOrigSrcInd":"U","CIRmrkEffTme":"00.00.00","RmrkEffDte":"0000-00-00","CINmeAddrLneCde01":"N","CIRltApplNbr01":"00000065881","RmrkPermTempInd":"P","CIRmrkPrcsTme":"00.00.00","CINmeAddrLneCde03":"C","CINmeAddrLneCde02":"S","PriSecRltCde01":"P","RmrkExpDte":"0000-00-00","CIEnt1ToEnt2RltCde":"000","NAStandardizationOvride":"Y"}}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}