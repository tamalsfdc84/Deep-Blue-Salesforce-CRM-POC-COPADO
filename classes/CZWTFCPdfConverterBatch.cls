global inherited sharing class CZWTFCPdfConverterBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  global List<tffa__Submission__c> start(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCPdfConverterBatch start()');
    List<tffa__Submission__c> submissionLst = CZWTFCSubmissionRepository.findSubmissionAndDisclosure();
    tffa.Logger.flush();
    return submissionLst;
  }
  global void execute(Database.BatchableContext batchableContext, List<tffa__Submission__c> submissionList) {
    tffa.Interaction.begin(CZWTFCPdfConverterBatch.class, 'execute');
    try {
      List<tffa__Submission__c> subList = new List<tffa__Submission__c>();
      CZWTFCGenDisclosurePdfProvider genDiscPdf = new CZWTFCGenDisclosurePdfProvider();
      for (tffa__Submission__c sub : submissionList) {
        boolean isSuccess = genDiscPdf.generateDisclosurePdf(sub);
        sub.DisclosureConverted__c = isSuccess;
        subList.add(sub);
      }
      CZWTFCSubmissionRepository.save(subList);
    } catch (Exception ex) {
      tffa.Logger.error('Exception msg in CZWTFCPdfConverterBatch execute : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }
  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCPdfConverterBatch finish()');
    Database.executeBatch(new CZWTFCFCMDocumentUploadBatch(), 1);
    tffa.Logger.flush();
  }
}