/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_LeadBeforeHandler_T
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @version 		v1.0 
* @CreatedDate		20-11-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_LeadBeforeHandler 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  executeHandler()
*  used to run the Trigger class for the WT_LeadBeforeHandler , generally for code coverage.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_LeadBeforeHandler_T 
{
    static testMethod void executeHandler() 
    {
        List<Lead> recordList = new List<Lead>();
        Lead leadRecord1 = new Lead();
        leadRecord1.LastName = 'Referral Record1';
        leadRecord1.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Standard').getRecordTypeId();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                             EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                             WT_Business_Unit_Entity__c='118-1');
        insert user ;
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118',
                                                                                       WT_Branch__c = '1');
        insert businessUnitRecord;
        
        Lead leadRecord2 = new Lead();
        leadRecord2.FinServ__ReferredByUser__c = user.Id;
        leadRecord2.LastName = 'Referral Record2';
        leadRecord2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        
        Lead leadRecord3 = new Lead();
        leadRecord3.FinServ__ReferredByUser__c = user.Id;
        leadRecord3.LastName = 'Referral Record3';
        leadRecord3.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        leadRecord3.WT_Referral_Business_Unit__c = businessUnitRecord.id;
        
        recordList.add(leadRecord1);
        recordList.add(leadRecord2);
        recordList.add(leadRecord3);
        Test.startTest();
        
        insert recordList;
        
        Test.stopTest();
    }
    
    static testMethod void populatePhoneEmailMapTest() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118', WT_Branch__c = '1');
        insert businessUnitRecord;
        
        List<Account> listPersonAccount = WT_DataFactory.createAccounts(1, 'PersonAccount_Customer', userRecord1.Id);
        listPersonAccount[0].PersonEmail = 'abc@gmail.com';
        listPersonAccount[0].PersonHomePhone = '1112223333';
        insert listPersonAccount;
        
        List<Lead> listLead = WT_DataFactory.createLead(1, userRecord1.Id, userRecord2.Id, userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listPersonAccount[0].Id;
        insert listLead;
        
        Lead insertedLead = [SELECT Id,
                             Phone,
                             WT_Account_Referred_Email__c
                             FROM Lead
                             WHERE Id = :listLead[0].Id];
        
        System.assertEquals('abc@gmail.com', insertedLead.WT_Account_Referred_Email__c, 'Emails Match');
        System.assertEquals('1112223333', insertedLead.Phone, 'Phones Match');
    }
    
    static testMethod void mapBusinessAccountToReferalTest() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118', WT_Branch__c = '1');
        insert businessUnitRecord;
        
        List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(1,'BusinessAccount_Customer',userRecord1.Id);
        listBusinessAccount[0].WT_Primary_Email_DNB__c = 'abc2@gmail.com';
        listBusinessAccount[0].Phone = '2223334444';
        insert listBusinessAccount;
        
        List<Lead> listLead = WT_DataFactory.createLead(1,userRecord1.Id,userRecord2.Id,userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listBusinessAccount[0].Id;
        insert listLead;
        
        Lead insertedLead = [SELECT Id,
                             Phone,
                             WT_Account_Referred_Email__c
                             FROM Lead
                             WHERE Id = :listLead[0].Id];
        
        System.assertEquals('abc2@gmail.com', insertedLead.WT_Account_Referred_Email__c, 'Emails Match');
        System.assertEquals('2223334444', insertedLead.Phone, 'Phones Match');
    }
    
    static testMethod void populateRelationshipgroupIdTest()
    {
        List<Lead> listLead = new List<Lead>();
        List<WT_RelationshipGroup_Relation__c> listRelationshipGroup = new List<WT_RelationshipGroup_Relation__c>();
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                             EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = userProfile.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                             WT_Business_Unit_Entity__c='118-1');
        insert user ;
        List<account> listAccount = new List<account>();
        account accountRecord = new account();
        accountRecord.FirstName = 'First Name';
        accountRecord.LastName = 'Last Name';
        accountRecord.BillingStreet = 'Test';
        accountRecord.BillingState = 'OH';
        accountRecord.BillingCity = 'Chicago';
        accountRecord.BillingCountry = 'United States';
        accountRecord.BillingPostalCode = '12345';
        accountRecord.PersonHomePhone = '1122334455';
        accountRecord.ownerid = user.id ;
        accountRecord.PersonEmail = 'abc@gmail.com'; 
        accountRecord.WT_Primary_Email_DNB__c = 'abc@gmail.com';
        accountRecord.type = 'customer';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        insert accountRecord;
        
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.name = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        
        WT_RelationshipGroup_Relation__c relationshipGroup = new  WT_RelationshipGroup_Relation__c();
        relationshipGroup.WT_RelatedAccount__c = accountRecord.id;
        relationshipGroup.WT_Account__c = accountRecord1.id;
        relationshipGroup.WT_Active__c = true;
        listRelationshipGroup.add(relationshipGroup);
        insert listRelationshipGroup;
        
        Contact contactRecord=new Contact();
        contactRecord.FirstName='fname';
        contactRecord.LastName = 'lname';
        contactRecord.Email = 'email@gmail.com';
        contactRecord.Phone = '9743800309';
        contactRecord.AccountID = accountRecord1.id;
        insert contactRecord; 
        
        Lead leadRecord = new Lead();
        leadRecord.LastName = 'Referral Record1';
        leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Standard').getRecordTypeId();
        leadRecord.FinServ__RelatedAccount__c = accountRecord.id;
        leadRecord.WT_Referred_To__c = user.id;
        listLead.add(leadRecord);
        Test.startTest();
        WT_LeadBeforeHandler leadhandler = new WT_LeadBeforeHandler();
        leadhandler.populateRelationshiproupId(listLead);
        leadhandler.populateOwnerID(listLead);
        leadhandler.populateContactID(listLead);
        Test.stopTest();   
    }    

   static testMethod void populateLead()
    {
        List<Lead> listLead2 = new List<Lead>();
        List<WT_RelationshipGroup_Relation__c> listRelationshipGroup = new List<WT_RelationshipGroup_Relation__c>();
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                             EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = userProfile.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                             WT_Business_Unit_Entity__c='118-1');
        insert user ;
        List<account> listAccount1 = new List<account>();
        account accountRecord1 = new account();
        accountRecord1.FirstName = 'First Name';
        accountRecord1.LastName = 'Last Name';
        accountRecord1.BillingStreet = 'Test';
        accountRecord1.BillingState = 'OH';
        accountRecord1.BillingCity = 'Chicago';
        accountRecord1.BillingCountry = 'United States';
        accountRecord1.BillingPostalCode = '12345';
        accountRecord1.PersonHomePhone = '1122334455';
        accountRecord1.ownerid = user.id ;
        accountRecord1.PersonEmail = 'abc@gmail.com'; 
        accountRecord1.WT_Primary_Email_DNB__c = 'abc@gmail.com';
        accountRecord1.type = 'customer';
        accountRecord1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        insert accountRecord1;
  
        Lead leadRecord2 = new Lead();
        leadRecord2.LastName = 'Referral Record2';
        leadRecord2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Standard').getRecordTypeId();
        leadRecord2.FinServ__RelatedAccount__c = accountRecord1.id;
        leadRecord2.WT_Referred_To__c = user.id;
        leadRecord2.FinServ__ReferredByUser__c = user.id;      
        listLead2.add(leadRecord2); 
        insert listLead2;         
    }  
}