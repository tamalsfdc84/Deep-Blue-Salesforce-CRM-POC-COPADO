public with sharing class FISCCObjectManagerRepository extends tffa.AbstractRepository {
  public static List<tffa__Submission__c> doUpsertSubmission(tffa__Submission__c entity) {
    return doUpsert(new List<tffa__Submission__c>{ entity });
  }
  public static List<tffa__party__c> doUpsertParties(List<tffa__party__c> entities) {
    return doUpsert(entities);
  }
  public static List<IntegrationLog__c> doUpsertIntegrationLogs(List<IntegrationLog__c> entities) {
    return doUpsert(entities);
  }
  public static List<IntegrationLogItem__c> doUpsertIntegrationLogItems(List<IntegrationLogItem__c> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__application__c> doUpsertApplications(List<tffa__application__c> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__Beneficiary__c> doUpsertBeneficiarys(List<tffa__Beneficiary__c> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__FundingRequest__c> doUpsertFundingReq(List<tffa__FundingRequest__c> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__ApplicationPartyXref__c> doApplicationPartyReq(List<tffa__ApplicationPartyXref__c> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__AccountPreference__c> doUpsertAccountPrefObj(List<tffa__AccountPreference__c> entities) {
    return doUpsert(entities);
  }

  public static List<sObject> updateRecords(List<sObject> entities) {
    return doUpsert(entities);
  }
  public static List<tffa__AdditionalPreference__c> doUpsertAdditionalPrefObj(List<tffa__AdditionalPreference__c> entities) {
    return doUpsert(entities);
  }
  public static List<UploadFileHistory__c> doUpsertuploadFileHistoryObj(List<UploadFileHistory__c> entities) {
    return doUpsert(entities);
  }
}