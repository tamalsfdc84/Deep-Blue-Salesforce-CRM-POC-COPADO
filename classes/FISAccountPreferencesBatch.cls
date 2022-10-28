/**
 * Copyright (c) 2019 Terafina Inc
 *
 * @description CZWTFC E-Statement Registration Integration Batch job
 * @group Job
 */

global inherited sharing class FISAccountPreferencesBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  private static boolean testException = false;

  global List<tffa__Application__c> start(Database.BatchableContext bc) {
    List<String> addOnServiceODTypes = new List<String>{
      FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE,
      FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE
    };
    List<tffa__Application__c> appLst = new List<tffa__Application__c>();
    appLst = CZWTFCApplicationRepository.findAppwithChildsForAccountPref();
    tffa.Logger.flush();
    return appLst;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObject) {
    List<tffa__Application__c> appList = (List<tffa__Application__c>) subObject;
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    tffa.Interaction.begin(FISAccountPreferencesBatch.class, 'execute');
    try {
      tffa.Logger.debug('FISAccountPreferencesBatch execute appList.size: ==-> ' + appList.size());
      appList = FISAccountPreferencesExecutor.processAccPrefRequest(appList);
      for (tffa__Application__c app : appList) {
        if (app.tffa__AccountPreferences__r != null) {
          accPrefList.addAll(app.tffa__AccountPreferences__r);
        }
      }
      //tffa.ApplicationAssigner appAssigner = new tffa.ApplicationAssigner();
      //appList = appAssigner.assign(appList);
      CZWTFCApplicationRepository.save(appList);
      CZWTFCApplicationRepository.save(accPrefList);
      FISCCIntegrationLogService.persistIntegationLogs();
    } catch (Exception e) {
      tffa.Logger.error('Exception in FISAccountPreferencesBatch execute : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
    } finally {
      tffa.Interaction.close();    
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('FISAccountPreferencesBatch finished ..');
    tffa.Logger.flush();
  }
}