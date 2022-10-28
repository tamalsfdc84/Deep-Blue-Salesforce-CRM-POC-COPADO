public with sharing class FISCCCEBEnrollmentResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCCEBEnrollmentResponseDTO() {
    this.Enrollment = new Enrollment();
  }

  public Enrollment Enrollment;

  public class Enrollment {
    public Enrollment() {
      this.BankInfo = new BankInfo();
    }
    Boolean EnrollmentPendingIndicator;
    BankInfo BankInfo;
  }

  public class BankInfo {
    String feId;
  }

  public static FISCCCEBEnrollmentResponseDTO parse(String json) {
    return (FISCCCEBEnrollmentResponseDTO) System.JSON.deserialize(json, FISCCCEBEnrollmentResponseDTO.class);
  }
}