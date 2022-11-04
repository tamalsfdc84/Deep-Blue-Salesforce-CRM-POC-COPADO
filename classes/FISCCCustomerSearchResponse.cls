public with sharing class FISCCCustomerSearchResponse extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCCustomerSearchResponse() {
    this.entity = new Entity();
  }

  public class Entity {
    public String CIMoreToBeReturnedInd;
    public String CISearchTyp;
    public String CIKeySSN;
    public String CICustNbrToStrtSearch;
    public String CICustTypInd;
    public String CIRequestedResTimes;
    public String CICustEntityFilter;
    public List<FISCCCustomerDTO> customersLst;
    public ControlData searchControlData;

    public Entity() {
      this.customersLst = new List<FISCCCustomerDTO>();
      this.searchControlData = new ControlData();
    }
  }

  //controlData
  public class ControlData {
    public String CIMoreToBeReturnedInd;
    public String CIKeySSN;
    public String CICustNbrToStrtSearch;
    public String CIRequestedResTimes;
  }
}