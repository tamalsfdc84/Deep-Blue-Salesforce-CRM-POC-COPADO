public with sharing class CZWTFCAccWriteCollectionService {
  public CZWTFCAccApiResponse callApi(String xmlRequest, AdobeCampaignConfiguration__mdt adapterConfig) {
    CZWTFCAccApiResponse resp = new CZWTFCAccApiResponse();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(adapterConfig.EndPointUrl__c + '/nl/jsp/soaprouter.jsp');
    req.setMethod(adapterConfig.HttpMethodType__c);
    req.setHeader('Content-Type', adapterConfig.ContentType__c);
    req.setHeader('SOAPAction', adapterConfig.SoapAction__c);
    tffa.Logger.debug('Adobe Campaign Req :: ' + xmlRequest);
    req.setbody(xmlRequest);
    Http h = new Http();
    HttpResponse res = h.send(req);
    if (res.getStatusCode() == 200) {
      resp = parseResponse(res.getBody());
      tffa.Logger.debug('Adobe Campaign Resp :: ' + res.getBody());
      resp.responseStatusCode = res.getStatusCode();
      resp.responseStatusMess = res.getStatus();
      return resp;
    } else {
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

      Dom.XmlNode faultNode = bodyXmlNode.getChildElement('Fault', 'http://schemas.xmlsoap.org/soap/envelope/');
      if (faultNode != null) {
        Dom.XmlNode faultCodeNode = faultNode.getChildElement('faultcode', null);
        Dom.XmlNode faultStringNode = faultNode.getChildElement('faultstring', null);
        Dom.XmlNode faultDetailNode = faultNode.getChildElement('detail', null);
        if (faultCodeNode != null) {
          accResp.faultString = faultCodeNode.getText();
        }
        if (faultStringNode != null) {
          accResp.faultDesc = faultStringNode.getText();
        }
        if (faultDetailNode != null) {
          accResp.faultDetailDesc = faultDetailNode.getText();
        }
        accResp.isSuccess = false;
      } else {
        accResp.isSuccess = true;
      }

      return accResp;
    } catch (Exception ex) {
    }

    return accResp;
  }
}