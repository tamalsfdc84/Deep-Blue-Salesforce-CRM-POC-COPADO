/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_BatchPersonAccountMerge
* @Author      Vamsi Pulikallu  <vpulikal@wintrust.com>
* @ModifiedBy  Vamsi Pulikallu  <vpulikal@wintrust.com>
* @Version     v1.0
* @CreatedDate 11 Nov 2021
* @UsedBy      Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* * This handles identifying all the duplicate person account records and merge them.
* --------------------------------------------------------------------------------------------------------------
**/
global class WT_BatchPersonAccountMerge implements Database.Batchable<sObject>, Database.Stateful
{
    global Database.querylocator start(Database.BatchableContext BC)
    {
        string query = 'SELECT Id, FinServ__SourceSystemId__pc, type FROM account WHERE RecordType.DeveloperName in (\'PersonAccount_Customer\',\'PersonAccount_Prospect\') order by CreatedDate';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        string customer = 'Customer';
        string prospect = 'Prospect';
        map<string,list<Account>> mapAccount = new map<string,list<Account>>();
        list<Account> listAccount = new list<Account>();
        list<string> listSourceId = new list<string>();
        
        for(Account accountRecord: Scope)
        {
            if(!listSourceId.contains(accountRecord.FinServ__SourceSystemId__pc))
            {
                listSourceId.add(accountRecord.FinServ__SourceSystemId__pc);
            }
            
            if(mapAccount.get(accountRecord.FinServ__SourceSystemId__pc)!=null)
            {
                listAccount = mapAccount.get(accountRecord.FinServ__SourceSystemId__pc);
                if(listAccount.size()>0 && !listAccount.contains(accountRecord))
                {
                    listAccount.add(accountRecord);
                    mapAccount.put(accountRecord.FinServ__SourceSystemId__pc,listAccount);
                }
            }
            else
            {
                listAccount = new List<Account>();
                listAccount.add(accountRecord);
                mapAccount.put(accountRecord.FinServ__SourceSystemId__pc,listAccount);
            }
        }
        system.debug('mapAccount--'+mapAccount);
        if(mapAccount != null)
        {
            if(listSourceId.size()>0)
            {
                for(string sourceId : listSourceId)
                {
                    list<Account> listSameAccounts = new list<Account>();
                    listSameAccounts = mapAccount.get(sourceId);
                    system.debug('listSameAccounts--'+listSameAccounts);
                    system.debug('listSameAccounts size--'+listSameAccounts.size());
                    if(listSameAccounts.size()>1)
                    {
                        list<Account> listMergeAccounts = new list<Account>();
                        Account winningAccount = new Account();
                        
                        for(Account acc: listSameAccounts)
                        {
                            system.debug('winningAccount--'+winningAccount);                            
                            if(winningAccount.type != null && 
                               winningAccount.type.equalsIgnoreCase(prospect) &&
                               acc.type.equalsIgnoreCase(customer))
                            {
                                winningAccount = acc;
                                break;
                            }
                            else if(winningAccount.type != null && 
                                    winningAccount.type.equalsIgnoreCase(prospect) &&
                                    acc.type.equalsIgnoreCase(prospect))
                            {
                                winningAccount = acc;
                            }
                            else if(winningAccount.type == null)
                            {
                                if (acc.type.equalsIgnoreCase(customer))
                                {
                                    winningAccount = acc;
                                    break;
                                }
                                else 
                                {
                                    winningAccount = acc;
                                }                                
                            }
                        }
                        system.debug('winningAccount--'+winningAccount);                            
                        system.debug('winningAccount.id--'+winningAccount.id);
                        if(winningAccount.id != null)
                        {
                            for(Account accMerge: listSameAccounts)
                            {
                                if(accMerge != winningAccount)
                                {
                                    listMergeAccounts.add(accMerge);
                                }
                            }
                            system.debug('winningAccount--'+winningAccount);                        
                            system.debug('listMergeAccounts--'+listMergeAccounts);  
                            if(listMergeAccounts.size()>0)
                            {
                                database.merge(winningAccount,listMergeAccounts);
                            }                            
                        }
                    }                    
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}