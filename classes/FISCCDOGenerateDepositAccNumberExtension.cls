public with sharing class FISCCDOGenerateDepositAccNumberExtension {
  public static FISCCGenerateDepositAccNumberDTO createDepositAccountNumberRequest(
    tffa__Submission__c subObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCGenerateDepositAccNumberDTO fisccGenerateDepositAccountNumberDTO = new FISCCGenerateDepositAccNumberDTO();
    try {
      fisccGenerateDepositAccountNumberDTO.DPAcctBrnch = Integer.valueOf(appObj.FISBranchCode__c);
      fisccGenerateDepositAccountNumberDTO.DPAcctTyp = Integer.valueOf(appObj.tffa__Product__r.tffa__Code__c);
      fisccGenerateDepositAccountNumberDTO.GenDPApplID = FISCCIntegrationConstants.GenDPApplID;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createDepositAccountNumberRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }
    tffa.logger.debug(
      'FISCCDOGenerateDepositAccNumberExtension : createDepositAccountNumberRequest ==>' + fisccGenerateDepositAccountNumberDTO
    );
    return fisccGenerateDepositAccountNumberDTO;
  }
}