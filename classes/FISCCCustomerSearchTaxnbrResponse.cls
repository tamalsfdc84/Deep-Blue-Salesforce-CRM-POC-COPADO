public with sharing class FISCCCustomerSearchTaxnbrResponse extends FISCCResponseBaseDTO {
  public FISCCCustomerSearchTaxnbrResponse() {
    this.customersLst = new List<FISCCCustomerDTO>();
    this.controlData = new ControlData();
  }
  public String CIMoreToBeReturnedInd;
  public String CISearchTyp;
  public String CIKeySSN;
  public String CICustNbrToStrtSearch;
  public String CICustTypInd;
  public String CIRequestedResTimes;
  public String CICustEntityFilter;
  public List<FISCCCustomerDTO> customersLst;
  public ControlData controlData;
  //controlData
  public class ControlData {
    public String CIMoreToBeReturnedInd;
    public String CIKeySSN;
    public String CICustNbrToStrtSearch;
    public String CIRequestedResTimes;
  }
}