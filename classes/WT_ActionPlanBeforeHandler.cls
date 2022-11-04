/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ActionPlanBeforeHandler
* @Author			Vamsi Krishna	<vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Krishna	<vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		29-06-2021
* @UsedBy			Action Plan Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for action plan trigger.
*
* This handles all the before logic of the action plan trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 31-08-2021 - Swaminathan E    <SEzhumal@wintrust.com>
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_ActionPlanBeforeHandler extends TriggerHandler
{
    List<ActionPlan> listNewActionPlan = new List<ActionPlan>();
    Map<Id, ActionPlan> mapNewActionPlan = new Map<Id, ActionPlan>();
    Map<Id, ActionPlan> mapOldActionPlan = new Map<Id, ActionPlan>();
    public WT_ActionPlanBeforeHandler()
    {
        PopulateGlobalLists();        
    }
    public override void beforeInsert()
    {
        populateContactId(listNewActionPlan);
        populateHouseholdId(listNewActionPlan);
        populateRelationshipGroupId(listNewActionPlan);
    }
    public override void beforeUpdate()
    {
        populateContactId(listNewActionPlan);
        populateRelationshipGroupId(listNewActionPlan);
    }
    private void PopulateGlobalLists()
    {        
        listNewActionPlan = (List<ActionPlan>) Trigger.new;
        mapNewActionPlan = (Map<Id, ActionPlan>) Trigger.newMap;
        mapOldActionPlan = (Map<Id, ActionPlan>) Trigger.oldMap;
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the action plans linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewActionPlan    List of Action Plans
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
  public void populateRelationshipGroupId(List<ActionPlan> listNewActionPlan)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(ActionPlan actionPlanRecord: listNewActionPlan)
        {
            if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
            {
            setAccountId.add(actionPlanRecord.TargetId);
            }
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id, WT_Account__c, WT_RelatedAccount__c FROM WT_RelationshipGroup_Relation__c WHERE WT_Active__c = true AND WT_RelatedAccount__c IN :setAccountId ];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(ActionPlan actionPlanRecord: listNewActionPlan)
        {
            if(mapAccountId.containsKey(actionPlanRecord.TargetId))
            {
                actionPlanRecord.WT_Relationship_Group__c = mapAccountId.get(actionPlanRecord.TargetId);
            }
            else
            {
                actionPlanRecord.WT_Relationship_Group__c = Null; 
            }     
        } 
    }     
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the contact ID for the action plans linked to person accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewActionPlan    List of Action Plans
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public static void populateContactId(List<ActionPlan> listNewActionPlan)
    {
        Set<Id> setAccountIds = new Set<Id>();
        List<ActionPlan> listIncorrectActionPlans = new List<ActionPlan>();
        for(ActionPlan actionPlanRecord :listNewActionPlan)
        {
            if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
            {
                setAccountIds.add(actionPlanRecord.TargetId);
            }                
        }
        if(!setAccountIds.isEmpty())
        {
            list<Account> listPersonAccounts = new list<Account>();
            listPersonAccounts = [Select id, Ownerid,recordtype.name,personcontactid from Account where id In: setAccountIds and (recordtype.developername ='PersonAccount_Prospect' or recordtype.developername ='PersonAccount_Customer')];
            if(listPersonAccounts.size()>0)
            {
                map<id,id> mapAccountContact = new map<id,id>();
                for(Account personAccount: listPersonAccounts)
                {
                    mapAccountContact.put(personAccount.id,personAccount.personcontactid);
                }
                for(ActionPlan actionPlanRecord :listNewActionPlan)
                {
                    if(actionPlanRecord.WT_ContactID__c != mapAccountContact.get(actionPlanRecord.TargetId))
                    {
                        actionPlanRecord.WT_ContactID__c = mapAccountContact.get(actionPlanRecord.TargetId);
                    }                    
                }
            }                
        }
    }
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Household ID for the action plans linked to person accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewActionPlan    List of Action Plans
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public static void populateHouseholdId(List<ActionPlan> listNewActionPlan)
    {
        Set<Id> setAccountIds = new Set<Id>();
        Set<Id> setContactIds = new Set<Id>();
        for(ActionPlan actionPlanRecord :listNewActionPlan)
        {
            if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
            {
                setAccountIds.add(actionPlanRecord.TargetId);
            }                
        }
        if(!setAccountIds.isEmpty())
        {
            list<Account> listPersonAccounts = [SELECT id, Ownerid,recordtype.name,PersonContactId from Account where id In: setAccountIds and (recordtype.developername ='PersonAccount_Prospect' or recordtype.developername ='PersonAccount_Customer')];            
            if(listPersonAccounts.size()>0)
            {
                map<id,id> mapAccountContact = new map<id,id>();
                map<id,id> mapHouseholdContact = new map<id,id>();
                for(Account account : listPersonAccounts)
                {
                    setContactIds.add(account.PersonContactId);
                    mapAccountContact.put(account.PersonContactId,account.id);
                }
                list<AccountContactRelation> listAccountContact = [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE ContactId In: setContactIds ];
                if(listAccountContact.size()>0)
                {
                    for(AccountContactRelation accountContact : listAccountContact)
                    {
                        mapHouseholdContact.put(mapAccountContact.get(accountContact.ContactId),accountContact.AccountId);
                    }
                    for(ActionPlan actionPlanRecord :listNewActionPlan)
                    {
                        actionPlanRecord.WT_Household__c = mapHouseholdContact.get(actionPlanRecord.TargetId);
                    }                
                }
            }
        }
    }
}