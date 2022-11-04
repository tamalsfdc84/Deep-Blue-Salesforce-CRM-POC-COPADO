public with sharing class CZWTFCExistingIRAPlanResponse extends FISCCTransactionResponseBaseDTO {
  public CustomerData customerData;
  public List<CZWTFCExistingIRAPlanDTO> existingPlanList;

  public CZWTFCExistingIRAPlanResponse() {
    this.customerData = new CustomerData();
    this.existingPlanList = new List<CZWTFCExistingIRAPlanDTO>();
  }

  public class CustomerData {
    public String MorePages;
    public String NextPageCursor;
  }
}