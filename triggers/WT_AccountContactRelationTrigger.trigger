trigger WT_AccountContactRelationTrigger on AccountContactRelation (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
    if(trigger.isBefore)
    {
        new WT_AccountContactRelationBeforeHandler().run();
    } 
    if(trigger.isAfter)
    {
        new WT_AccountContactRelationAfterHandler().run();
    } 
}