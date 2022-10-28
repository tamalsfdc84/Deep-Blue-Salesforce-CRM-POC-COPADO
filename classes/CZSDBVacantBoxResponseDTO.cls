public with sharing class CZSDBVacantBoxResponseDTO {
  public CZSDBVacantBoxResponseDTO(){
    this.boxData = new List<BoxData>();
    this.count = 0;
  }

  public Integer count;
  public List<BoxData> boxData;

  public class BoxData{
    public String AccountNumber;
  }
}