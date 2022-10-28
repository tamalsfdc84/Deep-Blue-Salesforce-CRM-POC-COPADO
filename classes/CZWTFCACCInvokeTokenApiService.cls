public with sharing class CZWTFCACCInvokeTokenApiService {
  public CZWTFCAccApiResponse callApi(String xmlRequest, AdobeCampaignConfiguration__mdt adapterConfig) {
    CZWTFCAccApiResponse resp = new CZWTFCAccApiResponse();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(adapterConfig.EndPointUrl__c + '/nl/jsp/soaprouter.jsp');
    req.setMethod(adapterConfig.HttpMethodType__c);
    req.setHeader('Content-Type', adapterConfig.ContentType__c);
    req.setHeader('SOAPAction', adapterConfig.SoapAction__c);

    req.setbody(xmlRequest);
    Http h = new Http();
    HttpResponse res = h.send(req);

    if (res.getStatusCode() == 200) {
      resp = parseResponse(res.getBody());
      resp.responseStatusCode = res.getStatusCode();
      resp.responseStatusMess = res.getStatus();

      return resp;
    } else {
      resp.faultDetailDesc = res.getBody();
      resp.isSuccess = false;
      return resp;
    }
  }

  public CZWTFCAccApiResponse parseResponse(String resp) {
    CZWTFCAccApiResponse accResp = new CZWTFCAccApiResponse();
    Dom.Document doc = new Dom.Document();
    try {
      doc.load(resp);
      Dom.XmlNode rootNode = doc.getRootElement();

      Dom.XmlNode bodyXmlNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');

      Dom.XmlNode logonRespNode = bodyXmlNode.getChildElement('LogonResponse', 'urn:xtk:session');
      if (logonRespNode != null) {
        Dom.XmlNode sessionToken = logonRespNode.getChildElement('pstrSessionToken', 'urn:xtk:session');
        if (sessionToken != null) {
          accResp.token = sessionToken.getText();
        }
        accResp.isSuccess = true;
      }
      // return accResp;
    } catch (Exception ex) {
      accResp.isSuccess = false;
      accResp.faultDetailDesc = resp;
    }
    return accResp;
  }
}