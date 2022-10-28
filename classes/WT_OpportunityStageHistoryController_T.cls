/**
* ----------------------------------------------------------------------------------------------------------------------
* @Name				WT_WT_OpportunityStageHistoryController_T
* @Author			Anoop		<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		12-OCT-2021
* ---------------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_OpportunityStageHistoryController.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* testMethod1()
* 	> 
----------------------------------------------------------------
**/
@isTest
public class WT_OpportunityStageHistoryController_T 
{
    @isTest
    public static void testMethod1()
    {
        Opportunity varOpportunity = new Opportunity();
        varOpportunity.name = 'Test Name One';
        varOpportunity.StageName = 'Stage 1 - Opportunity Identified';
        varOpportunity.CloseDate = Date.newInstance(2021, 12, 31);
        insert varOpportunity;
        
        test.startTest();
        varOpportunity.StageName = 'Test StageName two';
        update varOpportunity;
        WT_Opportunity_Stage_History__c stg = new WT_Opportunity_Stage_History__c();
        stg.WT_StageName__c ='Closed/Won';
        stg.WT_CloseDate__c =date.today();
        stg.WT_Probability__c =10;
        stg.WT_OpportunityId__c = varOpportunity.Id;
        insert stg;
        WT_OpportunityStageHistoryController.getOpportunityHistoryLoadList(varOpportunity.Id);
        WT_OpportunityStageHistoryController.getOpportunityHistoryList(varOpportunity.Id);
        test.stopTest();
    }
}