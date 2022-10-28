/**
* ----------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupRelationAfterHandler
* @Author           SWAminATHAN E <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      29-07-2021
* @UsedBy           WT_RelationshipGroup_Relation__c Object
* -----------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for WT_RelationshipGroup_Relation__c trigger.
*
* This handles all the After logic of the WT_RelationshipGroup_Relation__c trigger.
* -------------------------------------------------------------------------------------------------------------------
**/
public class WT_RelationshipGroupRelationAfterHandler extends TriggerHandler
{
    private List<WT_RelationshipGroup_Relation__c> listNewAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    private List<WT_RelationshipGroup_Relation__c> listOldAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    private Map<Id, WT_RelationshipGroup_Relation__c> mapNewAccountAccountMap = new Map<Id, WT_RelationshipGroup_Relation__c>();
    private Map<Id, WT_RelationshipGroup_Relation__c> mapOldAccountAccountMap = new Map<Id, WT_RelationshipGroup_Relation__c>(); 
    //constructor     
    public WT_RelationshipGroupRelationAfterHandler()
    {
        if(trigger.isUpdate)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;
            // this.mapNewAccountAccountMap = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.newMap;
            // this.mapOldAccountAccountMap = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.oldMap;
        }
        if(trigger.isInsert)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;            
        }
        if(trigger.isDelete)
        {
            this.listOldAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.old;
            //this.mapOldAccountAccountMap = (Map<Id, WT_RelationshipGroup_Relation__c>) Trigger.oldMap;
        }
    }
    public override void afterInsert()
    { 
        populateRGIdUpdate(listNewAccountAccount);
        SetInteractionDateOnRelationshipGroup(listNewAccountAccount);
    }
    public override void afterUpdate()
    {    
        populateRGIdUpdate(listNewAccountAccount);
        SetInteractionDateOnRelationshipGroup(listNewAccountAccount);
    }
    public override void afterDelete()
    { 
        populateRGIdNull(listOldAccountAccount);
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to Set InteractionDate On RelationshipGroup Accounts
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccountAccount    Map of new Account
* @Return void                         none
*--------------------------------------------------------------------------------------------------------------
**/
    public static void SetInteractionDateOnRelationshipGroup(List<WT_RelationshipGroup_Relation__c> listNewAccountAccount)
    {
        List<ID> listOfAccountID = new List<ID>();
        Map<Id, Map<String,date>> mapIDtoDateMap = new Map<ID,Map<String,Date>>();
        List<Account> listAccountUpdate = new List<Account>();
        For(WT_RelationshipGroup_Relation__c relation : listNewAccountAccount)
        {
            listOfAccountID.add(relation.WT_Account__c);
        }
        List<WT_RelationshipGroup_Relation__c> listOfRelationGroupRelation = [SELECT Id,WT_Account__c,WT_RelatedAccount__r.name,
                                                                              WT_RelatedAccount__r.WT_First_Date_Of_Contact__c,WT_RelatedAccount__c,
                                                                              WT_RelatedAccount__r.WT_Last_Date_Of_Contact__c
                                                                              FROM WT_RelationshipGroup_Relation__c
                                                                              WHERE WT_Account__c in : listOfAccountID AND
                                                                              WT_Active__c = true AND
                                                                              WT_RelatedAccount__r.WT_First_Date_Of_Contact__c != null AND
                                                                              WT_RelatedAccount__r.WT_Last_Date_Of_Contact__c != null];
        for(WT_RelationshipGroup_Relation__c relation: listOfRelationGroupRelation)
        {
            mapIDtoDateMap.put(relation.WT_Account__c,new Map<String,date>());
        }
        for(WT_RelationshipGroup_Relation__c relation: listOfRelationGroupRelation)
        {
            if(mapIDtoDateMap.get(relation.WT_Account__c).get('First') ==null)
            {
                mapIDtoDateMap.get(relation.WT_Account__c).put('First',relation.WT_RelatedAccount__r.WT_First_Date_Of_Contact__c);
            }
            Else if(mapIDtoDateMap.get(relation.WT_Account__c).get('First') > relation.WT_RelatedAccount__r.WT_First_Date_Of_Contact__c)
            {
                mapIDtoDateMap.get(relation.WT_Account__c).put('First',relation.WT_RelatedAccount__r.WT_First_Date_Of_Contact__c);
            }
            
            if(mapIDtoDateMap.get(relation.WT_Account__c).get('Last') ==null)
            {
                mapIDtoDateMap.get(relation.WT_Account__c).put('Last',relation.WT_RelatedAccount__r.WT_Last_Date_Of_Contact__c);
            }
            Else if(mapIDtoDateMap.get(relation.WT_Account__c).get('Last') < relation.WT_RelatedAccount__r.WT_Last_Date_Of_Contact__c)
            {
                mapIDtoDateMap.get(relation.WT_Account__c).put('Last',relation.WT_RelatedAccount__r.WT_Last_Date_Of_Contact__c);
            }
        }
        For(ID id: mapIDtoDateMap.keySet())
        {
            Account accountToUpdate = new Account();
            accountToUpdate.id = id;
            accountToUpdate.WT_First_Date_Of_Contact__c = mapIDtoDateMap.get(id).get('First');
            accountToUpdate.WT_Last_Date_Of_Contact__c = mapIDtoDateMap.get(id).get('Last');
            listAccountUpdate.add(accountToUpdate);
        }
        If(listAccountUpdate.size() >0)
            update listAccountUpdate;
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to update RelationshipGroup Id to the Account
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccountAccount    list of new AccountAccount
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/  
    public void populateRGIdUpdate(List<WT_RelationshipGroup_Relation__c> listNewAccountAccount)
    {
        Map<Id,Id> mapAccountIdRGId = new Map<Id,Id>();
        List<Id> listAccountId = new List<Id>();
        for(WT_RelationshipGroup_Relation__c accountRelation : listNewAccountAccount)
        {           
            mapAccountIdRGId.put(accountRelation.WT_RelatedAccount__c ,accountRelation.WT_Account__c);  
            if(accountRelation.WT_Active__c == false)
            {                
                listAccountId.add(accountRelation.WT_RelatedAccount__c);  
            }
        }
        List<Account> listAccount = [SELECT Id, WT_Parent_Relationship_Group__c FROM Account WHERE Id = : mapAccountIdRGId.keySet()];
        for(Account account : listAccount)
        {
            account.WT_Parent_Relationship_Group__c = mapAccountIdRGId.get(account.Id);
            if(listAccountId.contains(account.Id))
            {
                account.WT_Parent_Relationship_Group__c = Null; 
            }
        }
        try
        {
            update listAccount;
        }
        catch(DmlException e) 
        {
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    } 
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to update RelationshipGroup Id to the Account
* --------------------------------------------------------------------------------------------------------------
* @Param  listOldAccountAccount    list of old Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/   
    public void populateRGIdNull(List<WT_RelationshipGroup_Relation__c> listOldAccountAccount)
    {
        Set<Id> setAccountId = new Set<Id>();
        for(WT_RelationshipGroup_Relation__c accountRelation : listOldAccountAccount)
        {             
            setAccountId.add(accountRelation.WT_RelatedAccount__c);  
        }
        List<Account> listAccount = [SELECT Id, WT_Parent_Relationship_Group__c FROM Account WHERE Id = :setAccountId];
        for(Account account : listAccount)
        {
            account.WT_Parent_Relationship_Group__c = Null;
        }
        try
        {
            update listAccount;
        }
        catch(DmlException e)
        {
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }  
}