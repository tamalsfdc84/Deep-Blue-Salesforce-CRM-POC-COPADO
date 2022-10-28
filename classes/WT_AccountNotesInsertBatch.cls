/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_AccountNotesInsertBatch
* @Author      Vamsi Pulikallu  <VPulikal@wintrust.com>
* @ModifiedBy  Vamsi Pulikallu  <VPulikal@wintrust.com>
* @Version      v1.0
* @CreatedDate 03rd January 2021
* Modified Date 24th March 2021
* @UsedBy      Account Notes Temporary object
* --------------------------------------------------------------------------------------------------------------
* @Description
* * This batch class is created to load the Notes data into ContentNote object and will link to the account using
* the ContentDocumentLink object
* --------------------------------------------------------------------------------------------------------------
**/
global class WT_AccountNotesInsertBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,AccountId__c,WT_MSD_Record_ID__c,Subject__c,Notes_Description__c,IsInserted__c FROM Account_Notes_Temporary__c WHERE IsInserted__c = false AND AccountId__c != NULL';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account_Notes_Temporary__c> scope)
    {
        for(Account_Notes_Temporary__c accountNotesTemporary : scope)
        {   
            ContentNote note = new ContentNote();
            if(String.isNotBlank(accountNotesTemporary.Notes_Description__c))
            {
                if(String.isNotBlank(accountNotesTemporary.Subject__c))
                {                    
                    if(accountNotesTemporary.Subject__c.length() > 255)
                    {
                        note.Title = accountNotesTemporary.Subject__c.substring(0,255);
                    }
                    else 
                    {
                        note.Title = accountNotesTemporary.Subject__c;
                    }
                }
                else 
                {
                    if(accountNotesTemporary.Notes_Description__c.length() > 255)
                    {
                        note.Title = accountNotesTemporary.Notes_Description__c.substring(0,255);
                    }
                    else 
                    {
                        note.Title = accountNotesTemporary.Notes_Description__c;
                    }
                }
                note.Content = Blob.valueOf(accountNotesTemporary.Notes_Description__c);
                /*if(accountNotesTemporary.Notes_Description__c.length() > 50)
{
note.Title = accountNotesTemporary.Notes_Description__c.substring(0,50);
}
else 
{
note.Title = accountNotesTemporary.Notes_Description__c;
}*/
                try
                {
                    insert note;
                }
                catch(Exception e)
                {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
            else
            {
                if(String.isNotBlank(accountNotesTemporary.Subject__c))
                {                    
                    if(accountNotesTemporary.Subject__c.length() > 255)
                    {
                        note.Title = accountNotesTemporary.Subject__c.substring(0,255);
                    }
                    else 
                    {
                        note.Title = accountNotesTemporary.Subject__c;
                    }
                    note.Content = Blob.valueOf(accountNotesTemporary.Subject__c);
                    try
                    {
                        insert note;
                    }
                    catch(Exception e)
                    {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                }
            }
            
            if(note.Id != null)
            {
                ContentDocumentLink contentLink = new ContentDocumentLink();
                contentLink.ContentDocumentId = note.Id;
                contentLink.LinkedEntityId = accountNotesTemporary.AccountId__c;
                contentLink.ShareType = 'V';
                try
                {
                    insert contentLink;
                }
                catch(Exception e)
                {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                if(contentLink.Id != null)
                {
                    accountNotesTemporary.isInserted__c = true;
                    try
                    {
                        update accountNotesTemporary;
                    }
                    catch(Exception e)
                    {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
    }
}