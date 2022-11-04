public with sharing class CZIRACreateRetirementPlanExtension {
  public static boolean invokeApiCall(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    tffa__Application__c applicationObj,
    CZWTFCIRAPlanDetailsResponse planDetails
  ) {
    CZIRARetirementPlanResponseDTO response;
    Boolean finalResult = false;

    try {
      FISCCRequestBaseDTO fisccRequestBaseDTO = createRetirementPlanRequest(planDetails, applicationObj);
      Object result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);

      response = isFISCCAPICallSuccess(result);

      finalResult = response != null ? true : false;
      if (finalResult) {
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.IRA_CREATE_PLAN);
      } else {
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.IRA_CREATE_PLAN);
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZIRACreateRetirementPlanExtension.invokeApiCall ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    return finalResult;
  }

  public static FISCCRequestBaseDTO createRetirementPlanRequest(CZWTFCIRAPlanDetailsResponse planDetails, tffa__Application__c applicationObj) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    CZIRACreateRetirementPlanReqDTO request = new CZIRACreateRetirementPlanReqDTO();

    try {
      request.plansDetail = planDetails.planData;
      request.planAccountData = planDetails.planAccountData;

      request.plansDetail.PlnBnfcyPln =  'Y';
      request.plansDetail.DecdTin = applicationObj.CZInvestmentDeceasedPersonTaxIDNumber__c;

      fisccRequestBaseDTO = request;

      tffa.Logger.debug('fisccRequestBaseDTO::' + fisccRequestBaseDTO);

      return fisccRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in CZIRACreateRetirementPlanExtension createRetirementPlanRequest : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
    }
    return fisccRequestBaseDTO;
  }

  public static CZIRARetirementPlanResponseDTO isFISCCAPICallSuccess(Object response) {
    CZIRARetirementPlanResponseDTO objCZIRARetirementPlanResponseDTO;
    if (response instanceof CZIRARetirementPlanResponseDTO) {
      objCZIRARetirementPlanResponseDTO = (CZIRARetirementPlanResponseDTO) response;
    }

    if (
      objCZIRARetirementPlanResponseDTO != null &&
      objCZIRARetirementPlanResponseDTO.Metadata.MsgLst != null &&
      !objCZIRARetirementPlanResponseDTO.Metadata.MsgLst.isEmpty()
    ) {
      if (
        ('0').equalsIgnoreCase(objCZIRARetirementPlanResponseDTO.Metadata.MsgLst[0].Code) &&
        ('Success').equalsIgnoreCase(objCZIRARetirementPlanResponseDTO.Metadata.MsgLst[0].Text)
      ) {
        return objCZIRARetirementPlanResponseDTO;
      }
    }

    return null;
  }
}