public with sharing class CZWTFCSignersStatusDTO {
  public List<SignersDTO> signers;

  public class SignersDTO {
    public String name;
    public String email;
    public String recipientId;
    public String clientUserId;
    public String routingOrder;
    public String status;
    public String completedCount;
  }
}