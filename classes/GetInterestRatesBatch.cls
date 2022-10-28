global inherited sharing class GetInterestRatesBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  private List<String> param = new List<String>{};

  public Database.QueryLocator start(Database.BatchableContext bc) {
    tffa.Logger.debug('GetInterestRatesBatch.start: Start Datetime : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
    return Database.getQueryLocator(getQuery());
  }

  public void execute(Database.BatchableContext bc, List<SObject> brandsLst) {
    tffa.Interaction.begin(GetInterestRatesBatch.class, 'execute');
    try{
      Set<String> intPlanCodeSet = CZWTFCHelperRepository.fetchUniqueInterestPlanCodes();
      for (tffa__Brand__c brand : (List<tffa__Brand__c>) brandsLst) {
        tffa.logger.debug('GetInterestRatesBatch: Executing for brand code: ' + brand.tffa__Code__c);
        FISCCGetInterestRatesResponse response = FISCCGetInterestRatesProvider.getInterestRates(brand.tffa__Code__c);
        List<sObject> intPlanDtlsLst = new List<InterestPlanDetails__c>();
        List<String> usedIntPlanDtlsLst = new List<String>();
        if (response != null) {
          for (String intPlanCode : intPlanCodeSet) {
            FISCCInvestmentRateSchedulesDTO investmentRateSchedule = response.investmentRateSchedulesMap.get(intPlanCode);
            if (investmentRateSchedule != null) {
              if ('N'.equals(investmentRateSchedule.RteSchedInd)) {
                //Non-tiered
                InterestPlanDetails__c intPlanDtls = getNonTieredInterestPlanDetails(brand.tffa__Code__c, investmentRateSchedule);
                usedIntPlanDtlsLst.add(intPlanDtls.IntPlnCde__c + ':' + CZWTFCConstants.NON_TIERED + ':' + CZWTFCConstants.NON_TIERED);
                intPlanDtlsLst.add(intPlanDtls);
              } else {
                //Tiered
                for (FISCCInvestmentRateTiersDTO invRateTier : response.investmentRateTiersMap.get(intPlanCode)) {
                  InterestPlanDetails__c intPlanDtls = getTieredInterestPlanDetails(brand.tffa__Code__c, investmentRateSchedule, invRateTier);
                  usedIntPlanDtlsLst.add(
                    intPlanDtls.IntPlnCde__c +
                    ':' +
                    String.valueOf(intPlanDtls.TierMinBal__c.setScale(2)) +
                    ':' +
                    String.valueOf(intPlanDtls.TierMaxBal__c.setScale(2))
                  );
                  intPlanDtlsLst.add(intPlanDtls);
                }
              }
            }
          }
          WTFCObjectManagerRepository.doUpsertObjects(intPlanDtlsLst);
          CZWTFCHelperRepository.deleteUnusedInterestPlanDetails(brand.tffa__Code__c, usedIntPlanDtlsLst);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in execute passBatch' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  public void finish(Database.BatchableContext bc) {
    tffa.Logger.flush();
  }

  private static String getQuery() {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields(new List<String>{ 'tffa__Code__c' }).build().toQuery();

    tffa.Logger.debug(query);
    return query;
  }

  public static InterestPlanDetails__c getNonTieredInterestPlanDetails(
    String brandCode,
    FISCCInvestmentRateSchedulesDTO investmentRateSchedule
  ) {
    InterestPlanDetails__c intPlanDtls = CZWTFCHelperRepository.getIntPlanDtlsNonTiered(
      brandCode,
      investmentRateSchedule.IntPlnCde,
      investmentRateSchedule.RteSchedInd
    );
    if (intPlanDtls == null) {
      intPlanDtls = new InterestPlanDetails__c();
    }
    intPlanDtls.BrandCode__c = brandCode;
    intPlanDtls.IntPlnCde__c = investmentRateSchedule.IntPlnCde;
    intPlanDtls.IntPmtMthd__c = investmentRateSchedule.IntPmtMthd;
    intPlanDtls.Name__c = investmentRateSchedule.Nme;
    intPlanDtls.IntBasisDays__c = investmentRateSchedule.IntBasisDays;
    intPlanDtls.TDFreqId__c = investmentRateSchedule.TDFreqId;
    intPlanDtls.TDMatTerm__c = investmentRateSchedule.TDMatTerm;
    intPlanDtls.TDTermId__c = investmentRateSchedule.TDTermId;
    intPlanDtls.IntCalcMeths__c = investmentRateSchedule.IntCalcMeths;
    intPlanDtls.RteSchedInd__c = investmentRateSchedule.RteSchedInd;
    intPlanDtls.InterestRate__c = investmentRateSchedule.IntStateRte;
    return intPlanDtls;
  }

  public static InterestPlanDetails__c getTieredInterestPlanDetails(
    String brandCode,
    FISCCInvestmentRateSchedulesDTO investmentRateSchedule,
    FISCCInvestmentRateTiersDTO invRateTier
  ) {
    InterestPlanDetails__c intPlanDtls = CZWTFCHelperRepository.getIntPlanDtlsTiered(
      brandCode,
      investmentRateSchedule.IntPlnCde,
      investmentRateSchedule.RteSchedInd,
      invRateTier.TierMinBal,
      invRateTier.TierMaxBal
    );
    if (intPlanDtls == null) {
      intPlanDtls = new InterestPlanDetails__c();
    }
    intPlanDtls.BrandCode__c = brandCode;
    intPlanDtls.IntPlnCde__c = investmentRateSchedule.IntPlnCde;
    intPlanDtls.IntPmtMthd__c = investmentRateSchedule.IntPmtMthd;
    intPlanDtls.Name__c = investmentRateSchedule.Nme;
    intPlanDtls.IntBasisDays__c = investmentRateSchedule.IntBasisDays;
    intPlanDtls.TDFreqId__c = investmentRateSchedule.TDFreqId;
    intPlanDtls.TDMatTerm__c = investmentRateSchedule.TDMatTerm;
    intPlanDtls.TDTermId__c = investmentRateSchedule.TDTermId;
    intPlanDtls.IntCalcMeths__c = investmentRateSchedule.IntCalcMeths;
    intPlanDtls.RteSchedInd__c = investmentRateSchedule.RteSchedInd;
    intPlanDtls.TierMinBal__c = invRateTier.TierMinBal;
    intPlanDtls.TierMaxBal__c = invRateTier.TierMaxBal;
    intPlanDtls.InterestRate__c = invRateTier.TierRte;
    return intPlanDtls;
  }
}