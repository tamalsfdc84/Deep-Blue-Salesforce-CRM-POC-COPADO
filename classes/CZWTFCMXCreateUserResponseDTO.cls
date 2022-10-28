public class CZWTFCMXCreateUserResponseDTO {
  public class User {
    public String id;
    public String birthdate;
    public String gender;
    public Object logged_in_at;
    public Integer credit_score;
    public String email;
    public String first_name;
    public String guid;
    public Boolean is_disabled;
    public String last_name;
    public String metadata;
    public String phone;
    public String zip_code;
  }

  public User user;

  public Error error;

  public class Error {
    public Object code;
    public String message;
  }

  public static CZWTFCMXCreateUserResponseDTO parse(String json) {
    return (CZWTFCMXCreateUserResponseDTO) System.JSON.deserialize(json, CZWTFCMXCreateUserResponseDTO.class);
  }
}