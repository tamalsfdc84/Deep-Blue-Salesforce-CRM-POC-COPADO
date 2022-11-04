//Code Coverage: WT_BatchBankOfficerFinAcctReconcile_T
//Scheduler: WT_BatchBankOfficerFinAcctReconcileSch
//This batch class is used to reconcile Financial Account record Ownership with the Bank Officer Lookup object
//Bank Officer Lookup can be updated anytime but that doesn't necessarily trigger an update to the Financial Account
//This batch would ensure that both objects are always in sync
global class WT_BatchBankOfficerFinAcctReconciliation implements Database.Batchable<sObject>
{
    //Grab all Financial Accounts and iterate through and update them if necessary
    global Database.QueryLocator start(Database.BatchableContext batchContext) 
    {
        //Return the query with all Financial accounts
        return Database.getQueryLocator([SELECT Id,
                                         OwnerId,
                                         WT_Officer_Number__c
                                         FROM FinServ__FinancialAccount__c
                                         WHERE WT_Officer_Number__c != NULL
                                         AND WT_Officer_Number__c != '']);
    }
    
    global void execute(Database.BatchableContext batchContext, List<FinServ__FinancialAccount__c> scope)
    {
        List<FinServ__FinancialAccount__c> listFinancialAccountToUpdate = new List<FinServ__FinancialAccount__c>();
        Map<String, Id> mapBankOfficerCodeAndUserId = new Map<String, Id>();
        Set<String> setUniqueOfficerCode = new Set<String>();
        for(FinServ__FinancialAccount__c financialAccountToReconcile : scope)
        {
            setUniqueOfficerCode.add(financialAccountToReconcile.WT_Officer_Number__c);
        }
        
        if(!setUniqueOfficerCode.isEmpty())
        {
            for(WT_Bank_Officer_Lookup__c relatedBankOfficerLookup : [SELECT Id,
                                                                      WT_Unique_Officer_Code__c,
                                                                      WT_User__c
                                                                      FROM WT_Bank_Officer_Lookup__c
                                                                      WHERE WT_User__c != null
                                                                      AND WT_Unique_Officer_Code__c IN :setUniqueOfficerCode])
            {
                mapBankOfficerCodeAndUserId.put(relatedBankOfficerLookup.WT_Unique_Officer_Code__c, relatedBankOfficerLookup.WT_User__c);
            }
        }
        
        if(!mapBankOfficerCodeAndUserId.isEmpty())
        {
            for(FinServ__FinancialAccount__c financialAccountToReconcile : scope)
            {
                if(mapBankOfficerCodeAndUserId.containsKey(financialAccountToReconcile.WT_Officer_Number__c) &&
                   mapBankOfficerCodeAndUserId.get(financialAccountToReconcile.WT_Officer_Number__c) != financialAccountToReconcile.OwnerId)
                {
                    financialAccountToReconcile.OwnerId = mapBankOfficerCodeAndUserId.get(financialAccountToReconcile.WT_Officer_Number__c);
                    listFinancialAccountToUpdate.add(financialAccountToReconcile);
                }
            }
        }
        
        if(!listFinancialAccountToUpdate.isEmpty())
        {
            TriggerHandler.bypass('WT_FinancialAccountBeforeHandler');
            
            update listFinancialAccountToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext batchContext)
    {
        
    } 
}