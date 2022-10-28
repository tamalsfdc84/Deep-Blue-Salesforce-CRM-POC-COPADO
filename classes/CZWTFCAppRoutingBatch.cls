/**
 * Copyright (c) 2019 Terafina Inc
 *
 * @description CZWTFC Application Routing Batch job
 * @group Job
 */

global inherited sharing class CZWTFCAppRoutingBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  private static boolean testException = false;

  global List<tffa__Application__c> start(Database.BatchableContext bc) {
    List<tffa__Application__c> appLst = new List<tffa__Application__c>();
    appLst = CZWTFCApplicationRepository.findAppsToRoute();
    tffa.Logger.debug('CZWTFCAppRoutingBatch started with size ==-> ' + appLst.size());
    tffa.Logger.flush();
    return appLst;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObject) {
    List<tffa__Application__c> appList = (List<tffa__Application__c>) subObject;
    try {
      tffa.Logger.debug('CZWTFCAppRoutingBatch execute appList.size: ==-> ' + appList.size());
      for (tffa__Application__c app : appList) {
        CZWTFCAppRoutingService.routeApplicationAndRaiseEvent(app);
      }
    } catch (Exception e) {
      tffa.Logger.error('Exception in CZWTFCAppRoutingBatch execute : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
      tffa.Logger.flush();
    } finally {
      tffa.Logger.flush();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCAppRoutingBatch finished ..');
    tffa.Logger.flush();
  }
}