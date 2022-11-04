/**
* @Name             WT_AccountContactRelationAfterHandler 
* @Author           
* @ModifiedBy
* @Version          v1.0
* @CreatedDate      16-FEB-2021
* @UsedBy           WT_AccountContactTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_AccountContactTrigger
*  --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_AccountContactRelationAfterHandler_T
public class WT_AccountContactRelationAfterHandler extends TriggerHandler
{    
    private List<AccountContactRelation> listNewAccountContactRelation = new List<AccountContactRelation>();
    private Map<Id, AccountContactRelation> mapNewAccountContactRelationIdAndAccountContactRelation = new Map<Id, AccountContactRelation>();
    private Map<Id, AccountContactRelation> mapOldAccountContactRelationIdAndAccountContactRelation = new Map<Id, AccountContactRelation>();
    //constructor   
    public WT_AccountContactRelationAfterHandler()
    {
        if(trigger.isUpdate || trigger.isInsert)
        {
            this.listNewAccountContactRelation = (List<AccountContactRelation>) Trigger.new;
            this.mapNewAccountContactRelationIdAndAccountContactRelation = (Map<Id, AccountContactRelation>) Trigger.newMap;
            this.mapOldAccountContactRelationIdAndAccountContactRelation = (Map<Id, AccountContactRelation>) Trigger.oldMap;
        }
        if(trigger.isDelete)
        {
            this.mapOldAccountContactRelationIdAndAccountContactRelation = (Map<Id, AccountContactRelation>) Trigger.oldMap;
        }
    }
    public override void afterUpdate()
    { 
        AddHouseholdRelationToProcessLog(false);
    }
    public override void afterInsert()
    {
        AddHouseholdRelationToProcessLog(true);
    }
    public override void afterDelete()
    { 
        AddHouseholdRelationToProcessLog(false);
    }    
    
    private void AddHouseholdRelationToProcessLog(Boolean isInsert)
    {
        List<WT_Household_Relation_To_Process_Log__c> listLogToInsert = new List<WT_Household_Relation_To_Process_Log__c>();
        List<AccountContactRelation> listAccountContactRelationToProcess = new List<AccountContactRelation>();
        if(isInsert)
        {
            listAccountContactRelationToProcess.addAll(listNewAccountContactRelation);
        }
        else
        {
            listAccountContactRelationToProcess.addAll(mapOldAccountContactRelationIdAndAccountContactRelation.values());
        }
        
        if(!listAccountContactRelationToProcess.isEmpty())
        {
            for(AccountContactRelation accountContactRelationToProcess : listAccountContactRelationToProcess)
            {
                WT_Household_Relation_To_Process_Log__c newLog = new WT_Household_Relation_To_Process_Log__c();
                newLog.WT_Contact_Id__c = accountContactRelationToProcess.ContactId;
                newLog.WT_Household_Id__c = accountContactRelationToProcess.AccountId;
                newLog.WT_Date_Added__c = System.now();
                
                listLogToInsert.add(newLog);
            }
        }
        
        if(!listLogToInsert.isEmpty())
        {
            insert listLogToInsert;
        }
    }
}