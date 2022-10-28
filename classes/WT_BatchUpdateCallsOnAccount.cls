/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateCallsOnAccount
* @Author           Vamsi Krishna<vpulikal@wintrust.com>
* @ModifiedBy       Vamsi Krishna<vpulikal@wintrust.com>
* @Version          v1.0
* @CreatedDate      31 Jan 2022
* @ModifiedDate     31 Jan 2022
* @UsedBy           
* --------------------------------------------------------------------------------------------------------------
* @Description
* This batch updates the calls made in this year details on Accounts.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 31 Jan 2022
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchUpdateCallsOnAccount_T
public class WT_BatchUpdateCallsOnAccount implements Database.Batchable<sObject>, Database.Stateful
{
    Public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, WT_Calls_Made_Last_Year__c, WT_Calls_Made_This_Year__c FROM Account WHERE RecordType.DeveloperName in (\'PersonAccount_Prospect\', \'PersonAccount_Customer\', \'BusinessAccount_Customer\',\'BusinessAccount_Prospect\')';
        return Database.getQueryLocator(query);
    }
    
    Public void execute(Database.BatchableContext bc, List<Account> scope)
    {
        list<Account> listAccounts = new list<Account>();
        for(Account accountRecord: Scope)
        {
            if(string.isBlank(String.valueOf(accountRecord.WT_Calls_Made_This_Year__c)))
            {
                accountRecord.WT_Calls_Made_Last_Year__c = 0;
            }
            else
            {
                accountRecord.WT_Calls_Made_Last_Year__c = accountRecord.WT_Calls_Made_This_Year__c;
                accountRecord.WT_Calls_Made_This_Year__c = 0;
            }
            listAccounts.add(accountRecord);
        }
        if(!listAccounts.isEmpty())
        {
            database.update(listAccounts,false);
        }        
    }
    
    Public void finish(Database.BatchableContext bc)
    {
        
    }
}