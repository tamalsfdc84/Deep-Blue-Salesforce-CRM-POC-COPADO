/**
* ----------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupRelationBeforeHandle
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-02-2021
* @UsedBy           WT_RelationshipGroup_Relation__c Object
* -----------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for WT_RelationshipGroup_Relation__c trigger.
*
* This handles all the before trigger logic of the WT_RelationshipGroup_Relation__c trigger.
* ------------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_RelationshipGroupRelationBeforeHandle extends TriggerHandler 
{
    private List<WT_RelationshipGroup_Relation__c> listNewAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    private List<WT_RelationshipGroup_Relation__c> listOldAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    private Map<Id, WT_RelationshipGroup_Relation__c> mapOldAccountAccount = new Map<Id, WT_RelationshipGroup_Relation__c>();
    private Map<Id, WT_RelationshipGroup_Relation__c> mapNewAccountAccount = new Map<Id, WT_RelationshipGroup_Relation__c>();
    
    //constructor     
    public WT_RelationshipGroupRelationBeforeHandle()
    {
        if(trigger.isUpdate)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;
            this.mapOldAccountAccount = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.oldMap;
            this.mapNewAccountAccount = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.newMap;
        }
        if(trigger.isInsert)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;
            this.mapNewAccountAccount = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.newMap;            
        }
        if(trigger.isDelete)
        {
            this.listOldAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.old;
            this.mapOldAccountAccount = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.oldMap;
        }
    }
    public override void beforeInsert()
    { 
        //validatePrimaryMember(listNewAccountAccount);
       // SetInteractionDateOnHousehold(listNewAccountAccount, mapOldAccountAccount, true, false);
    }
    public override void beforeUpdate()
    {    
        //validatePrimaryMember(listNewAccountAccount);
       // SetInteractionDateOnHousehold(listNewAccountAccount, mapOldAccountAccount, true, false);
    }
    public override void beforeDelete()
    {  
       // SetInteractionDateOnHousehold(listNewAccountAccount, mapOldAccountAccount, true, false);
    } 
    /**
*--------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to calculate Rollup of child records
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccountAccount    Map of new RelationshipGroup_Relation
* @Return void                         none
*--------------------------------------------------------------------------------------------------------------
**/  
}