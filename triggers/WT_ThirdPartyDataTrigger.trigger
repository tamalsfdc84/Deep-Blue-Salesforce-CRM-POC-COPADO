trigger WT_ThirdPartyDataTrigger on WT_Third_Party_Data__c (after insert, after update) 
{
    if(trigger.isAfter)
    {
        new WT_ThirdPartyDataAfterHandler().run();
    } 
}