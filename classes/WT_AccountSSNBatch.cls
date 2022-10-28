/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_AccountSSNBatch
* @Author      Vamsi Pulikallu  <VPulikal@wintrust.com>
* @ModifiedBy  Vamsi Pulikallu  <VPulikal@wintrust.com>
* @Version      v1.0
* @CreatedDate 07 July 2021
* Modified Date 07 July 2021
* @UsedBy      Account object
* --------------------------------------------------------------------------------------------------------------
* @Description
* * This batch class is created to update the SSN/TIN Dev field with only numbers
* --------------------------------------------------------------------------------------------------------------
**/
global class WT_AccountSSNBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,FinServ__TaxId__pc,WT_SSN_TIN_Dev__c FROM Account';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<account> scope)
    {
        String regex = '[a-zA-Z]{1,}|\\-';
        String ssn = '';
        list<Account> listAccounts = new list<Account>();
        for(Account accountRecord : scope)
        {   
            if(accountRecord.FinServ__TaxId__pc != NULL)
            {                
                ssn = accountRecord.FinServ__TaxId__pc;
                accountRecord.WT_SSN_TIN_Dev__c = ssn.replaceAll(regex, '');
                listAccounts.add(accountRecord);
            }
        }
        database.update(listAccounts, false);
    }
    global void finish(Database.BatchableContext bc)
    {
    }
}