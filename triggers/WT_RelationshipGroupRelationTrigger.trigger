/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupRelationTrigger
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-02-2021
* @UsedBy           RelationshipGroup Relation Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is RelationshipGroup Relation trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
trigger WT_RelationshipGroupRelationTrigger on WT_RelationshipGroup_Relation__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{    
    if(trigger.isBefore)
    {
        new WT_RelationshipGroupRelationBeforeHandle().run();
    } 
    if(trigger.isAfter)
    {
        new WT_RelationshipGroupRelationAfterHandler().run();
        new WT_RelationshipGroupRelationHandler().run();
    } 
}