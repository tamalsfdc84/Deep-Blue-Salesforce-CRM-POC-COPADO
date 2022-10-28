global inherited sharing class CZWTFCFCMDocumentUploadBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public static List<String> statuses = new List<String>{ 'FUNDED', 'ACCOUNT_OPENED' };
  public static Integer retryCount = (Integer) CZWTFCHelperRepository.fetchWintrustEnvConfig().BatchRetryCount__c;
  public static List<String> fcmStatus = new List<String>{ CZWTFCConstants.PROCESS_STATUS_SUCCESS };
  public static List<tffa__Submission__c> submissionLst = new List<tffa__Submission__c>();

  global List<tffa__Application__c> start(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch Start');
    List<tffa__Application__c> appLst = CZWTFCApplicationRepository.fetchApplicationsForFCM(statuses, retryCount, fcmStatus);
    List<tffa__Application__c> filteredApps = filterApps(appLst);
    tffa.Logger.flush();
    return filteredApps;
  }

  global void execute(Database.BatchableContext batchableContext, List<tffa__Application__c> applications) {
    tffa.Interaction.begin(CZWTFCFCMDocumentUploadBatch.class, 'execute');
    try {
      tffa__Application__c application = applications[0];

      tffa__Application__c app = FCMIntegrationExecutor.processRequest(application);

      CZWTFCApplicationRepository.save(new List<tffa__Application__c>{ app });
    } catch (Exception ex) {
      tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch finish()');
    tffa.Logger.flush();
  }

  private static List<tffa__Application__c> filterApps(List<tffa__Application__c> appLst) {
    List<tffa__Application__c> filterApplications = new List<tffa__Application__c>();
    for (tffa__Application__c appObj : appLst) {
      if (appObj.tffa__Submission__r != null && appObj.tffa__Submission__r.DisclosureConverted__c) {
        filterApplications.add(appObj);
      }
    }

    return filterApplications;
  }
}