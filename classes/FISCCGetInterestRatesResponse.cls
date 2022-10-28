public with sharing class FISCCGetInterestRatesResponse extends FISCCResponseBaseDTO {
  public FISCCGetInterestRatesResponse() {
    this.investmentRateSchedulesMap = new Map<String, FISCCInvestmentRateSchedulesDTO>();
    this.investmentRateTiersMap = new Map<String, List<FISCCInvestmentRateTiersDTO>>();
    this.controlData = new ControlData();
  }

  public class ControlData {
    public String MoreInd;
    public String ReqStartKey;
  }
  public Map<String, FISCCInvestmentRateSchedulesDTO> investmentRateSchedulesMap;
  public Map<String, List<FISCCInvestmentRateTiersDTO>> investmentRateTiersMap;
  public ControlData controlData;
}