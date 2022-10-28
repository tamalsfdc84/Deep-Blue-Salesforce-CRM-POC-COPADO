public with sharing class CZWTFCMXReadMemberAccountRespDTO {
  public class Account {
    public String account_number_set_by_name;
    public String account_type_set_by_name;
    public String available_balance_set_by_name;
    public String balance_set_by_name;
    public String currency_code_set_by_name;
    public Object death_benefit_set_by_name;
    public String feed_account_type_name;
    public String name_set_by_name;
    public String account_number;
    public Integer account_number_set_by;
    public Integer account_type;
    public String account_type_name;
    public Integer account_type_set_by;
    public Double available_balance;
    public Integer available_balance_set_by;
    public Double balance;
    public Integer balance_set_by;
    public String created_at;
    public String currency_code;
    public Integer currency_code_set_by;
    public String external_guid;
    public String feed_account_number;
    public Integer feed_account_type;
    public Double feed_available_balance;
    public Double feed_balance;
    public String feed_currency_code;
    public String feed_name;
    public String routing_number;
    public String guid;
    public String institution_guid;
    public Boolean is_closed;
    public Boolean is_hidden;
    public Boolean is_manual;
    public String member_guid;
    public Boolean member_is_managed_by_user;
    public String metadata;
    public String name;
    public Integer name_set_by;
    public Integer revision;
    public String updated_at;
    public String user_guid;
  }

  public Account account;

  public Error error;

  public class Error {
    public Object code;
    public String message;
  }

  public static CZWTFCMXReadMemberAccountRespDTO parse(String json) {
    return (CZWTFCMXReadMemberAccountRespDTO) System.JSON.deserialize(json, CZWTFCMXReadMemberAccountRespDTO.class);
  }
}