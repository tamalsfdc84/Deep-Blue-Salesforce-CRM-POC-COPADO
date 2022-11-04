/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_OpportunityTeamMemberTrigger
* @Author			Karan Jugtawat		<KSinghJu@Wintrust.com>
* @ModifiedBy		
* @Version			v1.0
* @CreatedDate		16-FEB-2021
* @UsedBy			OpportunityTeamMember Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is WT_OpportunityTeamMemberTrigger trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_OpportunityTeamMemberTrigger on OpportunityTeamMember (before insert, before update,after insert, after update, after delete) 
{
    Boolean shouldRunTrigger = false;
    WT_Switch_Settings__c triggerSwitchSettings = WT_Switch_Settings__c.getInstance();
    if(triggerSwitchSettings != null && triggerSwitchSettings.WT_Is_Trigger_Active__c && !system.isBatch())
    {
        shouldRunTrigger=true;
    }
    if(shouldRunTrigger)
    {    
        if(Trigger.isBefore)
        {
            new WT_OpportunityTeamMemberBeforeHandler().run();
        }
        if(Trigger.isAfter)
        {
            new WT_OpportunityTeamMemberAfterHandler().run();
        }
    }
}