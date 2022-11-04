public with sharing class FISCCCustomerEmailHelper {
  public static FISCCCreateEmailAddressesDTO customerEmailRequest(
    List<tffa__Party__c> partyObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCCreateEmailAddressesDTO fisccEmailAddressDTO = new FISCCCreateEmailAddressesDTO();

    try {
      tffa.Logger.debug('Inside customerEmailRequest method');

      fisccEmailAddressDTO.ResnCde = FISCCApplicationConstants.RESEND_CODE;
      fisccEmailAddressDTO.EmailAddr = partyObjs[0].tffa__PrimaryEmail__c;

      tffa.logger.debug('partyObjs in customerEmailRequest==>' + partyObjs);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in customerEmailRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('FISCCEmailAddressDTO ==>' + fisccEmailAddressDTO);
    return fisccEmailAddressDTO;
  }
}