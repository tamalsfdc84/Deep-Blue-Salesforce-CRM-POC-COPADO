public with sharing class FISCCMultiAccDebitCardCreationResDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCMultiAccDebitCardCreationResDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public MultipleAaccountsParameters multipleAaccountsParameters;
    public List<MultipleAccountsNewLst> multipleAccountsNewLst;
    public Entity() {
      this.multipleAaccountsParameters = new MultipleAaccountsParameters();
      this.multipleAccountsNewLst =  new List<MultipleAccountsNewLst>();
    }
  }

  public class MultipleAaccountsParameters{
    public String CrdNbr;
  }

  public class MultipleAccountsNewLst{
    public String AcctTyp;
    public Integer AcctNbr; 
  }
}