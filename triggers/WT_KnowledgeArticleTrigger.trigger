trigger WT_KnowledgeArticleTrigger on Knowledge__kav (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
	Boolean shouldRunTrigger = false;
    WT_Switch_Settings__c triggerSwitchSettings = WT_Switch_Settings__c.getInstance();
    if(triggerSwitchSettings != null && triggerSwitchSettings.WT_Is_Trigger_Active__c)
    {
        shouldRunTrigger = true;
    }
    
    if(shouldRunTrigger)
    {
        if(trigger.isAfter)
        {
            new WT_KnowledgeArticleAfterHandler().run();
        }        
    }
}