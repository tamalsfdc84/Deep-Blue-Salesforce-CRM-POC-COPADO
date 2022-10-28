/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_LeadTrigger
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      29-03-2021
* @UsedBy           Lead Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is Lead trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    Boolean shouldRunTrigger = false;
    WT_Switch_Settings__c triggerSwitchSettings = WT_Switch_Settings__c.getInstance();
    if((null!=triggerSwitchSettings)&&(triggerSwitchSettings.WT_Is_Trigger_Active__c))
    {
        shouldRunTrigger=true;
    }
    if(shouldRunTrigger)
    {
        if(trigger.isAfter)
        {
            new WT_LeadAfterHandler().run();
        }  
        if(trigger.isBefore)
        {
            new WT_LeadBeforeHandler().run();
            new WT_LeadBeforeRequiredHandler().run();
        } 
    }
    else
    {
        if(trigger.isBefore)
        {
            new WT_LeadBeforeRequiredHandler().run();
        }
    }
}