/**
* @Name				WT_OpportunityStageHistoryController 
* @Author			Anoop		<abattini@wintrust.com>
* @ModifiedBy
* @Version			v1.0
* @CreatedDate		08-OCT-2021
* @UsedBy			WT_OpportunityStageHistoryController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is Controller class for  OpportunityStage History LWC
* --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_OpportunityStageHistoryController_T
public class WT_OpportunityStageHistoryController 
{
    @AuraEnabled(cacheable=true)
    public static List<wrapp> getOpportunityHistoryLoadList(Id oppId) 
    {
        
        List<wrapp> wrapperList = new List<wrapp>();
        for(OpportunityHistory OppHistory : [SELECT Id, OpportunityId,StageName, Amount, CloseDate, Probability,CreatedDate,CreatedBy.Name FROM OpportunityHistory where OpportunityId=:oppId])
        {
            wrapp obj = new wrapp(OppHistory);     wrapperList.add(obj);
        }
        for(WT_Opportunity_Stage_History__c stgHistory : [SELECT Id,WT_OpportunityId__c, WT_StageName__c, WT_Amount__c, WT_CloseDate__c, WT_Probability__c,LastModifiedDate,LastModifiedBy.Name FROM WT_Opportunity_Stage_History__c where WT_OpportunityId__c=:oppId])
        {
            wrapp obj = new wrapp(stgHistory);
            wrapperList.add(obj);
        }
        
        return wrapperList;
    }
    
    public static List<OpportunityHistory> getOpportunityHistoryList(Id oppId) 
    {
        return [SELECT Id, OpportunityId, CreatedById, CreatedDate, StageName, Amount, ExpectedRevenue, CloseDate, Probability, ForecastCategory, SystemModstamp, IsDeleted, PrevAmount, PrevCloseDate FROM OpportunityHistory where OpportunityId=:oppId];  
    }
    
    public class wrapp{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String StageName{get;set;}
        @AuraEnabled
        public Date CloseDate{get;set;}
        @AuraEnabled
        public Decimal Probability{get;set;}
        @AuraEnabled
        public DateTime LastModifiedDate{get;set;}
        @AuraEnabled
        public String LastModifiedBy{get;set;}
        
        public wrapp(OpportunityHistory oppHistory){
            id = oppHistory.Id;		StageName = oppHistory.StageName;   
            CloseDate = oppHistory.CloseDate;	Probability = oppHistory.Probability;
            LastModifiedDate= oppHistory.CreatedDate;	LastModifiedBy=oppHistory.CreatedBy.Name;
        }
        public wrapp(WT_Opportunity_Stage_History__c oppStage){
            id = oppStage.Id;
            StageName = oppStage.WT_StageName__c;
            CloseDate = oppStage.WT_CloseDate__c;
            Probability = oppStage.WT_Probability__c;
            LastModifiedDate= oppStage.LastModifiedDate;
            LastModifiedBy=oppStage.LastModifiedBy.Name;
        }
    }
    
}