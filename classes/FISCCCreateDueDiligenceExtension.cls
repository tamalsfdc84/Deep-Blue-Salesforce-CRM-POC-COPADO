public with sharing class FISCCCreateDueDiligenceExtension {
  @TestVisible
  private static boolean testException = false;

  public static boolean invokeApiCall(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess = true;
    String logitemCCD = FISCCIntegrationLogService.setCurrentLogItem(
      FISCCIntegrationConstants.CREATE_CUSTOMER_DUE_DILIGENCE,
      partyObj.Name,
      false
    );
    if (FISCCIntegrationLogService.isLogItemNewOrFailed(logitemCCD)) {
      fisccRequestBaseDTO = FISCCCreateDueDiligenceExtension.generateRequest(partyObj);
      tffa.Logger.debug('--------- fisccRequestBaseDTO' + fisccRequestBaseDTO);
      String custNumber = '';

      FISCC_Adapter_Configs__mdt adapterconfiguration = adapterConfig.clone();

      if (!Test.isRunningTest()) {
        custNumber = adapterConfig.IsEncrypted__c ? FISCCCommonHelper.encrypt(partyObj.Customer_Number__c) : partyObj.Customer_Number__c;
      }
      adapterconfiguration.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{custNumber}', custNumber);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterconfiguration, charterConfig);
      tffa.Logger.debug('--------- result' + result);
      isSuccess = FISCCCreateDueDiligenceExtension.parseCreateDDResponse(result);
      if (isSuccess) {
        partyObj.IsFisDueDiligenceCreated__c = true;
        if (!Test.isRunningTest()) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CREATE_CUSTOMER_DUE_DILIGENCE);
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.CREATE_CUSTOMER_DUE_DILIGENCE_SUCCESS);
        }
      } else {
        if (!Test.isRunningTest()) {
          isSuccess = false;
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CREATE_CUSTOMER_DUE_DILIGENCE);
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
          throw new tffa.ApplicationException('create Due diligence failed');
        }
      }
    }
    return isSuccess;
  }

  public static FISCCRequestBaseDTO generateRequest(tffa__Party__c partyObj) {
    tffa.Logger.debug('In generateDDReq');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCCreateDDRequestDTO createDDReq = new FISCCCreateDDRequestDTO();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (partyObj != null && partyObj.tffa__Employments__r != null && !partyObj.tffa__Employments__r.isEmpty()) {
        if (
          (partyObj.tffa__Employments__r[0].tffa__Type__c) == 'STUDENT' ||
          (partyObj.tffa__Employments__r[0].tffa__Type__c) == 'HOMEMAKER'
        ) {
          createDDReq.dueDiligenceDemographics.FullTime = 'U';
          createDDReq.dueDiligenceDemographics.OccpnDesc = partyObj.tffa__Employments__r[0].tffa__Type__c;
        } else if (partyObj.tffa__Employments__r[0].tffa__Type__c != null) {
          CZTerafinaFisMapping__c tfFisMap = CZTerafinaFisMapping__c.getValues(
            FISCCIntegrationConstants.EMPLOYMENT_TYPE +
            '_' +
            partyObj.tffa__Employments__r[0].tffa__Type__c
          );
          if (tfFisMap != null) {
            createDDReq.dueDiligenceDemographics.FullTime = tfFisMap.FisValue__c;
          }
          createDDReq.dueDiligenceDemographics.OccpnDesc = getOccupationLabel(partyObj.tffa__Employments__r[0].OccupationType__c);
        }

        if (!String.isBlank(partyObj.tffa__Employments__r[0].tffa__Title__c)) {
          createDDReq.dueDiligenceDemographics.Title = partyObj.tffa__Employments__r[0].tffa__Title__c;
        }
        if (partyObj.tffa__Citizenship__c == CZWTFCConstants.RESIDENT) {
          createDDReq.dueDiligenceDemographics.RsdntPrsn = 'Y';
        }
        fisccRequestBaseDTO = createDDReq;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateCreateDDRequest ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return fisccRequestBaseDTO;
  }

  public static Boolean parseCreateDDResponse(Object response) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (response instanceof FISCCCreateDDResponseDTO) {
        FISCCCreateDDResponseDTO createDDResp = (FISCCCreateDDResponseDTO) response;
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseCreateDDResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }

  public static String getOccupationLabel(String value) {
    List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.tffa__Employment__c.fields.OccupationType__c.getPicklistValues();

    if (picklistEntries != null) {
      for (Schema.PicklistEntry ple : picklistEntries) {
        if ((ple.getValue()).equalsIgnoreCase(value)) {
          return ple.getLabel();
        }
      }
    }
    return '';
  }

  public static String getEmploymentTypeLabel(String value) {
    List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.tffa__Employment__c.fields.tffa__Type__c.getPicklistValues();

    if (picklistEntries != null) {
      for (Schema.PicklistEntry ple : picklistEntries) {
        if ((ple.getValue()).equalsIgnoreCase(value)) {
          return ple.getLabel();
        }
      }
    }
    return '';
  }
}