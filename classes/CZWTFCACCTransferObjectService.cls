public with sharing class CZWTFCACCTransferObjectService {
  public CZWTFCAccApiResponse expiredObjects(List<SObject> objList, String token) {
    CZWTFCAccApiResponse resp = new CZWTFCAccApiResponse();
    AdobeCampaignConfiguration__mdt adapterConfig = CZWTFCHelperRepository.fetchAdobeCampaignApiConfig('WriteCollection');

    if (objList != null && !objList.isEmpty() && adapterConfig != null) {
      SObjectType sobjType = ((SObject) (objList[0])).getSObjectType();

      DescribeSObjectResult descSObjectResult = sobjType.getDescribe();

      Map<String, Schema.SObjectField> typeMap = descSObjectResult.fields.getMap();

      List<AdobeCampaign__c> adobeConfig = CZWTFCHelperRepository.fetchCampaignConfigs(descSObjectResult.getName());

      String xmlReq =
        '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:xtk:session\"> \n' +
        '   <soapenv:Header/> \n' +
        '   <soapenv:Body> \n' +
        '       <urn:Write> \n' +
        '         <urn:sessiontoken>' +
        token +
        '</urn:sessiontoken> \n' +
        '        <urn:tffa:' +
        adobeConfig[0].AdobeSchemaName__c +
        '> \n' +
        '<' +
        adobeConfig[0].AdobeSchemaName__c +
        '-collection xtkschema="tffa:' +
        adobeConfig[0].AdobeSchemaName__c +
        '">';

      for (SObject obj : objList) {
        String appPartyReq = '<' + adobeConfig[0].AdobeSchemaName__c + '';
        for (AdobeCampaign__c adobeC : adobeConfig) {
          String type = String.valueOf((typeMap.get(adobeC.TerafinaFieldName__c)).getDescribe().getType());

          if (type.equalsIgnoreCase('DOUBLE') || type.equalsIgnoreCase('CURRENCY')) {
            appPartyReq +=
              ' ' +
              adobeC.AdobeFieldName__c +
              '="' +
              (obj.get(adobeC.TerafinaFieldName__c) != null ? String.valueOf(obj.get(adobeC.TerafinaFieldName__c)) : '') +
              '"';
          } else if (type.equalsIgnoreCase('STRING')) {
            appPartyReq +=
              ' ' +
              adobeC.AdobeFieldName__c +
              '="' +
              (obj.get(adobeC.TerafinaFieldName__c) != null ? obj.get(adobeC.TerafinaFieldName__c) : '') +
              '"';
          } else if (type.equalsIgnoreCase('BOOLEAN')) {
            appPartyReq += ' ' + adobeC.AdobeFieldName__c + '="' + (String.valueOf(obj.get(adobeC.TerafinaFieldName__c))) + '"';
          } else {
            appPartyReq += ' ' + adobeC.AdobeFieldName__c + '="' + (obj.get(adobeC.TerafinaFieldName__c)) + '"';
          }
        }
        appPartyReq += ' />';
        xmlReq += appPartyReq;
        appPartyReq = '';
      }

      xmlReq +=
        '</' +
        adobeConfig[0].AdobeSchemaName__c +
        '-collection>' +
        ' </urn:tffa:' +
        adobeConfig[0].AdobeSchemaName__c +
        '>\n' +
        ' </urn:Write>\n' +
        ' </soapenv:Body>\n' +
        ' </soapenv:Envelope>';

      CZWTFCAccWriteCollectionService accWriteColl = new CZWTFCAccWriteCollectionService();
      resp = accWriteColl.callApi(xmlReq, adapterConfig);
      if (!resp.isSuccess) {
        resp.faultDetailDesc = descSObjectResult.getName() + ' --> ' + (resp.faultDetailDesc).abbreviate(200);
      }
    } else {
      resp.isSuccess = true;
    }
    return resp;
  }
}