public with sharing class MDMCustomerUpdateExtension {
  public static String updateCustomer(tffa__Submission__c submission, tffa__Party__c party) {
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL
        ? CZWTFCHelperRepository.fetchMulesoftAdapterConfig('UpdateCustomer')
        : CZWTFCHelperRepository.fetchMulesoftAdapterConfig('UpdateBusinessCustomer');

      Integer custNumber = Integer.valueOf(party.Customer_Number__c);

      adapterConfig.EndPoint__c =
        adapterConfig.EndPoint__c +
        '?orgId=' +
        MDMCommonHelper.getBrandCode(party.tffa__BrandCode__c) +
        '&mdmPartyId=' +
        party.CZMDMPartyID__c +
        '&cisNmb=' +
        String.valueOf(custNumber);

      if (submission.tffa__Channel__c == CZWTFCConstants.BRANCH) {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '&interactionMethod=BRANCH';
      } else {
        adapterConfig.EndPoint__c = adapterConfig.EndPoint__c + '?interactionMethod=ONLINE';
      }

      MDMCustomerUpdateRequest request = generateCustomerUpdateRequest(submission, party);

      String requestStr = System.JSON.serialize(request, true);

      CZMulesoftAdapter.auth = FISCCIntegrationLogService.auth;

      Object resp = CZMulesoftAdapter.invokeAPI(requestStr, adapterConfig);

      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.UPDATE_CUSTOMER_MDM);
      return 'SUCCESS';
    } catch (Exception ex) {
      tffa.logger.error('Exception in MDMCustomerUpdateExtension ' + ex.getMessage() + ' ' + ex.getStackTraceString());

      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.UPDATE_CUSTOMER_MDM);
      return 'FAILURE';
    }
  }

  public static MDMCustomerUpdateRequest generateCustomerUpdateRequest(tffa__Submission__c submission, tffa__Party__c party) {
    MDMCustomerUpdateRequest request = new MDMCustomerUpdateRequest();
    request.phoneNumbersLst = getCommunication(party);
    request.emailAddressesLst.add(getEmail(party));
    return request;
  }

  public static List<MDMCustomerUpdateRequest.PhoneNumber> getCommunication(tffa__Party__c party) {
    List<MDMCustomerUpdateRequest.PhoneNumber> communicationList = new List<MDMCustomerUpdateRequest.PhoneNumber>();
    MDMCustomerUpdateRequest.PhoneNumber item = new MDMCustomerUpdateRequest.PhoneNumber();

    //Consumer - MBL
    //business - MBL
    if (party.CellPhoneNumber__c != null) {
      String phoneNumber = String.valueOf(party.CellPhoneNumber__c).right(10);
      item.resnCde = 'MBL';
      item.areaCde = phoneNumber.left(3);
      item.localNbr = phoneNumber.right(7);
      communicationList.add(item);
    }

    //Consumer - HME
    //business - PRI
    if (party.tffa__PrimaryPhone__c != null) {
      item = new MDMCustomerUpdateRequest.PhoneNumber();
      String phoneNumber = String.valueOf(party.tffa__PrimaryPhone__c).right(10);
      item.resnCde = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'HME' : 'PRI';
      item.areaCde = phoneNumber.left(3);
      item.localNbr = phoneNumber.right(7);
      communicationList.add(item);
    }

    //Consumer - WRK
    //business - SEC
    if (party.tffa__SecondaryPhone__c != null) {
      item = new MDMCustomerUpdateRequest.PhoneNumber();
      String phoneNumber = String.valueOf(party.tffa__SecondaryPhone__c).right(10);
      item.resnCde = party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL ? 'WRK' : 'SEC';
      item.areaCde = phoneNumber.left(3);
      item.localNbr = phoneNumber.right(7);
      communicationList.add(item);
    }

    if (party.CZInternationalPhoneNumber__c != null) {
      item = new MDMCustomerUpdateRequest.PhoneNumber();
      String phoneNumber = String.valueOf(party.CZInternationalPhoneNumber__c);
      String[] internationNumber = phoneNumber.split(' ');
      item.resnCde = 'ITL';
      item.ctryCde = internationNumber[0].replaceAll('\\+', '');
      item.areaCde = internationNumber[1];
      item.localNbr = internationNumber[2];
      communicationList.add(item);
    }
    return communicationList;
  }

  public static MDMCustomerUpdateRequest.EmailAddress getEmail(tffa__Party__c party) {
    MDMCustomerUpdateRequest.EmailAddress item = new MDMCustomerUpdateRequest.EmailAddress();
    item.resnCde = 'PRI';
    item.emailAddr = party.tffa__PrimaryEmail__c;
    return item;
  }
}