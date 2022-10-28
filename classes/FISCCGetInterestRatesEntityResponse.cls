public inherited sharing class FISCCGetInterestRatesEntityResponse extends FISCCTransactionResponseBaseDTO {
  public FISCCResponseEntity Entity;

  public FISCCGetInterestRatesEntityResponse() {
    this.Entity = new FISCCResponseEntity();
  }

  public class FISCCResponseEntity {
    public List<FISCCInvestmentRateSchedulesDTO> investmentRateSchedulesLst;
    public List<FISCCInvestmentRateTiersDTO> investmentRateTiersLst;
    public FISCCGetInterestRatesResponse.ControlData controlData;

    public FISCCResponseEntity() {
      this.investmentRateSchedulesLst = new List<FISCCInvestmentRateSchedulesDTO>();
      this.investmentRateTiersLst = new List<FISCCInvestmentRateTiersDTO>();
      this.controlData = new FISCCGetInterestRatesResponse.ControlData();
    }
  }
}