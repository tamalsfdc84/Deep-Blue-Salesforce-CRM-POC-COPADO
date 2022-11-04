/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_OpportunityTrigger
* @Author           Vamsi Pulikallu <vpulikal@wintrust.com>
* @ModifiedBy       
* @Version          v1.0
* @CreatedDate      22-FEB-2021
* @UsedBy           Opportunity Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is Opportunity trigger used to perform actions when data is changed in the record.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_OpportunityAfterHandler_T
trigger WT_OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    Boolean shouldRunTrigger = false;
    if(Test.isRunningTest())
    {
        shouldRunTrigger = true;
    }
    WT_Switch_Settings__c triggerSwitchSettings = WT_Switch_Settings__c.getInstance();
    if(triggerSwitchSettings != null && triggerSwitchSettings.WT_Is_Trigger_Active__c && !system.isBatch())
    {
        shouldRunTrigger=true;
    }
    if(shouldRunTrigger)
    {
        if(Trigger.isAfter)
        {
           new WT_OpportunityAfterHandler().run();
           new WT_OpportunityAfterRequiredHandler().run();
        }  
        if(Trigger.isBefore)
        {   
            new WT_OpportunityBeforeHandler().run();
            new WT_OpportunityBeforeRequiredHandler().run();
        }
    }
    else 
    {
        if(Trigger.isBefore)
        {
            new WT_OpportunityBeforeRequiredHandler().run();
        }
        if(Trigger.isAfter)
        {
            new WT_OpportunityAfterRequiredHandler().run();
        }   
    }
}