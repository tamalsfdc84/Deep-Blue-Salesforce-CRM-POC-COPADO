public inherited sharing class FISCCSubmissionExecutor {
  public static Long startTime = System.currentTimeMillis();
  public static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  // public static Boolean isManuallyApproved = false;
  /**
   * @description Prepare required data for api call
   * @param String submissionId
   * @return void
   */
  private static void buildData(String submissionId) {
    FISCCIntegrationLogService.setSubmissionObj(submissionId);
    FISCCIntegrationLogService.setPartyObjs();
    FISCCIntegrationLogService.setIntegrationLog(submissionId);
    FISCCIntegrationLogService.setApplicationObjs();
  }

  public static List<tffa__Application__c> filterApplications(List<tffa__Application__c> appObjs, String appId) {
    List<tffa__Application__c> appList = new List<tffa__Application__c>();
    List<tffa__Application__c> reviewAppLst = new List<tffa__Application__c>();
    List<String> appStatus = new List<String>{ 'SUBMITTED', 'APPROVED', 'IN_PROGRESS', 'DOCS_GENERATED', 'DOCS_SIGNED' };
    List<String> fundingStatus = new List<String>{ 'VERIFIED', 'AUTOMATICALLY_VERIFIED', 'MANUALLY_VERIFIED' };

    for (tffa__Application__c appObj : appObjs) {
      if (
        !String.isBlank(appObj.tffa__KYCDecisionOutcome__c) &&
        appObj.tffa__KYCDecisionOutcome__c.equalsIgnoreCase('APPROVED') &&
        (appStatus.contains(appObj.tffa__Status__c) || (CZWTFCConstants.PROCESS_STATUS_FAILURE).equals(appObj.AccountOpeningStatus__c))
      ) {
        if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
          if (
            (fundingStatus.contains(appObj.tffa__LinkedFundingRequests__r[0].tffa__VerificationStatus__c) ||
            appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c != CZWTFCConstants.FUNDING_TYPE_ACH) &&
            !appObj.tffa__LinkedFundingRequests__r[0].IsObsolete__c &&
            !appObj.tffa__LinkedFundingRequests__r[0].tffa__IsDeleted__c &&
            (appId == null ||
            appId == appObj.Id)
          ) {
            appList.add(appObj);
          }
        } else if (appId == null || appId == appObj.Id) {
          appList.add(appObj);
        }
      } else if (!String.isBlank(appObj.tffa__KYCDecisionOutcome__c) && appObj.tffa__KYCDecisionOutcome__c.equalsIgnoreCase('REVIEW')) {
        reviewAppLst.add(appObj);
      }
    }
    FISCCIntegrationLogService.reviewApps = reviewAppLst;
    return appList;
  }

  public static tffa__Submission__c processApplication(String subId) {
    return processApplication(subId, null);
  }

  /**
   * Process Application using sub ID
   */
  public static tffa__Submission__c processApplication(String subId, String appId) {
    tffa.Logger.debug('In processApp');
    List<String> accOpeningStatus = new List<String>{ CZWTFCConstants.ACCOUNT_OPENED, CZWTFCConstants.FUNDED };
    buildData(subId);
    if (FISCCIntegrationLogService.submissionObj == null) {
      throw new tffa.ApplicationException(FISCCIntegrationConstants.INVALID_SUBMISSION);
    }
    if (!Test.isRunningTest()) {
      FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = false;
    }
    try {
      List<tffa__Application__c> appList = new List<tffa__Application__c>();
      tffa.Logger.debug('appList before ' + FISCCIntegrationLogService.applicationObjs);
      appList = FISCCSubmissionExecutor.filterApplications(FISCCIntegrationLogService.applicationObjs, appId);
      FISCCIntegrationLogService.applicationObjs = appList;

      if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
        FISCCCommonHelper.setFISBranchPrimaryOffcrAndCostCenter(appList, FISCCIntegrationLogService.partyObjMap.values());
        setDigitalFlowValues(appList, FISCCIntegrationLogService.partyObjMap.values());
        if (!CZWTFCCommonHelper.checkAcctNbrCreationCompleted(appList)) {
          CZAccNbrGenerationProvider.generateAccountNbr(appList);
        }
      }
      tffa.Logger.debug('appList after acc Nbr generation ' + appList);

      //Recheck if it's a Existing Customer --> Digital flow.
      try {
        if (FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.DIGITAL) {
          if (String.isBlank(FISCCIntegrationLogService.auth)) {
            FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
          }
          String strDeveloperName = 'SearchCustomerTaxnbr';
          FISCC_Adapter_Configs__mdt adapterSearchConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
          for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjs) {
            if (!partyObj.tffa__IsExistingCustomer__c && String.isBlank(partyObj.Customer_Number__c)) {
              FISCCIntegrationLogService.setCurrentLog(partyObj.Name + '-' + FISCCIntegrationConstants.CUSTOMER_API_INQUIRES);
              FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.SEARCH_CUSTOMER, partyObj.name, true);
              FISCCCustomerSearchTaxnbrExtension.invokeFindByTaxbr(partyObj, adapterSearchConfig, FISCCIntegrationLogService.charterConfig);

              if (partyObj.tffa__IsExistingCustomer__c) {
                FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.SEARCH_CUSTOMER);
              } else {
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.SEARCH_CUSTOMER);
              }
            }
          }
        }
      } catch (Exception ex) {
        tffa.logger.error('Exception in Searching Customer Number :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      }

      /**
       * Create Business and Benficial owners
       */
      try {
        if (
          !CZWTFCCommonHelper.checkBusinessAndOwnerCreated(FISCCIntegrationLogService.partyObjMap, true, true) &&
          !FISCCIntegrationLogService.applicationObjs.isEmpty() &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != FISCCIntegrationLogService.applicationObjs[0].tffa__AccountPurpose__c
        ) {
          boolean isSuccess = false;
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CREATE_BUSINESS_ENTITY);
          isSuccess = FISCCDepositOriginationProvider.createBusinessAndOwners(
            FISCCIntegrationLogService.partyObjMap.values(),
            FISCCIntegrationLogService.submissionObj
          );

          if (!isSuccess) {
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_FAILURE);
          } else {
            FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_SUCCESS);
          }
        }
      } catch (Exception ex) {
        tffa.logger.error(' Exception in BusinessAndOwnerCreation:::' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }

      try {
        if (
          CZWTFCCommonHelper.checkBusinessAndOwnerCreated(FISCCIntegrationLogService.partyObjMap, true, true) &&
          !CZWTFCCommonHelper.checkCustToCustRelnCreated(FISCCIntegrationLogService.partyObjMap) &&
          !FISCCIntegrationLogService.applicationObjs.isEmpty() &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != FISCCIntegrationLogService.applicationObjs[0].tffa__AccountPurpose__c
        ) {
          boolean isSuccess = false;
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CREATE_BUSINESS_ENTITY_RELN);
          isSuccess = FISCCOrgCustomerRelnProvider.createBusinessAndOwnersReln(
            FISCCIntegrationLogService.partyObjMap.values(),
            FISCCIntegrationLogService.submissionObj
          );

          if (!isSuccess) {
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CUST_TO_CUST_CREATION_RELN_FAILURE);
          } else {
            FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.CUST_TO_CUST_CREATION_RELN_SUCCESS);
          }
        }
      } catch (Exception ex) {
        tffa.logger.error(' Exception in BusinessAndOwnerReln:::' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }

      if (
        !CZWTFCCommonHelper.checkBusinessAndOwnerCreated(FISCCIntegrationLogService.partyObjMap, true, false) &&
        !FISCCIntegrationLogService.applicationObjs.isEmpty() &&
        FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != FISCCIntegrationLogService.applicationObjs[0].tffa__AccountPurpose__c
      ) {
        for (tffa__Application__c appObj : appList) {
          appObj.AccountOpeningStatus__c = 'FAILURE';
          appObj.AcctOpenRetryCount__c = appObj.AcctOpenRetryCount__c + 1;
        }
        return FISCCIntegrationLogService.submissionObj;
      }

      for (tffa__Application__c appObj : appList) {
        Boolean isSuccess = false;
        Boolean isDepositOriginationFailure = false;
        Boolean isCustomerCreationFailure = false;
        Boolean isFundingHoldFailure = false;
        Boolean isCustAccRelnFailure = false;
        Boolean isCustomerInfoUpdateFailure = false;
        Boolean isFundingFailed = false;
        Boolean updatingAPYFailed = false;
        Boolean isLoanHoldFailed = false;

        if (
          FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          !accOpeningStatus.contains(appObj.tffa__Status__c) &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id);
          try {
            if (CZWTFCCommonHelper.isCertificateProduct(appObj) && appObj.tffa__Term__c != 0) {
              String promoIntTerm = null;
              if (!String.isBlank(appObj.tffa__PromotionCode__c)) {
                promoIntTerm = CZWTFCHelperRepository.fetchPromotionPlanCode(appObj.tffa__PromotionCode__c);
                appObj.InterestPlanCode__c = promoIntTerm;
              }
            }
          } catch (Exception ex) {
            tffa.logger.error(
              'Exception in fetching interest plan code Message :::' +
              ex.getMessage() +
              ' Exception:::' +
              ex.getStackTraceString()
            );
          }
          try {
            if (FISCCIntegrationLogService.submissionObj != null) {
              isSuccess = FISCCDepositOriginationProvider.createDepositOrigination(
                FISCCIntegrationLogService.partyObjMap.values(),
                appObj,
                FISCCIntegrationLogService.submissionObj
              );
            }

            if (!isSuccess) {
              FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_FAILED);
              isDepositOriginationFailure = true;
            } else {
              FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_COMPLETED);
            }
          } catch (Exception ex) {
            isDepositOriginationFailure = true;
            tffa.logger.error(' Exception :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id);
            tffa.logger.debug(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id);
          } finally {
            tffa.logger.debug('ACCOUNT_OPENING COMPLETED');
          }
        } else {
          // account perviously opened
          appObj.IsAccAlreadyOpened__c = true;
        }

        // Process pending Customer Creation
        try {
          if (
            !CZWTFCCommonHelper.checkCustomerCreationCompleted(appObj) &&
            !isDepositOriginationFailure &&
            FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
          ) {
            FISCCDepositOriginationExtension.custCreationMap.clear();
            FISCCDepositOriginationExtension.relnAdded.clear();
            FISCCIntegrationLogService.setCurrentLog(
              FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION +
              '-' +
              appObj.Name +
              '-' +
              appObj.Id
            );
            if (FISCCIntegrationLogService.submissionObj != null) {
              isSuccess = FISCCDepositOriginationProvider.createPendingApplicants(
                FISCCIntegrationLogService.partyObjMap.values(),
                appObj,
                FISCCIntegrationLogService.submissionObj
              );
            }

            if (!isSuccess) {
              FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_FAILURE);
              isCustomerCreationFailure = true;
            } else {
              FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_SUCCESS);
            }
          }
        } catch (Exception ex) {
          isCustomerCreationFailure = true;
          tffa.logger.error(' Exception in CustomerCreation:::' + ex.getMessage() + ' ' + ex.getStackTraceString());
          FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_FAILURE);
        }

        /**
         *Proccess Customer Acct Reln
         */
        try {
          if (
            CZWTFCCommonHelper.checkCustomerCreationCompleted(appObj) &&
            !CZWTFCCommonHelper.checkCustomerAccRelnCompleted(appObj) &&
            !isDepositOriginationFailure &&
            !isCustomerCreationFailure &&
            FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
          ) {
            FISCCDepositOriginationExtension.custCreationMap.clear();
            FISCCDepositOriginationExtension.relnAdded.clear();
            FISCCIntegrationLogService.setCurrentLog(
              FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP +
              '-' +
              appObj.Name +
              '-' +
              appObj.Id
            );
            isSuccess = FISCCCustAccRelnProvider.createCustAccountRelnship(
              FISCCIntegrationLogService.partyObjMap.values(),
              appObj,
              FISCCIntegrationLogService.submissionObj
            );

            if (!isSuccess) {
              FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP_FAILURE);
              isCustomerCreationFailure = true;
            } else {
              FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP_SUCCESS);
            }
          }
        } catch (Exception ex) {
          isCustomerCreationFailure = true;
          tffa.logger.error(' Exception in CustAcctReln:::' + ex.getMessage() + ' ' + ex.getStackTraceString());
          FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP_FAILURE);
        }

        /**
         * Customer details updated nly for Digital flow
         */
        if (
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.DIGITAL
        ) {
          try {
            if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION)) {
              boolean custInfoUpdateFlag;

              custInfoUpdateFlag = FISCCUpdateCustInfoProvider.updateCustInfo(FISCCIntegrationLogService.partyObjs);
              if (!custInfoUpdateFlag) {
                isCustomerInfoUpdateFailure = true;
              }
              tffa.Logger.debug('create cust due diligence success');
            }
          } catch (Exception ex) {
            tffa.logger.error(
              'Exception in creating cust due diligence :::' +
              ex.getMessage() +
              ' Exception:::' +
              ex.getStackTraceString()
            );
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FAILURE);
            isCustomerInfoUpdateFailure = true;
          }
        }

        // IRA - Update Retirement Plan only if its Inherited
        if (
          appObj.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED &&
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__ProductCategory__c.equalsIgnoreCase(CZWTFCConstants.IRA) &&
          appObj.tffa__IsInheritedInvestmentPlan__c
        ) {
          try {
            CZWTFCIRAProvider.createRetirementPlan(FISCCIntegrationLogService.partyObjs[0], appObj);
          } catch (Exception ex) {
            tffa.logger.error('Exception in Retirement Plan :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
          }
        }

        // IRA - Add Beneficiary
        if (
          appObj.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED &&
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__ProductCategory__c.equalsIgnoreCase(CZWTFCConstants.IRA) &&
          appObj.tffa__Beneficiaries__r != null &&
          appObj.tffa__Beneficiaries__r.size() > 0
        ) {
          try {
            CZWTFCIRAProvider.addIRABeneficiary(appObj.tffa__Beneficiaries__r, appObj);
          } catch (Exception ex) {
            tffa.logger.error('Exception in Add Beneficiary :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
          }
        }

        // HSA - Add Beneficiary
        if (
          appObj.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED &&
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__ProductCategory__c.equalsIgnoreCase(CZWTFCConstants.HSA) &&
          appObj.tffa__Beneficiaries__r != null &&
          appObj.tffa__Beneficiaries__r.size() > 0
        ) {
          try {
            CZWTFCHSAProvider.addHSABeneficiary(appObj.tffa__Beneficiaries__r, appObj);
          } catch (Exception ex) {
            tffa.logger.error('Exception in Add HSA Beneficiary :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
          }
        }

        /**
         * Process Funding
         */
        if (
          appObj.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED &&
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__LinkedFundingRequests__r != null &&
          !appObj.tffa__LinkedFundingRequests__r.isEmpty() &&
          !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          try {
            FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.APP_PROCESS + appObj.Name + '-' + appObj.Id);
            if (appObj.tffa__Status__c != 'FUNDED') {
              if (
                ((String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__RoutingNumber__c) &&
                String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c) &&
                String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__AccountType__c)) ||
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) ||
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER)) ||
                FISCCCommonHelper.isBranchCertificatewithManualFunding(FISCCIntegrationLogService.submissionObj, appObj) &&
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c > 0
              ) {
                Boolean appFunded = FISCCApplicationFundingProvider.processFunding(appObj);
                if (appFunded) {
                  //FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.ACCOUNT_FUNDING_COMPLETED);
                } else {
                  if (!Test.isRunningTest()) {
                    if (FISCCIntegrationConstants.ErrorMessage.length() > 220) {
                      appObj.CZApplicationProcessingErrorMessage__c =
                        FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED +
                        ' ' +
                        FISCCIntegrationConstants.ErrorMessage.substring(0, 219);
                    } else {
                      appObj.CZApplicationProcessingErrorMessage__c =
                        FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED +
                        ' ' +
                        FISCCIntegrationConstants.ErrorMessage;
                    }
                  }
                  isFundingFailed = true;
                }
              }
            }
          } catch (Exception ex) {
            tffa.logger.error('Exception in application funding :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED);
            isFundingFailed = true;
          }
        }

        /**
         * Process Funding Hold
         */
        FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.APP_PROCESS + appObj.Name + '-' + appObj.Id);
        if (
          FISCCIntegrationLogService.isLogItemOk(FISCCIntegrationConstants.ACCOUNT_FUNDING + '-' + appObj.Name) &&
          appObj.tffa__Status__c == CZWTFCConstants.FUNDED &&
          appObj.tffa__LinkedFundingRequests__r != null &&
          !appObj.tffa__LinkedFundingRequests__r.isEmpty() &&
          appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_ACH) &&
          !appObj.tffa__LinkedFundingRequests__r[0].IsObsolete__c &&
          !appObj.tffa__LinkedFundingRequests__r[0].tffa__IsDeleted__c
        ) {
          try {
            String itemLog = FISCCIntegrationLogService.setCurrentLogItem(
              FISCCIntegrationConstants.FUNDINGHOLD,
              appObj.Name +
              '-' +
              appObj.Id,
              false
            );
            if (FISCCIntegrationLogService.isLogItemNewOrFailed(itemLog)) {
              Boolean isFundHoldSuccess = FISCCFundingHoldProvider.holdFunds(appObj, FISCCIntegrationConstants.FUNDINGHOLD);
              if (isFundHoldSuccess) {
                FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FUNDINGHOLD, FISCCIntegrationConstants.FUNDING_HOLD_COMP);
              } else {
                isFundingHoldFailure = true;
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FUNDINGHOLD);
              }
            }
          } catch (Exception ex) {
            isFundingHoldFailure = true;
            tffa.logger.error(' Exception in FundHold :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FUNDINGHOLD);
          } finally {
            tffa.logger.debug('FUNDING HOLD Completed');
          }
        }

        if (
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH &&
          appObj.CZLoanHoldAmount__c != null &&
          appObj.CZLoanHoldExpiry__c != null &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          try {
            tffa.Logger.debug('In Loan Hold Amount');
            FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.APP_PROCESS + appObj.Name + '-' + appObj.Id);
            String itemLog = FISCCIntegrationLogService.setCurrentLogItem(
              FISCCIntegrationConstants.LOANHOLD,
              appObj.Name +
              '-' +
              appObj.Id,
              false
            );
            if (FISCCIntegrationLogService.isLogItemNewOrFailed(itemLog)) {
              Boolean isLoanHoldSuccess = FISCCFundingHoldProvider.holdFunds(appObj, FISCCIntegrationConstants.LOANHOLD);
              if (isLoanHoldSuccess) {
                FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
              } else {
                isLoanHoldFailed = true;
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
              }
            }
          } catch (Exception ex) {
            tffa.Logger.error('Exception in Loan Hold Amount ' + ex.getLineNumber() + ' ' + ex.getMessage());
          }
        }

        tffa.Logger.debug(
          'Status ' +
          isDepositOriginationFailure +
          isFundingHoldFailure +
          isCustAccRelnFailure +
          isCustomerCreationFailure +
          isFundingFailed +
          isCustomerInfoUpdateFailure +
          isLoanHoldFailed
        );
        if (
          isDepositOriginationFailure ||
          isFundingHoldFailure ||
          isCustAccRelnFailure ||
          isCustomerCreationFailure ||
          isFundingFailed ||
          isCustomerInfoUpdateFailure ||
          isLoanHoldFailed
        ) {
          appObj.AccountOpeningStatus__c = 'FAILURE';
          appObj.AcctOpenRetryCount__c = appObj.AcctOpenRetryCount__c + 1;
        } else {
          appObj.AccountOpeningStatus__c = 'SUCCESS';
        }
        tffa.Logger.debug('Total callouts ' + Limits.getCallouts());

        if (!withinGovernorLimits()) {
          FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
          return FISCCIntegrationLogService.submissionObj;
        }

        FISCCIntegrationLogService.applicationObjMap.put(appObj.Id, appObj);
      }

      //Update Customer information and International Phone numbers
      //If updating the customer fails, we will retry from customer update Batch
      if (
        FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH &&
        !appList.isEmpty() &&
        FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appList[0].tffa__AccountPurpose__c
      ) {
        // if CZBatchUpdateStatus__c is blank
        //if (partyObj.tffa__IsExistingCustomer__c && !partyObj.CZCustomerUpdated__c) {

        try {
          for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjMap.values()) {
            if (partyObj.tffa__IsExistingCustomer__c && !partyObj.CZCustomerUpdated__c) {
              FISCCUpdateCustInfoProvider.updateBranchCustomerInformation(new List<tffa__Party__c>{ partyObj });
              if (FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c) {
                return FISCCIntegrationLogService.submissionObj;
              }
            }
          }
        } catch (Exception ex) {
          tffa.Logger.error('Exception in Updating Customer Info ' + ex.getLineNumber() + ' ' + ex.getMessage());
        }
      }

      /* try {
        if (
          FISCCIntegrationLogService.partyObjMap != null && !CZWTFCCommonHelper.checkAliasCreated(FISCCIntegrationLogService.partyObjMap)
        ) {
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_INFORMATION);
          for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjMap.values()) {
            boolean isAliasSuccess = FISCCCustomerAliasExtension.invokeAddAliasAPI(partyObj);
            if (!isAliasSuccess) {
              break;
            }
          }
        }
      } catch (Exception ex) {
        tffa.Logger.debug('Exception in creating alias ' + ex.getLineNumber() + ' ' + ex.getMessage());
      }*/

      /**
       * Cardbase Integration
       */
      for (tffa__Application__c appObj : appList) {
        Boolean isCardIntegrationFailed = false;
        if (
          (FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.DebitCardIssueRetryCount__c < wintrustEnvConfig.BatchRetryCount__c) ||
          (appObj.tffa__AccountPurpose__c == 'DEBIT_CARD' &&
          appObj.DebitCardIssueRetryCount__c < wintrustEnvConfig.BatchRetryCount__c) ||
          Test.isRunningTest()
        ) {
          try {
            FISCCCardBaseIntegrationExecutor.processDebitCardRequest(appObj);
            if (FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c) {
              return FISCCIntegrationLogService.submissionObj;
            }

            if (appObj.DebitCardIssuanceStatus__c == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
              isCardIntegrationFailed = true;
            }
          } catch (Exception ex) {
            isCardIntegrationFailed = true;
            tffa.logger.error('Exception in Cardbase integration :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
          }
        }

        if (isCardIntegrationFailed) {
          appObj.AccountOpeningStatus__c = 'FAILURE';
        }

        if (appObj.tffa__AccountPurpose__c == 'DEBIT_CARD' && !isCardIntegrationFailed) {
          appObj.AccountOpeningStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
          appObj.tffa__Status__c = 'COMPLETED';
        }
      }

      //  Starter Check
      try {
        for (tffa__Application__c appObj : appList) {
          tffa.Logger.debug('appObj.AccountOpeningStatus__c :' + appObj.AccountOpeningStatus__c);
          // appObj.AccountOpeningStatus__c = 'SUCCESS';
          if (
            FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
            FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.STARTER_CHECK + '-' + appObj.Name + '-' + appObj.Id)
          ) {
            if (!withinGovernorLimits()) {
              FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
              return FISCCIntegrationLogService.submissionObj;
            }
            tffa.logger.debug('Submission Executor - Starter Check : Start');
            CZStarterCheckExecutor.processRequest(appObj);
            tffa.logger.debug('Submission Executor - Starter Check : End');
          }
        }
      } catch (Exception ex) {
        tffa.logger.error(' Exception in Starter Check :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      }

      try {
        CZMDMDataUploadExecutor.processRequest(FISCCIntegrationLogService.submissionObj);
      } catch (Exception ex) {
        tffa.logger.error(' Exception in MDM Upload :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      }

      // OLB Register
      if (!FISCCIntegrationLogService.isLogExist(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING)) {
        try {
          registerOnlineBanking();
          if (FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c) {
            return FISCCIntegrationLogService.submissionObj;
          }
        } catch (Exception ex) {
          tffa.logger.error(' Exception in registerOnlineBanking :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
        }
      }
    } catch (Exception ex) {
      tffa.logger.error(' exception ::: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
    } finally {
      checkAppsAndSetWidgetStatus();
      FISCCIntegrationLogService.persistData();
    }

    return fetchSubmissionObj(subId);
  }

  public static void registerOnlineBanking() {
    for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjs) {
      for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
        if (
          partyObj.CZMDMPartyID__c != null &&
          partyObj.IsOLBEnrolled__c != 'Y' &&
          additionalPreference.tffa__Code__c == 'ONLINE-BANKING' &&
          additionalPreference.tffa__Enabled__c &&
          additionalPreference.tffa__Status__c != 'COMPLETED'
        ) {
          if (!withinGovernorLimits()) {
            FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
            return;
          }
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING);
          FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING, partyObj.name, true);

          String status = CZNCRD3PartyAuthenticationProvider.registerOnlineBankingUserId(
            FISCCIntegrationLogService.submissionObj,
            partyObj
          );

          if (status == 'SUCCESS') {
            FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING_COMPLETED);
            additionalPreference.tffa__Status__c = 'COMPLETED';
          } else {
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.REGISTER_ONLINE_BANKING_FAILED);
            additionalPreference.tffa__Status__c = 'FAILED';
          }
        }
      }
    }
  }

  public static void setDigitalFlowValues(List<tffa__Application__c> appList, List<tffa__Party__c> partyList) {
    if (FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.DIGITAL) {
      FISCCCommonHelper.setAccountTitle(appList);
      FISCCCommonHelper.setStatusCode(appList);
      FISCCCommonHelper.setAccountRelnCodeAndAppLevelFields(appList);
    }
  }

  public static tffa__Submission__c fetchSubmissionObj(String id) {
    tffa__Submission__c sub = CZWTFCSubmissionRepository.fetchSubmissionbyId(id);
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(sub);
    List<tffa__Application__c> appList = CZWTFCApplicationRepository.findBySubmissionId(id);
    asm.addChildObjects('Applications__r', appList);
    return (tffa__Submission__c) asm.assemble();
  }

  public static boolean withinGovernorLimits() {
    if (Test.isRunningTest()) {
      return true;
    }
    Long currentTime = System.currentTimeMillis() - startTime;

    if (
      Limits.getCallouts() > wintrustEnvConfig.CZAllowedCalloutLimit__c ||
      Limits.getCpuTime() > wintrustEnvConfig.CZAllowedCPULimit__c ||
      currentTime > wintrustEnvConfig.CZAllowedCumulativeTimeoutLimit__c ||
      Limits.getHeapSize() > 4000000
    ) {
      tffa.Logger.debug(
        'CallOut: ' +
        String.valueOf(Limits.getCallouts()) +
        ' CPUTime: ' +
        String.valueOf(Limits.getCpuTime()) +
        ' Time: ' +
        String.valueOf(Limits.getCpuTime()) +
        'HeapSize: ' +
        Limits.getHeapSize()
      );
      return false;
    }

    return true;
  }

  public static void checkAppsAndSetWidgetStatus() {
    try {
      for (tffa__Application__c app : FISCCIntegrationLogService.applicationObjs) {
        if (app.AccountOpeningStatus__c == 'FAILURE') {
          FISCCIntegrationLogService.submissionObj.CZApplicationProcessingStatus__c = 'FAILED';
          return;
        }
      }
      FISCCIntegrationLogService.submissionObj.CZApplicationProcessingStatus__c = 'COMPLETED';
    } catch (Exception ex) {
      tffa.Logger.error('Exception thrown in checkAppsAndSetWidgetStatus ' + ex.getStackTraceString());
    }
  }

  @auraEnabled(cacheable=true)
  public static List<tffa__Application__c> getApplicationList(String subId) {
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(subId);
    return sub.tffa__Applications__r;
  }

  @auraEnabled
  public static tffa__Submission__c updateSubmissionWidgetStatus(String id) {
    tffa.Interaction.begin(FISCCSubmissionExecutor.class, 'processSubmission');
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(id);
    try {
      sub.CZApplicationProcessingStatus__c = 'IN_PROGRESS';
      CZWTFCSubmissionRepository.save(new List<tffa__Submission__c>{ sub });
    } catch (Exception ex) {
      tffa.Logger.error(' Exception msg in FISCCSubmissionExecutor.updateSubmissionWidgetStatus: ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
    return sub;
  }

  @auraEnabled
  @future(callout=true)
  public static void processSubmission(String id) {
    tffa.Interaction.begin(FISCCSubmissionExecutor.class, 'processSubmission');
    try {
      FISCCIntegrationLogService.isBatchSource = true;
      FISCCSubmissionExecutor.processApplication(id);
    } catch (Exception ex) {
      tffa.Logger.error(' Exception msg in FISCCSubmissionExecutor.processSubmission: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }
}