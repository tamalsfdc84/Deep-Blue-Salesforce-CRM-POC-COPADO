public with sharing class FISCCDOOrganizationDemoRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOOrganizationDemoRequest() {
    this.organizationDemographics = new FISCCOrganizationDemographicsDTO();
  }
  public FISCCOrganizationDemographicsDTO organizationDemographics;
}