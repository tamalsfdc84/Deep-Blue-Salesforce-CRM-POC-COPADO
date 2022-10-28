global with sharing class CZWTFCDebitCardFundingVoidBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  @TestVisible
  private static boolean calledFromTestCls = false;

  global List<tffa__Submission__c> start(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('CZWTFCDebitCardFundingVoidBatch Job started');

    List<tffa__Submission__c> filterSubList = new List<tffa__Submission__c>();
    List<tffa__Submission__c> subList = CZWTFCSubmissionRepository.fetchSubForCCDelete();

    filterSubList = filterSubs(subList);

    if (Test.isRunningTest()) {
      filterSubList = CZWTFCSubmissionRepository.findtestSubmission();
    }
    tffa.Logger.flush();
    return filterSubList;
  }

  global void execute(Database.BatchableContext batchableCntx, List<SObject> subObject) {
    tffa.Logger.debug('CZWTFCDebitCardFundingVoidBatch execute Datetime Started on : ' + String.valueOf(Datetime.now()));
    Boolean isSuccess = false;
    List<tffa__Submission__c> subList = (List<tffa__Submission__c>) subObject;
    List<tffa__FundingRequest__c> fundObjList = new List<tffa__FundingRequest__c>();

    try {
      for (tffa__Submission__c sub : subList) {
        List<tffa__Submission__c> submissionList = CZWTFCSubmissionRepository.findSubmissionAndAppByIds(new List<String>{ sub.Id });
        if (checkPendingApp(submissionList[0])) {
          boolean doCCDelete = true;
          for (tffa__FundingRequest__c currentFundingRequest : submissionList[0].tffa__FundingRequests__r) {
            if (currentFundingRequest.tffa__Status__c == 'IN_PROGRESS' || currentFundingRequest.tffa__Status__c == 'REVERSAL_FAILED') {
              for (tffa__FundingRequest__c fundObj : submissionList[0].tffa__FundingRequests__r) {
                // if one transaction with same reference number is processed with multipartial flag as N or reversed, then void is not requried.
                if (
                  (fundObj.MultiPartialFlag__c == 'N' ||
                  fundObj.tffa__Status__c == CZWTFCConstants.REVERSED) &&
                  currentFundingRequest.Id != fundObj.Id &&
                  currentFundingRequest.tffa__TransactionReferenceId__c == fundObj.tffa__TransactionReferenceId__c
                ) {
                  doCCDelete = false;
                  break;
                }
              }
              if (doCCDelete) {
                isSuccess = CZWTFCConvergeService.ccDeleteConvergeTrans(sub.Id, currentFundingRequest.tffa__TransactionReferenceId__c);

                //if (!fundObj.tffa__Status__c.equalsIgnoreCase(CZWTFCConstants.APPROVAL)) {
                if (isSuccess) {
                  currentFundingRequest.tffa__Status__c = CZWTFCConstants.REVERSED;
                } else {
                  currentFundingRequest.tffa__Status__c = CZWTFCConstants.REVERSAL_FAILED;
                  currentFundingRequest.ReversalRetryCount__c += 1;
                }

                fundObjList.add(currentFundingRequest);
              } else {
                currentFundingRequest.tffa__Status__c = CZWTFCConstants.REVERSAL_NOT_REQ;
                fundObjList.add(currentFundingRequest);
              }
            }
          }
        }
      }
      WTFCObjectManagerRepository.doUpsertObjects(fundObjList);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCDebitCardFundingVoidBatch cls: Execute ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.flush();
    }
  }

  global void finish(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('CZWTFCDebitCardFundingVoidBatch execute Completed at  : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
  }

  public List<tffa__Submission__c> filterSubs(List<tffa__Submission__c> sublist) {
    List<tffa__Submission__c> filtersublist = new List<tffa__Submission__c>();
    if (sublist != null && !sublist.isEmpty()) {
      for (tffa__Submission__c sub : sublist) {
        if (
          sub.tffa__FundingRequests__r != null &&
          !sub.tffa__FundingRequests__r.isEmpty() &&
          sub.tffa__Applications__r != null &&
          !sub.tffa__Applications__r.isEmpty()
        ) {
          filtersublist.add(sub);
        }
      }
    }
    return filtersublist;
  }

  public static boolean checkPendingApp(tffa__Submission__c sub) {
    if (Test.isRunningTest() && calledFromTestCls) {
      return true;
    }
    List<tffa__Application__c> appList = CZWTFCApplicationRepository.findApplicationWithChildObjsBySubId(sub);
    List<String> appStatusLst = new List<String>{ CZWTFCConstants.REVIEW, CZWTFCConstants.APPROVED };
    for (tffa__Application__c app : appList) {
      if (appStatusLst.contains(app.tffa__Status__c)) {
        return false;
      } else if ((app.tffa__Status__c).equalsIgnoreCase(CZWTFCConstants.ACCOUNT_OPENED)) {
        if (app.tffa__LinkedFundingRequests__r != null && !app.tffa__LinkedFundingRequests__r.isEmpty()) {
          if ((app.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)) {
            return false;
          }
        }
      }
    }
    return true;
  }
}