/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_OpportunityAfterHandler_T
* @Author			Vamsi Pulikallu	<vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		23-02-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_OpportunityAfterHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_OpportunityAfterHandler_T 
{
    @isTest
    public static void setUpData()
    {
        test.startTest();
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
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
        OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember(OpportunityAccessLevel = 'Read',UserId = userRecord.Id, TeamMemberRole = 'Product Partner', OpportunityId = listOpportunity[0].id);
        //insert opportunityTeamMember1;
        System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void setUpData2()
    {
        test.startTest();
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
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
        Product2 productA= new Product2
        (
            Name= 'Credit Card - Business',
            Family= 'TM',
            IsActive= True
        );
        insert productA;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', WT_Product__c = productA.id, WT_Fee__c = 10000,RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        opportunityRecord1.OwnerId = userRecord.Id;
        listOpportunity.add(opportunityRecord1);
        insert listOpportunity;
         List<WT_Opportunity_Stage_Tracking__c> listOpportunityStageTracking = new List<WT_Opportunity_Stage_Tracking__c>();
         WT_Opportunity_Stage_Tracking__c timeTrackingRecord  = new WT_Opportunity_Stage_Tracking__c();
         timeTrackingRecord.WT_Date_Started__c = System.now();
         timeTrackingRecord.WT_Previous_Stage__c = 'Stage 1 - Opportunity Identified';
         timeTrackingRecord.WT_New_Stage__c   = 'Stage 3 - Deal Structured/Presented';
         timeTrackingRecord.Name = 'Test';
         timeTrackingRecord.WT_Opportunity__c = opportunityRecord1.Id;
         listOpportunityStageTracking.add(timeTrackingRecord);      
         System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
         test.stopTest();
    }
    
    @isTest
    public static void setUpData1()
    {
        test.startTest();
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
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
        Product2 productA= new Product2
        (
            Name= 'Credit Card - Business',
            Family= 'TM',
            IsActive= True
        );
        insert productA;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', WT_Product__c = productA.id, WT_Fee__c = 10000,RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        listOpportunity.add(opportunityRecord1);
        insert listOpportunity;
        OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember(OpportunityAccessLevel = 'Read',UserId = userRecord.Id, TeamMemberRole = 'Product Partner', OpportunityId = listOpportunity[0].id);
        //insert opportunityTeamMember1;
        System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
        test.stopTest();
    }
    
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
    
    @isTest
    public static void timeTrackingTest()
    {
        test.startTest();
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
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
        Product2 productA= new Product2
        (
            Name= 'Credit Card - Business',
            Family= 'TM',
            IsActive= True
        );
        insert productA;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', WT_Product__c = productA.id, WT_Fee__c = 10000,RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        opportunityRecord1.OwnerId = userRecord.Id;
        listOpportunity.add(opportunityRecord1);
        insert listOpportunity;
        
         List<WT_Opportunity_Stage_Tracking__c> listOpportunityStageTracking = new List<WT_Opportunity_Stage_Tracking__c>();
         WT_Opportunity_Stage_Tracking__c timeTrackingRecord  = new WT_Opportunity_Stage_Tracking__c();
         timeTrackingRecord.WT_Date_Started__c = System.now();
         timeTrackingRecord.WT_Previous_Stage__c = 'Stage 1 - Opportunity Identified';
         timeTrackingRecord.WT_New_Stage__c= 'Stage 3 - Deal Structured/Presented';
         timeTrackingRecord.Name = 'Test';
         timeTrackingRecord.WT_Opportunity__c = opportunityRecord1.Id;
         listOpportunityStageTracking.add(timeTrackingRecord);      
         System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
         opportunityRecord1.StageName = 'Closed Lost';
         update opportunityRecord1;
         test.stopTest();
    }
}