@SuppressWarnings('PMD.AvoidDeeplyNestedIfStmts')
public inherited sharing class CZMDMDataUploadExecutor {
  public static List<tffa__Application__c> applicationList = new List<tffa__Application__c>();
  public static List<tffa__Party__c> partyList = new List<tffa__Party__c>();

  public static void processRequest(tffa__Submission__c submission) {
    try {
      // Fetch Auth token
      FISCCIntegrationLogService.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();

      if (FISCCIntegrationLogService.auth != null) {
        Boolean hasExistingCustomers = false;
        Boolean hasNewCustomers = false;

        for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
          if (party.tffa__IsExistingCustomer__c) {
            hasExistingCustomers = true;
          } else {
            hasNewCustomers = true;
          }
        }

        // Call account creation API
        if (hasExistingCustomers) {
          for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
            if (
              app.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
              app.tffa__AccountNumber__c != null &&
              (app.tffa__Product__r.tffa__Category__c != 'CERTIFICATE' ||
              app.DPTDId__c != null)
            ) {
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
        if (hasNewCustomers) {
          for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
            //tffa__Party__c party = subPartyXref.tffa__Party__r;
            if (
              party.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS &&
              !party.tffa__IsExistingCustomer__c &&
              !String.isBlank(party.Customer_Number__c)
            ) {
              String mdmStatus = 'FAILURE';
              try {
                mdmStatus = CZMDMDataUploadProvider.processCustomerCreation(submission, party);
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
            }
              // need to update application status when submission has only new customers
            if (!hasExistingCustomers) {
              for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
                if (
                  app.tffa__AccountNumber__c != null &&
                  (app.tffa__Product__r.tffa__Category__c != 'CERTIFICATE' ||
                  app.DPTDId__c != null) &&
                  app.MDMUploadStatus__c != CZWTFCConstants.PROCESS_STATUS_SUCCESS
                ) {
                  app.MDMUploadStatus__c = party.MDMUploadStatus__c ;

                  if (party.MDMUploadStatus__c  == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
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
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZMDMDataUploadExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    }
  }
}