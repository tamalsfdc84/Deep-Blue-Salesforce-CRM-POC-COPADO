public with sharing class FISCCDepositOriginationEntityResponse extends FISCCTransactionResponseBaseDTO {
  public FISCCResponseEntity Entity;
  public FISCCDepositOriginationEntityResponse() {
    this.Entity = new FISCCResponseEntity();
  }

  public class FISCCResponseEntity {
    public List<FISCCDepositOriginationResponse> DepositOriginationLst;

    public FISCCResponseEntity() {
      this.DepositOriginationLst = new List<FISCCDepositOriginationResponse>();
    }
  }
}