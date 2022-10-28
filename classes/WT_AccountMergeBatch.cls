/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_AccountMergeBatch
* @Author      Navanit Kamble  <nkamble@wintrust.com>
* @ModifiedBy  Navanit Kamble  <nkamble@wintrust.com>
* @Version      v1.0
* @CreatedDate 11/5/2020
* @UsedBy      Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* * This handles identifying all the duplicate records and merge them.
* --------------------------------------------------------------------------------------------------------------
**/
global class WT_AccountMergeBatch implements Database.Batchable<sObject>
{    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        string query = 'SELECT Name, Id, RecordCount,ParentId , (select Name, RecordId  FROM DuplicateRecordItems ) FROM DuplicateRecordSet WHERE RecordCount > 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        string prospect = 'Prospect';
        string customer = 'Customer';
        map<id,List<Id>> mapListAccountId = new map<id,List<Id>>();
        map<id,map<string,List<Account>>>  mapListAccount = new map<id,map<string,List<Account>>>();
        set<Id> setAccountId = new set<Id>();
        map<Id,Account> mapAccount = new map<Id,Account>();
        map<Id,Account> mapAccountWithoutRecord = new map<Id,Account>();
        
        for(sObject duplicateSet : scope)
        {
            for(sObject duplicateRecordId:  duplicateSet.getSObjects('DuplicateRecordItems'))
            {
                //add the account ids to the set based on the record id that we get by querying DuplicateRecordItems
                setAccountId.add((string)duplicateRecordId.get('RecordId'));
                //this map captures the key of the DuplicateRecordItems and the values of the accountIds
                if(mapListAccountId.containsKey((string)duplicateSet.get('Id')))
                {
                    mapListAccountId.get((string)duplicateSet.get('Id')).add((string)duplicateRecordId.get('RecordId'));
                }
                else
                {
                    mapListAccountId.put((string)duplicateSet.get('Id'), new List<Id> {(string)duplicateRecordId.get('RecordId')});
                }
            }
        }
        //this map is used to capture the accountid as the key and account details as the value
        mapAccount = new Map<Id,Account>([SELECT id, LastActivityDate, type, name, OwnerId, Owner.Email, Owner.Name from Account where id IN : setAccountId Order By LastActivityDate DESC]);
        //this map is used to capture the accountid as the key and account details as the value
        mapAccountWithoutRecord = new Map<Id,Account>([SELECT id, type, OwnerId from Account where id IN : setAccountId Order By LastActivityDate DESC]);
        //start the for loop using the ids of the DuplicateRecordItems
        for(Id setKey : mapListAccountId.keySet())
        {
            if(!mapListAccountId.get(setKey).isEmpty())
            {
                //start the for loop using the accountids of Account object
                for(id accountKey : mapListAccountId.get(setKey))
                {
                    if(mapAccount.get(accountKey) != null)
                    {
                        if(mapAccount.get(accountKey).type!=null)
                        {
                            //if the account is prospect, map<AccountId,map<'prospect',list of prospect accounts>
                            if(mapAccount.get(accountKey).type.equalsIgnoreCase(prospect))
                            {
                                if(mapListAccount.containsKey(setKey))
                                {
                                    if(mapListAccount.get(setKey).containsKey(prospect))
                                    {
                                        mapListAccount.get(setKey).get(prospect).add(mapAccount.get(accountKey));
                                    }
                                    else
                                    {
                                        mapListAccount.get(setKey).put(prospect, new List<Account> {mapAccount.get(accountKey)});
                                    }
                                }
                                else
                                {
                                    mapListAccount.put(setKey,new Map<string, List<Account>> {prospect=> new List<Account> {mapAccount.get(accountKey)} } );
                                }
                            }
                            //if the account is customer, map<AccountId,map<'customer',list of customer accounts>
                            else
                            {
                                if(mapListAccount.containsKey(setKey))
                                {
                                    if(mapListAccount.get(setKey).containsKey(customer))
                                    {
                                        mapListAccount.get(setKey).get(customer).add(mapAccount.get(accountKey));
                                    }
                                    else
                                    {
                                        mapListAccount.get(setKey).put(customer, new List<Account> {mapAccount.get(accountKey)});
                                    }
                                }
                                else
                                {
                                    mapListAccount.put(setKey,new Map<string, List<Account>> {customer=> new List<Account> {mapAccount.get(accountKey)} } );
                                }
                            }
                        }   
                    }  
                }
            }
        }        
        //start merging process
        Set<Id> setProspectsToEmail = new Set<Id>();
        map<string,List<string>> mapCustomerToProspectListEmail =  new map<string,List<string>>();
        boolean allProspectsSameOwner = false;
        string ownerID; 
        for(id setItem : mapListAccount.keySet())
        {
            //if all the accounts are prospects
            if(!mapListAccount.get(setItem).containskey(customer))
            {
                //All are prospects 
                allProspectsSameOwner = true;
                //if there are excatly 2 prospects
                if(mapListAccount.get(setItem).get(prospect) != null && mapListAccount.get(setItem).get(prospect).size() == 2)
                {
                    //if the LastActivityDate is not NULL and if either of the records has the LastActivityDate before 2 years
                    if(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate != null && mapListAccount.get(setItem).get(prospect)[1].LastActivityDate != null &&
                       ((Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate)) >= 730 && 
                         Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[1].LastActivityDate)) >= 730) ||
                        (Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate)) >= 730 &&
                         Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[1].LastActivityDate)) < 730) ||
                        (Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[1].LastActivityDate)) >= 730 &&
                         Math.abs(Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate)) < 730)
                       ))
                    {   
                        try
                        {
                            if(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate > mapListAccount.get(setItem).get(prospect)[1].LastActivityDate)
                            {
                                Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(prospect)[0].Id),mapListAccount.get(setItem).get(prospect)[1].Id);
                            }
                            else{
                                Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(prospect)[1].Id),mapListAccount.get(setItem).get(prospect)[0].Id);
                            }
                        }
                        catch(exception e)
                        {
                            system.debug('e--'+e);
                        }
                        continue;
                    }
                    //if both the prospects have the same owner, then merge the records
                    else if(mapListAccount.get(setItem).get(prospect)[0].OwnerId == mapListAccount.get(setItem).get(prospect)[1].OwnerId)
                    {
                        try
                        {
                            Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(prospect)[0].Id),mapListAccount.get(setItem).get(prospect)[1].Id);
                        }
                        catch(exception e){
                            system.debug('e--'+e);
                        }
                        continue;
                    }
                    //if neither of the above criteria are met, send email to the owners of the records
                    else
                    {
                        //send an email to the account owners regarding the possible account duplicates 
                        addToEmailList(setItem,mapListAccount.get(setItem).get(prospect)[0].Id,mapCustomerToProspectListEmail);
                        addToEmailList(setItem,mapListAccount.get(setItem).get(prospect)[1].Id,mapCustomerToProspectListEmail);
                        continue;
                    }
                }
                //if there are more than two prospects
                else if(mapListAccount.get(setItem).get(prospect) != null && mapListAccount.get(setItem).get(prospect).size() > 2)
                {
                    //check if all these prospects have same owner 
                    ownerID = mapListAccount.get(setItem).get(prospect)[0].OwnerId;
                    for(Account temporaryAccount : mapListAccount.get(setItem).get(prospect))
                    {
                        if(temporaryAccount.OwnerId != ownerID)
                        {
                            allProspectsSameOwner = false;
                            break;
                        }
                    }
                    //if all these prospects have same owner
                    if(allProspectsSameOwner)
                    {
                        set<Account> setSameOwnerProspectAccounts = new set<Account>();
                        for(Account temporaryAccount : mapListAccount.get(setItem).get(prospect))
                        {   
                            setSameOwnerProspectAccounts.add(temporaryAccount);
                        }
                        List<Account> listSameOwnerProspectAccounts = new List<Account>(setSameOwnerProspectAccounts);
                        Account firstAccount = listSameOwnerProspectAccounts[0];
                        Account masterAccount = mapAccountWithoutRecord.get(listSameOwnerProspectAccounts[0].Id);
                        integer index = 0;
                        for(integer i=0; i<listSameOwnerProspectAccounts.size();i++)
                        {
                            if(firstAccount.LastActivityDate < listSameOwnerProspectAccounts[i].LastActivitydate)
                            {
                                firstAccount = listSameOwnerProspectAccounts[i];
                                index = i;
                            }
                        }
                        masterAccount = mapAccountWithoutRecord.get(listSameOwnerProspectAccounts[index].Id);
                        listSameOwnerProspectAccounts.remove(index);
                        try
                        {
                            for(Account childAccount: listSameOwnerProspectAccounts)
                            {                                
                                Database.merge(masterAccount, childAccount);
                            }
                        } 
                        catch(exception e)
                        {
                            system.debug('e--'+e.getMessage());
                        }
                        continue;
                    }
                    //get the list of prospects which are greater than 2 years in ascending Order
                    //if the prospects doesn't have the same owner                        
                    else
                    {
                        set<Account> setProspectsToMerge = new set<Account>();                                    
                        for(Account temporaryAccount : mapListAccount.get(setItem).get(prospect))
                        {
                            if( temporaryAccount.LastActivityDate!=null && 730 < Math.abs(Date.today().daysBetween(temporaryAccount.LastActivityDate)))
                            {
                                //these prospects will be merged
                                setProspectsToMerge.add(temporaryAccount);
                            }
                            else
                            {
                                //these go out email process
                                addToEmailList(setItem,temporaryAccount.Id,mapCustomerToProspectListEmail);
                            }
                        }
                        //Merge accounts here if two or more prospects have last activity date more than 2 years
                        list<Account> listProspectsToMerge = new list<Account>(setProspectsToMerge);
                        if(listProspectsToMerge != null && listProspectsToMerge.size() >= 2)
                        {   
                            Account firstAccount = listProspectsToMerge[0];
                            integer index = 0;
                            Account masterAccount = mapAccountWithoutRecord.get(listProspectsToMerge[0].Id);
                            for(integer i=0; i<listProspectsToMerge.size();i++)
                            {
                                if(firstAccount.LastActivityDate < listProspectsToMerge[i].LastActivitydate)
                                {
                                    firstAccount = listProspectsToMerge[i];
                                    index = i;
                                }
                            }
                            masterAccount = mapAccountWithoutRecord.get(listProspectsToMerge[index].Id);
                            listProspectsToMerge.remove(index);
                            try
                            {
                                for(Account childAccount: listProspectsToMerge)
                                {
                                    Database.merge(masterAccount, childAccount);
                                }
                            }
                            catch(exception e)
                            {
                                system.debug('e--'+e.getMessage());
                            }
                        }
                        continue;
                    }
                }
            }
            //if there is atleast one customer account
            else
            {
                //if there is only one prospect and there is only one customer
                if(mapListAccount.get(setItem).get(prospect) != null && mapListAccount.get(setItem).get(customer) != null &&
                   mapListAccount.get(setItem).get(customer).size() == 1 && mapListAccount.get(setItem).get(prospect).size() == 1)
                {
                    //if the last activity date of prospect is more than 2 years ago
                    if(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate != null && 730 < Math.abs( Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate)))
                    {
                        //merge the prospect into the customer record
                        try
                        {
                            Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(customer)[0].Id),mapListAccount.get(setItem).get(prospect)[0]);
                        }
                        catch(exception e)
                        {
                            system.debug('e--'+e);
                        }
                        continue;
                    }
                    //if the prospect has last activity date less than 2 years ago
                    //and there is only one customer
                    //but they have same owner
                    else if(mapListAccount.get(setItem).get(prospect)[0].Owner == mapListAccount.get(setItem).get(customer)[0].Owner)
                    {
                        //merge the prospect into the customer record
                        try
                        {
                            Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(customer)[0].Id),mapListAccount.get(setItem).get(prospect));
                        }
                        catch(exception e)
                        {
                            system.debug('e--'+e);
                        }
                        continue;
                    }
                    //if there is only one prospect with last activity date less than 2 years ago
                    //and there is only one customer
                    //but they have different owners
                    else
                    {
                        //Send email 
                        addToEmailList(setItem, mapListAccount.get(setItem).get(customer)[0].Id, mapCustomerToProspectListEmail);
                        addToEmailList(setItem, mapListAccount.get(setItem).get(prospect)[0].Id, mapCustomerToProspectListEmail);
                    }
                }
                //if there are two or more customers and only one prospect
                else if(mapListAccount.get(setItem).get(prospect) != null && mapListAccount.get(setItem).get(customer) != null &&
                        mapListAccount.get(setItem).get(customer).size() >= 2 && mapListAccount.get(setItem).get(prospect).size() == 1)
                {
                    //if the last activity date of the prospect is more than 2 years
                    if(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate != null && 730 < Math.abs( Date.today().daysBetween(mapListAccount.get(setItem).get(prospect)[0].LastActivityDate)))
                    {
                        //merge the prospect into one of the customer records
                        try
                        {
                            Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(customer)[0].Id),mapListAccount.get(setItem).get(prospect)[0]);
                        }
                        catch(exception e)
                        {
                            system.debug('e--'+e);
                        }
                        continue;
                    }
                    //if the prospect has last activity date less than 2 years ago
                    //and there are more than one customer 
                    else 
                    {
                        //if the prospect's owner doesn't match with either of the customers' owners
                        //send the respective owners emails
                        addToEmailList(setItem, mapListAccount.get(setItem).get(prospect)[0].Id, mapCustomerToProspectListEmail);
                        for(Account temporaryAccount : mapListAccount.get(setItem).get(customer))
                        {
                            addToEmailList(setItem, temporaryAccount.Id, mapCustomerToProspectListEmail);
                        }
                    }
                }
                //if there is more than one customer and there are two or more prospects
                else  if(mapListAccount.get(setItem).get(prospect)!= null && mapListAccount.get(setItem).get(customer)!=null &&
                         mapListAccount.get(setItem).get(prospect).size() > 1 && mapListAccount.get(setItem).get(customer).size() >= 1)
                {
                    //for the set 
                    list<Account> listProspectsToMergeWithCustomer = new List<Account>();
                    boolean addCustomerToEmail = false;
                    //get the list of prospects which are greater that 2 years 
                    //arrange in ascending Order
                    for(Account temporaryAccount : mapListAccount.get(setItem).get(prospect))
                    {
                        if(temporaryAccount.LastActivityDate!=null && 730 <  Math.abs(Date.today().daysBetween(temporaryAccount.LastActivityDate)))
                        {
                            //these merge with customers
                            listProspectsToMergeWithCustomer.add(temporaryAccount);
                        }
                        else
                        {
                            //these go out email process
                            addToEmailList(setItem,temporaryAccount.Id,mapCustomerToProspectListEmail);
                            addCustomerToEmail = true;
                        }
                    }
                    if(addCustomerToEmail)
                    {
                        for(Account temporaryAccount : mapListAccount.get(setItem).get(customer))
                        {
                            addToEmailList(setItem,temporaryAccount.Id,mapCustomerToProspectListEmail);
                        }
                    }
                    //Merge accounts here 
                    for(Account acc: listProspectsToMergeWithCustomer)
                    {   
                        try
                        {
                            Database.MergeResult mergeResult = Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(customer)[0].Id),acc);
                        }
                        catch(exception e)
                        {
                            system.debug('e--'+e);
                        }
                    }
                }
            }
        }
        sendEmail(mapCustomerToProspectListEmail,mapAccount);
    }
    
    global void sendEmail (map<string,list<string>> mapCustomerToProspectListEmail, map<id, Account> mapAccount)
    {
        Messaging.SingleEmailMessage emailMessage;
        List<Messaging.SingleEmailMessage> emailMessagesList = new List<Messaging.SingleEmailMessage>();
        List<string> toAddresses = new List<string>();
        for(string setKey : mapCustomerToProspectListEmail.keySet())
        {
            emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setSubject('Found possible duplicate records ');
            string body = 'Hi Team, </br></br>' + 'Request you to please examine these possible duplciates :-</br><br/>' ;
            integer k = 0;
            for(id duplicateAccountKey : mapCustomerToProspectListEmail.get(setKey))
            {
                k=k+1;
                body += '<b><u>Account '+k+'</u></b><br/>';
                body += 'Account Name : ' + mapAccount.get(duplicateAccountKey).Name + '<br/>';
                body += 'Account Owner : ' + mapAccount.get(duplicateAccountKey).Owner.Name + '</br>';
                body += 'Account Type : ' + mapAccount.get(duplicateAccountKey).Type + '<br/>';
                body += 'Account Id : ' + mapAccount.get(duplicateAccountKey).Id + '<br/><br/>';
                toAddresses.add(String.valueOf(mapAccount.get(duplicateAccountKey).owner.email) );
            }
            //toAddresses.add('vpulikal@wintrust.com');
            emailMessage.setToAddresses(toAddresses); 
            emailMessage.setSaveAsActivity(false);
            emailMessage.setHtmlBody(body); 
            emailMessagesList.add(emailMessage);
        }
        system.debug('emailMessagesList--'+emailMessagesList.size());
        Messaging.sendEmail(emailMessagesList);
    }
    
    global void addToEmailList(string setId, string accountId, map<string, List<string>> mapCustomerToProspectListEmail)
    {
        if(mapCustomerToProspectListEmail.containsKey(setId))
        {
            mapCustomerToProspectListEmail.get(setId).add(accountId);
        }
        else
        {
            mapCustomerToProspectListEmail.put(setId,new List<string> {accountId});
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}