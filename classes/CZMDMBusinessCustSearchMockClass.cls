global with sharing class CZMDMBusinessCustSearchMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"totalRecords":4,"totalPages":0,"status":"success","pageSize":10,"pageNumber":1,"organizationInfo":[{"zip5Cd":"60616","zip4Cd":"3717","taxId":"3434","state":"ILLINOIS","phoneNumber":"4343443434","orgNm":"SDDS","mdmPartyId":"7220226","countryNm":"United States of America","countryCd":"USA","city":"CHICAGO","address1":"10 W 35TH ST"},{"zip5Cd":"60137","zip4Cd":"3712","taxId":"","state":"ILLINOIS","phoneNumber":"6308584396","orgNm":"SDDS INC","mdmPartyId":"215884","countryNm":"United States of America","countryCd":"USA","city":"GLEN ELLYN","address1":"312 GENEVA RD"},{"zip5Cd":"06471","zip4Cd":"1000","taxId":"","state":"CONNECTICUT","phoneNumber":"2034849793","orgNm":"SDDS SERVICES LLC","mdmPartyId":"2936570","countryNm":"United States of America","countryCd":"USA","city":"NORTH BRANFORD","address1":"1 FOXON RD"},{"zip5Cd":"06471","zip4Cd":"1000","taxId":"","state":"CONNECTICUT","phoneNumber":"2034849793","orgNm":"SDDS SERVICES LLC","mdmPartyId":"3465479","countryNm":"United States of America","countryCd":"USA","city":"NORTH BRANFORD","address1":"1 FOXON RD"}],"firstRecord":1}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}