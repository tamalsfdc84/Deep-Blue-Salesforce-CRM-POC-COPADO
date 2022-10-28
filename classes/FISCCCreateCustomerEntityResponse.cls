public inherited sharing class FISCCCreateCustomerEntityResponse extends FISCCTransactionResponseBaseDTO {
  public FISCCResponseEntity Entity;
  public FISCCCreateCustomerEntityResponse() {
    this.Entity = new FISCCResponseEntity();
  }
  public class FISCCResponseEntity {
    public FISCCCustomerDTO customer;
    public FISCCResponseEntity() {
      this.customer = new FISCCCustomerDTO();
    }
  }
}