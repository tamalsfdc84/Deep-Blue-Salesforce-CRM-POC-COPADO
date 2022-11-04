public with sharing class CZMDMBusinessCustSearchResponse {
  public CZMDMBusinessCustSearchResponse() {
    this.organizationInfo = new List<OrgInfo>();
  }

  public String status;
  public Integer firstRecord;
  public Integer pageSize;
  public Integer totalRecords;
  public Integer pageNumber;
  public Integer totalPages;
  public List<OrgInfo> organizationInfo;
  public String nextCISStartNumber;
  public String previousCISStartNumber;

  public class OrgInfo {
    public String mdmPartyId;
    public String businessName;
    public String SSN;
    public String addressLine1;
    public String city;
    public String state;
    public String countryName;
    public String countryCode;
    public String zip5Cd;
    public String zip4Cd;
    public String phoneNumber;
    public String BusinessType;
    public String BusinessDescription;
  }
}