public with sharing class CZSDBAddOwnerRequest extends FISCCDepositOriginationRequestBaseDTO {
  public CZSDBAddOwnerRequest() {
    this.boxOwnerNew = new CZSDBAddOwnerRequestDTO();
  }
  public CZSDBAddOwnerRequestDTO boxOwnerNew;
}