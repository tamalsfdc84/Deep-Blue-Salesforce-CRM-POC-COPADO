public with sharing class CZAccNbrGenerationRequestDTO extends FISCCRequestBaseDTO {
  public CZAccNbrGenerationRequestDTO() {
    this.accnbr = new AccountNbr();
  }
  public AccountNbr accnbr;

  public class AccountNbr {
    public String DPAcctBrnch;
    public String DPAcctTyp;
  }
}