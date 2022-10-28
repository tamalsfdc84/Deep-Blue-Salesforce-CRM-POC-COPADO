/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_EmailMessageTrigger
* @Author           Adil Khan   <AKhan@wintrust.com>
* @ModifiedBy       Adil Khan   <AKhan@wintrust.com>
* @Version          v1.0
* @CreatedDate      10-12-2020
* @UsedBy           EmailMessage Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is EmailMessage trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_EmailMessageTrigger on EmailMessage (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
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
            new WT_EmailMessageAfterHandler().run();
        }                
    }
}