public with sharing class FISCCOrgCustomerRelnExtension {
  public static List<Id> customerToCustomerRelnCreated = new List<Id>();
  public static Id orgOwnerCreated;
  public static boolean invokeBusinessOwnerRelnCall(List<tffa__Party__c> partyObjs, tffa__Submission__c subObj) {
    tffa.Logger.debug('In invokeBusinessOwnerRelnCall');
    boolean isRelnCreationSuccess = false;
    Object result;
    try {
      do {
        customerToCustomerRelnCreated = new List<Id>();

        for (tffa__Party__c partyObj : partyObjs) {
          if (
            partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION &&
            !partyObj.CZOwnerRelnCompleted__c &&
            !partyObj.tffa__IsExistingCustomer__c
          ) {
            FISCCIntegrationLogService.setCurrentLogItem(
              FISCCIntegrationConstants.CUST_TO_CUST_CREATION_RELN,
              'Business and Owners Reln',
              true
            );
            FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
              FISCCIntegrationConstants.CUST_TO_CUST_RELN_ADAPTERCONFIG
            );
            FISCCRequestBaseDTO fisccRequestBaseDTO = null;
            fisccRequestBaseDTO = generateReq(partyObj, subObj);

            result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

            if (parseRelnResponse(result, partyObjs)) {
              FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CUST_TO_CUST_CREATION_RELN_SUCCESS);
              isRelnCreationSuccess = true;
            } else {
              FISCCCommonHelper.setErrormessageInSub();
              FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CUST_TO_CUST_CREATION_RELN_FAILURE);
              isRelnCreationSuccess = false;
              throw new tffa.ApplicationException('Customer to Customer Relationship API Failed.');
            }
            FISCCOrgCustomerRelnExtension.customerToCustomerRelnCreated = new List<Id>();
          }
        }
      } while (!CZWTFCCommonHelper.checkCustToCustRelnCreated(FISCCIntegrationLogService.partyObjMap));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in invokeCustAccRelnAPI ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      isRelnCreationSuccess = false;
    }
    return isRelnCreationSuccess;
  }

  public static FISCCRequestBaseDTO generateReq(tffa__Party__c partyObj, tffa__Submission__c subObj) {
    Integer relnAdded = 0;
    tffa.Logger.debug('In FISCCOrgCustomerRelnExtension.generateReq');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCCustToCustRelnRequestDTO reqDto = new FISCCCustToCustRelnRequestDTO();

    // for (tffa__Party__c partyObj : partyObjs) {
    if (relnAdded < 10) {
      if (partyObj.tffa__PartyXrefs__r != null && !partyObj.tffa__PartyXrefs__r.isEmpty()) {
        reqDto.ccMaintainedCust.CustNbr = partyObj.Customer_Number__c;
        orgOwnerCreated = partyObj.Id;
        for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
          if (!partyPartyObj.CZFisRelnshipCreated__c && relnAdded < 10 && partyPartyObj.tffa__RelationCode__r != null) {
            FISCCCustToCustRelnRequestDTO.CustomerRelnship relnDto = new FISCCCustToCustRelnRequestDTO.CustomerRelnship();

            relnDto.E1toE2Cde = partyPartyObj.tffa__RelationCode__r.tffa__Value__c;
            relnDto.E2toE1Cde = partyPartyObj.tffa__RelationCode__r.CZToRelnCode__c;
            relnDto.RltBeneTitle = partyPartyObj.tffa__Title__c;
            relnDto.RltPercentOwner = partyPartyObj.tffa__OwnershipPercentage__c != null
              ? String.valueOf(partyPartyObj.tffa__OwnershipPercentage__c)
              : null;
            relnDto.RltCustNbr = FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).Customer_Number__c;
            customerToCustomerRelnCreated.add(partyPartyObj.Id);
            reqDto.customerRelnship.add(relnDto);
            relnAdded++;
          }
        }
      }
    }

    fisccRequestBaseDTO = reqDto;
    return fisccRequestBaseDTO;
  }

  public static boolean parseRelnResponse(Object response, List<tffa__Party__c> partyObjs) {
    tffa.Logger.debug('In parseRelnResponse');
    try {
      if (response instanceof FISCCCustToCustRelnDTO) {
        FISCCCustToCustRelnDTO custToCustResp = (FISCCCustToCustRelnDTO) response;
        tffa.Logger.debug('parseRelnResponse--> ' + custToCustResp);
        for (
          tffa__PartyPartyXref__c partyPartyObj : FISCCIntegrationLogService.partyObjMap.get(FISCCOrgCustomerRelnExtension.orgOwnerCreated)
            .tffa__PartyXrefs__r
        ) {
          if (FISCCOrgCustomerRelnExtension.customerToCustomerRelnCreated.contains(partyPartyObj.Id)) {
            partyPartyObj.CZFisRelnshipCreated__c = true;
          }
        }
        FISCCIntegrationLogService.partyObjMap.get(FISCCOrgCustomerRelnExtension.orgOwnerCreated).CZOwnerRelnCompleted__c = true;
        for (
          tffa__PartyPartyXref__c partyPartyObj : FISCCIntegrationLogService.partyObjMap.get(FISCCOrgCustomerRelnExtension.orgOwnerCreated)
            .tffa__PartyXrefs__r
        ) {
          if (!partyPartyObj.CZFisRelnshipCreated__c) {
            FISCCIntegrationLogService.partyObjMap.get(FISCCOrgCustomerRelnExtension.orgOwnerCreated).CZOwnerRelnCompleted__c = false;
            break;
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseRelnResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }
}