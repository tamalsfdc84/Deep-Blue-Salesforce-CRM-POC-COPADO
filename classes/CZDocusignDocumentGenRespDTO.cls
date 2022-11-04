public with sharing class CZDocusignDocumentGenRespDTO {
  public List<CZDocusignDocumentGenDTO> lstDocuments = new List<CZDocusignDocumentGenDTO>();
  public RecipientViewRequestDTO recipientView;
  //List of signers who will sign at branch
  public Map<String, CZDocusignDocumentGenDTO.SignerDTO> branchSigners = new Map<String, CZDocusignDocumentGenDTO.SignerDTO>();
  public Id submissionId;
  public Boolean signByEmail = false;

  public class RecipientViewRequestDTO {
    public String authenticationMethod = 'email';
    public String email;
    public String returnUrl;
    public String userName;
    public String clientUserId;
    public String recipientId;
    public String roleName;
  }
}