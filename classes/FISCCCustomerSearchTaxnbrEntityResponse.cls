public inherited sharing class FISCCCustomerSearchTaxnbrEntityResponse extends FISCCTransactionResponseBaseDTO {
  public FISCCResponseEntity Entity;

  public FISCCCustomerSearchTaxnbrEntityResponse() {
    this.Entity = new FISCCResponseEntity();
  }

  public class FISCCResponseEntity {
    public List<FISCCCustomerDTO> customersLst;
    public FISCCCustomerSearchTaxnbrResponse.ControlData controlData;
    public FISCCResponseEntity() {
      this.customersLst = new List<FISCCCustomerDTO>();
      this.controlData = new FISCCCustomerSearchTaxnbrResponse.ControlData();
    }
  }
}