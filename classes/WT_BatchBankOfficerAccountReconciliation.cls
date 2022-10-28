//Code Coverage: WT_BatchBankOfficerAcctReconciliation_T
//Scheduler: WT_BatchBankOfficerAcctReconciliationSch
//This batch class is used to reconcile Account record Ownership with the Bank Officer Lookup object
//Bank Officer Lookup can be updated anytime but that doesn't necessarily trigger an update to the account
//This batch would ensure that both objects are always in sync
global class WT_BatchBankOfficerAccountReconciliation implements Database.Batchable<sObject>
{
    //Grab all account records that are of type Person Account (Customer), Business Account (Customer), Household, or Relationship Group
    //We would not grab prospects because MDM would not have owner information for those records
    global Database.QueryLocator start(Database.BatchableContext batchContext) 
    {
        Id personAcountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Id householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesHousehold').getRecordTypeId();
        Id relationshipGroupRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Relationship_Group').getRecordTypeId();
        
        Set<Id> setRecordTypeId = new Set<Id>
        {
            personAcountCustomerRecordTypeId,
                businessAccountCustomerRecordTypeId,
                householdRecordTypeId,
                relationshipGroupRecordTypeId
        };
            //Return the query with all accounts
            return Database.getQueryLocator([SELECT Id,
                                             OwnerId,
                                             RecordTypeId,
                                             WT_Primary_Officer_Number__c
                                             FROM Account
                                             WHERE RecordTypeId IN :setRecordTypeId
                                             AND WT_Primary_Officer_Number__c != NULL
                                             AND WT_Primary_Officer_Number__c != '']);
    }
    
    global void execute(Database.BatchableContext batchContext, List<Account> scope)
    {
        List<Account> listAccountToUpdate = new List<Account>();
        Map<String, Id> mapBankOfficerCodeAndUserId = new Map<String, Id>();
        Set<String> setUniqueOfficerCode = new Set<String>();
        for(Account accountToReconcile : scope)
        {
            setUniqueOfficerCode.add(accountToReconcile.WT_Primary_Officer_Number__c);
        }
        
        if(!setUniqueOfficerCode.isEmpty())
        {
            for(WT_Bank_Officer_Lookup__c relatedBankOfficerLookup : [SELECT Id,
                                                                      WT_Unique_Officer_Code__c,
                                                                      WT_User__c
                                                                      FROM WT_Bank_Officer_Lookup__c
                                                                      WHERE WT_User__c != null])
            {
                mapBankOfficerCodeAndUserId.put(relatedBankOfficerLookup.WT_Unique_Officer_Code__c, relatedBankOfficerLookup.WT_User__c);
            }
        }
        
        if(!mapBankOfficerCodeAndUserId.isEmpty())
        {
            for(Account accountToReconcile : scope)
            {
                if(mapBankOfficerCodeAndUserId.containsKey(accountToReconcile.WT_Primary_Officer_Number__c) &&
                   mapBankOfficerCodeAndUserId.get(accountToReconcile.WT_Primary_Officer_Number__c) != accountToReconcile.OwnerId)
                {
                    accountToReconcile.OwnerId = mapBankOfficerCodeAndUserId.get(accountToReconcile.WT_Primary_Officer_Number__c);
                    listAccountToUpdate.add(accountToReconcile);
                }
            }
        }
        
        if(!listAccountToUpdate.isEmpty())
        {
            TriggerHandler.bypass('WT_AccountBeforeHandler');
            TriggerHandler.bypass('WT_AccountAfterHandler');
            TriggerHandler.bypass('WT_AccountAfterRequiredHandler');
            
            update listAccountToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext batchContext)
    {
        
    } 
}