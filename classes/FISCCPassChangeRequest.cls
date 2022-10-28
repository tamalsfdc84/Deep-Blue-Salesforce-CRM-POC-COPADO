public with sharing class FISCCPassChangeRequest extends FISCCRequestBaseDTO {
  public FISCCPassChangeRequest() {
    this.racfpass = new racfpassword();
  }

  public racfpassword racfpass;

  public class racfpassword {
    public String NewPwd;
  }
}