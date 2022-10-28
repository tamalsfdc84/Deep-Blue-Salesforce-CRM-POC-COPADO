/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountNotesInsertBatch_T
* @Author			Vamsi Pulikallu  <VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu  <VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		04th January 2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for WT_AccountNotesInsertBatch.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* runCreateNotes() 
* 	> used to test the creation of Notes.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_AccountNotesInsertBatch_T 
{
    @isTest
    public static void runCreateNotes()
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);
        insert listCustomerAccount;
        list<Account_Notes_Temporary__c> listAccountNotesTemporary = new list<Account_Notes_Temporary__c>();
        Account_Notes_Temporary__c accountNotesTemporary1 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456',
                                                                                           Notes_Description__c = 'test notes',
                                                                                           Subject__c ='test');
        listAccountNotesTemporary.add(accountNotesTemporary1);
        Account_Notes_Temporary__c accountNotesTemporary2 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456',
                                                                                           Notes_Description__c = 'test notes to make sure that the character limit is more than 50'
                                                                                          );
        listAccountNotesTemporary.add(accountNotesTemporary2);
        Account_Notes_Temporary__c accountNotesTemporary3 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456',
                                                                                           Subject__c = 'test notes to make sure that the character limit is more than 50'
                                                                                          );
        listAccountNotesTemporary.add(accountNotesTemporary3);
        string char256 = 'You can convert old Note records to Lightning Experience, so users can view and edit notes from the Notes & Attachments related list in Lightning Experience. Users can edit their converted notes, which are accessible from the Notes related list and Notes tab.';
        Account_Notes_Temporary__c accountNotesTemporary4 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456',
                                                                                           Subject__c = char256,
                                                                                           Notes_Description__c = char256
                                                                                          );
        listAccountNotesTemporary.add(accountNotesTemporary4);
        Account_Notes_Temporary__c accountNotesTemporary5 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456',
                                                                                           Subject__c = char256
                                                                                          );
        listAccountNotesTemporary.add(accountNotesTemporary5);
        Account_Notes_Temporary__c accountNotesTemporary6 = new Account_Notes_Temporary__c(IsInserted__c = false,
                                                                                           AccountId__c = listCustomerAccount[0].Id,
                                                                                           WT_MSD_Record_ID__c = '123456'
                                                                                          );
        listAccountNotesTemporary.add(accountNotesTemporary6);
        insert listAccountNotesTemporary;
        Database.executeBatch(new WT_AccountNotesInsertBatch());
        system.assertEquals(0, [Select count() from Account_Notes_Temporary__c where IsInserted__c = true]);
    }
}