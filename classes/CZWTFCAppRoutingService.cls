public with sharing class CZWTFCAppRoutingService implements Queueable {
  private tffa__Application__c applicationObject;
  public CZWTFCAppRoutingService(tffa__Application__c appObject) {
    this.applicationObject = appObject;
    tffa.Logger.debug('CZWTFCAppRoutingService called for : ' + appObject.Id);
  }

  public void execute(QueueableContext context) {
    routeApplicationAndRaiseEvent(applicationObject);
  }

  public static void routeApplicationAndRaiseEvent(tffa__Application__c appObj) {
    try {
      appObj = routeApplication(appObj);
      appObj.IsRoutingRequired__c = false;
      if (
        (appObj.tffa__Status__c.equals(CZWTFCConstants.ACCOUNT_OPENED) || appObj.tffa__Status__c.equals(CZWTFCConstants.FUNDED)) &&
        !appObj.IsAccAlreadyOpened__c
      ) {
        (new CZWTFCApplicationEventExtension()).post(appObj);
      }
      if (appObj != null) {
        FISCCObjectManagerRepository.doUpsertApplications(new List<tffa__Application__c>{ appObj });
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception  :::' + ex.getMessage() + 'LineNumber  :::' + ex.getStackTraceString());
    }
  }

  public static tffa__Application__c routeApplication(tffa__Application__c appObj) {
    // if (CZWTFCConstants.PROCESS_STATUS_FAILURE.equals(appObj.AccountPreference__c)) {
    //   appObj.tffa__Score__c = FISCCApplicationConstants.ESTMT_REGN_FAILED_CODE;
    // } else if (CZWTFCConstants.PROCESS_STATUS_FAILURE.equals(appObj.DebitCardIssuanceStatus__c)) {
    //   appObj.tffa__Score__c = FISCCApplicationConstants.DEBIT_ISSUANCE_FAILED_CODE;
    // } else if (CZWTFCConstants.PROCESS_STATUS_FAILURE.equals(appObj.AccountOpeningStatus__c)) {
    //   appObj.tffa__Score__c = FISCCApplicationConstants.ACC_OPENING_FAILED_CODE;
    // } else if (
    //   (appObj.tffa__Status__c.equals(CZWTFCConstants.ACCOUNT_OPENED) || appObj.tffa__Status__c.equals(CZWTFCConstants.FUNDED)) &&
    //   (appObj.DebitCardIssuanceStatus__c.equals('PENDING') ||
    //   appObj.AccountPreference__c.equals('PENDING') ||
    //   appObj.DebitCardIssuanceStatus__c.equals('PENDING'))
    // ) {
    //   appObj.tffa__Score__c = FISCCApplicationConstants.IN_PROGRESS_APPLICATION;
    // } else if ((appObj.tffa__Status__c.equals(CZWTFCConstants.ACCOUNT_OPENED) || appObj.tffa__Status__c.equals(CZWTFCConstants.FUNDED))) {
    //   appObj.tffa__Score__c = FISCCApplicationConstants.APPLICATION_PROCESSING_COMPLETED;
    // }
    tffa__Submission__c submission = CZWTFCSubmissionRepository.findSubmissionById(appObj.tffa__Submission__c);
    Map<String, Object> facts = new Map<String, Object>();
    facts.put('AccountOpeningStatus__c', appObj.AccountOpeningStatus__c);
    facts.put('DebitCardIssuanceStatus__c', appObj.DebitCardIssuanceStatus__c);
    facts.put('AccountPreference__c', appObj.AccountPreference__c);
    facts.put('tffa__StatusSet__c', appObj.tffa__Status__c);

    if (String.isNotBlank(appObj.CZKYCOutcomeQueueName__c)) {
      facts.put('CZKYCOutcomeQueueName__c', appObj.CZKYCOutcomeQueueName__c);
    }

    tffa.ApplicationAssigner appAssigner = new tffa.ApplicationAssigner();
    List<tffa__Application__c> appObjList = appAssigner.assign(new List<tffa__Application__c>{ appObj }, facts);
    if (appObjList != null && appObjList.size() > 0)
      return appObjList.get(0);
    else
      return appObj;
  }
}