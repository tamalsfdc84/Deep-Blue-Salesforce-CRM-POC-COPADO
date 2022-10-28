public inherited sharing class FISCCSubmissionExecutor {
  // public static Boolean isManuallyApproved = false;
  /**
   * @description Prepare required data for api call
   * @param String submissionId
   * @return void
   */
  private static void buildData(String submissionId) {
    FISCCIntegrationLogService.setSubmissionObj(submissionId);
    if (FISCCIntegrationLogService.submissionObj == null) {
      throw new tffa.ApplicationException(FISCCIntegrationConstants.INVALID_SUBMISSION);
    }
    FISCCIntegrationLogService.setSubmissionObj(submissionId);
    FISCCIntegrationLogService.setPartyObjs();
    FISCCIntegrationLogService.setIntegrationLog(submissionId);
    FISCCIntegrationLogService.setApplicationObjs();
  }

  /**
   * @description make api call to jxchange
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static tffa__Submission__c processApplication(String submissionId) {
    Boolean isNewUser = false;
    Boolean isPartyAddressChange = false;
    //tffa.ApplicationAssigner appAssigner = new tffa.ApplicationAssigner();
    try {
      tffa.logger.debug('Inside processApplication :' + submissionId);

      // build the required data for api in this function
      buildData(submissionId);
      List<tffa__Application__c> appList = new List<tffa__Application__c>();
      tffa.Logger.debug('appList before ' + FISCCIntegrationLogService.applicationObjs);
      appList = FISCCSubmissionExecutor.filterApplications(FISCCIntegrationLogService.applicationObjs);
      FISCCIntegrationLogService.applicationObjs = appList;
      tffa.Logger.debug('appList after ' + appList);
      FISCCCommonHelper.setFISBranchAndCostCenter(appList, FISCCIntegrationLogService.partyObjs);

      //Recheck if it's a Existing Customer
      try {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
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
      } catch (Exception ex) {
        tffa.logger.error('Exception in Searching Customer Number :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      }

      for (tffa__Application__c appObj : appList) {
        Boolean isSuccess = false;
        Boolean isDepositOriginationFailure = false;
        Boolean isFundingHoldFailure = false;
        Boolean isBenefAdditionFalure = false;
        Boolean isCustomerInfoUpdateFailure = false;
        Boolean isFundingFailed = false;

        if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id)) {
          try {
            tffa.logger.debug('Inside ACCOUNT_OPENING and the Party Objects are ' + FISCCIntegrationLogService.partyObjs);

            FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id);

            try {
              if (appObj.tffa__ProductCategory__c.equalsIgnoreCase('CERTIFICATE') && appObj.tffa__Term__c != 0) {
                String promoIntTerm = null;
                if (!String.isBlank(appObj.tffa__PromotionCode__c)) {
                  promoIntTerm = CZWTFCHelperRepository.fetchPromotionPlanCode(appObj.tffa__PromotionCode__c);
                  appObj.InterestPlanCode__c = promoIntTerm;
                }

                if (String.isBlank(promoIntTerm)) {
                  tffa__ProductTerm__c prodTermObj = CZWTFCHelperRepository.findProductTerms(appObj.tffa__Product__c, appObj.tffa__Term__c);
                  if (
                    prodTermObj != null &&
                    prodTermObj.tffa__InterestPlanCode__c != null &&
                    !String.isBlank(prodTermObj.tffa__InterestPlanCode__c)
                  ) {
                    appObj.InterestPlanCode__c = prodTermObj.tffa__InterestPlanCode__c;
                  }
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

            if (FISCCIntegrationLogService.submissionObj != null) {
              isSuccess = FISCCDepositOriginationProvider.createDepositOrigination(
                FISCCIntegrationLogService.partyObjs,
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
            tffa.logger.debug('ACCOUNT_OPENING Completed');
          }
        } else {
          // account perviously opened
          appObj.IsAccAlreadyOpened__c = true;
        }

        if (
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__Beneficiaries__r != null &&
          !appObj.tffa__Beneficiaries__r.isEmpty()
        ) {
          try {
            if (
              FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.ADD_BENEFICIARY + '-' + appObj.Name + '-' + appObj.Id)
            ) {
              FISCCIntegrationLogService.setCurrentLog(
                FISCCIntegrationConstants.ADD_BENEFICIARY_FLOW +
                '-' +
                appObj.Name +
                '-' +
                appObj.Id
              );
              Boolean isBenefSuccess = FISCCAddBenefRelnProvider.addBenefReln(appObj);

              if (isBenefSuccess) {
                FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.ADD_BENEFICIARY);
                FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ADD_BENEFICIARY_COMPLETED);
                FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.ADD_BENEFICIARY_COMPLETED);
                tffa.Logger.debug('add benef success');
              } else {
                isBenefAdditionFalure = true;
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ADD_BENEFICIARY);
                FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ADD_BENEFICIARY_FAILURE);
              }
            }
          } catch (Exception ex) {
            isBenefAdditionFalure = true;
            tffa.logger.error('Exception in add Benef Reln :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ADD_BENEFICIARY);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ADD_BENEFICIARY_FAILURE);
          }
        }

        if (FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id)) {
          try {
            if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION)) {
              boolean custInfoUpdateFlag;
              //FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FLOW);
              custInfoUpdateFlag = FISCCUpdateCustInfoProvider.updateCustInfo(FISCCIntegrationLogService.partyObjs);
              if (custInfoUpdateFlag) {
                //FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_COMPLETED);
              } else {
                //FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FAILURE);
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

        if (
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_OPENING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__LinkedFundingRequests__r != null &&
          !appObj.tffa__LinkedFundingRequests__r.isEmpty()
        ) {
          try {
            if (
              FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING + '-' + appObj.Name + '-' + appObj.Id)
            ) {
              FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_FUNDING + '-' + appObj.Name + '-' + appObj.Id);
              if (
                ((String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__RoutingNumber__c) &&
                String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__AccountNumber__c) &&
                String.isNotBlank(appObj.tffa__LinkedFundingRequests__r[0].tffa__AccountType__c)) ||
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) ||
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER)) &&
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c > 0
              ) {
                Boolean appFunded = FISCCApplicationFundingProvider.processFunding(appObj);
                if (appFunded) {
                  FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.ACCOUNT_FUNDING_COMPLETED);
                } else {
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED);
                  isFundingFailed = true;
                }
              } else {
                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED);
                isFundingFailed = true;
              }
            }
          } catch (Exception ex) {
            tffa.logger.error('Exception in application funding :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ACCOUNT_FUNDING_FAILED);
            isFundingFailed = true;
          }
        }

        if (
          FISCCIntegrationLogService.isLogOk(FISCCIntegrationConstants.ACCOUNT_FUNDING + '-' + appObj.Name + '-' + appObj.Id) &&
          appObj.tffa__LinkedFundingRequests__r != null &&
          !appObj.tffa__LinkedFundingRequests__r.isEmpty() &&
          appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_ACH) &&
          !appObj.tffa__LinkedFundingRequests__r[0].IsObsolete__c &&
          !appObj.tffa__LinkedFundingRequests__r[0].tffa__IsDeleted__c
        ) {
          try {
            if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.FUNDINGHOLD + '-' + appObj.Name + '-' + appObj.Id)) {
              FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.FUNDINGHOLD + '-' + appObj.Name + '-' + appObj.Id);
              Boolean isFundHoldSuccess = FISCCFundingHoldProvider.holdFunds(appObj);
              if (isFundHoldSuccess) {
                FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FUNDINGHOLD, FISCCIntegrationConstants.FUNDING_HOLD_COMP);
                FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.FUNDING_HOLD_COMP);
              } else {
                isFundingHoldFailure = true;
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FUNDINGHOLD);
                FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.FUNDING_HOLD_FAILED);
                //appObj.tffa__Score__c = FISCCApplicationConstants.HOLD_FAILED_CODE;
                //appObj = appAssigner.assign(new List<tffa__Application__c>{ appObj })[0];
              }
            }
          } catch (Exception ex) {
            isFundingHoldFailure = true;
            tffa.logger.error(' Exception in FundHold :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FUNDINGHOLD);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.FUNDINGHOLD);
          } finally {
            tffa.logger.debug('FUNDING HOLD Completed');
          }
        }

        if (
          isDepositOriginationFailure ||
          isFundingHoldFailure ||
          isBenefAdditionFalure ||
          isCustomerInfoUpdateFailure ||
          isFundingFailed
        ) {
          appObj.AccountOpeningStatus__c = 'FAILURE';
          appObj.AcctOpenRetryCount__c = appObj.AcctOpenRetryCount__c + 1;
        } else {
          appObj.AccountOpeningStatus__c = 'SUCCESS';
        }
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
        } catch (Exception ex) {
          tffa.logger.error(' Exception in registerOnlineBanking :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
        }
      }
    } catch (Exception ex) {
      tffa.logger.error(' exception ::: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
    } finally {
      FISCCIntegrationLogService.persistData();
    }
    return FISCCIntegrationLogService.fetchSubmissionById(submissionId);
  }

  public static List<tffa__Application__c> filterApplications(List<tffa__Application__c> appObjs) {
    List<tffa__Application__c> appList = new List<tffa__Application__c>();
    List<tffa__Application__c> reviewAppLst = new List<tffa__Application__c>();
    List<String> appStatus = new List<String>{ 'SUBMITTED', 'APPROVED', 'IN_PROGRESS' };
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
            !appObj.tffa__LinkedFundingRequests__r[0].tffa__IsDeleted__c
          ) {
            appList.add(appObj);
          }
        } else {
          appList.add(appObj);
        }
      } else if (!String.isBlank(appObj.tffa__KYCDecisionOutcome__c) && appObj.tffa__KYCDecisionOutcome__c.equalsIgnoreCase('REVIEW')) {
        reviewAppLst.add(appObj);
      }
    }
    FISCCIntegrationLogService.reviewApps = reviewAppLst;
    return appList;
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
}