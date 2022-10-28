public with sharing class FISCCDepositOriginationRequest extends FISCCRequestBaseDTO {
  public List<FISCCDepositOriginationRequestBaseDTO> DepositOriginationLst;
  public FISCCDepositOriginationRequest() {
    this.DepositOriginationLst = new List<FISCCDepositOriginationRequestBaseDTO>();
  }
}