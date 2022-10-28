public class WT_BatchAPYProcessor implements Database.Batchable<sObject>
{
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, APY__c, InterestRate__c
                                         FROM InterestPlanDetails__c]);   
    }
    
    public void execute(Database.BatchableContext bc, List<InterestPlanDetails__c> scope)
    {
        for(InterestPlanDetails__c interestPlan : scope)
        {
            if(interestPlan.InterestRate__c != null)
            {
                WT_TerafinaAPYHelper.APYResponseModel apyModel = WT_TerafinaAPYHelper.GetApy((Double)(interestPlan.InterestRate__c/100), (Double)0.0, 'monthly', null, null);
                interestPlan.APY__c = apyModel.APY;
            }
        }
        
        update scope;
    }
    
    public void finish(Database.BatchableContext bc)
    {
    }
}