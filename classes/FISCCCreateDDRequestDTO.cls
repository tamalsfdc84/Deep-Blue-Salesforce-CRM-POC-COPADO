public with sharing class FISCCCreateDDRequestDTO extends FISCCRequestBaseDTO {
  public FISCCCreateDDRequestDTO() {
    this.dueDiligenceDemographics = new DueDiligenceDemographics();
  }

  public DueDiligenceDemographics dueDiligenceDemographics;

  public class DueDiligenceDemographics {
    public String OccpnDesc;

    public String Title;

    public String FullTime;

    public String RsdntPrsn;
  }
}