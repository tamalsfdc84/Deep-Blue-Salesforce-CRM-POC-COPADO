public with sharing class CZWTFCMXCreateUserService {
  public static CZWTFCMXCreateUserResponseDTO createUser(Map<String, String> params) {
    CZWTFCMXCreateUserResponseDTO responseObj;
    try {
      String requestBody = buildCreateUserRequest(params);

      HttpResponse response;
      if (String.isNotBlank(requestBody)) {
        response = CZWTFCMXCreateUserAdapter.execute(requestBody);

        if (response != null && String.isNotBlank(response.getBody()) && !(response.getStatus()).equalsIgnoreCase('Forbidden')) {
          responseObj = parseResponse(response.getBody());
        }
      }
      return responseObj;
    } catch (Exception ex) {
      return responseObj;
    }
  }

  public static String generateCreateUserReqBody(Map<String, String> params) {
    HttpRequest req = new HttpRequest();
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeFieldName('user');
    gen.writeStartObject();
    gen.writeStringField('birthdate', params.get('birthdate'));
    // gen.writeStringField('credit_score', params.get('credit_score'));
    gen.writeStringField('email', params.get('email'));
    gen.writeStringField('first_name', params.get('first_name'));
    // gen.writeStringField('gender', params.get('gender'));
    gen.writeStringField('id', params.get('id'));
    gen.writeStringField('last_name', params.get('last_name'));
    // gen.writeStringField('metadata', params.get('metadata'));
    gen.writeStringField('phone', params.get('phone'));
    gen.writeStringField('zip_code', params.get('zip_code'));
    gen.writeEndObject();

    String jsonFormattedRequest = gen.getAsString();
    req.setbody(jsonFormattedRequest);
    return req.getBody();
  }

  public static String buildCreateUserRequest(Map<String, String> params) {
    String body = CZWTFCMXCreateUserService.generateCreateUserReqBody(params);
    return body;
  }

  public static CZWTFCMXCreateUserResponseDTO parseResponse(String reponseBody) {
    CZWTFCMXCreateUserResponseDTO responseDTO = (CZWTFCMXCreateUserResponseDTO) JSON.deserialize(
      reponseBody,
      CZWTFCMXCreateUserResponseDTO.class
    );
    return responseDTO;
  }
}