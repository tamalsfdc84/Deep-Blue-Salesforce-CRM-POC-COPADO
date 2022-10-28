global with sharing class CZWTFCPurgeSubmissionBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  @TestVisible
  private static boolean calledFromTestCls = false;

  global List<tffa__Submission__c> start(Database.BatchableContext batchableCntx) {
    List<tffa__Submission__c> subList = new List<tffa__Submission__c>();

    try {
      List<tffa__Submission__c> expiredAndCancelSub = CZWTFCSubmissionRepository.getExpiredAndCancelSubmission();
      List<tffa__Submission__c> oldSubmission = CZWTFCPurgeSubmissionHelper.getPurgeSub();

      if (Test.isRunningTest() && calledFromTestCls) {
        List<tffa__Submission__c> subTest = CZWTFCSubmissionRepository.findtestSubmission();
        subList.addAll(subTest);
      }

      if (expiredAndCancelSub != null) {
        subList.addAll(expiredAndCancelSub);
      }
      if (oldSubmission != null) {
        subList.addAll(oldSubmission);
      }

      createSubCSVDoc(subList);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in purgebatch cls: Start ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    tffa.Logger.flush();
    return subList;
  }

  global void execute(Database.BatchableContext batchableCntx, List<SObject> subObject) {
    tffa.Logger.debug('ACC execute Datetime Started on : ' + String.valueOf(Datetime.now()));
    List<tffa__Submission__c> subList = (List<tffa__Submission__c>) subObject;
    tffa.Logger.debug('Total Submission deleted ' + subList.size());
    try {
      if (subList[0].tffa__Applications__r != null) {
        tffa.ApplicationService.purge(subList[0].tffa__Applications__r);
      }

      CZWTFCPurgeSubmissionHelper.deletePartyAndItsChildObj(subList[0]);
      tffa.Logger.debug('ACC execute Datetime Ended on  : ' + String.valueOf(Datetime.now()));
    } catch (Exception ex) {
      tffa.Logger.error('Exception in purgebatch cls: Execute ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.flush();
    }
  }

  global void finish(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('ACC execute Completed at  : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
  }

  public static void createSubCSVDoc(List<tffa__Submission__c> subList) {
    try {
      String csvColumnHeader;
      List<String> csvRowValues = new List<String>();

      for (tffa__Submission__c sub : subList) {
        if (subList[0].tffa__Applications__r != null) {
          for (tffa__Application__c appObj : sub.tffa__Applications__r) {
            String submissionNo = sub.Name;
            String appName = appObj.Name;
            String primaryPartyName = sub.PrimaryPartyName__c;
            String noOfApplicants = String.valueOf(sub.tffa__NumberOfParties__c);
            String appCreateDate = String.valueOf(appObj.CreatedDate);
            String appModifiedDate = String.valueOf(appObj.Lastmodifieddate);
            String subStatus = sub.tffa__Status__c;
            String appStatus = appObj.tffa__Status__c;
            String csvRow =
              submissionNo +
              ', ' +
              appName +
              ', ' +
              primaryPartyName +
              ', ' +
              noOfApplicants +
              ', ' +
              appCreateDate +
              ', ' +
              appModifiedDate +
              ', ' +
              subStatus +
              ', ' +
              appStatus;

            csvRowValues.add(csvRow);
          }
        }
      }
      String dateTimeStr = String.valueOf(system.now()).replace(' ', '_');
      String documentName = 'EligiblePurgedApplications_' + dateTimeStr;
      String folderName = 'Miscellaneous';

      csvColumnHeader = 'Submission No, Application Name, Primary PartyName, No Of Applicants, Application CreateDate, Application ModifiedDate, Submission status, Application status\n';
      String csvFile = csvColumnHeader + String.join(csvRowValues, '\n');

      Folder fldr = CZWTFCHelperRepository.getFolder(folderName);
      if (fldr != null) {
        Document doc = new Document();
        doc.Name = documentName;
        doc.Body = Blob.valueOf(csvFile);
        doc.FolderId = fldr.Id;
        doc.Type = 'csv';
        doc.ContentType = 'application/vnd.ms-excel';
        CZWTFCHelperRepository.saveDoc(doc);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in purgebatch cls: creating csv file ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}