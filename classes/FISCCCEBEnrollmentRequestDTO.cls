public inherited sharing class FISCCCEBEnrollmentRequestDTO extends FISCCRequestBaseDTO {
  public FISCCCEBEnrollmentRequestDTO() {
    this.Enrollment = new Enrollment();
  }

  public Enrollment Enrollment;
  //Enrollment object
  public class Enrollment {
    public Enrollment() {
      this.UserInfo = new UserInfo();
      this.BankInfo = new BankInfo();
    }

    public UserInfo UserInfo;
    public BankInfo BankInfo;
  }
  // Bank Info fields
  public class BankInfo {
    public String feId;
    public String abaNumber;
  }
  // User Info fields
  public class UserInfo {
    public String userType;
    public String lastName;
    public String emailType;
    public String emailAddress;
    public String taxId;
    public String ipId;
    public String userId;
    public String password;
  }
}