@isTest
public class WT_TerafinaAPYHelper_T 
{
	@isTest
    static void TestGetSingleTierApy()
    {
        WT_TerafinaAPYHelper.APYResponseModel responseModel = WT_TerafinaAPYHelper.GetApy((Double)0.05, (Double)0.025, 'monthly', null, null);
        System.assertEquals(7.76, responseModel.APY);
        System.assertEquals(5.1162, responseModel.Yield);
    }
    
    @isTest
    static void TestGetSingleTierApyQuarterly()
    {
        WT_TerafinaAPYHelper.APYResponseModel responseModel = WT_TerafinaAPYHelper.GetApy((Double)0.05, (Double)0.025, 'quarterly', null, null);
        System.assertEquals(7.76, responseModel.APY);
        System.assertEquals(5.0945, responseModel.Yield);
    }
    
    @isTest
    static void TestGetSingleTierApyAtMaturity()
    {
        WT_TerafinaAPYHelper.APYResponseModel responseModel = WT_TerafinaAPYHelper.GetApy((Double)0.05, (Double)0.025, 'maturity', 'M', 4);
        System.assertEquals(7.76, responseModel.APY);
        System.debug(responseModel.Yield);
        System.assertEquals(5.0838, responseModel.Yield);
    }
    
    @isTest
    static void TestGetSingleTierApyAtMaturityDays()
    {
        WT_TerafinaAPYHelper.APYResponseModel responseModel = WT_TerafinaAPYHelper.GetApy((Double)0.05, (Double)0.025, 'maturity', 'D', 89);
        System.assertEquals(7.76, responseModel.APY);
        System.assertEquals(5.0953, responseModel.Yield);
    }
}