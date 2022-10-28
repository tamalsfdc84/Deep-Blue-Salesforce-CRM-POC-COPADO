trigger WT_TFSubmissionTrigger on tffa__Submission__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
	WT_Switch_Settings__c switchSettings = WT_Switch_Settings__c.getInstance();
    Boolean shouldSkipTrigger = false;

    if(switchSettings != null)
    {
        shouldSkipTrigger = switchSettings.WT_Is_Trigger_Active__c;
    }

    if(!shouldSkipTrigger)
    {
        if(Trigger.isAfter)
        {
            new WT_TFSubmissionTriggerAfterHandler().run();
        } 
    } 
}