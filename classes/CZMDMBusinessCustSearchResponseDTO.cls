public with sharing class CZMDMBusinessCustSearchResponseDTO extends CZMDMResponseBaseDTO {
  public CZMDMBusinessCustSearchResponseDTO() {
    this.organizationInfo = new List<OrgInfo>();
  }
  public Integer first_record;
  public Integer page_size;
  public Integer total_record_count;
  public List<OrgInfo> organizationInfo;

  public class OrgInfo {
    public String mdmPartyId;
    public String orgNm;
    public String taxId;
    public String address1;
    public String city;
    public String state;
    public String countryNm;
    public String countryCd;
    public String zip5Cd;
    //public String zip4Cd;
    public String phoneNum;
    public String phoneNumber;
    public String busTyp;
    public String busDesc;
  }
}