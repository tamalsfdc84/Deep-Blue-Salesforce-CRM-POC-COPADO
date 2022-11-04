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
    appLst = filterApps(appLst);
    tffa.Logger.flush();
    return appLst;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> appListObject) {
    List<tffa__Application__c> appList = (List<tffa__Application__c>) appListObject;
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    tffa.Interaction.begin(FISAccountPreferencesBatch.class, 'execute');
    try {
      tffa.Logger.debug('FISAccountPreferencesBatch execute appList.size: ==-> ' + appList.size());
      appList = FISAccountPreferencesExecutor.processAccPrefRequest(appList);

      //tffa.ApplicationAssigner appAssigner = new tffa.ApplicationAssigner();
      //appList = appAssigner.assign(appList);
      tffa.Logger.debug('HEEEREEEEE ' + appList[0].OwnerId);
      tffa__Application__c updatedApp = new tffa__Application__c();
      updatedApp.AccountPreference__c = appList[0].AccountPreference__c;
      updatedApp.AccPrefRetryCount__c = appList[0].AccPrefRetryCount__c;
      updatedApp.Id = appList[0].Id;
      updatedApp.OwnerId = appList[0].OwnerId;
      CZWTFCApplicationRepository.save(new List<tffa__Application__c>{ updatedApp });
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

  public static List<tffa__Application__c> filterApps(List<tffa__Application__c> apps) {
    List<tffa__Application__c> updatedAppList = new List<tffa__Application__c>();
    for (tffa__Application__c app : apps) {
      if (CZWTFCCommonHelper.isCertificateProduct(app)) {
        if (app.tffa__Status__c == 'FUNDED') {
          updatedAppList.add(app);
        }
      } else {
        updatedAppList.add(app);
      }
    }
    return updatedAppList;
  }
}