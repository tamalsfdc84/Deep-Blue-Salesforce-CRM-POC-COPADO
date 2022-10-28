public inherited sharing class CZWTFCPrintRequestDTO {
  public PrintRequest PrintRequest;

  public inherited sharing class PrintRequest {
    public CheckData CheckData;
    public PrintRequest() {
      this.CheckData = new CheckData();
      this.CheckData.ItemTypeName = 'StarterCheck';
    }
  }

  public inherited sharing class CheckData {
    public String JobID;
    public String ItemTypeName;
    public String CustomerData01;
    public String CustomerData02;
    public String CustomerData03;
    public String CustomerData04;
    public String CustomerData05;
    public Decimal CheckNumber01;
    public Decimal CheckNumber02;
    public Decimal CheckNumber03;
    public String BranchID;
    public String RoutingNumber;
    public String AccountNumber;
    public String UserID;

    public CheckData() {
    }
  }

  public CZWTFCPrintRequestDTO() {
    this.PrintRequest = new PrintRequest();
  }

  public static String requestBody(CZWTFCPrintRequestDTO obj) {
    return JSON.Serialize(obj, true);
  }
}