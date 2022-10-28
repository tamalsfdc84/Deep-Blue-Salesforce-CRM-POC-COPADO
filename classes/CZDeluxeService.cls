global with sharing class CZDeluxeService {
  public static String getRedirectUrl(String applicationID) {
    tffa__Application__c application = CZWTFCApplicationRepository.findApplicationById(applicationID);

    String requestXML = createRequestXML(application);
    tffa.Logger.debug(requestXML);

    CZWTFCIntegrationLogService.setIntegrationLog(application.tffa__Submission__c, 'Deluxe Check Order');
    CZWTFCIntegrationLogService.setCurrentLog('Deluxe Check Order');
    CZWTFCIntegrationLogService.setCurrentLogItem('Deluxe Check Order - ' + application.Name, application.Id, true);
    String redirectURL;
    try {
      redirectURL = invokeAPIRequest(requestXML);
      CZWTFCIntegrationLogService.setLogItemOk(application.Name);
    } catch (Exception ex) {
      CZWTFCIntegrationLogService.setLogItemFailed(application.Name, ex.getMessage());
      throw ex;
    } finally {
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(requestXML, redirectURL);
      CZWTFCIntegrationLogService.persistIntegationLogs();
    }
    return redirectURL;
  }

  public static String invokeAPIRequest(String requestXML) {
    Deluxe_Creds__mdt fiConfig = CZWTFCHelperRepository.fetchDeluxeConfig('Deluxe_Data');
    string postData =
      'FIId=' +
      fiConfig.FI_ID__c +
      '&FIToken=' +
      EncodingUtil.urlEncode(fiConfig.FI_TOKEN__c, 'UTF-8') +
      '&xml_data=' +
      EncodingUtil.urlEncode(requestXML, 'UTF-8').replaceAll('\\s+', '');

    tffa.Logger.debug('postData :' + postData);

    HttpRequest req = new HttpRequest();
    req.setEndpoint(fiConfig.Endpoint_URL__c);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    req.setHeader('Content-Length', string.valueOf(postData.length()));

    req.setBody(postData);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    tffa.Logger.debug(res);
    String returnURL;
    if (res.getStatusCode() == 302) {
      for (String headerKey : res.getHeaderKeys()) {
        tffa.Logger.debug(headerKey + ' : ' + res.getHeader(headerKey));
      }
      returnURL = res.getHeader('Location');
    } else {
      throw new tffa.ApplicationException(res.getStatusCode() + ' ' + res.getBody());
    }
    return returnURL;
  }

  public static String createRequestXML(tffa__Application__c application) {
    User currentUser = tffa.UserService.getCurrentUser();

    Boolean isBusinessApplication = application.tffa__ProductCategory__c.contains('BUSINESS');

    Set<Id> partyIds = new Set<Id>();
    ID primaryPartyID;
    for (tffa__ApplicationPartyXref__c xref : application.tffa__PartyXrefs__r) {
      // collect all parties from appicaltion party
      if (
        CZWTFCDisclosureHelper.ROLE_MAP.get('BUSINESS_SIGNER').contains(xref.tffa__RoleCode__c) ||
        CZWTFCDisclosureHelper.ROLE_MAP.get('CONSUMER_SIGNER').contains(xref.tffa__RoleCode__c)
      )
        partyIds.add(xref.tffa__Party__c);
      if (xref.tffa__Primary__c == true) {
        primaryPartyID = xref.tffa__Party__c;
      }
    }
    if (partyIds.size() == 0) {
      tffa.Logger.error('No signers on the account. Cannot redirect to Deluxe.');
      throw new tffa.ApplicationException('No signers on the account. Cannot redirect to Deluxe.');
    }
    // get the parties with party ids
    List<tffa__Party__c> partiesWithAddress = CZWTFCPartyRepository.findAddressByParties(partyIds);

    String programName = 'NONE';
    for (tffa__Party__c prty : partiesWithAddress) {
      if (primaryPartyID == prty.ID) {
        if (prty.CZIsFounder__c) {
          programName = 'FOUNDER';
          break;
        } else if (prty.tffa__IsEmployee__c) {
          programName = 'EMPLOYEE';
          break;
        } else if (application.tffa__Product__r.CZDeluxeProgram__c != null) {
          programName = 'product level';
          break;
        }
      }
    }

    String xmlRequest = '<?xml version="1.0" encoding="UTF-8"?><Deluxe Version=\"10.0\">';
    xmlRequest = xmlRequest + '<DeluxePort>';
    xmlRequest = xmlRequest + '<ChkOrdAddRq>';
    xmlRequest = xmlRequest + '<RqUID>' + application.Id + '</RqUID>';
    xmlRequest = xmlRequest + '<ChkOrdInfo>';
    xmlRequest = xmlRequest + '<DepAcctId>';
    xmlRequest = xmlRequest + '<AcctId>' + application.tffa__AccountNumber__c + '</AcctId>';
    xmlRequest = xmlRequest + '<AcctType>DDA</AcctType>';
    xmlRequest = xmlRequest + '<BankInfo>';
    xmlRequest = xmlRequest + '<BankIdType>ABA</BankIdType>';
    xmlRequest = xmlRequest + '<BankId>' + application.tffa__Submission__r.tffa__BrandEntity__r.tffa__RoutingNumber__c + '</BankId>';
    xmlRequest = xmlRequest + '<BranchId>' + application.CZLocation__r.FISBranchCode__c + '</BranchId>';
    xmlRequest = xmlRequest + '</BankInfo>';
    xmlRequest = xmlRequest + '<Program><ProgramName>' + programName + '</ProgramName></Program>';
    if (application.CZAccountOpeningDate__c != null) {
      xmlRequest = xmlRequest + '<OpenDt>' + CZWTFCCommonHelper.formatDate(application.CZAccountOpeningDate__c, 'MM-dd') + '</OpenDt>';
    }
    if (isBusinessApplication) {
      xmlRequest = xmlRequest + '<CustomerType>Business</CustomerType>';
    } else {
      xmlRequest = xmlRequest + '<CustomerType>Personal</CustomerType>';
    }
    xmlRequest = xmlRequest + '</DepAcctId>';

    for (tffa__Party__c prt : partiesWithAddress) {
      if (prt.tffa__Type__c == 'INDIVIDUAL') {
        xmlRequest = xmlRequest + '<PersonInfo>';
        xmlRequest = xmlRequest + '<NameAddrType>Primary</NameAddrType>';
        xmlRequest = xmlRequest + '<PersonName>';
        xmlRequest = xmlRequest + '<LastName>' + prt.tffa__LastName__c + '</LastName>';
        xmlRequest = xmlRequest + '<FirstName>' + prt.tffa__FirstName__c + '</FirstName>';
        if (!String.isBlank(prt.tffa__MiddleName__c))
          xmlRequest = xmlRequest + '<MiddleName>' + prt.tffa__MiddleName__c + '</MiddleName>';
        if (!String.isBlank(prt.tffa__Suffix__c))
          xmlRequest = xmlRequest + '<NameSuffix>' + prt.tffa__Suffix__c + '</NameSuffix>';
        xmlRequest = xmlRequest + '</PersonName>';
        xmlRequest = xmlRequest + '<ContactInfo>';
        if (prt.tffa__PrimaryPhone__c != null) {
          xmlRequest = xmlRequest + '<PhoneNum>';
          xmlRequest = xmlRequest + '<PhoneType>EvePhone</PhoneType>';
          xmlRequest = xmlRequest + '<Phone>' + prt.tffa__PrimaryPhone__c + '</Phone>';
          xmlRequest = xmlRequest + '</PhoneNum>';
        } else if (prt.CellPhoneNumber__c != null) {
          xmlRequest = xmlRequest + '<PhoneNum>';
          xmlRequest = xmlRequest + '<PhoneType>EvePhone</PhoneType>';
          xmlRequest = xmlRequest + '<Phone>' + prt.CellPhoneNumber__c + '</Phone>';
          xmlRequest = xmlRequest + '</PhoneNum>';
        }
        if (prt.tffa__SecondaryPhone__c != null) {
          xmlRequest = xmlRequest + '<PhoneNum>';
          xmlRequest = xmlRequest + '<PhoneType>DayPhone</PhoneType>';
          xmlRequest = xmlRequest + '<Phone>' + prt.tffa__SecondaryPhone__c + '</Phone>';
          xmlRequest = xmlRequest + '</PhoneNum>';
        }
      } else {
        xmlRequest = xmlRequest + '<OrgInfo><Name>' + prt.Name + '</Name>';
      }

      if (application.tffa__Address__r != null) {
        tffa__Address__c addressObj = application.tffa__Address__r;
        xmlRequest = xmlRequest + '<PostAddr>';
        xmlRequest = xmlRequest + '<Addr1>' + addressObj.tffa__Line1__c + '</Addr1>';
        if (!String.isBlank(addressObj.tffa__Line2__c))
          xmlRequest = xmlRequest + '<Addr2>' + addressObj.tffa__Line2__c + '</Addr2>';
        xmlRequest = xmlRequest + '<City>' + addressObj.tffa__City__c + '</City>';
        xmlRequest = xmlRequest + '<StateProv>' + addressObj.tffa__State__c + '</StateProv>';
        xmlRequest = xmlRequest + '<PostalCode>' + addressObj.tffa__ZipCode__c + '</PostalCode>';
        xmlRequest = xmlRequest + '<Country>' + addressObj.tffa__Country__c + '</Country>';
        xmlRequest = xmlRequest + '</PostAddr>';
      }
      if (!String.isBlank(prt.tffa__PrimaryEmail__c))
        xmlRequest = xmlRequest + '<EmailAddr>' + prt.tffa__PrimaryEmail__c + '</EmailAddr>';
      xmlRequest = xmlRequest + '</ContactInfo>';
      if (prt.tffa__Type__c == 'INDIVIDUAL') {
        xmlRequest = xmlRequest + '</PersonInfo>';
      } else {
        xmlRequest = xmlRequest + '</OrgInfo>';
      }
      //}
    }
    xmlRequest = xmlRequest + '</ChkOrdInfo>';
    xmlRequest = xmlRequest + '<AgentInfo>';
    xmlRequest = xmlRequest + '<UserId>' + currentUser.userName + '</UserId>';
    xmlRequest = xmlRequest + '<FullName>' + currentUser.Name + '</FullName>';
    xmlRequest = xmlRequest + '</AgentInfo>';
    xmlRequest = xmlRequest + '</ChkOrdAddRq>';
    xmlRequest = xmlRequest + '</DeluxePort>';
    xmlRequest = xmlRequest + '</Deluxe>';
    return xmlRequest;
  }
}