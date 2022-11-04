/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_FinancialAccountBeforeHandler
* @Author           Sivaranjani         <smoorthi@wintrust.com>
* @ModifiedBy       Swaminathan E       <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      03-18-2021
* @UsedBy           Financial Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Financial account trigger.
* This handles all the after logic of the financial account trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 08-31-2021
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_FinancialAccountBeforeHandler_T
public class WT_FinancialAccountBeforeHandler extends TriggerHandler
{        
    List<FinServ__FinancialAccount__c> listNewFinancialAccount = new List<FinServ__FinancialAccount__c>();
    Map<Id, FinServ__FinancialAccount__c> mapNewFinancialAccountIdandAccount = new Map<Id, FinServ__FinancialAccount__c>();
    Map<Id, FinServ__FinancialAccount__c> mapOldFinancialAccountIdandAccount = new Map<Id, FinServ__FinancialAccount__c>();
    public WT_FinancialAccountBeforeHandler()
    {              
        PopulateGlobalLists();        
    } 
    private void PopulateGlobalLists()
    {        
        listNewFinancialAccount = (List<FinServ__FinancialAccount__c>) Trigger.new;
        mapNewFinancialAccountIdandAccount = (Map<Id, FinServ__FinancialAccount__c>) Trigger.newMap;
        mapOldFinancialAccountIdandAccount = (Map<Id, FinServ__FinancialAccount__c>) Trigger.oldMap;
    }
 public override void beforeInsert()
    {
        populateRelationshiproupId(listNewFinancialAccount);
    }
    public override void beforeUpdate()
    {
        populateRelationshiproupId(listNewFinancialAccount);
    }
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewEvent          List of Event
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void populateRelationshiproupId(List<FinServ__FinancialAccount__c> listNewFinancialAccount)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(FinServ__FinancialAccount__c finRecord: listNewFinancialAccount)
        {
            setAccountId.add(finRecord.FinServ__PrimaryOwner__c);
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id, WT_Account__c, WT_RelatedAccount__c FROM WT_RelationshipGroup_Relation__c WHERE WT_Active__c = true AND WT_RelatedAccount__c IN : setAccountId ];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(FinServ__FinancialAccount__c financialRecord: listNewFinancialAccount)
        {  
            if(mapAccountId.containsKey(financialRecord.FinServ__PrimaryOwner__c))
            {
                financialRecord.WT_Relationship_Group__c = mapAccountId.get(financialRecord.FinServ__PrimaryOwner__c);
            }
            else
            {
                financialRecord.WT_Relationship_Group__c = Null; 
            }
        }
    }     
}