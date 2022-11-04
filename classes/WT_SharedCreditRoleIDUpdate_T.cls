@isTest
public class WT_SharedCreditRoleIDUpdate_T {

    @testSetup
    static void setup() {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=false,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
        insert switchRecord;
        User userRecord = WT_DataFactory.createUser('WT Retail');
        userRecord.WT_Line_of_Business__c = 'Treasury Management';
        insert userRecord;
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.name = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        listOpportunity.add(opportunityRecord1);
        insert listOpportunity;
        OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember(OpportunityAccessLevel = 'Read',UserId = userRecord.Id, TeamMemberRole = 'Share Credit', OpportunityId = listOpportunity[0].id);
        insert opportunityTeamMember1;
        
    }
    @isTest static void test() {
        List<String> listEmail = new List<String>();
		listEmail.add('testtesttest@wintrust.com');
        
        Test.startTest();
        Id batchId = Database.executeBatch(new WT_SharedCreditRoleIDUpdate(listEmail));
        Test.stopTest();
    }
}