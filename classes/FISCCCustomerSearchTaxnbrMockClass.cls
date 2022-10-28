@isTest
global inherited sharing class FISCCCustomerSearchTaxnbrMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public FISCCCustomerSearchTaxnbrMockClass() {
  }
  public FISCCCustomerSearchTaxnbrMockClass(String endPoint) {
    this.endPoint = endPoint;
  }
  global HttpResponse respond(HttpRequest req) {
    String success = '{"Entity": {"control-data": {"CIMoreToBeReturnedInd": "N","CIKeySSN": "333001234","CICustNbrToStrtSearch": "00000088844","CIRequestedResTimes": 3},"customersLst": [{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "1 WESTERN WAY","CICurStdAddr2Txt": "MILWAUKEE WI 53224","CICurStdNmeCde01": "N","CICurStdNme01": "MR Test Data","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000003818","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2005-02-22","CICurNmePrcsTme": "13.20.23","MktAreaPrcVal": 90,"ElmntLstNme": "MELLEN","ElmntFrstNme": "JESSE","ElmntHouseNbr": "1","ElmntOddEvenInd": "1","ElmntStreet": "WESTERN WAY","ElmntCity": "MILWAUKEE","ElmntState": "WI","ElmntZip": "53224","CIPrspctInd": "C","CIBirthdate": "1920-01-01","CIDrvrLic": "WI","CICustTaxCde": "S","CISncDte": "1988-06-01","SurNme": "MELLEN","CIRecTypInd": "M","CITtl": "MR","CIFrstNmeMidInitl": "JESSE"},{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "123 TESTING ST","CICurStdAddr2Txt": "MILWAUKEE WI 53222","CICurStdNmeCde01": "N","CICurStdNme01": "TEST ACCOUNTSS","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000079674","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2008-02-20","CICurNmePrcsTme": "12.50.25","MktAreaPrcVal": 90,"ElmntLstNme": "ACCOUNTSS","ElmntFrstNme": "TEST","ElmntHouseNbr": "123","ElmntOddEvenInd": "1","ElmntStreet": "TESTING ST","ElmntCity": "MILWAUKEE","ElmntState": "WI","ElmntZip": "53222","CIPrspctInd": "C","CICustTaxCde": "S","CISncDte": "2008-02-20","CtryCde": "USA","SurNme": "ACCOUNTSS","CIFrstNmeMidInitl": "TEST"},{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "777 REGDD DR","CICurStdAddr2Txt": "ANYTOWN WI 53222","CICurStdNmeCde01": "N","CICurStdNme01": "REGDD CUSTOMER","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000088844","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2009-10-09","CICurNmePrcsTme": "13.39.01","MktAreaPrcVal": 90,"ElmntLstNme": "CUSTOMER","ElmntFrstNme": "REGDD","ElmntHouseNbr": "777","ElmntOddEvenInd": "1","ElmntStreet": "REGDD DR","ElmntCity": "ANYTOWN","ElmntState": "WI","ElmntZip": "53222","CIPrspctInd": "C","CICustTaxCde": "S","CISncDte": "2009-10-09","CtryCde": "USA","SurNme": "CUSTOMER","CIFrstNmeMidInitl": "REGDD"}]},"Metadata": {"MsgLst": [{"Type": "Informational Message","Code": "0","Text": "Success","Severity": "Info"}]}}';
    String successToken = '{"access_token":"4f5282f0-4312-3aee-bf8f-6c271b33fe88","scope":"am_application_scope default","token_type":"Bearer","expires_in":3600}';
    String success_createCustomer = '{"Entity": {"customer": {"ZIP": 53224,"CINmeAddrLne01": "PETER T HAINES","St": "WI","CISinceDte": "2017-12-05","CICurStdAddr1Cde": "S","CIFrstNmeMidInitl": "PETER T","CINmeAddrLne02": "107 STREET","CINmeAddrLne03": "MIKWAUKEE WI 53224","CIScndyPhNbr": "0000000000","Cty": "MIKWAUKEE","CIBirthdate": "0000-00-00","Str": "107 ST","AddrOvrideInd": "N","CINmeAddrLneCde01": "N","PrspctInd": "C","CINmeAddrLneCde03": "C","CINmeAddrLneCde02": "S","CICustBnkNbr": 547,"CICurStdAddr1Txt": "107 ST","CICurMidNmeKeyFld3": "T","CICustTaxNbr": "000000000","CIW8Dte": "0000-00-00","OddEven": 2,"CIPrmyPhNbr": 2624088765,"CtryCde": "USA","CIRmrkEffDte": "0000-00-00","CICurStdAddr2Cde": "C","CICurStdNmeCde01": "N","CICurLstNmeKeyFld1": "HAINES","CICustTaxCde": "N","CIFaxPhNbr": "0000000000","CIMobilePhNbr": "0000000000","CICustEmploymentDte": "0000-00-00","CICurFrstNmeKeyFld2": "PETER","CICurStdNme01": "PETER T HAINES","CICustNbr": "00000157091","CICurStdAddr2Txt": "MIKWAUKEE WI 53224","CIApplCde": "CUST","Surname": "HAINES","CICustDecdDte": "0000-00-00","NAStandardizationOvride": "N","CIRmrkExpDte": "0000-00-00"}},"Metadata": {"MsgLst": [{"Type": "Informational Message","Text": "Success","Severity": "Info","Code": "0"}]}}';
    //String failure = '{"Output": {"ExtensionResponses": null,"Responses": [{"__type": "AccountMaintenanceResponse:http://www.opensolutions.com/CoreApi","Errors": [{"ErrorMessage": "AddrLineTypCd attribute cannot contain null value","ErrorNumber": 10001,"OraErrorMessage": null,"RtxnExceptionMessage": null,"RtxnExceptionNumber": null}],"RequestNumber": "","RequestTypeCode": "7719","WasSuccessful": false,"ResponseAccounts": null}],"UserAuthentication": {"Errors": null,"WasSuccessful": true}}}';
    String failure = '';
    String strEndPoint = req.getEndPoint();
    // httpRequest.getHeader('content-Type')

    HttpResponse res = new HttpResponse();
    //add condition for taxnbr
    if (endPoint.equals('failureEndPoint')) {
      res.setBody(failure);
      res.setStatusCode(400);
    } else if (endPoint.equals('emptyEndPoint')) {
      res.setBody('');
      res.setStatusCode(400);
    } else if (endPoint.equals('successEndPoint')) {
      res.setBody(success);
      res.setStatusCode(200);
    } else if (strEndPoint.containsIgnoreCase('taxnbr')) {
      res.setBody(success);
      res.setStatusCode(200);
    } else if (strEndPoint.containsIgnoreCase('token')) {
      res.setBody(successToken);
      res.setStatusCode(200);
    } else if (strEndPoint.containsIgnoreCase('individuals')) {
      res.setBody(success_createCustomer);
      res.setStatusCode(200);
    }
    system.debug('p' + res.getBody());
    return res;
  }
}