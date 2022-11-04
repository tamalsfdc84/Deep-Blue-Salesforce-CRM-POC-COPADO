@isTest
global class FISCCMultiAccDebitCardCreationMockClass implements HttpCalloutMock {
  private String endPoint = '';

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"multiple-accounts-parameters":{"InstnNbr":"string","CrdNbr":"string","CrdStat":"string"},"multiple-accounts-newLst":[{"AcctTyp":"string","AcctNbr":0,"AcctStat":"string","AcctDesc":"string","NoteNbr":0}]},"Metadata":{"MsgLst":[{"Type":"System Error","Text":"string","Severity":"string","Code":"string"}]}}';

    HttpResponse res = new HttpResponse();
    res.setBody(validResponse);
    res.setStatusCode(200);
    res.setStatus('Success');
    return res;
  }
}