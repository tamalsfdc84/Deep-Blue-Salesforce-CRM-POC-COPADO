public with sharing class FISCCDOMBPassRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOMBPassRequest() {
    this.mbpassLst = new List<FISCCMBPassDTO>();
  }
  public List<FISCCMBPassDTO> mbpassLst;
}