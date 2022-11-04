public with sharing class FISCCDOCustomerOrganizationRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerOrganizationRequest() {
    this.customerOrg = new FISCCOrganizationDTO();
  }
  public FISCCOrganizationDTO customerOrg;
}