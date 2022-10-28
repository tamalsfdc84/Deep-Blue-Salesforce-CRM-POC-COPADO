public with sharing class CZWTFCMXFetchMemberAccountResponseDTO {
  public List<Account_numbers> account_numbers;
  public List<Account_verifications> account_verifications;

  public class Account_numbers {
    public String guid;
    public String user_guid;
    public String member_guid;
    public String account_guid;
    public String account_number;
    public String routing_number;
    public Object transit_number;
    public Object institution_number;
  }

  public class Account_verifications {
    public String account_name;
    public String account_number_guid;
    public String created_at;
    public String updated_at;
    public Integer account_type;
    public String member_guid;
    public String account_number;
    public String account_type_name;
    public String micro_deposit_guid;
    public String routing_number;
    public Integer micro_deposit_status;
    public String micro_deposit_status_name;
    public Integer verification_method;
    public String verification_method_name;
  }

  public Error error;

  public class Error {
    public Object code;
    public String message;
  }

  public static CZWTFCMXFetchMemberAccountResponseDTO parse(String json) {
    return (CZWTFCMXFetchMemberAccountResponseDTO) System.JSON.deserialize(json, CZWTFCMXFetchMemberAccountResponseDTO.class);
  }
}