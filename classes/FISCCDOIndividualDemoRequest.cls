public with sharing class FISCCDOIndividualDemoRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOIndividualDemoRequest() {
    this.individualDemographics = new FISCCIndividualDemographicsDTO();
  }
  public FISCCIndividualDemographicsDTO individualDemographics;
}