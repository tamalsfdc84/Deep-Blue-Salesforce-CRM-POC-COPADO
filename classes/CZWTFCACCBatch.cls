global with sharing class CZWTFCACCBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  String status = 'EXPIRED';
  Integer retryCount = 4;

  public Database.QueryLocator start(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('start Datetime : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
    return Database.getQueryLocator(getQuery());
  }

  public void execute(Database.BatchableContext batchableCntx, List<SObject> subObject) {
    tffa.Logger.debug('ACC execute Datetime Started on : ' + String.valueOf(Datetime.now()));
    try {
      List<tffa__Submission__c> subList = new List<tffa__Submission__c>();
      List<tffa__Submission__c> submissionList = (List<tffa__Submission__c>) subObject;
      tffa.Logger.debug('ACC Submission List : ' + submissionList);

      CZWTFCAdobeCampaignService accService = new CZWTFCAdobeCampaignService();
      subList = accService.processExpiredSubmissions(submissionList);

      if (!Test.isRunningTest()) {
        CZWTFCSubmissionRepository.save(subList);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in ACC :::' + ex.getStackTraceString() + 'LineNumber :::' + ex.getLineNumber());
    } finally {
      tffa.Logger.flush();
    }
    tffa.Logger.debug('ACC execute Datetime Ended on  : ' + String.valueOf(Datetime.now()));
  }

  public void finish(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('ACC execute Completed at  : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
  }

  private static String getQuery() {
    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Status__c', '= :status')
      .opAnd()
      .whereClause('IsAccTransferred__c', '= false')
      .opAnd()
      .whereClause('AdobeCampaignRetryCount__c', '< :retryCount')
      .build()
      .toQuery();

    tffa.Logger.debug(query);
    return query;
  }
}