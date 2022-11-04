/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_FinancialAccountTrigger
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      02-09-2021
* @UsedBy           Financial Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is Financial Account trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_FinancialAccountTrigger on FinServ__FinancialAccount__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    Boolean shouldRunTrigger = false;
    WT_Switch_Settings__c triggerSwitchSettings = WT_Switch_Settings__c.getInstance();
    if((null!=triggerSwitchSettings)&&(triggerSwitchSettings.WT_Is_Trigger_Active__c))
    {
        shouldRunTrigger=true;
    }
    if(shouldRunTrigger)
    {
       if(trigger.isBefore)
        {
            new WT_FinancialAccountBeforeHandler().run();
        }        
    }
}