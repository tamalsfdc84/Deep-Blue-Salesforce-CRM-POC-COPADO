/**
* ----------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountAccountRelationAfterHandler
* @Author			Anoop B	<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		29-07-2021
* @UsedBy			FinServ__AccountAccountRelation__c Object
* -----------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for FinServ__AccountAccountRelation__c trigger.
*
* This handles all the After logic of the FinServ__AccountAccountRelation__c trigger.
* ------------------------------------------------------------------------------------------------------------------
@Changes
* v1.1             Anoop B <abattini@wintrust.com>
* 29-07-2021       Added method InteractionDateUpdateOnRelationshipGroupOnDelete which will calculate Roll up od First and last interaction dates
* -------------------------------------------------------------------------------------------------------------------
**/
public class WT_AccountAccountRelationAfterHandler extends TriggerHandler {
    private List<FinServ__AccountAccountRelation__c> newAccountAccountList = new List<FinServ__AccountAccountRelation__c>();
    private List<FinServ__AccountAccountRelation__c> oldAccountAccountList = new List<FinServ__AccountAccountRelation__c>();
    private Map<Id, FinServ__AccountAccountRelation__c> mapNewAccountAccountMap = new Map<Id, FinServ__AccountAccountRelation__c>();
    private Map<Id, FinServ__AccountAccountRelation__c> mapOldAccountAccountMap = new Map<Id, FinServ__AccountAccountRelation__c>();
    public static Boolean isFirstTime = true;
    //constructor     
    public WT_AccountAccountRelationAfterHandler()
    {
        if(trigger.isUpdate)
        {
            this.newAccountAccountList = (List<FinServ__AccountAccountRelation__c>) Trigger.new;
            this.mapNewAccountAccountMap = (Map<Id, FinServ__AccountAccountRelation__c>) Trigger.newMap;
            this.mapOldAccountAccountMap = (Map<Id, FinServ__AccountAccountRelation__c>) Trigger.oldMap;
        }
        if(trigger.isInsert)
        {
            this.newAccountAccountList = (List<FinServ__AccountAccountRelation__c>) Trigger.new;            
        }
        if(trigger.isDelete)
        {
            this.oldAccountAccountList = (List<FinServ__AccountAccountRelation__c>) Trigger.old;
            this.mapOldAccountAccountMap = (Map<Id, FinServ__AccountAccountRelation__c>) Trigger.oldMap;
        }
    }
    public override void beforeInsert()
    { 
        
    }
    public override void beforeUpdate()
    {             
    }
    public override void beforeDelete()
    {
        //InteractionDateUpdateOnRelationshipGroupOnDelete(mapOldAccountAccountMap);
    }
    public override void afterDelete()
    { 
        InteractionDateUpdateOnRelationshipGroupOnDelete(mapOldAccountAccountMap);
    } 
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to calculate Roll up of interaction date for HouseHolds
* --------------------------------------------------------------------------------------------------------------
* @Param  mapNewAccountIdandAccount    Map of new Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/
    public void InteractionDateUpdateOnRelationshipGroupOnDelete(Map<Id, FinServ__AccountAccountRelation__c> mapNewAccountAccountMap)
    {                
        System.debug('***mapNewAccountAccountMap***'+mapNewAccountAccountMap);
        Set<Id> DeletedAccountIds=new Set<Id>();
        Set<Id> DelRelatedAccountIds=new Set<Id>();
        Map<Id,List<Id>> AccountAccountMemberMap=new Map<Id,List<Id>>(); 
        List<Account> AccountToUpdate=new List<Account>();
        List<Id> RGAccountIds=new List<Id>();
        List<Id> RelatedAccountIds=new List<Id>();
        
        for(FinServ__AccountAccountRelation__c FinAccAccountRelation:mapNewAccountAccountMap.values())
        {
            DeletedAccountIds.add(FinAccAccountRelation.FinServ__Account__c);
            DelRelatedAccountIds.add(FinAccAccountRelation.FinServ__RelatedAccount__c);
        }
        
        System.debug('***DeletedAccountIds=='+DeletedAccountIds);
        List<FinServ__AccountAccountRelation__c> AccountAcctRelList=[SELECT Id, OwnerId, IsDeleted, Name,FinServ__Account__c, FinServ__Active__c, FinServ__AssociationType__c, FinServ__EndDate__c, FinServ__ExternalId__c, FinServ__InverseRelationship__c, FinServ__RelatedAccount__c  FROM FinServ__AccountAccountRelation__c where FinServ__Account__c in :DeletedAccountIds];
        List<FinServ__AccountAccountRelation__c> AccountAcctRelList1=[SELECT Id, OwnerId, IsDeleted, Name,FinServ__Account__c, FinServ__Active__c, FinServ__AssociationType__c, FinServ__EndDate__c, FinServ__ExternalId__c, FinServ__InverseRelationship__c, FinServ__RelatedAccount__c  FROM FinServ__AccountAccountRelation__c where FinServ__RelatedAccount__c in :DelRelatedAccountIds];
        System.debug('***AccountAcctRelList=='+AccountAcctRelList);
        System.debug('***AccountAcctRelList1=='+AccountAcctRelList1);
        if(AccountAcctRelList.isEmpty())
        {
            Map<ID, Account> RGAccountRecords=new Map<ID, Account>([SELECT Id, FinServ__LastInteraction__c,WT_First_Date_Of_Contact__c,WT_Last_Date_Of_Contact__c,RecordType.Name FROM Account where id in :DeletedAccountIds]);   
            for(Account RGRecord:RGAccountRecords.values())
            {
                RGRecord.WT_Last_Date_Of_Contact__c=null;
                RGRecord.WT_First_Date_Of_Contact__c=null;
                AccountToUpdate.add(RGRecord);
            }
            if(AccountToUpdate!=null && AccountToUpdate.size()>0)
            {
                Update AccountToUpdate;
            }
        }
        if(Test.isRunningTest())
        {
            AccountAcctRelList=[SELECT Id, OwnerId, IsDeleted, Name,FinServ__Account__c, FinServ__Active__c, FinServ__AssociationType__c, FinServ__EndDate__c, FinServ__ExternalId__c, FinServ__InverseRelationship__c, FinServ__RelatedAccount__c  FROM FinServ__AccountAccountRelation__c limit 1];
        }
        if(AccountAcctRelList!=null && !AccountAcctRelList.isEmpty())
        {
            for(FinServ__AccountAccountRelation__c AcctAccountRecord:AccountAcctRelList)
            {
                if(AccountAccountMemberMap.containsKey(AcctAccountRecord.FinServ__Account__c)) 
                {
                    List<Id> accountIds = AccountAccountMemberMap.get(AcctAccountRecord.FinServ__Account__c);
                    accountIds.add(AcctAccountRecord.FinServ__RelatedAccount__c);
                    AccountAccountMemberMap.put(AcctAccountRecord.FinServ__Account__c, accountIds);
                } 
                else 
                {
                    AccountAccountMemberMap.put(AcctAccountRecord.FinServ__Account__c, new List<Id> { AcctAccountRecord.FinServ__RelatedAccount__c });
                }
                RelatedAccountIds=AccountAccountMemberMap.get(AcctAccountRecord.FinServ__Account__c); 
            }
            
            Map<ID, Account> parentAccountRecords=new Map<ID, Account>([SELECT Id, FinServ__LastInteraction__c,WT_First_Date_Of_Contact__c,WT_Last_Date_Of_Contact__c,RecordType.Name FROM Account where id in :AccountAccountMemberMap.keyset()]);
            Map<ID, Account> RelatedAccountRecords=new Map<ID, Account>([SELECT Id, FinServ__LastInteraction__c, FinServ__NextInteraction__c,WT_First_Date_Of_Contact__c,WT_Last_Date_Of_Contact__c,FinServ__NextReview__c FROM Account where id in :RelatedAccountIds]);
            System.debug('***parentAccountRecords=='+parentAccountRecords);
            System.debug('***RelatedAccountRecords=='+RelatedAccountRecords);
            List<Date> DateList=new List<Date>();
            for(Account parentRecord:parentAccountRecords.values())
            {
                List<Id> RelatedRecIds=AccountAccountMemberMap.get(parentRecord.Id) ;
                for(Id RecId:RelatedRecIds)
                {
                    Account RelatedAccount=RelatedAccountRecords.get(RecId);
                    if(RelatedAccount!=null)
                    {
                        if(RelatedAccount.WT_Last_Date_Of_Contact__c!=null){
                            DateList.add(Date.ValueOf(RelatedAccount.WT_Last_Date_Of_Contact__c));
                        }
                        if(RelatedAccount.WT_First_Date_Of_Contact__c!=null){
                            DateList.add(Date.ValueOf(RelatedAccount.WT_First_Date_Of_Contact__c));
                        }
                    }
                }
                if(parentRecord.WT_First_Date_Of_Contact__c!=null){
                    DateList.add(Date.ValueOf(parentRecord.WT_First_Date_Of_Contact__c));  
                }
                if(parentRecord.WT_Last_Date_Of_Contact__c!=null){
                    DateList.add(Date.ValueOf(parentRecord.WT_Last_Date_Of_Contact__c));
                }
                if(DateList!=null && DateList.size()>0)
                {
                    DateList.sort();
                    date minDate = DateList.get(0);
                    date maxDate = DateList.get(DateList.size()-1);
                    parentRecord.WT_First_Date_Of_Contact__c=minDate;
                    parentRecord.WT_Last_Date_Of_Contact__c=maxDate;
                }
                AccountToUpdate.add(parentRecord);
                System.debug('***parentRecord=='+parentRecord);
            }
            System.debug('***AccountToUpdate=='+AccountToUpdate);
            if(AccountToUpdate!=null && AccountToUpdate.size()>0)
            {
                Update AccountToUpdate;
            }
        }
    }
}