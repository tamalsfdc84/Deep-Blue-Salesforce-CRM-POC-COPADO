public with sharing class CZWTFCDocusignResponseDTO {
  public CZWTFCResultStatus status;
  public String statusMsg;
  public String httpStatus;

  public LoginResponseDTO lgnResp;

  public EnvelopeResponseDTO envelopeResp;

  public RecipientViewResponseDTO recipientViewResp;

  public EnvelopeStatusResponseDTO envelopeStatusResp;

  public CZWTFCSignersStatusDTO signersStatus;
  public CZWTFCDocusignResponseDTO() {
    this.lgnResp = new LoginResponseDTO();
    status = CZWTFCResultStatus.Warning;
    statusMsg = 'Result Message Not updated in Response';
  }

  public class LoginResponseDTO {
    public LoginResponseDTO() {
      this.loginAccounts = new List<LoginAccountDTO>();
    }

    public List<LoginAccountDTO> loginAccounts;
  }

  public class LoginAccountDTO {
    public String name;
    public String accountId;
    public String baseUrl;
    public String userId;
  }

  public class EnvelopeResponseDTO {
    public String envelopeId;
    public String uri;
  }

  public class RecipientViewResponseDTO {
    public String url;
  }

  public class EnvelopeStatusResponseDTO {
    public String status;
  }
}