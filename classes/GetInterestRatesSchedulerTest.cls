/**
@author     : Amit Wagle
@description: This test class covers testcoverage for GetInterestRatesBatch
@version    : 1.0  02 Nov, 2021
*/

@isTest
private class GetInterestRatesSchedulerTest {
  @isTest
  static void test1() {
    tffa__Brand__c brand1 = new tffa__Brand__c();
    brand1.tffa__Code__c = '118';
    insert brand1;

    tffa__Brand__c brand2 = new tffa__Brand__c();
    brand2.tffa__Code__c = '380';
    insert brand2;

    tffa__Product__c prod1 = new tffa__Product__c();
    prod1.tffa__Category__c = 'CHECKING';
    prod1.tffa__Code__c = '1234';
    prod1.Name = 'Test1';
    prod1.InterestPlanCode__c = '12';
    insert prod1;

    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '12345';
    prod2.Name = 'Test2';
    prod2.InterestPlanCode__c = '26';
    insert prod2;

    tffa__Product__c prod3 = new tffa__Product__c();
    prod3.tffa__Category__c = 'CHECKING';
    prod3.tffa__Code__c = '123456';
    prod3.Name = 'Test3';
    insert prod3;

    tffa__ProductTerm__c productTermObj = new tffa__ProductTerm__c();
    productTermObj.tffa__Product__c = prod3.Id;
    productTermObj.tffa__InterestPlanCode__c = '672';
    insert productTermObj;

    /*tffa__ProductTerm__c prodTerm1 = new tffa__ProductTerm__c();
    prodTerm1.tffa__InterestPlanCode__c = '672';
    insert prodTerm1;*/

    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new GetInterestRatesSchedulerMockClass());
    Database.executeBatch(new GetInterestRatesBatch());
    Test.stopTest();
  }

  @isTest
  static void test2() {
    Test.StartTest();
    FISCCInvestmentRateSchedulesDTO investmentRateSchedule = new FISCCInvestmentRateSchedulesDTO();
    investmentRateSchedule.IntPlnCde = '12';
    investmentRateSchedule.Nme = '12 M TERAFINA PROMO';
    investmentRateSchedule.IntBasisDays = 'T';
    investmentRateSchedule.IntPmtMthd = 'A';
    investmentRateSchedule.TDFreqId = 'M';
    investmentRateSchedule.TDMatTerm = 14;
    investmentRateSchedule.TDTermId = 'M';
    investmentRateSchedule.IntCalcMeths = 'S';
    investmentRateSchedule.RteSchedInd = 'N';
    investmentRateSchedule.IntStateRte = 0.05;
    InterestPlanDetails__c intPlnDtls = GetInterestRatesBatch.getNonTieredInterestPlanDetails('118', investmentRateSchedule);
    Test.stopTest();
  }

  @isTest
  static void test3() {
    Test.StartTest();
    FISCCInvestmentRateSchedulesDTO investmentRateSchedule = new FISCCInvestmentRateSchedulesDTO();
    investmentRateSchedule.IntPlnCde = '672';
    investmentRateSchedule.Nme = 'MMKT LEVEL 1';
    investmentRateSchedule.IntBasisDays = 'T';
    investmentRateSchedule.IntPmtMthd = 'A';
    investmentRateSchedule.TDFreqId = 'T';
    investmentRateSchedule.TDMatTerm = 0;
    investmentRateSchedule.TDTermId = 'D';
    investmentRateSchedule.IntCalcMeths = 'S';
    investmentRateSchedule.RteSchedInd = 'Y';
    investmentRateSchedule.IntStateRte = 0;

    FISCCInvestmentRateTiersDTO invRateTier = new FISCCInvestmentRateTiersDTO();
    invRateTier.InvestRteSchedIndx = '672';
    invRateTier.TierMinBal = 0;
    invRateTier.TierMaxBal = 10000;
    invRateTier.TierRte = 0.45;
    InterestPlanDetails__c intPlnDtls = GetInterestRatesBatch.getTieredInterestPlanDetails('118', investmentRateSchedule, invRateTier);
    Test.stopTest();
  }
}