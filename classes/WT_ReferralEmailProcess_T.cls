/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_LeadAfterRequiredHander_T
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    05/03/2022
  @Description    This test class is for WT_LeadAfterRequiredHander
* -----------------------------------------------------------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/
@isTest
public class WT_ReferralEmailProcess_T {
   @isTest
    static void TestEmailToLoanOfficerAndLoadAssistant()
    {
        WT_DataFactory.createRequiredCustomSetting();
        List<User> listUsers = new List<User>();
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        userRecord1.FirstName = 'Test 123User'; 
        userRecord1.WT_Referrals_Type__c = 'Retail Banking';
        userRecord1.Email = 'test@123.com';
        listUsers.add(userRecord1);
        User userRecord2 = WT_DataFactory.createUser('System Administrator');        
        userRecord2.FirstName = 'Test 124User';
        userRecord2.Email = 'test@123.com';
        userRecord2.WT_Referrals_Type__c = 'Retail Banking';
        listUsers.add(userRecord2);
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        userRecord3.WT_Referrals_Type__c = 'Retail Banking';
        userRecord3.FirstName = 'Test 125User';
        userRecord3.Email = 'test@123.com';
        listUsers.add(userRecord3);
        User userRecord4 = WT_DataFactory.createUser('System Administrator');
        userRecord4.WT_Referrals_Type__c = 'Retail Banking';
        userRecord4.FirstName = 'Test 126User'; 
        userRecord4.Email = 'test@123.com';
        listUsers.add(userRecord4);
        insert listUsers;   
        Id user1Id =userRecord1.Id;
        Id user2Id = userRecord2.Id;
        Id user3Id =userRecord3.Id;
        Id user4Id = userRecord4.Id;
        List<WT_Assistant_Lookup__c> listLOA = new List<WT_Assistant_Lookup__c>();
        WT_Assistant_Lookup__c loa1 = new WT_Assistant_Lookup__c();
        loa1.WT_Assisting_User__c = user4Id;
        loa1.WT_User_To_Assist__c = user2Id;
        loa1.WT_Assisting_Workstream__c = 'Referral';
        loa1.Name = 'Test123';
        listLOA.add(loa1);
        insert listLOA;
        List<Id> ListLeadId = new List<Id>();
        Lead leadRecord1 = new Lead();
        leadRecord1.LastName = 'Test Job1';
        leadRecord1.OwnerId = user1Id;
        leadRecord1.WT_Referred_To__c = user2Id;
        leadRecord1.FinServ__ReferredByUser__c = user3Id;
        leadRecord1.FinServ__ExpressedInterest__c = 'Retail Banking';
        leadRecord1.CreatedDate = system.Today();
        insert leadRecord1;
        ListLeadId.add(leadRecord1.Id);
        Test.StartTest();
        WT_ReferralEmailProcess.SendEmailOnReferralCreation(ListLeadId);
        Test.stopTest(); 
    }
}