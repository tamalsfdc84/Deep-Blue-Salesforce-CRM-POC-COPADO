public with sharing class FISCCDODepositNameAddressRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDODepositNameAddressRequest() {
    this.depositAddresses = new FISCCDepositNameAddressDTO();
  }
  public FISCCDepositNameAddressDTO depositAddresses;
}