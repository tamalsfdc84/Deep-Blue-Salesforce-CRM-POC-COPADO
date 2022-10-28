public with sharing class FISCCDOPhoneNumberRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOPhoneNumberRequest() {
    this.custPhoneNumber = new FISCCPhoneNumber();
  }
  public FISCCPhoneNumber custPhoneNumber;
  public class FISCCPhoneNumber {
    public FISCCPhoneNumber() {
      this.phoneNumLst = new List<FISCCCreatePhoneNumberDTO>();
    }
    public String CustNbr;
    public List<FISCCCreatePhoneNumberDTO> phoneNumLst;
  }
}