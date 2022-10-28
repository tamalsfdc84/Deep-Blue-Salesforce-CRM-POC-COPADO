/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_TaskTrigger
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Swaminathan E	    <SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Task Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is task trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 04-09-2021
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
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
         	new WT_TaskBeforeHandler().run();  
        }        
    }
}