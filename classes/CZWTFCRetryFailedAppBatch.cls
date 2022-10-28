/**
 * Copyright (c) 2019 Terafina Inc
 *
 * @description CZWTFC Retry Opening Failed Applications Batch
 * @group Job
 */

global inherited sharing class CZWTFCRetryFailedAppBatch extends tffa.AbstractBatchJob implements Database.Batchable<SObject>, Database.AllowsCallouts {
  @TestVisible
  private static boolean calledFromTestCls = false;
  global List<tffa__Submission__c> start(Database.BatchableContext bc) {
    List<String> subIDList = new List<String>();
    List<tffa__Application__c> appLst = new List<tffa__Application__c>();
    List<tffa__Submission__c> submissionList = new List<tffa__Submission__c>();
    appLst = CZWTFCApplicationRepository.findAppforFailedAppBatch();

    for (tffa__Application__c app : appLst) {
      if (app.tffa__Submission__c != null) {
        if (
          app.tffa__LinkedFundingRequests__r != null &&
          !app.tffa__LinkedFundingRequests__r.isEmpty() &&
          app.tffa__LinkedFundingRequests__r[0].tffa__VerificationStatus__c != 'PENDING_MANUAL_VERIFICATION'
        ) {
          subIDList.add(app.tffa__Submission__c);
        } else if (app.tffa__LinkedFundingRequests__r == null || app.tffa__LinkedFundingRequests__r.isEmpty()) {
          subIDList.add(app.tffa__Submission__c);
        }
      }
    }
    if (!subIDList.isEmpty()) {
      submissionList = CZWTFCSubmissionRepository.findSubByIds(subIDList);
    }
    if (Test.isRunningTest() && calledFromTestCls) {
      List<tffa__Submission__c> subTest = CZWTFCSubmissionRepository.findtestSubmission();
      submissionList.addAll(subTest);
    }
    tffa.Logger.flush();
    return submissionList;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObject) {
    tffa.Interaction.begin(CZWTFCRetryFailedAppBatch.class, 'execute');
    try {
      List<tffa__Submission__c> submissionList = (List<tffa__Submission__c>) subObject;
      FISCCIntegrationLogService.isBatchSource = true;
      for (tffa__Submission__c sub : submissionList) {
        if (CZWTFCConstants.SUBMITTED.equals(sub.tffa__Status__c)) {
          FISCCSubmissionExecutor.processApplication(sub.Id);
        }
      }
    } catch (Exception e) {
      tffa.Logger.error('Exception in CZWTFCRetryFailedAppBatch execute : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
      tffa.Logger.flush();
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    CZWTFCAppRoutingBatch batch = new CZWTFCAppRoutingBatch();
    ID id = Database.executeBatch(batch, 1);
    tffa.Logger.debug('CZWTFCRetryFailedAppBatch finished ..');
    tffa.Logger.flush();
  }
}