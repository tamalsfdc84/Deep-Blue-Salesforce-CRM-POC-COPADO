/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AttendeeTrigger
* @Author			Sivaranjani	<smoorthi@wintrust.com>
* @ModifiedBy		Sivaranjani	<smoorthi@wintrust.com>
* @Version			v1.0
* @CreatedDate		18-01-2021
* @UsedBy			Attendee junction Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is attendee juncrion object trigger.
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_AttendeeTrigger on WT_Attendee_Junction__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    WT_Switch_Settings__c currentInstance = WT_Switch_Settings__c.getInstance(UserInfo.getUserId());
    if(currentInstance.WT_Is_Trigger_Active__c)
    {
        if(trigger.isBefore)
        {
            new WT_AttendeeBeforeHandler().run();
        }  
        if(trigger.isAfter)
        {
            new WT_AttendeeAfterHandler().run();
        }
    }  
}