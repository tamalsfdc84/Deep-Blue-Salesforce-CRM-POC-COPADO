public with sharing class FISCCDOCustomerAccountRelationExtension {
  public static FISCCDepositOriginationRequestBaseDTO invokeCustomerAccountRelation(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    Object result = null;
    boolean isCustomerEmailSuccess = null;
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    try {
      fisccDepositOriginationRequestBaseDTO = customerAccountRelationRequest(partyObjs, appObjs, adapterConfig, charterConfig);
      tffa.Logger.debug('invokeDepositAccountNumber is called');

      return fisccDepositOriginationRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeCustomerAccountRelation : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return fisccDepositOriginationRequestBaseDTO;
    }
  }
  public static FISCCDepositOriginationRequestBaseDTO customerAccountRelationRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCDOCustomerAccountRelationRequest objFISCCDOCustomerAccountRelationRequest = new FISCCDOCustomerAccountRelationRequest();
    try {
      objFISCCDOCustomerAccountRelationRequest.customerAccounts = FISCCCustomerAccountRelationHelper.customerAccountRelationRequest(
        partyObjs,
        appObjs,
        adapterConfig,
        charterConfig
      );

      tffa.logger.debug('Inside FISCCDOCustomerAccountRelationExtension : customerAccountRelationRequest method');

      fisccDepositOriginationRequestBaseDTO = objFISCCDOCustomerAccountRelationRequest;
      tffa.logger.debug(
        'FISCCDOCustomerAccountRelationExtension : fisccDepositOriginationRequestBaseDTO ==> ' + fisccDepositOriginationRequestBaseDTO
      );
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeCEBEnroll : ' + +ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    tffa.logger.debug(
      'FISCCDOCustomerAccountRelationExtension : fisccDepositOriginationRequestBaseDTO1 ==>' + fisccDepositOriginationRequestBaseDTO
    );
    return fisccDepositOriginationRequestBaseDTO;
  }
}