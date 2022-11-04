/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_AttachmentTrigger
* @Author           Femi Onakoya    <fonakoya@wintrust.com>
* @ModifiedBy       
* @Version          v1.0
* @CreatedDate      07-18-2022
* @UsedBy           Attachment Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is Attachment trigger.
* --------------------------------------------------------------------------------------------------------------
*@Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_AttachmentTrigger on Attachment (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    WT_Switch_Settings__c currentUserSettings = WT_Switch_Settings__c.getInstance(UserInfo.getUserId());
    
    if(currentUserSettings.WT_Is_Trigger_Active__c)
    { 
        if(trigger.isAfter)
        {
            new WT_AttachmentAfterHandler().run();
        }
    }
}