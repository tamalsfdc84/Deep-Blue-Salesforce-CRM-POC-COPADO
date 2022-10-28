/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_UserTrigger
* @Author			Swaminatahan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		23-12-2020
* @UsedBy			User Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is User object trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
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
           new WT_UserAfterHandler().run();
        }        
    }
}