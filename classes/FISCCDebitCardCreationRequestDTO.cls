public with sharing class FISCCDebitCardCreationRequestDTO extends FISCCRequestBaseDTO {
  public CardNew cardNew;
  public FISCCDebitCardCreationRequestDTO() {
    this.cardNew = new CardNew();
  }

  public class CardNew {
    public String CBCrdNbr;
    public String CustNbr;
    public String CBStAbbr;
    public String CBInstnNbr;
    public String CBCrdPrfxNbr;
    public String CBBrnchNbr;
    public String CBStrAddrLne1;
    public String CBStrAddrLne2;
    public String CBCtyNme;
    public String CBZIP;
    public String CBPrmyDdaAcctNbr;
    public String CBPrmySavAcctNbr;
    public String CBPrmySsn;
    public String NmeEmbossOnCard;
    public String CBShrtNmeFrst;
    public String CBShrtNmeLst;
    public String CBCrdNmeLne1;
  }
}