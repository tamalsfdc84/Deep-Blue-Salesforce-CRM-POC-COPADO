/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_EventTrigger
* @Author           Karishma Keswani    <kkeswani@wintrust.com>
* @ModifiedBy       Swaminathan E       <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      15-12-2020
* @UsedBy           Event Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is event trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 04-09-2021
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_EventTrigger on Event (before insert, before update, before delete, after insert, after update, after delete, after undelete)
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
            new WT_EventBeforeHandler().run();
        }
        if(trigger.isAfter && trigger.isInsert){
            WT_EventBeforeHandler.updateAttendeeWithOrganizer(trigger.newMap,null);
        }else if(trigger.isAfter && trigger.isUpdate){
            WT_EventBeforeHandler.updateAttendeeWithOrganizer(trigger.newMap,trigger.oldMap);
        }
    }
}