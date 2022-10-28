public inherited sharing class CZBrandResponseDTO {
  public tffa__Brand__c Brand;
  public List<tffa__Location__c> Locations;
  public List<CZOfficerDetails__c> Officers;
  public List<String> CostCenterList;

  public CZBrandResponseDTO() {
    Brand = new tffa__Brand__c();
    Locations = new List<tffa__Location__c>();
    Officers = new List<CZOfficerDetails__c>();
  }
}