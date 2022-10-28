public with sharing class FISCCPartyDobUpdateExtension {
  public static List<FISCCDepositOriginationRequestBaseDTO> generateRequest(List<tffa__Party__c> parties) {
    tffa.Logger.debug('In FISCCPartyDobUpdateExtension.generateRequest ');
    List<FISCCDepositOriginationRequestBaseDTO> requestLst = new List<FISCCDepositOriginationRequestBaseDTO>();
    try {
      for (tffa__Party__c party : parties) {
        if (party.IsAuthenticatedCustomer__c && party.tffa__IsExistingCustomer__c && party.IsDobMissing__c) {
          FISCCDOIndividualDemoRequest individualDemo = new FISCCDOIndividualDemoRequest();
          individualDemo.SvcID = FISCCIntegrationConstants.INDIVIDUAL_DEMOGRAPHICS;
          individualDemo.individualDemographics.CIApplNbr = party.Customer_Number__c;
          individualDemo.individualDemographics.CICustDteOfBrth = String.valueOf(party.tffa__BirthDate__c);
          FISCCDepositOriginationRequestBaseDTO req = (FISCCDepositOriginationRequestBaseDTO) individualDemo;
          requestLst.add(req);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in generating request for individual Demographics ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return requestLst;
  }
}