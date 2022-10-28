public with sharing class FISCCDOCustomerDDRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerDDRequest() {
    this.dueDiligenceReq = new DueDiligence();
  }

  public DueDiligence dueDiligenceReq;

  public class DueDiligence {
    public DueDiligence() {
      this.dueDiligenceDemographics = new FISCCDODueDiligenceDTO();
      this.incomingCountries = new List<IncomingCountry>();
      this.outgoingCountries = new List<OutgoingCountry>();
    }
    public FISCCDODueDiligenceDTO dueDiligenceDemographics;
    public List<IncomingCountry> incomingCountries;
    public List<OutgoingCountry> outgoingCountries;
  }

  public class IncomingCountry {
    public String InCtryCde;
  }

  public class OutgoingCountry {
    public String OutCtryCde;
  }
}