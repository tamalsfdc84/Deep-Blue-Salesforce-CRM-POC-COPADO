public with sharing class CZSDBVacantBoxResponse extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZSDBVacantBoxResponse() {
    this.entity = new Entity();
  }

  public class Entity {
    public SDBControlData sdbControlData;
    public List<CZSDBVacantBoxDTO> sdbVacantBox;
    public Entity() {
      this.sdbControlData = new SDBControlData();
      this.sdbVacantBox = new List<CZSDBVacantBoxDTO>();
    }
  }

  public class SDBControlData {
    public String MoreInd;
    public String RepositionBox;
  }
}