public with sharing class FISCCMultiAccDebitCardCreationRequestDTO {
  public String CrdNbr;
  public String InstnNbr;
  public List<MultipleAccountsNewLst> debitCardmultipleAccountsNewLst;

  public FISCCMultiAccDebitCardCreationRequestDTO() {
    this.debitCardmultipleAccountsNewLst =  new List<MultipleAccountsNewLst>();
  }

  public class MultipleAccountsNewLst{
    public String AcctTyp;
    public String AcctNbr; 
  }
}