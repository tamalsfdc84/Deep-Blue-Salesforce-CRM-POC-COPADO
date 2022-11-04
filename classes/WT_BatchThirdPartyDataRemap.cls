global class WT_BatchThirdPartyDataRemap implements Database.Batchable<sobject>, Database.Stateful
{
    Integer countRecordsToDelete = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        Id businessProspectRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
        Id dbAmpUser = null;
        if(!Test.isRunningTest())
        {
            dbAmpUser = [SELECT Id FROM User WHERE Name = 'DBAMP USER'].Id;
        }
        else
        {
            dbAmpUser = UserInfo.getUserId();
        }
        return Database.getQueryLocator(
            [SELECT Id, 
             Name,
             WT_Employees_Single_Site__c,
             WT_INFOUSAID__c,
             WT_Contact_Name__c,
             WT_Email__c,
             WT_Primary_Address__c,
             WT_Account__c, 
             WT_Account__r.CreatedDate,
             WT_Account__r.CreatedById, 
             WT_Account__r.RecordTypeId, 
             WT_Account__r.Name,
             WT_Account__r.FinServ__SourceSystemId__c
             FROM WT_Third_Party_Data__c
             WHERE WT_Account__r.CreatedDate >= 2022-03-11T00:45:29.000+0000 
             AND WT_Account__r.CreatedDate <= 2022-03-13T00:45:29.000+0000
             AND WT_Account__r.CreatedById = :dbAmpUser
             AND WT_Account__r.RecordTypeId = :businessProspectRecordId
             AND WT_Account__r.FinServ__SourceSystemId__c = NULL]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<WT_Third_Party_Data__c> scope) 
    {
        Set<Id> setAccountIdToUpdate = new Set<Id>();
        List<Account> listAccountToDelete = new List<Account>();
        List<Account> listAccountToUpdate = new List<Account>();
        Id businessProspectRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
        Map<Id, Account> mapAccountIdAndAccount = new Map<Id, Account>();
        Set<String> setAccountName = new Set<String>();
        for(WT_Third_Party_Data__c thirdPartyData : scope)
        {
            setAccountName.add(thirdPartyData.Name);
        }
        
        if(!setAccountName.isEmpty())
        {
            for(Account relatedAccount : [SELECT Id, 
                                          Name, 
                                          CreatedDate,
                                          BillingStreet,
                                          BillingCity,
                                          BillingState,
                                          BillingPostalCode
                                          FROM Account
                                          WHERE CreatedDate >= 2022-03-12T00:45:29.000+0000
                                          AND RecordTypeId = :businessProspectRecordId
                                          AND WT_InfoUSA_Prospect_ID__c = null
                                          AND FinServ__SourceSystemId__c != null
                                          AND Name IN :setAccountName])
            {
                mapAccountIdAndAccount.put(relatedAccount.Id, relatedAccount);
            }
        }
        
        if(!mapAccountIdAndAccount.isEmpty())
        {
            for(WT_Third_Party_Data__c thirdPartyData : scope)
            {
                Map<Id, Account> mapMatchingAccountIdAndAccount = new Map<Id, Account>();
                if(String.isNotBlank(thirdPartyData.WT_Account__r.Name))
                {
                    for(Account relatedDMAccount : mapAccountIdAndAccount.values())
                    {
                        if(relatedDMAccount.Name == thirdPartyData.Name && !setAccountIdToUpdate.contains(relatedDMAccount.Id))
                        {
                            mapMatchingAccountIdAndAccount.put(relatedDMAccount.Id, relatedDMAccount);
                        }
                    }
                }
                
                if(!mapMatchingAccountIdAndAccount.isEmpty())
                {
                    Account relatedDMAccount = null;
                    if(mapMatchingAccountIdAndAccount.size() == 1)
                    {
                        relatedDMAccount = mapMatchingAccountIdAndAccount.values()[0];
                    }
                    else
                    {
                        for(Account matchingAccount : mapMatchingAccountIdAndAccount.values())
                        {
                            Boolean isAddressMatching = WT_ThirdPartyDataToAccountMatchUtility.GetAreStrings85PercentFuzzyMatch(thirdPartyData.WT_Primary_Address__c, matchingAccount.BillingStreet);
                            if(isAddressMatching)
                            {
                                relatedDMAccount = matchingAccount;
                                break;
                            }
                        }
                    }
                    
                    //Delete Account from Friday night
                    Account accountToDelete = new Account();
                    accountToDelete.Id = thirdPartyData.WT_Account__c;
                    listAccountToDelete.add(accountToDelete);
                    countRecordsToDelete++;
                    
                    //Update the 3PData
                    thirdPartyData.WT_Account__c = relatedDMAccount.Id;
                    
                    //Update the DM Prospects with InfoUSA info
                    Account accountToUpdate = new Account();
                    accountToUpdate.Id = relatedDMAccount.Id;
                    if(String.isNotBlank(thirdPartyData.WT_Employees_Single_Site__c))
                    {
                        Integer employeeCount = null;
                        try
                        {
                            employeeCount = Integer.valueOf(thirdPartyData.WT_Employees_Single_Site__c);
                        }
                        catch(Exception ex)
                        {
                            
                        }
                        
                        if(employeeCount != null)
                        {
                            accountToUpdate.WT_Employees_InfoUSA__c = employeeCount;
                        }
                    }
                    accountToUpdate.WT_InfoUSA_Prospect_ID__c = thirdPartyData.WT_INFOUSAID__c;                    
                    accountToUpdate.WT_Primary_Contact_Name_InfoUSA__c = thirdPartyData.WT_Contact_Name__c;
                    accountToUpdate.WT_Primary_Email_InfoUSA__c = thirdPartyData.WT_Email__c;
                    listAccountToUpdate.add(accountToUpdate);
                    setAccountIdToUpdate.add(accountToUpdate.Id);
                }
            }
        }
        TriggerHandler.bypass('WT_AccountBeforeHandler');
        TriggerHandler.bypass('WT_AccountAfterHandler');
        update scope;
        
        if(!listAccountToUpdate.isEmpty())
        {
            update listAccountToUpdate;
        }
        
        if(!listAccountToDelete.isEmpty())
        {
            delete listAccountToDelete;
        }
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        Messaging.SingleEmailMessage emailMessage;
        List<Messaging.SingleEmailMessage> emailMessagesList = new List<Messaging.SingleEmailMessage>();
        List<string> toAddresses = new List<string>();
        emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject('Total Prospects Deleted');
        string body = 'Total count of prospects deleted: ' + countRecordsToDelete;
        toAddresses.add('hpatel1@wintrust.com');
        emailMessage.setToAddresses(toAddresses); 
        emailMessage.setSaveAsActivity(false);
        emailMessage.setHtmlBody(body); 
        emailMessagesList.add(emailMessage);
        Messaging.sendEmail(emailMessagesList);
    }
}