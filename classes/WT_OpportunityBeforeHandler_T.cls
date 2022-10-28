@isTest
public class WT_OpportunityBeforeHandler_T
{
    @isTest static void OpportunityBeforeHandler_Test()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
        insert switchRecord;
        User userRecord = WT_DataFactory.createUser('System Administrator');
        userRecord.WT_Line_of_Business__c = 'Treasury Management';
        insert userRecord;
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.lastname = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        
        Opportunity testOpportunity1 = new Opportunity();
        testOpportunity1.AccountId = accountRecord1.Id;
        testOpportunity1.Name = 'Test Opportunity 1';
        testOpportunity1.StageName = 'Stage 1 - Opportunity Identified';
        testOpportunity1.CloseDate = system.today().addDays(5);
        insert testOpportunity1;
    }
}