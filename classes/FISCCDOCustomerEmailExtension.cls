public with sharing class FISCCDOCustomerEmailExtension {
  public static FISCCDepositOriginationRequestBaseDTO customerEmailRequest(
    List<tffa__Party__c> partyObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {
      tffa.Logger.debug('Inside customerEmailRequest method');
      FISCCCreateEmailAddressesDTO objFISCCCreateEmailAddressesDTO = new FISCCCreateEmailAddressesDTO();
      List<FISCCCreateEmailAddressesDTO> lstFISCCCreateEmailAddressesDTO = new List<FISCCCreateEmailAddressesDTO>();
      FISCCDOCustomerEmailRequest objFISCCDOCustomerEmailRequest = new FISCCDOCustomerEmailRequest();

      objFISCCCreateEmailAddressesDTO = FISCCCustomerEmailHelper.customerEmailRequest(partyObjs, adapterConfig, charterConfig);
      tffa.logger.debug('objFISCCCreateEmailAddressesDTO in EmailHelper ==>' + objFISCCCreateEmailAddressesDTO);
      objFISCCCreateEmailAddressesDTO.AddDelInd = FISCCIntegrationConstants.AddDelInd;
      tffa.logger.debug('objFISCCCreateEmailAddressesDTO2 in EmailHelper ==>' + objFISCCCreateEmailAddressesDTO);
      lstFISCCCreateEmailAddressesDTO.add(objFISCCCreateEmailAddressesDTO);
      tffa.logger.debug('lstFISCCCreateEmailAddressesDTO in EmailHelper ==>' + lstFISCCCreateEmailAddressesDTO);
      objFISCCDOCustomerEmailRequest.customerEmail.emailAddressLst = lstFISCCCreateEmailAddressesDTO;
      objFISCCDOCustomerEmailRequest.customerEmail.CustNbr = FISCCIntegrationConstants.MBPASS_DUMMY_CUSTOMER_NUMBER;

      tffa.logger.debug('partyObjs in createCustomerSearchRequest==>' + partyObjs);

      fisccDepositOriginationRequestBaseDTO = objFISCCDOCustomerEmailRequest;
      tffa.Logger.debug('fisccDepositOriginationRequestBaseDTO ==> ' + fisccDepositOriginationRequestBaseDTO);
    } catch (Exception ex) {
      tffa.Logger.error(
        'FISCCDOCustomerEmailExtension : fisccDepositOriginationRequestBaseDTO ==>' +
        ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('fisccDepositOriginationRequestBaseDTO3 ==>' + fisccDepositOriginationRequestBaseDTO);
    return fisccDepositOriginationRequestBaseDTO;
  }
}