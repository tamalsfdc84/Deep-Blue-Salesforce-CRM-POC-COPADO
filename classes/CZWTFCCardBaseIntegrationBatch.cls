/**
 * Copyright (c) 2019 Terafina Inc
 *
 * @description CZWTFC Debit Card Base Integration Batch job
 * @group Job
 */

global inherited sharing class CZWTFCCardBaseIntegrationBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  private static boolean testException = false;

  global List<tffa__Application__c> start(Database.BatchableContext bc) {
    List<tffa__Application__c> appLst = new List<tffa__Application__c>();
    appLst = CZWTFCApplicationRepository.findAppwithChildsforCB();
    tffa.Logger.flush();
    return appLst;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> appObjList) {
    List<tffa__Application__c> appList = (List<tffa__Application__c>) appObjList;
    tffa__Application__c appObj = appList[0];
    tffa.Interaction.begin(CZWTFCCardBaseIntegrationBatch.class, 'execute');
    try {
      FISCCIntegrationLogService.setSubmissionObj(appObj.tffa__Submission__c);
      FISCCIntegrationLogService.setPartyObjs();
      FISCCIntegrationLogService.setApplicationObjs();
      FISCCIntegrationLogService.setCharterConfig(appObj.tffa__Brand__c);
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(appObj.tffa__Submission__c));
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      FISCCIntegrationLogService.isBatchSource = true;

      for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
        FISCCIntegrationLogService.applicationObjMap.put(app.Id, app);
      }

      for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
        if (app.Id == appObj.Id) {
          FISCCCardBaseIntegrationExecutor.processDebitCardRequest(app);
        }
      }
    } catch (Exception e) {
      tffa.Logger.error('Exception in CZWTFCCardBaseIntegrationBatch execute : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
    } finally {
      try {
        FISCCIntegrationLogService.persistData();
      } finally {
        tffa.Interaction.close();
      }
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCCardBaseIntegrationBatch finished ..');
    tffa.Logger.flush();
  }
}