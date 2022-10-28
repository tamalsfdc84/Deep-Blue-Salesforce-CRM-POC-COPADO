/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOpportunityClosedLostWeekly
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		09 Feb 2021
* @ModifiedDate		09 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to update Opportunities to Closed/Lost if they are open for more than 365 days
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOpportunityClosedLostWeekly implements Database.Batchable<sObject>, Database.Stateful
{
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, CloseDate, WT_Actual_Close_Date__c , WT_Status__c, StageName,WT_Status_Reason__c FROM Opportunity WHERE WT_Status__c = \'Open\' AND CloseDate <= LAST_N_DAYS:364';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        system.debug(scope.size());
        List<Opportunity> listUpdateOpportunities = New List<Opportunity>();
        for(Opportunity opportunityRecord : scope) 
        {
            //if the estimated close date is more than 365 days
            if(opportunityRecord.CloseDate <= system.now().addDays(-365))
            {
                opportunityRecord.StageName = 'Stage 7 - Deal Lost or Declined';
                opportunityRecord.WT_Status_Reason__c = 'Automatic Deactivation';
                opportunityRecord.WT_Status__c ='Closed/Lost';
                opportunityRecord.WT_Actual_Close_Date__c = system.now();
                listUpdateOpportunities.add(opportunityRecord);
            }
        }
        if(listUpdateOpportunities.size()>0)
        {
            Database.update(listUpdateOpportunities, false);
            //update listUpdateOpportunities;
        }
    }
    public void finish(Database.BatchableContext bc)
    {
    } 
}