global inherited sharing class CZWTFCFCMDocumentUploadBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public static List<String> statuses = new List<String>{ 'FUNDED', 'ACCOUNT_OPENED' };
  public static Integer retryCount = 20;
  public static List<String> fcmStatus = new List<String>{ CZWTFCConstants.PROCESS_STATUS_SUCCESS };
  public static List<tffa__Submission__c> submissionLst = new List<tffa__Submission__c>();

  global List<tffa__Submission__c> start(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch Start');
    List<tffa__Submission__c> subLst = CZWTFCSubmissionRepository.fetchSubmissionssForFCM(retryCount, fcmStatus);
    List<tffa__Submission__c> filteredSubs = filterSubs(subLst);
    tffa.Logger.debug('filteredSubs ' + filteredSubs);

    tffa.Logger.flush();
    return filteredSubs;
  }

  global void execute(Database.BatchableContext batchableContext, List<tffa__Submission__c> submissions) {
    tffa.Interaction.begin(CZWTFCFCMDocumentUploadBatch.class, 'execute');
    try {
      tffa__Submission__c submission = submissions[0];

      tffa__Submission__c sub = FCMIntegrationExecutor.processRequest(submission);
      tffa__Submission__c updatedSub = new tffa__Submission__c();
      updatedSub.FCMUploadStatus__c = sub.FCMUploadStatus__c;
      updatedSub.FCMUploadRetryCount__c = sub.FCMUploadRetryCount__c;
      updatedSub.Id = sub.Id;

      CZWTFCSubmissionRepository.save(new List<tffa__Submission__c>{ updatedSub });
    } catch (Exception ex) {
      tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCFCMDocumentUploadBatch finish()');
    tffa.Logger.flush();
  }

  private static List<tffa__Submission__c> filterSubs(List<tffa__Submission__c> subLst) {
    List<tffa__Submission__c> filterSubmissions = new List<tffa__Submission__c>();
    for (tffa__Submission__c subObj : subLst) {
      Boolean isAccountOpened = false;

      for (tffa__Application__c appObj : subObj.tffa__Applications__r) {
        if (statuses.contains(appObj.tffa__Status__c)) {
          isAccountOpened = true;
          break;
        }
      }

      if (!isAccountOpened) {
        continue;
      }

      if (subObj.tffa__Channel__c == 'Digital' && !subObj.DisclosureConverted__c) {
        continue;
      } else if (subObj.tffa__Channel__c == 'Branch' && subObj.CZDocusignDownloadStatus__c != CZWTFCConstants.COMPLETED) {
        continue;
      }

      filterSubmissions.add(subObj);
    }
    return filterSubmissions;
  }
}