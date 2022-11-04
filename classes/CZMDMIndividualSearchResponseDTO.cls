public with sharing class CZMDMIndividualSearchResponseDTO extends CZMDMResponseBaseDTO {
  public CZMDMIndividualSearchResponseDTO() {
    this.individualInfo = new List<IndInfo>();
  }
  public Integer first_record;
  public Integer page_size;
  public Integer total_record_count;
  public List<IndInfo> individualInfo;
  public String errorCode;

  public class IndInfo {
    public String frstNm;
    public String lstNm;
    public String ssnNum;
    public String address1;
    public String cityNm;
    public String stateCd;
    public String zip4Cd;
    public String zip5Cd;
    public String countryNm;
    public String countryCd;
    public String phoneNum;
    public String mdmPartyId;
  }
}