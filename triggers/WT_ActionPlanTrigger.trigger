/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ActionPlanTrigger
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Vamsi Krishna	<vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Action Plan Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is action plan trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_ActionPlanTrigger on ActionPlan (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
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
            new WT_ActionPlanBeforeHandler().run();
        }
        if(trigger.isAfter)
        {
            new WT_ActionPlanAfterHandler().run();
        }
    }
}