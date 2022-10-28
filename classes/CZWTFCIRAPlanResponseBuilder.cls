public with sharing class CZWTFCIRAPlanResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;

  public CZWTFCIRAPlanResponseBuilder() {
  }

  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      //hostResponse = '{"Entity":{"customer-data":{"TaxNbr":"string","CustTaxId":"string","CustNme":"string","CustDOB":"string","CustDecdDte":"string","CustDeathCert":"string","CustNewTaxId":"string","CustLstMaintTmestmp":"string","CustLstMaintDte":"string","CustCurPlnBalTot":0,"CustYTDContributionsTot":0,"CustPRYRContributionsTot":0,"CustYTDDistrbutionsTot":0,"CustPRYRDistributionsTot":0,"NbrPln":0,"MorePages":"N","NextPageCursor":"string"},"customer-plan-dataLst":[{"CustPlnNbr":"123456","CustPlnTyp":"1","CustPlnTypNme":"string","CustCurPlnBal":0,"CustYTDContributions":0,"CustPRYRContributions":0,"CustYTDDistrbutions":0,"CustPRYRDistributions":0},{"CustPlnNbr":"1234567","CustPlnTyp":"1","CustPlnTypNme":"string","CustCurPlnBal":0,"CustYTDContributions":0,"CustPRYRContributions":0,"CustYTDDistrbutions":0,"CustPRYRDistributions":0}]},"Metadata":{"MsgLst":[{"Code":"string","Text":"string","Type":"System Error","Severity":"string"}]}}';

      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (hostResponse.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
          hostResponse = hostResponse.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
        }
      }

      tffa.Logger.debug('CZWTFCIRAPlanResponseBuilder.build hostResponse ==> ' + hostResponse);
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetIRAPlansEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetIRAPlansEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into CZWTFCIRAPlanResponseBuilder.build :::' +
        ex.getMessage() +
        ' LineNumber :::' +
        ex.getStackTraceString()
      );
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    FISCCGetIRAPlansEntityResponse perOutputResponse = null;

    CZWTFCExistingIRAPlanResponse objCZWTFCExistingIRAPlanResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      Map<String, String > investmentPlanTypeMap = new Map<String, String >();
      for(CZTerafinaFisMapping__c investmentPlanType: CZWTFCHelperRepository.getTFndFISMappingByType('InvestmentPlanType')){
        investmentPlanTypeMap.put(investmentPlanType.FisValue__c, investmentPlanType.TerafinaValue__c);
      }

      if (response != null) {
        perOutputResponse = (FISCCGetIRAPlansEntityResponse) response;
        tffa.Logger.debug('CZWTFCIRAPlanResponseBuilder.parseResponse: perOutputResponse  ==> ' + perOutputResponse);
        objCZWTFCExistingIRAPlanResponse = new CZWTFCExistingIRAPlanResponse();
        if (perOutputResponse.Entity != null) {
          objCZWTFCExistingIRAPlanResponse.customerData = perOutputResponse.Entity.customerData;

          List<CZWTFCExistingIRAPlanDTO> plans = new List<CZWTFCExistingIRAPlanDTO>();
          for(CZWTFCExistingIRAPlanDTO plan : perOutputResponse.Entity.existingPlanList) {
            plan.CustPlnTyp = investmentPlanTypeMap.containsKey(plan.CustPlnTyp) ? investmentPlanTypeMap.get(plan.CustPlnTyp) : '';
            plans.add(plan);
          }
          objCZWTFCExistingIRAPlanResponse.existingPlanList = plans;
        }
        tffa.Logger.debug(
          'CZWTFCIRAPlanResponseBuilder.parseResponse: objCZWTFCExistingIRAPlanResponse ==> ' + objCZWTFCExistingIRAPlanResponse
        );
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAPlanResponseBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('CZWTFCIRAPlanResponseBuilder.parseResponse: objCZWTFCExistingIRAPlanResponse : ' + objCZWTFCExistingIRAPlanResponse);

    return objCZWTFCExistingIRAPlanResponse;
  }
}