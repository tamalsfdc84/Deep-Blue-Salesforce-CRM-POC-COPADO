global with sharing class CZWTFCIRAService {
  global CZWTFCIRAService() {
  }

  public CZWTFCExistingIRAPlanResponse fetchIRAPlans(Map<String, Object> params) {
    CZWTFCExistingIRAPlanResponse result = new CZWTFCExistingIRAPlanResponse();
    try {
      FISCCIntegrationLogService.setSubmissionObj((String) params.get('submissionId'));
      FISCCIntegrationLogService.setIntegrationLog((String) params.get('submissionId'));

      //fetch access token
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      result = CZWTFCIRAProvider.fetchExistingIRAPlan((String) params.get('ssn'), FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAService :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }
    return result;
  }

  public CZWTFCIRAPlanBeneficiaryResponse FetchIRABeneficiary(Map<String, Object> params) {
    CZWTFCIRAPlanBeneficiaryResponse result = new CZWTFCIRAPlanBeneficiaryResponse();
    try {
      FISCCIntegrationLogService.setSubmissionObj((String) params.get('submissionId'));
      FISCCIntegrationLogService.setIntegrationLog((String) params.get('submissionId'));

      //fetch access token
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      result = CZWTFCIRAProvider.fetchExistingIRAPlanBeneficiary((String) params.get('PlnNbr'), FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAService :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }
    return result;
  }

  public CZWTFCIRAPlanDetailsResponse fetchIRAPlanDetails(Map<String, Object> params) {
    CZWTFCIRAPlanDetailsResponse result = new CZWTFCIRAPlanDetailsResponse();
    try {
      FISCCIntegrationLogService.setSubmissionObj((String) params.get('submissionId'));
      FISCCIntegrationLogService.setIntegrationLog((String) params.get('submissionId'));

      //fetch access token
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      result = CZWTFCIRAProvider.fetchIRAPlanDetails((String) params.get('PlnNbr'), FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAService :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }
    return result;
  }
}