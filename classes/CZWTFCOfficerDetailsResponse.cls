public with sharing class CZWTFCOfficerDetailsResponse extends FISCCResponseBaseDTO {
  public ControlData controlData;
  public List<CZWTFCOfficerDetailsDTO> officerDetailsLts;

  public CZWTFCOfficerDetailsResponse() {
    this.controlData = new ControlData();
    this.officerDetailsLts = new List<CZWTFCOfficerDetailsDTO>();
  }

  public class ControlData {
    public String MoreInd;
    public String StrtOfcrNbr;
  }
}