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
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    tffa.Interaction.begin(CZWTFCCardBaseIntegrationBatch.class, 'execute');
    try {
      appList = FISCCCardBaseIntegrationExecutor.processDebitCardRequest(appList);
      for (tffa__Application__c app : appList) {
        if (app.DebitCardIssuanceStatus__c.equalsIgnoreCase(CZWTFCConstants.PROCESS_STATUS_FAILURE))
          app.DebitCardIssueRetryCount__c = app.DebitCardIssueRetryCount__c + 1;
        if (app.tffa__AccountPreferences__r != null) {
          accPrefList.addAll(app.tffa__AccountPreferences__r);
        }
        app = CZWTFCAppRoutingService.routeApplication(app);
      }
      CZWTFCApplicationRepository.save(appList);
      CZWTFCApplicationRepository.save(accPrefList);
    } catch (Exception e) {
      tffa.Logger.error('Exception in CZWTFCCardBaseIntegrationBatch execute : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCCardBaseIntegrationBatch finished ..');
    tffa.Logger.flush();
  }
}