public with sharing class FISCCFundHoldResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCFundHoldResponseDTO() {
    this.Entity = new Entity();
  }

  public class Entity {
    public Entity() {
      this.holds = new Holds();
    }
    public Holds holds;
  }
  public Entity Entity;

  public class Holds {
    public String DPHldExpireDte;
    public Decimal DPHldAmt;
    public Integer DPHldTyp;
    public String DPHldDesc;
    public String DPHldDelInd;
    public String DPAcctNbr;
  }
}