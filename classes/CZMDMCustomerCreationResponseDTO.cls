public with sharing class CZMDMCustomerCreationResponseDTO extends CZMDMResponseBaseDTO {
  public CZMDMCustomerCreationResponseDTO() {
    this.message = '';
    this.status = '';
    this.code = '';
    this.wtfcPartyId = '';
  }

  public String message;
  public String status;
  public String code;
  public String wtfcPartyId;
}