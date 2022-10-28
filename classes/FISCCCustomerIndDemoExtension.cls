public with sharing class FISCCCustomerIndDemoExtension {
  public static FISCCDepositOriginationRequestBaseDTO generateCustomerIndDemoRequest(tffa__Party__c partyObj) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO;
    try {
      FISCCDOIndividualDemoRequest individualDemo = new FISCCDOIndividualDemoRequest();
      individualDemo.SvcID = FISCCIntegrationConstants.INDIVIDUAL_DEMOGRAPHICS;
      individualDemo.individualDemographics.CIApplNbr = partyObj.Customer_Number__c;
      individualDemo.individualDemographics.NNAPhnNum = partyObj.CZInternationalPhoneNumber__c;

      fisccDepositOriginationRequestBaseDTO = individualDemo;
      tffa.Logger.debug('FISCCCustomerIndDemoExtension req ==> ' + fisccDepositOriginationRequestBaseDTO);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateCustomerIndDemoRequest ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return fisccDepositOriginationRequestBaseDTO;
  }
}