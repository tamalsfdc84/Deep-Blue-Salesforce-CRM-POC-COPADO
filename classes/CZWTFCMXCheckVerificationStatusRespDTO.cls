public with sharing class CZWTFCMXCheckVerificationStatusRespDTO {
  public Member member;

  public class Member {
    public String aggregated_at;
    public String connection_status;
    public Integer connection_status_id;
    public String connection_status_message;
    public Object external_guid;
    public String guid;
    public String institution_guid;
    public Boolean is_being_aggregated;
    public Boolean is_managed_by_user;
    public Boolean is_manual;
    public Boolean is_user_created;
    public String metadata;
    public String most_recent_job_guid;
    public String name;
    public Boolean needs_updated_credentials;
    public Integer revision;
    public String successfully_aggregated_at;
    public String user_guid;
  }

  public Error error;

  public class Error {
    public Object code;
    public String message;
  }

  public static CZWTFCMXCheckVerificationStatusRespDTO parse(String json) {
    return (CZWTFCMXCheckVerificationStatusRespDTO) System.JSON.deserialize(json, CZWTFCMXCheckVerificationStatusRespDTO.class);
  }
}