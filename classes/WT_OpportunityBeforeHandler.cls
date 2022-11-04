/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_OpportunityBeforeHandler
* @Author           sivaranjani         <smoorthi@wintrust.com>
* @ModifiedBy       Swaminathan E       <SEzhumal@wintrust.com>
* @version          v1.0 
* @CreatedDate      22 Feb 2021
* @UsedBy           Opportunity Object
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_OpportunityTrigger 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 08-31-2021
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_OpportunityAfterHandler_T
public class WT_OpportunityBeforeHandler extends TriggerHandler
{
    private List<Opportunity> listNewOpportunity = new List<Opportunity>();
    private Map<Id, Opportunity> mapNewOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    private Map<Id, Opportunity> mapOldOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    public WT_OpportunityBeforeHandler()
    {      
        PopulateGlobalLists(); 
    }
    public override void beforeInsert()
    {
        populateRecordTypeName(listNewOpportunity);
        populateRelationshiproupId(listNewOpportunity);
    }    
    public override void beforeUpdate()
    {
        populateRecordTypeName(listNewOpportunity);
        populateRelationshiproupId(listNewOpportunity);
    } 
    private void PopulateGlobalLists()
    {        
        listNewOpportunity = (List<Opportunity>) Trigger.new;
        mapNewOpportunityIdandOpportunity = (Map<Id, Opportunity>) Trigger.newMap;
        mapOldOpportunityIdandOpportunity = (Map<Id, Opportunity>) Trigger.oldMap;
    }
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewOpportunity          List of Opportunity
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void populateRelationshiproupId(List<Opportunity> listNewOpportunity)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(Opportunity opportunityRecord: listNewOpportunity)
        {
            setAccountId.add(opportunityRecord.AccountId);
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id, WT_Account__c, WT_RelatedAccount__c FROM WT_RelationshipGroup_Relation__c WHERE WT_Active__c = true AND WT_RelatedAccount__c IN : setAccountId ];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(Opportunity opportunityRecord: listNewOpportunity)
        {
            if(mapAccountId.containsKey(opportunityRecord.AccountId))
            {
                opportunityRecord.WT_Relationship_Group__c = mapAccountId.get(opportunityRecord.AccountId);
            }
            else
            {
                opportunityRecord.WT_Relationship_Group__c = Null; 
            }
        }
    }  
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Record Type Name for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listOpportunity          List of Opportunity
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public static void populateRecordTypeName(list<Opportunity> listOpportunity)
    {
        for(Opportunity opporunityToUpdate: listOpportunity){
            opporunityToUpdate.WT_Record_Type_Name__c = opporunityToUpdate.WT_Opportunity_Record_Type__c;
        }
    }
    
}