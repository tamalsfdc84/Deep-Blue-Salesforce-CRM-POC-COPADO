public inherited sharing class CZMDMDataUploadProvider {
  public static String processCustomerCreation(tffa__Submission__c submission, tffa__Party__c party) {
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CREATE_CUSTOMER_MDM);
    FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CREATE_CUSTOMER_MDM, party.name, true);

    return MDMCustomerCreateExtension.createCustomer(submission, party);
  }

  public static String processAccountCreation(tffa__Application__c app) {
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CREATE_ACCOUNT_MDM);
    FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CREATE_ACCOUNT_MDM, app.name, true);

    return MDMAccountCreateExtension.createAccount(app);
  }
  
  public static String processCustomerUpdate(tffa__Submission__c submission, tffa__Party__c party) {
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATE_CUSTOMER_MDM);
    FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.UPDATE_CUSTOMER_MDM, party.name, true);

    return MDMCustomerUpdateExtension.updateCustomer(submission, party);
  }
}