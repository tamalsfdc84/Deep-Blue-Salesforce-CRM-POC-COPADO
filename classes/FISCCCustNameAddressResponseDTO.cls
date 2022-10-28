public with sharing class FISCCCustNameAddressResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCCustNameAddressResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public NameAddressDto customerAddress;
    public Entity() {
      this.customerAddress = new NameAddressDto();
    }
  }

  public class NameAddressDto {
    public String cIApplNbr;
    public String cICustBnkNbr;
    public String cICurStdAddr1Cde;
    public String cICurStdAddr2Cde;
    public String cICurStdAddr3Cde;
    public String cICurStdAddr1Txt;
    public String cICurStdAddr2Txt;
    public String cICurStdAddr3Txt;
    public String cICurStdNmeCde01;
    public String cICurStdNme01;
    public String cICurNmeAppndCde;
    public String cIElementizedCty;
    public String cICurNmeAddrEffDte;
    public String cIFaxPhNbr;
    public String cIFrstNmeMidInitl;
    public String cICurLstNmeKeyFld1;
    public String cICurFrstNmeKeyFld2;
    public String cIElementizedOddEvenInd;
    public String cIPrmyPhNbr;
    public String cINmeAddrRecTyp;
    public String cISecondayPhNbr;
    public String cIElementizedSt;
    public String cIElementizedStr;
    public String cICurNmeSfxCde;
    public String cISrnme;
    public String cIMobilePhNbr;
    public String cINmeTC;
    public String cIElementizedZipCde;
    public String cICurElementizedCtry;
    public String cIPrmyPhHmFromTmeRng;
    public String cIPrmyPhHmToTmeRng;
    public String cIScndyPhHmFromTmeRng;
    public String cIScndyPhHmToTmeRng;
    public String addrOvrideInd;
    public String ovrideAddrStddization;
  }
}