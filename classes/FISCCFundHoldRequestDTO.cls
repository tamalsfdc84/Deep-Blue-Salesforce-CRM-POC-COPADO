public with sharing class FISCCFundHoldRequestDTO extends FISCCRequestBaseDTO {
  public FISCCFundHoldRequestDTO() {
    this.holds = new Holds();
  }

  public Holds holds;

  public class Holds {
    public String DPHldExpireDte;
    public Decimal DPHldAmt;
    public Integer DPHldTyp;
    public String DPHldDesc;
    public String DPHldOvride;
  }
}