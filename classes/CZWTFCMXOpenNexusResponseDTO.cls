public with sharing class CZWTFCMXOpenNexusResponseDTO {
  public Session session;

  public class Session {
    public String token;
  }

  public Error error;

  public class Error {
    public Object code;
    public String message;
  }

  public static CZWTFCMXOpenNexusResponseDTO parse(String json) {
    return (CZWTFCMXOpenNexusResponseDTO) System.JSON.deserialize(json, CZWTFCMXOpenNexusResponseDTO.class);
  }
}