public inherited sharing class FISCCCEBEnrollmentExtension {
  // request DTO object
  public static FISCCCEBEnrollmentRequestDTO objFISCCCEBEnrollmentRequestDTO = new FISCCCEBEnrollmentRequestDTO();
  @TestVisible
  private static boolean testException = false;
  public static Object invokeCEBEnroll(
    Map<String, Object> params,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    boolean isCEBEnrollSuccess = null;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (params != null && !params.isEmpty()) {
        fisccRequestBaseDTO = generateCEBEnrollRequest(params, adapterConfig, charterConfig);
        tffa.Logger.debug('generateCEBEnrollRequest is called');
      } else {
        tffa.Logger.debug('generateCEBEnrollRequest is called with null params****');
      }

      //TODO result handling
      //tffa.logger.debug('generateCEBEnrollRequest req :: ' + fisccRequestBaseDTO);
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      tffa.Logger.debug('result in invokeCEBEnroll ==>' + result);
      tffa.Logger.debug('HostAdapter is called');

      return result;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeCEBEnroll : ' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
  }

  // creates request object for CEB Enroll call
  public static FISCCRequestBaseDTO generateCEBEnrollRequest(
    Map<String, Object> params,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('Inside generateCEBEnrollRequest method');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    tffa__Party__c partyObj = (tffa__Party__c) params.get('partyObj');
    tffa.logger.debug('partyObj in generateCEBEnrollRequest ==>' + partyObj);

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (partyObj != null) {
        tffa.Logger.debug('inside party not null ');
        // setting userInfo
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.userType = 'Individual'; //partyObj.tffa__Type__c;
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.lastName = partyObj.tffa__LastName__c;
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.emailType = 'Primary';
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.emailAddress = partyObj.tffa__PrimaryEmail__c;
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.taxId = partyObj.tffa__NationalIdentifierValue__c;
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.ipId = partyObj.Customer_Number__c;
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.userId = (String) params.get('userName');
        objFISCCCEBEnrollmentRequestDTO.enrollment.userInfo.password = (String) params.get('password');

        objFISCCCEBEnrollmentRequestDTO.enrollment.bankInfo.feId = partyObj.tffa__BrandCode__c;
        // fetching brand to get aba number
        tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(partyObj.tffa__BrandCode__c);
        objFISCCCEBEnrollmentRequestDTO.enrollment.bankInfo.abaNumber = brandObj.tffa__RoutingNumber__c;
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception into generateCEBEnrollRequest :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    //tffa.Logger.debug('generated objFISCCCEBEnrollmentRequestDTO : ==>' + objFISCCCEBEnrollmentRequestDTO);
    fisccRequestBaseDTO = objFISCCCEBEnrollmentRequestDTO;
    return fisccRequestBaseDTO;
  }
}