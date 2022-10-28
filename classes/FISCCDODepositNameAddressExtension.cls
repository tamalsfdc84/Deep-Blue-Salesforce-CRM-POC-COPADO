public with sharing class FISCCDODepositNameAddressExtension {
  public static FISCCDepositOriginationRequestBaseDTO invokeDepositNameAddress(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    Object result = null;
    boolean isCustomerEmailSuccess = null;
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {
      fisccDepositOriginationRequestBaseDTO = depositNameAddressRequest(partyObjs, appObjs, adapterConfig, charterConfig);
      tffa.Logger.debug('invokeDepositAccountNumber is called');

      return fisccDepositOriginationRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeDepositNameAddress : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return fisccDepositOriginationRequestBaseDTO;
    }
  }
  public static FISCCDepositOriginationRequestBaseDTO depositNameAddressRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCDODepositNameAddressRequest objFISCCDODepositNameAddressRequest = new FISCCDODepositNameAddressRequest();
    try {
      objFISCCDODepositNameAddressRequest.depositAddresses = FISCCDepositNameAddressHelper.depositAccountAddressRequest(
        partyObjs,
        appObjs,
        adapterConfig,
        charterConfig
      );

      tffa.logger.debug('Inside FISCCDODepositNameAddressExtension : depositNameAddressRequest method');

      fisccDepositOriginationRequestBaseDTO = objFISCCDODepositNameAddressRequest;
      tffa.logger.debug(
        'FISCCDODepositNameAddressExtension : fisccDepositOriginationRequestBaseDTO ==> ' + fisccDepositOriginationRequestBaseDTO
      );
    } catch (Exception ex) {
      tffa.Logger.error('Exception in depositNameAddressRequest : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return null;
    }
    tffa.logger.debug(
      'FISCCDODepositNameAddressExtension : fisccDepositOriginationRequestBaseDTO1 ==>' + fisccDepositOriginationRequestBaseDTO
    );
    return fisccDepositOriginationRequestBaseDTO;
  }
}