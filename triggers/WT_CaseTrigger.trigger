trigger WT_CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    WT_Switch_Settings__c CurrentInstance = WT_Switch_Settings__c.getInstance(UserInfo.getUserId());
    if(CurrentInstance.WT_Is_Trigger_Active__c)
    {
        if(trigger.isBefore)
        {
            new WT_CaseBeforeHandler().run();
        } 
        if(trigger.isAfter)
        {
            new WT_CaseAfterHandler().run();
        } 
    }
    
}