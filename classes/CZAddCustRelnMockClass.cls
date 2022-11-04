global with sharing class CZAddCustRelnMockClass implements HttpCalloutMock {
  global CZAddCustRelnMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"cc-maintained-customer":{"CustNbr":"string"},"customer-customer-relationshipsLst":[{"RltCustNbr":"string","EffDte":"string","ExpDte":"string","E1toE2Cde":10,"E2toE1Cde":20,"RltPercentOwner":40,"RltBeneOwnr":"string","RltBeneTitle":"string","PriPercentOwner":50,"PriBeneOwnr":"string","PriBeneTitle":"string"}]}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}