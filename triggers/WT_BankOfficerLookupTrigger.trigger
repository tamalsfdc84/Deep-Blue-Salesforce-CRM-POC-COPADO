/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BankOfficerLookupTrigger
* @Author           Himanshu Patel     <hpatel1@wintrust.com> 
* @ModifiedBy       Himanshu Patel     <hpatel1@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-17-2021
* @UsedBy			WT_Bank_Officer_Lookup__c Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* Trigger for WT_Bank_Officer_Lookup__c objkect.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 06-17-2021
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_BankOfficerLookupTrigger on WT_Bank_Officer_Lookup__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    WT_Switch_Settings__c currentInstance = WT_Switch_Settings__c.getInstance(UserInfo.getUserId());
    if(currentInstance.WT_Is_Trigger_Active__c)
    {
        if(trigger.isBefore)
        {
            new WT_BankOfficerLookupBeforeHandler().run();
        } 
    }
}