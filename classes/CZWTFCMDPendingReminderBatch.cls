global inherited sharing class CZWTFCMDPendingReminderBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {

  public static String PENDING_STATUS = 'PENDING_MANUAL_VERIFICATION';

  global Database.QueryLocator start(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCMDPendingReminderBatch : query => ' + getQuery());
    tffa.Logger.flush();
    return Database.getQueryLocator(getQuery());
  }

  global void execute(Database.BatchableContext batchableContext, List<tffa__FundingRequest__c> fundingRequests) {
    try {

      // Get mail frequency from config
      List<Integer> microdepositsReminderSchedule = new List<Integer>();
      for(String schedule : CZWTFCHelperRepository.fetchWintrustEnvConfig().MicrodepositsReminderSchedule__c.split(';')){
        MicrodepositsReminderSchedule.add(integer.valueof(schedule));
      }

      List<tffa__Submission__c> submissionList =  new List<tffa__Submission__c>();
      for(tffa__FundingRequest__c fundReq: fundingRequests){
        submissionList.add(fundReq.tffa__Submission__r);
      }

      for(tffa__Submission__c sub: submissionList){
        // check submission is submitted and count is 0 and date is null
        if(sub.tffa__Status__c == 'SUBMITTED' && sub.FundingVerificationReminderCount__c == 0 && sub.NextFundingVerificationReminderDate__c == null){
          // Update the next reminder date
          sub.NextFundingVerificationReminderDate__c = sub.tffa__SubmissionDate__c.addDays(microdepositsReminderSchedule[0]);
       }
     }

     List<tffa__Submission__c> reminderSubmissionList =  new List<tffa__Submission__c>();

     for(tffa__Submission__c sub: submissionList){
       // Check submission is submitted and date is not null and date is less or equal to todays date and count should not be max
      if(sub.tffa__Status__c == 'SUBMITTED'  && sub.NextFundingVerificationReminderDate__c != null && sub.NextFundingVerificationReminderDate__c <= Date.today()  && sub.FundingVerificationReminderCount__c < microdepositsReminderSchedule.size()){

        Integer index = integer.valueOf(sub.FundingVerificationReminderCount__c);
        // Update the date to next date only if maximum attempt is not reached.
        if(index+1 < microdepositsReminderSchedule.size()){
          sub.NextFundingVerificationReminderDate__c = sub.tffa__SubmissionDate__c.addDays(microdepositsReminderSchedule[index+1]);
        }
        
        // Update count
        sub.FundingVerificationReminderCount__c ++;

        reminderSubmissionList.add(sub);
     }
    }

    // Send mail
    if(reminderSubmissionList != null && reminderSubmissionList.size()>0){
      new CZWTFCSubmissionEventExtension('Micro_Deposit_Pending').post(reminderSubmissionList);
    }

    // Update submission data
    if(submissionList != null && submissionList.size()>0){
      CZWTFCSubmissionRepository.save(submissionList);
    }

    } catch (Exception ex) {
      tffa.Logger.debug('CZWTFCMDPendingReminderBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.flush();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZWTFCMDPendingReminderBatch finish()');
    tffa.Logger.flush();
  }

  private static String getQuery() {

    // Get the funding request with pending status
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .build()
      .whereClause('tffa__VerificationStatus__c', ' =:PENDING_STATUS')
      .build()
      .toQuery();

    tffa.Logger.debug('CZWTFCMDPendingReminderBatch query => ' + query);

    return query;
  }
}