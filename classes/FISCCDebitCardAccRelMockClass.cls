/**
 * @description This is the Mock class for card to AccRelation call
 */
@isTest
global class FISCCDebitCardAccRelMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"accounts":{"BnkNbr":547,"NmeAddrLne01":"TEST CUSTOMER","NmeAddrLne03":"APPLETON WI 54911","AcctNbr":6521331265,"NmeAddrLne02":"321 MAIN AVE","ApplCde":"DP","CIRmrkOrigSrcInd":"U","CIRmrkEffTme":"00.00.00","RmrkEffDte":"0000-00-00","CINmeAddrLneCde01":"N","CIRltApplNbr01":156077,"RmrkPermTempInd":"P","CIRmrkPrcsTme":"00.00.00","CINmeAddrLneCde03":"C","CINmeAddrLneCde02":"S","PriSecRltCde01":"P","RmrkExpDte":"0000-00-00","CIEnt1ToEnt2RltCde":"000"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}