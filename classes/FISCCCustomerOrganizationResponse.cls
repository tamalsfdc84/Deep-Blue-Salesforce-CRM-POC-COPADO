public with sharing class FISCCCustomerOrganizationResponse extends FISCCResponseBaseDTO {
  public FISCCOrganizationDTO organizationDto;
  public FISCCCustomerOrganizationResponse() {
    this.organizationDto = new FISCCOrganizationDTO();
  }
}