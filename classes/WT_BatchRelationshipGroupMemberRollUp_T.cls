/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchRelationshipGroupMemberRollUp_T
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-08-2020
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class used for Batch class for WT_BatchRelationshipGroupMemberRollUp.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runExcuteLogic() 
*   > used to roll up all the child records.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchRelationshipGroupMemberRollUp_T 
{
    @isTest
    public Static void runExcuteLogic()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c=false;
        switchRecord.WT_Is_Trigger_Active__c=false;
        switchRecord.WT_Is_Validation_Rule_Active__c=false;
        switchRecord.WT_Is_Workflow_Rule_Active__c=false;
        switchRecord.WT_Is_Required_AAR_Load__c=false;
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
        FinServ__FinancialAccount__c financialRecord1 = new FinServ__FinancialAccount__c();
        financialRecord1.Name = 'Checking Account1';
        financialRecord1.FinServ__PrimaryOwner__c = listBusinessAccount[1].Id;
        financialRecord1.RecordTypeId = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByDeveloperName().get('CheckingAccount').getRecordTypeId();
        insert financialRecord1;
        Opportunity opportunityRecord = new Opportunity();
        opportunityRecord.Name = 'TM - Treasury Management Services';
        opportunityRecord.AccountId = listBusinessAccount[0].Id ;
        opportunityRecord.CloseDate = System.today();
        opportunityRecord.StageName = 'Stage 1 - Opportunity Identified';
        insert opportunityRecord;
        Opportunity opportunityRecord1 = new Opportunity();
        opportunityRecord1.Name = 'TM - Treasury Management Services1';
        opportunityRecord1.AccountId = listBusinessAccount[1].Id ;
        opportunityRecord1.CloseDate = System.today();
        opportunityRecord1.StageName = 'Stage 1 - Opportunity Identified';
        insert opportunityRecord1;
        Lead leadRecord = new Lead();
        leadRecord.FinServ__ReferredByUser__c = userRecord.Id;
        leadRecord.LastName = 'Referral Record3';
        leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        leadRecord.FinServ__RelatedAccount__c = listBusinessAccount[0].Id;
        insert leadRecord;
        Lead leadRecord1 = new Lead();
        leadRecord1.FinServ__ReferredByUser__c = userRecord.Id;
        leadRecord1.LastName = 'Referral Record4';
        leadRecord1.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        leadRecord1.FinServ__RelatedAccount__c = listBusinessAccount[1].Id;
        insert leadRecord1;
        Event eventRecord =new Event(Subject='Send Letter',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listBusinessAccount[0].Id);
        insert eventRecord;
        Event eventRecord1 =new Event(Subject='grade event',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listBusinessAccount[1].Id);
        insert eventRecord1;
        Task taskRecord = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listBusinessAccount[0].Id );
        insert taskRecord;
        Task taskRecord1 = new Task(subject='grade task' , Priority='Normal' , Status='Open' , WhatId=listBusinessAccount[1].Id );
        insert taskRecord1;
        WT_RelationshipGroup_Relation__c relationRecord1 = new WT_RelationshipGroup_Relation__c();
        relationRecord1.WT_Account__c = listRGAccount[0].Id;
        relationRecord1.WT_RelatedAccount__c = listBusinessAccount[0].Id;
        relationRecord1.WT_Primary__c = true;
        relationRecord1.WT_Role__c = role.Id;
        relationRecord1.WT_Active__c = true;
        insert relationRecord1;
        WT_RelationshipGroup_Relation__c relationRecord2 = new WT_RelationshipGroup_Relation__c();
        relationRecord2.WT_Account__c = listRGAccount[0].Id;
        relationRecord2.WT_RelatedAccount__c = listBusinessAccount[1].Id;
        relationRecord2.WT_Role__c = role.Id;
        relationRecord2.WT_Active__c = false;
        insert relationRecord2;
        //System.assertEquals(0, [SELECT ID FROM LEAD WHERE WT_Relationship_Group__c = :listRGAccount[0].Id].size());
        test.startTest();
        WT_BatchRelationshipGroupMemberRollUp batchRollupReferral = new 
            WT_BatchRelationshipGroupMemberRollUp('aCCount,oPPortUniTy,RefeRRal,task,ActioN PlaN,Financial aCCount,evENT');
        Database.executeBatch(batchRollupReferral);
        test.stopTest();
        //System.assertEquals(1, [SELECT ID FROM LEAD WHERE WT_Relationship_Group__c = :listRGAccount[0].Id].size());
    }
}