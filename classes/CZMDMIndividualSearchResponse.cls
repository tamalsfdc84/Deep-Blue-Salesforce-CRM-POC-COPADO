public with sharing class CZMDMIndividualSearchResponse {
  public CZMDMIndividualSearchResponse() {
    this.individualInfoLst = new List<IndInfo>();
  }

  public String status;
  public Integer firstRecord;
  public Integer pageSize;
  public Integer totalRecords;
  public Integer pageNumber;
  public Integer totalPages;
  public List<IndInfo> individualInfoLst;
  public String errorCode;
  public String nextCISStartNumber;
  public String previousCISStartNumber;

  public class IndInfo {
    public String firstName;
    public String lastName;
    public String SSN;
    public String addressLine1;
    public String city;
    public String state;
    public String zip4Cd;
    public String zip5Cd;
    public String countryName;
    public String countryCode;
    public String phoneNumber;
    public String mdmPartyId;
  }
}