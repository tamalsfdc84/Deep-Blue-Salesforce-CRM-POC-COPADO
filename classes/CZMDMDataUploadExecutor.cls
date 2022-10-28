public inherited sharing class CZMDMDataUploadExecutor {
  public static List<tffa__Application__c> applicationList = new List<tffa__Application__c>();
  public static List<tffa__Party__c> partyList = new List<tffa__Party__c>();

  public static void processRequest(tffa__Submission__c submission) {
    try {
      // Fetch Auth token
      FISCCIntegrationLogService.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();

      if (FISCCIntegrationLogService.auth == null) {
        return;
      }

      Boolean isDebitCardProduct = false;
      for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
        if (app.tffa__AccountPurpose__c == 'DEBIT_CARD') {
          isDebitCardProduct = true;
          break;
        }
      }

      Boolean hasExistingCustomers = false;
      Boolean hasNewCustomers = false;

      for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
        if (party.tffa__IsExistingCustomer__c || party.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
          hasExistingCustomers = true;
        } else {
          hasNewCustomers = true;
        }
      }

      // Call account creation API
      if (hasExistingCustomers && !isDebitCardProduct) {
        for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
          if (
            app.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
            (app.tffa__AccountNumber__c != null ||
            app.tffa__DepositBoxAccountNumber__c != null) &&
            (!CZWTFCCommonHelper.isCertificateProduct(app) || app.DPTDId__c != null) &&
            FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST.contains(app.tffa__Status__c)
          ) {
            if (!FISCCSubmissionExecutor.withinGovernorLimits()) {
              FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
              return;
            }
            try {
              app.MDMUploadStatus__c = CZMDMDataUploadProvider.processAccountCreation(app);
              if (app.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
                app.MDMUploadRetryCount__c++;
                app.MDMUploadStatus__c = 'FAILURE';
                //app.AcctOpenRetryCount__c = app.AcctOpenRetryCount__c + 1;
              }
            } catch (Exception ex) {
              tffa.Logger.error(
                'CZMDMDataUploadExecutor Exception in account creation msg : ' +
                ex.getMessage() +
                ' ' +
                ex.getStackTraceString()
              );
              app.MDMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
              app.MDMUploadRetryCount__c++;
              app.MDMUploadStatus__c = 'FAILURE';
              //app.AcctOpenRetryCount__c = app.AcctOpenRetryCount__c + 1;
            }
            //applicationList.add(app);
          }
        }
      }

      // Call customer creation API
      if (hasNewCustomers || isDebitCardProduct) {
        for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
          //tffa__Party__c party = subPartyXref.tffa__Party__r;
          if (
            party.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
            (!party.tffa__IsExistingCustomer__c || isDebitCardProduct) &&
            !String.isBlank(party.Customer_Number__c)
          ) {
            if (!FISCCSubmissionExecutor.withinGovernorLimits()) {
              FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
              return;
            }
            String mdmStatus = 'FAILURE';
            try {
              if (!isDebitCardProduct || (isDebitCardProduct && party.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL)) {
                mdmStatus = CZMDMDataUploadProvider.processCustomerCreation(submission, party);
              }

              party.MDMUploadStatus__c = mdmStatus;
            } catch (Exception ex) {
              tffa.Logger.error(
                'CZMDMDataUploadExecutor Exception in customer creation msg : ' +
                ex.getMessage() +
                ' ' +
                ex.getStackTraceString()
              );

              party.MDMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
            }

            if (party.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
              party.MDMUploadRetryCount__c++;
            }

            //partyList.add(party);

            // need to update application status when submission has only new customers
            if (!hasExistingCustomers || isDebitCardProduct) {
              for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
                if (
                  (app.tffa__AccountNumber__c != null ||
                  app.tffa__DepositBoxAccountNumber__c != null ||
                  isDebitCardProduct) &&
                  (!FISCCIntegrationConstants.CERTIFICATE_PROD_CATEGORY.contains(app.tffa__ProductCategory__c) || app.DPTDId__c != null) &&
                  app.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
                  FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST.contains(app.tffa__Status__c)
                ) {
                  app.MDMUploadStatus__c = mdmStatus;

                  if (mdmStatus == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
                    app.MDMUploadRetryCount__c++;
                    app.MDMUploadStatus__c = 'FAILURE';
                    //app.AcctOpenRetryCount__c = app.AcctOpenRetryCount__c + 1;
                  }
                  //applicationList.add(app);
                }
              }
            }
          }
        }
      }

      //call customer update api
      for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
        String mdmUpdateStatus = 'FAILURE';

        if (
          party.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
          party.tffa__IsExistingCustomer__c &&
          party.CZContactInfoUpdated__c &&
          !String.isBlank(party.CZMDMPartyID__c) &&
          !String.isBlank(party.Customer_Number__c) &&
          party.CZCustomerUpdated__c
        ) {
          if (!FISCCSubmissionExecutor.withinGovernorLimits()) {
            FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
            return;
          }

          try {
            mdmUpdateStatus = CZMDMDataUploadProvider.processCustomerUpdate(submission, party);
            party.MDMUploadStatus__c = mdmUpdateStatus;
          } catch (Exception ex) {
            tffa.Logger.error(
              'CZMDMDataUploadExecutor Exception in customer update msg : ' +
              ex.getMessage() +
              ' ' +
              ex.getStackTraceString()
            );
            mdmUpdateStatus = 'FAILURE';
            party.MDMUploadStatus__c = mdmUpdateStatus;
          }

          if (party.MDMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
            party.MDMUploadRetryCount__c++;
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZMDMDataUploadExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    }
  }
}