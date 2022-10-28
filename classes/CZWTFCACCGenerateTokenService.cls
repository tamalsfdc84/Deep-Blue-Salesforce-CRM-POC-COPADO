public with sharing class CZWTFCACCGenerateTokenService {
  public CZWTFCAccApiResponse getToken() {
    CZWTFCAccApiResponse resp = new CZWTFCAccApiResponse();
    AdobeCampaignConfiguration__mdt adapterConfig = CZWTFCHelperRepository.fetchAdobeCampaignApiConfig('Login');

    if (adapterConfig != null) {
      String xmlRequest =
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:xtk:session">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<urn:Logon>' +
        '<urn:sessiontoken></urn:sessiontoken>' +
        '<urn:strLogin>' +
        adapterConfig.Username__c +
        '</urn:strLogin>' +
        '<urn:strPassword>' +
        adapterConfig.Password__c +
        '</urn:strPassword>' +
        '<urn:elemParameters></urn:elemParameters>' +
        '</urn:Logon>' +
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
      CZWTFCACCInvokeTokenApiService invokeApi = new CZWTFCACCInvokeTokenApiService();
      resp = invokeApi.callApi(xmlRequest, adapterConfig);
    }
    return resp;
  }
}