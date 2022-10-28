/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchCampaignMembersLoad
* @Author           Pushpa Mopuru   <PMopuru@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @version          v1.0 
* @CreatedDate      03-25-2021
* @UsedBy           CampaignMembe,Accounts
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to add Accounts to CampaignMember based on WT_Prospect_List__c.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_BatchCampaignMembersLoad_T
global class WT_BatchCampaignMembersLoad implements Database.Batchable<sObject>,Database.Stateful
{
    global List<Campaign> listOfAllMissingCampaigns = new List<Campaign>();
    global Map<String,Long> mapBusinessAccountsAndCount= new Map<String,Long>();
    global Map<String,Long> mapPersonAccountsCount= new Map<String,Long>();
    global List<String> listError = new List<String>();
    global List<String> listCampaignErrorId = new List<String>();
    //Query all the unprocesssed Account record
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String queryString= 'SELECT Id, Name,WT_Prospect_List__c,WT_IsProcessed__c,WT_Account_Record_Type__c FROM Account WHERE WT_IsProcessed__c = false AND WT_Prospect_List__c != NULL';
        return Database.getQueryLocator(queryString);  
    }
    global void execute(Database.BatchableContext bc, List<Account> listOfAccounts)
    {
        if(listOfAccounts != null && listOfAccounts.size() != 0)
        {
            list<Contact> listContact = [Select id, AccountId from Contact WHERE  AccountId IN : listOfAccounts];
            Map<Id,Id> mapAccountIdContactId= new Map<Id,Id>();
            Map<Id,Id> mapContactIdAccountId= new Map<Id,Id>();
            for(Contact contact: listContact)
            {
                mapAccountIdContactId.put(contact.AccountId, contact.Id);
                mapContactIdAccountId.put(contact.Id, contact.AccountId);
            }
            Set<string> setCampaignFromAccounts= new Set<string>();
            List<Campaign> listMissingCampaigns= new List<Campaign>();
            List<string> listMissingCampaignErrors= new List<string>();
            Map<String,List<Id>> mapCampaignsAccounts= new Map<String,List<Id>>();
            Map<String,List<Id>> mapCampaignsContacts= new Map<String,List<Id>>();
            Map<String,Id> mapCampaignsNameId= new Map<String,Id>();
            Map<Id,String> mapCampaignsIdName= new Map<Id,String>();
            List<CampaignMember> listBusinessCampaignMember = new List<CampaignMember>();
            List<CampaignMember> listPersonCampaignMember = new List<CampaignMember>();
            Set<Account> setAccountsToUpdate = new Set<Account>();
            List<Account> listAccountsToUpdateFinal = new List<Account>();
            for(Account account: listOfAccounts)
            {   
                //setCampaignFromAccounts: unique set of campaign names attached to Accounts and it also contains campaigns not available in db
                if(account.WT_Prospect_List__c.contains(','))
                {
                    List<string> listProspect = account.WT_Prospect_List__c.split(',');
                    for (String prospect:listProspect)
                    {
                        setCampaignFromAccounts.add(prospect.trim());
                    }
                }
                else
                {
                    setCampaignFromAccounts.add((account.WT_Prospect_List__c).trim());
                }
            }
            //listCampaigns: List of campaigns present in db attached to Accounts. It will not have campaigns not in db
            //Difference between setCampaignFromAccounts and listCampaigns have to be reported as missing campaigns
            List<Campaign> listCampaigns = [SELECT Id, Name FROM Campaign WHERE Name IN: setCampaignFromAccounts];
            for(Campaign campaign: listCampaigns)
            {
                mapCampaignsNameId.put(campaign.Name,campaign.Id);
            }
            //find missing campaigns
            if(setCampaignFromAccounts.size() != listCampaigns.size()){
                for(String campaignName : setCampaignFromAccounts)
                {
                    List<Id> listAccount = new List<Id>();
                    if(!mapCampaignsNameId.containsKey(campaignName))
                    {
                        Campaign campaign = new Campaign();
                        campaign.Name = campaignName;
                        listMissingCampaigns.add(campaign);
                    }
                }
            }
            //create missingcampaigns in database
            Integer campaignIndex=0;
            List<Database.SaveResult> campainSaveResults = Database.Insert(listMissingCampaigns, false);
            for(Database.SaveResult result:campainSaveResults)
            {
                if (!result.isSuccess())
                {
                    Database.Error error = result.getErrors().size()>0?result.getErrors().get(0):null;
                    if(error !=null) 
                    { 
                        // Error Messages List
                        String errorMsg = 'Campaign insertion failed '+listMissingCampaigns.get(campaignIndex).Name + ', ' + error.getMessage();
                        listMissingCampaignErrors.add(errorMsg);
                    }
                }
                else
                {
                    listOfAllMissingCampaigns.add(listMissingCampaigns.get(campaignIndex));
                }
                campaignIndex++;
            }
            for(Account account: listOfAccounts)
            {   
                List<string> listProspect = new List<string>();
                if(account.WT_Prospect_List__c.contains(','))
                {
                    listProspect = account.WT_Prospect_List__c.split(',');
                }
                else
                {
                    listProspect.add(account.WT_Prospect_List__c);
                }
                for(String prospect: listProspect)
                {
                    if(account.WT_Account_Record_Type__c.contains('Business'))
                    {              
                        List<Id> listAccountId = new List<Id>();
                        //mapCampaignsAccounts : map of campaign names and AccountIds List for Business Accounts.
                        if(mapCampaignsAccounts.get(prospect.trim()) != null)
                        {                      
                            listAccountId = mapCampaignsAccounts.get(prospect.trim());
                            listAccountId.add(account.Id);
                            mapCampaignsAccounts.put(prospect.trim(), listAccountId);                    
                        }
                        else
                        {
                            listAccountId.add(account.Id);
                            mapCampaignsAccounts.put(prospect.trim(), listAccountId);
                        }
                    }
                    else if(account.WT_Account_Record_Type__c.contains('Person'))
                    {
                        List<Id> listContactId = new List<Id>();
                        Id contactId = mapAccountIdContactId.get(account.Id);
                        //mapCampaignsContacts : map of campaign names and ContactIdsList for person accounts.
                        if(contactId!=null)
                        {
                            if(mapCampaignsContacts.get(prospect.trim()) != null)
                            {                      
                                listContactId = mapCampaignsContacts.get(prospect.trim());
                                listContactId.add(contactId);
                                mapCampaignsContacts.put(prospect.trim(), listContactId);                    
                            }
                            else
                            {
                                listContactId.add(contactId);
                                mapCampaignsContacts.put(prospect.trim(), listContactId);
                            }
                        }
                        else
                        {
                            listError.add('No Contact associated to this person account Id - '+account.Id +', Name - '+account.Name);
                        }
                    } 
                }               
            }
            listCampaigns = [SELECT Id, Name FROM Campaign WHERE Name IN: setCampaignFromAccounts];
            for(Campaign campaign: listCampaigns)
            {
                mapCampaignsNameId.put(campaign.Name,campaign.Id);
                mapCampaignsIdName.put(campaign.Id,campaign.Name);
            }
            for (Campaign campaign : listCampaigns)
            {
                //Business account campaignmemebers and counts 
                Long accountsCount = 0;
                if(mapBusinessAccountsAndCount.containsKey(campaign.Name))
                {
                    accountsCount = mapBusinessAccountsAndCount.get(campaign.Name);
                }
                List<Id> accountIdsTobeAddedToCampaignMember = new List<Id>();
                accountIdsTobeAddedToCampaignMember = mapCampaignsAccounts.get(campaign.Name);
                if(accountIdsTobeAddedToCampaignMember!=null)
                {
                    for(Id accountId: accountIdsTobeAddedToCampaignMember)
                    {
                        CampaignMember campaignMember = new CampaignMember();
                        campaignMember.CampaignId= campaign.Id;
                        campaignMember.AccountId= accountId;
                        listBusinessCampaignMember.add(campaignMember);
                        Account accountsToUpdate = new Account();
                        accountsToUpdate.Id = accountId;
                        accountsToUpdate.WT_IsProcessed__c = true;
                        setAccountsToUpdate.add(accountsToUpdate);
                        accountsCount++;
                    }
                    mapBusinessAccountsAndCount.put(campaign.Name, accountsCount);
                }
                //Person account campaignmemebers and counts 
                Long personAccountsCount = 0;
                if(mapPersonAccountsCount.containsKey(campaign.Name))
                {
                    personAccountsCount = mapPersonAccountsCount.get(campaign.Name);
                }
                List<Id> personAccountIdsTobeAddedToCampaignMember = new List<Id>();
                personAccountIdsTobeAddedToCampaignMember = mapCampaignsContacts.get(campaign.Name);
                if(personAccountIdsTobeAddedToCampaignMember!=null)
                {
                    for(Id contactId: personAccountIdsTobeAddedToCampaignMember)
                    {
                        Id accountId = mapContactIdAccountId.get(contactId);
                        if(accountId!=null)
                        {
                            CampaignMember campaignMember = new CampaignMember();
                            campaignMember.CampaignId= campaign.Id;
                            campaignMember.ContactId= contactId;
                            listPersonCampaignMember.add(campaignMember);
                            Account accountsToUpdate = new Account();
                            accountsToUpdate.Id = accountId;
                            accountsToUpdate.WT_IsProcessed__c = true;
                            setAccountsToUpdate.add(accountsToUpdate);
                            personAccountsCount++;
                        }
                        else 
                        {
                            listError.add('No Account associated to this contact Id - '+ contactId);
                        }
                    }
                    mapPersonAccountsCount.put(campaign.Name, personAccountsCount);
                }
            }
            //Insert business account CampaignMembers
            try 
            {
                Integer index=0;
                List<Id> listErrorAccountId = new List<Id>();
                List<Database.SaveResult> campainMemberSaveResults = Database.Insert(listBusinessCampaignMember,false); 
                for(Database.SaveResult result:campainMemberSaveResults)
                {
                    if (!result.isSuccess())
                    {
                        CampaignMember campaignMember = listBusinessCampaignMember.get(index);
                        listErrorAccountId.add(campaignMember.accountId);
                        
                        String campaingnName = '';
                        if(mapCampaignsIdName.containsKey(campaignMember.campaignId))
                            campaingnName = mapCampaignsIdName.get(campaignMember.campaignId);
                        if(mapBusinessAccountsAndCount.containsKey(campaingnName))
                        {
                            Long count = mapBusinessAccountsAndCount.get(campaingnName);
                            count--;
                            mapBusinessAccountsAndCount.put(campaingnName, count);
                        }
                        Database.Error error = result.getErrors().size()>0?result.getErrors().get(0):null;
                        if(error !=null) 
                        { 
                            // Error Messages List
                            listError.add('AccountId: '+campaignMember.accountId+' and CampaignIdandName: '+campaignMember.CampaignId+' & '+mapCampaignsIdName.get(campaignMember.campaignId)+' -> '+error.getMessage());
                            listCampaignErrorId.add(mapCampaignsIdName.get(campaignMember.CampaignId));
                        }
                    }
                    index++;
                }                
                //person account campaignmembers insertion
                Integer personIndex=0;
                List<Database.SaveResult> personAccountCampainMemberSaveResults = Database.Insert(listPersonCampaignMember,false); 
                for(Database.SaveResult result : personAccountCampainMemberSaveResults)
                {
                    if (!result.isSuccess())
                    {
                        CampaignMember campaignMember = listPersonCampaignMember.get(personIndex);
                        if(mapContactIdAccountId.containsKey(campaignMember.contactId)){
                            Id accountId = mapContactIdAccountId.get(campaignMember.contactId);
                            listErrorAccountId.add(accountId);  
                        }                     
                        if(mapCampaignsIdName.containsKey(campaignMember.campaignId))
                        {
                            String campaingnName = mapCampaignsIdName.get(campaignMember.campaignId);
                            if(mapPersonAccountsCount.containsKey(campaingnName))
                            {
                                Long count = mapPersonAccountsCount.get(campaingnName);
                                count--;
                                mapPersonAccountsCount.put(campaingnName, count);
                            }
                        }
                        Database.Error error = result.getErrors().size()>0?result.getErrors().get(0):null;
                        if(error !=null) 
                        { 
                            // Error Messages List
                            listError.add('AccountId: '+mapContactIdAccountId.get(campaignMember.contactId)+' and CampaignIdandName: '+campaignMember.CampaignId+' & '+mapCampaignsIdName.get(campaignMember.campaignId)+' -> '+error.getMessage());
                            listCampaignErrorId.add(mapCampaignsIdName.get((campaignMember.CampaignId)));
                        }
                    }
                    personIndex++;
                }   
                //filtering error accounts from accounts to be updated
                for(Account finalAccount : setAccountsToUpdate)
                {
                    if(!(listErrorAccountId.contains(finalAccount.Id)))
                    {
                        listAccountsToUpdateFinal.add(finalAccount);
                    }  
                }    
                List<Database.SaveResult> accountsUpdateResults  = Database.Update(listAccountsToUpdateFinal,false);
                for(Database.SaveResult result:accountsUpdateResults)
                {
                    if (!result.isSuccess()){   
                        Database.Error accountUpdateError = result.getErrors().size()>0?result.getErrors().get(0):null;
                        if(accountUpdateError != null)
                        {
                            listError.add('AccountId: '+result.getId()+' -> '+accountUpdateError.getMessage());
                        }
                    }
                } 
            } 
            catch (Exception e)
            {
                System.debug('The following exception has occurred: ' + e.getMessage());
                listError.add('The following exception has occurred: '+e.getMessage());
            }                     
        }
    }
    // Send Email to Logged in User with Job status.
    global void finish(Database.BatchableContext bc)
    {    
        User activeUser = [Select Email From User where Id = : UserInfo.getUserId() limit 1];
        String loggedInUserEmail = activeUser.Email; 
        Id jobId =bc.getJobId();
        Integer index = 0;
        AsyncApexJob asyncResults= [SELECT NumberofErrors, JobType, Status,TotalJobItems, JobItemsProcessed FROM AsyncApexJob WHERE id=: jobId];
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {loggedInUserEmail};
            emailMessage.setToAddresses(toAddress);
        String body = 'Total Batches     :' + asyncResults.TotalJobItems; 
        body = body+ '<br/><br/> Batches Processed :' + asyncResults.JobItemsProcessed; 
        body = body+ '<br/><br/> Failures  :' + asyncResults.NumberofErrors; 
        body = body+ '<br/><br/> Number of Errors  :' + listError.size(); 
        if(listOfAllMissingCampaigns.size()!=0 && listOfAllMissingCampaigns.size()!=null)
        {
            body = body + '<br/><br/><table border="1" style="border-collapse: collapse"><caption><b> Newly Created Campaign Details </b></caption><tr><th> Campaign Id </th><th>Campaign Name</th></tr>';
            for(Campaign campaign : listOfAllMissingCampaigns)
            {
                body = body+ '<tr><td>' + campaign.Id + '</td><td>' + campaign.Name + '</td></tr>';            
            }
            body = body +'</table>';
        }    
        for(String campaignName : mapBusinessAccountsAndCount.keySet())
        {
            if(!listCampaignErrorId.contains(campaignName))
            {
                if(index == 0)
                {
                    body = body + '<br/><br/><table border="1" style="border-collapse: collapse"><caption><b>Campaign-Business Accounts Mapping Details</b></caption><tr><th>Campaign Name</th><th>Accounts</th></tr>';
                    index++;
                }
                Long numberOfAccountsMapped = mapBusinessAccountsAndCount.get(campaignName);
                body = body+ '<tr><td>' + campaignName + '</td><td>' + numberOfAccountsMapped + '</td></tr>';            
            }
        }
        body = body +'</table>';
        index = 0;
        for(String campaignName : mapPersonAccountsCount.keySet())
        {
            if(!listCampaignErrorId.contains(campaignName))
            {
                if(index == 0)
                {
                    body = body + '<br/><br/><table border="1" style="border-collapse: collapse"><caption><b>Campaign-Person Accounts Mapping Details</b></caption><tr><th>Campaign Name</th><th>Accounts</th></tr>';
                    index++;
                }
                Long numberOfAccountsMapped = mapPersonAccountsCount.get(campaignName);
                body = body+ '<tr><td>' + campaignName + '</td><td>' + numberOfAccountsMapped + '</td></tr>';            
            }
        }
        body = body +'</table>';
        if(listError.size()!=0  && listError.size() != null)
        {
            body = body + '<br/><br/> <b> List of Errors  :</b>';
            for(String error : listError)
            {
                body = body+ '<br/>   Error  : ' + error;
            }     
        }  
        emailMessage.setSubject('Campaign Member Bulk Upload Batch Job :' + jobId +' '+ asyncResults.Status);
        emailMessage.setHtmlBody(body);
        emailMessage.setSenderDisplayName('Bulk Campagin Batch Processing');
        Messaging.Email[] emails = new Messaging.Email[]{emailMessage};
            Messaging.sendEmail(emails);
    }
}