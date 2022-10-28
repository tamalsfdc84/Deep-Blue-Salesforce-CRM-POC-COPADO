global with sharing class CZFetchDocusignDocumentBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  List<tffa__Submission__c> subList;
  global List<tffa__Disclosure__c> start(Database.BatchableContext bc) {
    subList = CZWTFCSubmissionRepository.fetchSubmissionswithDisc();
    List<tffa__Disclosure__c> discList = new List<tffa__Disclosure__c>();
    //discList = updateSubmissionDownloadStatus(subList, 'FilterDisclosures');
    for (tffa__Submission__c subObj : subList) {
      discList.addAll(subObj.tffa__Disclosures__r);
    }
    if (Test.isRunningTest()) {
      discList = CZWTFCSubmissionRepository.findtestSubmission()[0].tffa__Disclosures__r;
    }
    return discList;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObjectList) {
    tffa.Interaction.begin(CZFetchDocusignDocumentBatch.class, 'execute');
    List<tffa__Disclosure__c> discList = (List<tffa__Disclosure__c>) subObjectList;
    try {
      CZDocusignDocumentExtension.fetchAndSaveDocument(discList);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in downloading docs ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
    tffa.Logger.flush();
  }

  global void finish(Database.BatchableContext batchableContext) {
    List<Id> ids = new List<Id>();
    for (tffa__Submission__c sub : subList) {
      ids.add(sub.Id);
    }
    List<tffa__Submission__c> updatedSubList = CZWTFCSubmissionRepository.fetchSubmissionswithDiscById(ids);
    updateSubmissionDownloadStatus(updatedSubList);
  }

  public static List<tffa__Disclosure__c> updateSubmissionDownloadStatus(List<tffa__Submission__c> subList) {
    List<tffa__Disclosure__c> discList = new List<tffa__Disclosure__c>();
    List<tffa__Submission__c> updatedSubList = new List<tffa__Submission__c>();
    for (tffa__Submission__c subObj : subList) {
      boolean isDownloadPending = false;
      for (tffa__Disclosure__c disc : subObj.tffa__Disclosures__r) {
        if (disc.tffa__ProcessState__c != 'Downloaded') {
          isDownloadPending = true;
        }
      }
      tffa__Submission__c sub = new tffa__Submission__c();
      sub.Id = subObj.Id;
      if (!isDownloadPending) {
        sub.CZDocusignDownloadStatus__c = CZWTFCConstants.COMPLETED;
      } else {
        sub.CZDocusignDownloadRetryCount__c = subObj.CZDocusignDownloadRetryCount__c + 1;
      }
      updatedSubList.add(sub);
    }
    WTFCObjectManagerRepository.doUpsertObjects(updatedSubList);

    return discList;
  }
}