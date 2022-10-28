/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountTrigger
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Karishma Keswani	<kkeswani@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is account trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
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
            new WT_AccountBeforeHandler().run();
        }
        if(trigger.isAfter)
        {
            new WT_AccountAfterHandler().run();
            new WT_AccountAfterRequiredHandler().run();
        }        
    }
    else
    {
        if(trigger.isAfter)
        {
        	new WT_AccountAfterRequiredHandler().run();
        }
    }
}