public inherited sharing class CZWTFCIRAProvider {
  public static CZWTFCExistingIRAPlanResponse fetchExistingIRAPlan(String taxNumber, FISCC_Charter_Config__mdt charterConfig) {
    CZWTFCExistingIRAPlanResponse result = null;
    try {
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.IRA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.IRA_EXISTING_PLAN, taxNumber, true);

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('RetirementCustomerSummary');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{TaxNbr}', FISCCCommonHelper.encrypt(taxNumber));
      
      result = CZWTFCIRAFetchCustomerPlansExtension.invokeIRAPlans(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCIRAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return result;
  }

  public static CZWTFCIRAPlanBeneficiaryResponse fetchExistingIRAPlanBeneficiary(String planNumber, FISCC_Charter_Config__mdt charterConfig) {
    CZWTFCIRAPlanBeneficiaryResponse result = null;
    try {
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.IRA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.IRA_BENEFICIARY, planNumber, true);

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('RetirementPlanBeneficiary');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{PlnNbr}', FISCCCommonHelper.encrypt(planNumber));
      
      result = CZWTFCIRAFetchBeneficiaryExtension.invokeIRAPlanBeneficiary(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCIRAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return result;
  }

  public static void createRetirementPlan(tffa__Party__c partyObj, tffa__Application__c applicationObj) {
    try {

      CZWTFCIRAPlanDetailsResponse result = fetchIRAPlanDetails(applicationObj.tffa__InvestmentPlanNumber__c, FISCCIntegrationLogService.charterConfig);

      if(result == null && !Test.isRunningTest()){
        return;
      }

      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.IRA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.IRA_UPDATE_PLAN, partyObj.Name, true);

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('NewRetirementPlan');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{PlnNbr}', FISCCCommonHelper.encrypt(applicationObj.tffa__InvestmentPlanNumber__c));
      
      CZIRACreateRetirementPlanExtension.invokeApiCall(adapterConfig, FISCCIntegrationLogService.charterConfig, applicationObj, result);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCIRAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }

  public static void addIRABeneficiary( List<tffa__Beneficiary__c> beneficiaryList, tffa__Application__c applicationObj) {
    try {
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.IRA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.IRA_NEW_BENEFICIARY, applicationObj.Id, true);

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('NewIRABeneficiary');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{PlnNbr}', FISCCCommonHelper.encrypt(applicationObj.tffa__InvestmentPlanNumber__c));
      
      CZIRAAddBeneficiaryExtension.invokeApiCall(adapterConfig, FISCCIntegrationLogService.charterConfig, beneficiaryList, applicationObj);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCIRAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }

  public static CZWTFCIRAPlanDetailsResponse fetchIRAPlanDetails(String planNumber, FISCC_Charter_Config__mdt charterConfig) {
    CZWTFCIRAPlanDetailsResponse result = null;
    try {
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.IRA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.IRA_PLAN_DETAILS, planNumber, true);

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('RetirementPlanDetails');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{PlnNbr}', FISCCCommonHelper.encrypt(planNumber));
      
      result = CZWTFCIRAFetchPlansDetailsExtension.invokeIRAPlanDetails(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCIRAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return result;
  }
}