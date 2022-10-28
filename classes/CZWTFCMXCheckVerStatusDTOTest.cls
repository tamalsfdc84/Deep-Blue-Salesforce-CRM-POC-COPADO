@isTest
public with sharing class CZWTFCMXCheckVerStatusDTOTest {
  @isTest
  static void testChexRequest() {
    Test.startTest();
    CZWTFCMXCheckVerificationStatusRespDTO dto = new CZWTFCMXCheckVerificationStatusRespDTO();
    String json = '{"member":{"aggregated_at":"12345","connection_status":"pass"}}';

    CZWTFCMXCheckVerificationStatusRespDTO.parse(json);
    CZWTFCMXCreateUserResponseDTO.parse(json);
    Test.stopTest();
  }
}