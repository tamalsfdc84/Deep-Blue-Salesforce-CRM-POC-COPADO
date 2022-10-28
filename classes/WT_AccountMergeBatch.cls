/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_AccountMergeBatch
* @Author           Navanit Kamble  <nkamble@wintrust.com>
* @LastModifiedBy   Venkat Somireddy <vsomireddy@wintrust.com>
* @Version          v1.1
* @CreatedDate      11/5/2020
* @ModifiedDate     07/20/2022
* @UsedBy           Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This handles identifying all the duplicate records and merge them.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* 07-20-2022        Modified Query to include actual Record Type instead of Type and implemented Automation Log to track failures.
**/
global class WT_AccountMergeBatch implements Database.Batchable<sObject>
{    
    List<exception> exceptionList = new List<exception>();
    Map<Id, String> mapFailedDuplicateRecordSetIdAndError = new Map<Id, String>();
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
        mapAccount = new Map<Id,Account>([SELECT id, LastActivityDate, RecordTypeId,RecordType.Name, name, OwnerId, Owner.Email, Owner.Name from Account where id IN : setAccountId Order By LastActivityDate DESC]);        
        //this map is used to capture the accountid as the key and account details as the value
        mapAccountWithoutRecord = new Map<Id,Account>([SELECT id, RecordTypeId, OwnerId from Account where id IN : setAccountId Order By LastActivityDate DESC]);        
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
                        if(mapAccount.get(accountKey).RecordType!=null)
                        {
                            //if the account is prospect, map<AccountId,map<'prospect',list of prospect accounts>
                            if(mapAccount.get(accountKey).RecordType.Name.contains(prospect))
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
                                Id masterRecordId = mapListAccount.get(setItem).get(prospect)[0].Id;
                                Id duplicateId = mapListAccount.get(setItem).get(prospect)[1].Id;
                                WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Prospect with LastActivityDate < 2 Years', true, 'Merged Prospect to Prospect with LastActivityDate');    
                            }
                            else{
                                Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(prospect)[1].Id),mapListAccount.get(setItem).get(prospect)[0].Id);
                                Id masterRecordId = mapListAccount.get(setItem).get(prospect)[1].Id;
                                Id duplicateId = mapListAccount.get(setItem).get(prospect)[0].Id;
                                WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Prospect with LastActivityDate < 2 Years', true, 'Merged Prospect to Prospect with LastActivityDate');    
                            }
                        }
                        catch(exception e)
                        {
                            exceptionList.add(e);                            
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
                        }
                        continue;
                    }
                    //if both the prospects have the same owner, then merge the records
                    else if(mapListAccount.get(setItem).get(prospect)[0].OwnerId == mapListAccount.get(setItem).get(prospect)[1].OwnerId)
                    {
                        try
                        {
                            Database.merge (mapAccountWithoutRecord.get(mapListAccount.get(setItem).get(prospect)[0].Id),mapListAccount.get(setItem).get(prospect)[1].Id);
                            Id masterRecordId = mapListAccount.get(setItem).get(prospect)[0].Id;
                            Id duplicateId = mapListAccount.get(setItem).get(prospect)[1].Id;
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Prospect with same Owner', true, 'Merged Prospect to Prospect with same Owner');
                        }
                        catch(exception e){
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
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
                                Id masterRecordId = masterAccount.Id;
                                Id duplicateId = childAccount.Id;                                
                                WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Prospect with same Owner and more than 2 duplicates', true, 'Merged Prospect to Prospects with same Owner');
                            }
                        } 
                        catch(exception e)
                        {
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
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
                                    Id masterRecordId = masterAccount.Id;
                                    Id duplicateId = childAccount.Id;
                                    WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Prospect with LastActivityDate > 2 Years', true, 'Merged Prospect to Prospect with LastActivityDate');    
                                }
                            }
                            catch(exception e)
                            {
                                exceptionList.add(e);
                                mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                                WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');        
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
                            Id masterRecordId = mapListAccount.get(setItem).get(customer)[0].Id;
                            Id duplicateId = mapListAccount.get(setItem).get(prospect)[0].Id;
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Customer with LastActivityDate > 2 Years', true, 'Merged Prospect to Customer with LastActivityDate');    
                        }
                        catch(exception e)
                        {
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
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
                            Id masterRecordId = mapListAccount.get(setItem).get(customer)[0].Id;
                            Id duplicateId = mapListAccount.get(setItem).get(prospect)[0].Id;                            
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , 'Successfully Merged-Prospect to Customer with same Owner', true, 'Merged Prospect to Customer with same Owner');    
                        }
                        catch(exception e)
                        {
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
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
                            Id masterRecordId = mapListAccount.get(setItem).get(customer)[0].Id;
                            Id duplicateId = mapListAccount.get(setItem).get(prospect)[0].Id;
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', masterRecordId , duplicateId , '', true, 'Successfully Merged');
                        }
                        catch(exception e)
                        {
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
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
                            exceptionList.add(e);
                            mapFailedDuplicateRecordSetIdAndError.put(setItem,e.getMessage());
                            WT_AutomationLogService.log('WT_AccountMergeBatch', 'execute', setItem , setItem , e.getMessage() , false, 'Merged Failed');    
                        }
                    }
                }
            }
        }
        sendEmail(mapCustomerToProspectListEmail,mapAccount);
        if(!WT_AutomationLogService.listAutomationLogToInsert.isEmpty()) 
        {
            WT_AutomationLogService.CommitLogs();
        }      
        if(!mapFailedDuplicateRecordSetIdAndError.isEmpty())
        {
            SendEmailNotification(mapFailedDuplicateRecordSetIdAndError);
        }
    }
    
    global void sendEmail (map<string,list<string>> mapCustomerToProspectListEmail, map<id, Account> mapAccount)
    {
        Messaging.SingleEmailMessage emailMessage;
        List<Messaging.SingleEmailMessage> emailMessagesList = new List<Messaging.SingleEmailMessage>();
        List<string> toAddresses = new List<string>();
        List<String> listCCEmailAddress = new List<String>();  
        Boolean  isOwnerNotificationEnabled = false;
        Boolean  isEmailNotificationEnabled = false;
        for(WT_Duplicate_Accounts_Notification__mdt notificationSetting : WT_Duplicate_Accounts_Notification__mdt.getAll().values())
        {
            if(String.isNotBlank(notificationSetting.WT_CC_Recipients_Email__c) && notificationSetting.WT_Active__c == true)
            {
                listCCEmailAddress.add(notificationSetting.WT_CC_Recipients_Email__c);   
            }      
            else if(notificationSetting.DeveloperName == 'Email_Notification' && notificationSetting.WT_Active__c == true)      
            {
                isEmailNotificationEnabled = true;
            }
            else if(notificationSetting.DeveloperName == 'Owner_Notification' && notificationSetting.WT_Active__c == true)      
            {
                isOwnerNotificationEnabled = true;
            }
        }         
        if(isEmailNotificationEnabled)
        {
            for(string setKey : mapCustomerToProspectListEmail.keySet())
            {
                emailMessage = new Messaging.SingleEmailMessage();
                emailMessage.setSubject('Found possible duplicate records ');
                string body = 'Hi Team, </br></br>' + 'Request you to please examine these possible duplciates :-</br><br/>' ;
                integer k = 0;
                String tdHead='"border:1px solid black; width=200px; font-weight:bold;"';
                body = body+ '<table border="1" style="border-collapse: collapse">';
                for(id duplicateAccountKey : mapCustomerToProspectListEmail.get(setKey))
                {
                    k = k+1;                
                    body += '<tr><th style='+tdHead+'>Account ' + k + '</th>';
                    body += '<td>';
                    body += 'Account Name : ' + mapAccount.get(duplicateAccountKey).Name + '<br/>';
                    body += 'Account Owner : ' + mapAccount.get(duplicateAccountKey).Owner.Name + '</br>';
                    body += 'Account Type : ' + mapAccount.get(duplicateAccountKey).RecordType.Name + '<br/>';
                    body += 'Account Id : ' + mapAccount.get(duplicateAccountKey).Id + '<br/>';
                    body += '</td></tr>';
                    toAddresses.add(String.valueOf(mapAccount.get(duplicateAccountKey).owner.email) );
                }           
                if(listCCEmailAddress != null && listCCEmailAddress.size() > 0)
                {               
                    emailMessage.setCcAddresses(listCCEmailAddress);
                }
                if(isOwnerNotificationEnabled)
                {
                    emailMessage.setToAddresses(toAddresses); 
                }            
                emailMessage.setSaveAsActivity(false);
                emailMessage.setHtmlBody(body); 
                emailMessagesList.add(emailMessage);
            }
            if(!Test.isRunningTest())
            {            
                Messaging.sendEmail(emailMessagesList);
            }
        }  
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
    public void SendEmailNotification(Map<Id, String> mapFailedDuplicateRecordSetIdAndError)
    {
        List<String> listEmailAddress = new List<String>();
        String subject = 'WT_AccountMergeBatch Apex Job Failed';
        String body = '';      
        String tdHead='"border:1px solid black; width=200px; font-weight:bold;"';
        //Email the failures out to admins so they can fix the issues manually
        String tableBody = '';
        String tableBodyTemplate = '<tr>' +
        '<td class="tg-0lax">{{RecordId}}</td>' +
        '<td class="tg-0lax">{{Error}}</td>' +
        '</tr>';        
        for(Id failedDuplicateRecordSetId : mapFailedDuplicateRecordSetIdAndError.keySet())
        {
            String relatedErrors = mapFailedDuplicateRecordSetIdAndError.get(failedDuplicateRecordSetId);
            String tempBodyTemplate = tableBodyTemplate;
            tempBodyTemplate = tempBodyTemplate.replace('{{RecordId}}', failedDuplicateRecordSetId);
            tempBodyTemplate = tempBodyTemplate.replace('{{Error}}', relatedErrors);
            tableBody += tempBodyTemplate;
        }        
        body = '<table border="1" style="border-collapse: collapse">' + '<tr><th style='+tdHead+'>DuplicateRecordSetId</th>' +'<th style='+tdHead+'>Error</th>';
        body = body +  tableBody + '</table>';  
        for(WT_Automation_Notification_Setting__mdt notificationSetting : WT_Automation_Notification_Setting__mdt.getAll().values())
        {
            listEmailAddress.add(notificationSetting.WT_Recipient_Email__c);            
        }     
        Messaging.Singleemailmessage emailNotification = new Messaging.Singleemailmessage();    
        emailNotification.setReplyTo('no-reply@wintrust.com');
        emailNotification.setSenderDisplayName('Wintrust Automation');
        emailNotification.setToAddresses(listEmailAddress);
        emailNotification.setSaveAsActivity(false);
        emailNotification.setSubject(subject);
        emailNotification.setHtmlBody(body);
    
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {emailNotification});
        }
    }
}