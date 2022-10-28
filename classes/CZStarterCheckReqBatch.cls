public inherited sharing class CZStarterCheckReqBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public List<tffa__Application__c> start(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZStarterCheckReqBatch start() method');
    List<tffa__Application__c> listApplication = CZWTFCApplicationRepository.getApplicationByCheck();
    return listApplication;
  }

  public void execute(Database.BatchableContext batchableContext, List<tffa__Application__c> listApplication) {
    tffa.Logger.debug('CZStarterCheckReqBatch execute() method');
    try {
      tffa__Application__c app = listApplication.isEmpty() ? new tffa__Application__c() : listApplication[0];
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));
      tffa.Logger.debug('CZStarterCheckReqBatch execute() method : app => ' + app);
      CZStarterCheckExecutor.processRequest(app);
    } catch (Exception ex) {
      tffa.Logger.error('CZStarterCheckReqBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistData();
    }
  }

  public void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZStarterCheckReqBatch finish() method');
  }
}