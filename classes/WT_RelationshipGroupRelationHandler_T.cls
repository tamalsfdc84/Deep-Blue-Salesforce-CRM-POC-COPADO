/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupRelationHandler_T
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-08-2020
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_RelationshipGroupRelationHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runBeforeTriggerLogic() 
*   > used to validate multiple primary member exist or not.
* 2- runAfterTriggerLogic() 
*   > used to roll up all the child records.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_RelationshipGroupRelationHandler_T 
{
    @isTest
    public Static void runBeforeTriggerLogic()
    {
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List<Account> listRGAccount = WT_DataFactory.createNonPersonAccounts(2,'Relationship_Group',userRecord.Id);
        List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(2,'BusinessAccount_Prospect',userRecord.Id);
        listBusinessAccount[0].WT_First_Date_Of_Contact__c = System.today();
        listBusinessAccount[0].WT_Last_Date_Of_Contact__c = System.today();
        listBusinessAccount[1].WT_First_Date_Of_Contact__c = System.today();
        listBusinessAccount[1].WT_Last_Date_Of_Contact__c = System.today();
        insert listBusinessAccount;
        insert listRGAccount;
        Id accountRecordId = Schema.SObjectType.FinServ__ReciprocalRole__c.getRecordTypeInfosByDeveloperName().get('AccountRole').getRecordTypeId();
        FinServ__ReciprocalRole__c role = new FinServ__ReciprocalRole__c();
        role.FinServ__CreateInverseRole__c  = false;
        role.FinServ__InverseRole__c = 'Client';
        role.Name = 'Client';
        role.RecordTypeId = accountRecordId;
        insert role;
        test.startTest();
        WT_RelationshipGroup_Relation__c relationRecord1 = new WT_RelationshipGroup_Relation__c();
        relationRecord1.WT_Account__c = listRGAccount[0].Id;
        relationRecord1.WT_RelatedAccount__c = listBusinessAccount[0].Id;
        relationRecord1.WT_Primary__c = true;
        relationRecord1.WT_Role__c = role.Id;
        insert relationRecord1;
        WT_RelationshipGroup_Relation__c relationRecord2 = new WT_RelationshipGroup_Relation__c();
        relationRecord2.WT_Account__c = listRGAccount[0].Id;
        relationRecord2.WT_RelatedAccount__c = listBusinessAccount[1].Id;
        relationRecord2.WT_Role__c = role.Id;
        insert relationRecord2;
        relationRecord2.WT_Primary__c = true;
        try
        {
            update relationRecord2;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  (e.getMessage().contains('primary relationship group member')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        relationRecord1.WT_Primary__c = false;
        update relationRecord1;
        delete relationRecord2;
        test.stopTest();
    }
    @isTest
    public Static void runAfterTriggerLogic()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c=false;
        switchRecord.WT_Is_Trigger_Active__c=false;
        switchRecord.WT_Is_Validation_Rule_Active__c=false;
        switchRecord.WT_Is_Workflow_Rule_Active__c=false;
        switchRecord.WT_Is_Required_AAR_Load__c=true;
        Database.insert(switchRecord,false);
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List<Account> listRGAccount = WT_DataFactory.createNonPersonAccounts(2,'Relationship_Group',userRecord.Id);
        List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(2,'BusinessAccount_Prospect',userRecord.Id);
        insert listBusinessAccount;
        insert listRGAccount;
        Id accountRecordId = Schema.SObjectType.FinServ__ReciprocalRole__c.getRecordTypeInfosByDeveloperName().get('AccountRole').getRecordTypeId();
        FinServ__ReciprocalRole__c role = new FinServ__ReciprocalRole__c();
        role.FinServ__CreateInverseRole__c  = false;
        role.FinServ__InverseRole__c = 'Client';
        role.Name = 'Client';
        role.RecordTypeId = accountRecordId;
        insert role;
        FinServ__FinancialAccount__c financialRecord = new FinServ__FinancialAccount__c();
        financialRecord.Name = 'Checking Account';
        financialRecord.FinServ__PrimaryOwner__c = listBusinessAccount[0].Id;
        financialRecord.RecordTypeId = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByDeveloperName().get('CheckingAccount').getRecordTypeId();
        insert financialRecord;
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Name = 'TM - Treasury Management Services';
        opportunityRecord.AccountId = listBusinessAccount[0].Id ;
        opportunityRecord.CloseDate = System.today();
        opportunityRecord.StageName = 'Stage 1 - Opportunity Identified';
        insert opportunityRecord;
        Lead leadRecord = new Lead();
        leadRecord.FinServ__ReferredByUser__c = userRecord.Id;
        leadRecord.LastName = 'Referral Record3';
        leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        leadRecord.FinServ__RelatedAccount__c = listBusinessAccount[0].Id;
        insert leadRecord;
        Event eventRecord =new Event(Subject='Send Letter',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listBusinessAccount[0].Id);
        insert eventRecord;
        Task taskRecord = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listBusinessAccount[0].Id );
        insert taskRecord;
        test.startTest();
        WT_RelationshipGroup_Relation__c relationRecord1 = new WT_RelationshipGroup_Relation__c();
        relationRecord1.WT_Account__c = listRGAccount[0].Id;
        relationRecord1.WT_RelatedAccount__c = listBusinessAccount[0].Id;
        relationRecord1.WT_Primary__c = true;
        relationRecord1.WT_Role__c = role.Id;
        insert relationRecord1;
        relationRecord1.WT_Primary__c = false;
        update relationRecord1;
        WT_RelationshipGroup_Relation__c relationRecord2 = new WT_RelationshipGroup_Relation__c();
        relationRecord2.WT_Account__c = listRGAccount[0].Id;
        relationRecord2.WT_RelatedAccount__c = listBusinessAccount[1].Id;
        relationRecord2.WT_Role__c = role.Id;
        insert relationRecord2;
        relationRecord1.WT_Active__c = false;
        update relationRecord1;
        delete relationRecord1;
        test.stopTest();
    }
}