public inherited sharing class FISCCGetInterestRatesResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;
  public FISCCGetInterestRatesResponseBuilder() {
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
      hostResponse = hostResponse.replace('investment-rate-schedulesLst', 'investmentRateSchedulesLst');
      hostResponse = hostResponse.replace('investment-rate-tiersLst', 'investmentRateTiersLst');
      hostResponse = hostResponse.replace('control-data', 'controlData');
      tffa.Logger.debug('FISCCGetInterestRatesResponseBuilder.build hostResponse ==> ' + hostResponse);
      tffa.Logger.debug(
        'FISCCGetInterestRatesResponseBuilder.build deserialized Response ==> ' +
        (FISCCGetInterestRatesEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetInterestRatesEntityResponse.class)
      );
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetInterestRatesEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetInterestRatesEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into FISCCGetInterestRatesResponseBuilder.build :::' +
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
    FISCCGetInterestRatesEntityResponse perOutputResponse = null;

    FISCCGetInterestRatesResponse objFISCCGetInterestRatesResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCGetInterestRatesEntityResponse) response;
        tffa.Logger.debug(
          'FISCCGetInterestRatesResponseBuilder.parseResponse: perOutputResponse  in response builder ==> ' + perOutputResponse
        );
        if (perOutputResponse.Entity != null) {
          objFISCCGetInterestRatesResponse = new FISCCGetInterestRatesResponse();
          objFISCCGetInterestRatesResponse.controlData = perOutputResponse.Entity.controlData;
          for (FISCCInvestmentRateSchedulesDTO investmentRateSchedule : perOutputResponse.Entity.investmentRateSchedulesLst) {
            if (objFISCCGetInterestRatesResponse.investmentRateSchedulesMap.containsKey(investmentRateSchedule.IntPlnCde)) {
              FISCCInvestmentRateSchedulesDTO schInMap = objFISCCGetInterestRatesResponse.investmentRateSchedulesMap.get(
                investmentRateSchedule.IntPlnCde
              );
              Date schInMapEffDate = Date.valueOf(schInMap.EffDte);
              Date schCurrEffDate = Date.valueOf(investmentRateSchedule.EffDte);
              //If effective date of current loop element is greater than effective date of existing map element, then insert new element
              if (schCurrEffDate > schInMapEffDate) {
                objFISCCGetInterestRatesResponse.investmentRateSchedulesMap.put(investmentRateSchedule.IntPlnCde, investmentRateSchedule);
              }
            } else {
              objFISCCGetInterestRatesResponse.investmentRateSchedulesMap.put(investmentRateSchedule.IntPlnCde, investmentRateSchedule);
            }
          }

          for (FISCCInvestmentRateTiersDTO investmentRateTier : perOutputResponse.Entity.investmentRateTiersLst) {
            if (objFISCCGetInterestRatesResponse.investmentRateTiersMap.containsKey(investmentRateTier.InvestRteSchedIndx)) {
              List<FISCCInvestmentRateTiersDTO> invRateTiersList = objFISCCGetInterestRatesResponse.investmentRateTiersMap.get(
                investmentRateTier.InvestRteSchedIndx
              );
              invRateTiersList.add(investmentRateTier);
              objFISCCGetInterestRatesResponse.investmentRateTiersMap.put(investmentRateTier.InvestRteSchedIndx, invRateTiersList);
            } else {
              List<FISCCInvestmentRateTiersDTO> invRateTiersList = new List<FISCCInvestmentRateTiersDTO>();
              invRateTiersList.add(investmentRateTier);
              objFISCCGetInterestRatesResponse.investmentRateTiersMap.put(investmentRateTier.InvestRteSchedIndx, invRateTiersList);
            }
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCGetInterestRatesResponseBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug(
      'FISCCGetInterestRatesResponseBuilder.parseResponse: Response in GetInterestRates ::: ' + objFISCCGetInterestRatesResponse
    );
    return objFISCCGetInterestRatesResponse;
  }
}