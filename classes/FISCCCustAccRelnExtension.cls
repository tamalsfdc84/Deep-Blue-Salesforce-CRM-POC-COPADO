public with sharing class FISCCCustAccRelnExtension {
  public static boolean invokeCustAccRelnAPI(List<tffa__Party__c> partyObjs, tffa__Application__c tfApp, tffa__Submission__c subObj) {
    tffa.logger.debug('In invokeCustAccRelnAPI');
    boolean isRelnCreationSuccess = false;
    Object result;
    try {
      do {
        FISCCDepositOriginationExtension.relnAdded.clear();
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP, tfApp.Name, true);
        FISCCRequestBaseDTO fisccRequestBaseDTO;
        FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
          FISCCIntegrationConstants.CUST_RELN_ADAPTERCONFIG
        );
        fisccRequestBaseDTO = generateCustAccRelnReq(tfApp);
        tffa.Logger.debug('invokeCustAccRelnAPI fisccRequestBaseDTO' + fisccRequestBaseDTO);
        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);
        tffa.Logger.debug('invokeCustAccRelnAPI result' + result);
        if (parseCustAcctRelnResponse(result, tfApp)) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP);
          isRelnCreationSuccess = true;
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP);
          isRelnCreationSuccess = false;
          break;
        }
      } while (!CZWTFCCommonHelper.checkCustomerAccRelnCompleted(tfApp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in invokeCustAccRelnAPI ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      isRelnCreationSuccess = false;
    }
    return isRelnCreationSuccess;
  }

  /**
   *
   */
  public static FISCCRequestBaseDTO generateCustAccRelnReq(tffa__Application__c appObj) {
    tffa.Logger.debug('In generateCustAccRelnReq');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCCustAccRelnRequestDTO relnReq = new FISCCCustAccRelnRequestDTO();
    tffa__Product__c prod = appObj.tffa__Product__r;
    Integer applicantRelnCounter = 0;
    try {
      relnReq.caMaintainAcc.ApCd1 = FISCCIntegrationConstants.GenDPApplID;
      relnReq.caMaintainAcc.ApNbr1 = appObj.tffa__AccountNumber__c;
      for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
        if (applicantRelnCounter < FISCCIntegrationConstants.CUSTOMER_RELN_LIMIT && !appParty.CZFisRelnshipCreated__c && !FISCCIntegrationConstants.DEPUTY.equalsIgnoreCase(appParty.tffa__ApplicantRole__r.tffa__Code__c)) {
          FISCCDepositOriginationExtension.relnAdded.add(appParty.Id);
          tffa__Party__c partyObject = FISCCIntegrationLogService.partyObjMap.get(appParty.tffa__party__c);
          FISCCCustAccRelnRequestDTO.CustomerAccountRelnList customerDetail = new FISCCCustAccRelnRequestDTO.CustomerAccountRelnList();
          customerDetail.AcNbr2 = partyObject.Customer_Number__c;
          customerDetail.E2ToE1RlCd = appParty.tffa__Primary__c
            ? FISCCIntegrationConstants.CUST_ACC_PRIMARY_RELN
            : FISCCIntegrationConstants.CUST_ACC_SECONDARY_RELN;
          if (appParty.tffa__ApplicantRole__r != null && appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c != null) {
            customerDetail.E1ToE2RlCd = appParty.tffa__ApplicantRole__r.CZFISRelationshipCode__c;
          } else {
            if (prod.IsCustodianProduct__c) {
              customerDetail.E1ToE2RlCd = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            } else {
              customerDetail.E1ToE2RlCd = FISCCIntegrationConstants.JOINT_RELATION;
            }
          }
          relnReq.caAccRelnList.add(customerDetail);
          applicantRelnCounter++;
        }
      }

      if(appObj.tffa__ProductCategory__c != null && FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c) && appObj.tffa__DepositBoxAccountNumber__c != null){
        relnReq.caMaintainAcc.ApCd1 = FISCCIntegrationConstants.GenSDBApplID;
        relnReq.caMaintainAcc.ApNbr1 = appObj.tffa__DepositBoxAccountNumber__c;
      }

      if (
        applicantRelnCounter < FISCCIntegrationConstants.CUSTOMER_RELN_LIMIT &&
        appObj.tffa__Beneficiaries__r != null &&
        !appObj.tffa__Beneficiaries__r.isEmpty() &&
        !FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY.equalsIgnoreCase(prod.tffa__Category__c) &&
        !FISCCIntegrationConstants.HSA_PRODUCT_CATEGORY.equalsIgnoreCase(prod.tffa__Category__c)
      ) {
        for (tffa__Beneficiary__c benefObj : appObj.tffa__Beneficiaries__r) {
          if (applicantRelnCounter < FISCCIntegrationConstants.CUSTOMER_RELN_LIMIT && !benefObj.CZFisRelnshipCreated__c) {
            FISCCDepositOriginationExtension.relnAdded.add(benefObj.Id);
            FISCCCustAccRelnRequestDTO.CustomerAccountRelnList customerDetail = new FISCCCustAccRelnRequestDTO.CustomerAccountRelnList();
            customerDetail.AcNbr2 = benefObj.Customer_Number__c;
            customerDetail.E1ToE2RlCd = FISCCIntegrationConstants.BENEF_RELN_CODE;
            customerDetail.E2ToE1RlCd = FISCCIntegrationConstants.CUST_ACC_SECONDARY_RELN;
            relnReq.caAccRelnList.add(customerDetail);
            applicantRelnCounter++;
          }
        }
      }
      fisccRequestBaseDTO = relnReq;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateCustAccRelnReq ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return fisccRequestBaseDTO;
  }

  /**
   * Parse Response
   */
  public static boolean parseCustAcctRelnResponse(Object response, tffa__Application__c appObj) {
    try {
      if (response instanceof FISCCCustAccRelnResponseDTO) {
        FISCCCustAccRelnResponseDTO custAcctResp = (FISCCCustAccRelnResponseDTO) response;
        tffa.Logger.debug('parseCustAcctRelnResponse--> ' + custAcctResp);
        for (tffa__ApplicationPartyXref__c appPartyObj : appObj.tffa__PartyXrefs__r) {
          if (FISCCDepositOriginationExtension.relnAdded.contains(appPartyObj.Id)) {
            appPartyObj.CZFisRelnshipCreated__c = true;
          }
        }

        for (tffa__Beneficiary__c benefObj : appObj.tffa__Beneficiaries__r) {
          if (FISCCDepositOriginationExtension.relnAdded.contains(benefObj.Id)) {
            benefObj.CZFisRelnshipCreated__c = true;
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseCustAcctRelnResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }
}