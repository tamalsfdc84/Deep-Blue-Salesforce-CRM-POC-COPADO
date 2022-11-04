trigger WT_AccountAccountRelationTrigger on FinServ__AccountAccountRelation__c(before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    WT_Switch_Settings__c CurrentInstance = WT_Switch_Settings__c.getInstance(UserInfo.getUserId());
    if(CurrentInstance.WT_Is_Trigger_Active__c)
    {
        if(trigger.isBefore)
        {
            new WT_AccountAccountRelationBeforeHandler().run();
            //new WT_AccountAccountRelationAfterHandler().run();
        } 
        if(trigger.isAfter)
        {
            new WT_AccountAccountRelationAfterHandler().run();
        } 
    }
}