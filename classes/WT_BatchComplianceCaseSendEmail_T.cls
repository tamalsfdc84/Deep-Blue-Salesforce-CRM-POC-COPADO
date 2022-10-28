/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchComplianceCaseSendEmail_T
* @Author			Vamsi Pulikallu	<vpulikal@wintrust.com>	
* @version 			v1.0 
* @CreatedDate		21 Jan 2021
* @ModifiedDate		09 Feb 2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchComplianceCaseSendEmail 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_BatchComplianceCaseSendEmail_T 
{
	@isTest
    public static void setUpData()
    {
        test.startTest();
        List<Case> listCase = new List<Case>();
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_Compliance_Complaint').getRecordTypeId();
        Case caseRecord = new Case(Status='In Progress', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()-10,WT_Case_Title__c ='test',Description = 'test',WT_Respond_By__c=Date.Today()-10);
        Case caseRecord1 = new Case(Status='In Progress', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()-11,WT_Case_Title__c ='test1',Description = 'test1',WT_Respond_By__c=Date.Today()-11);
        Case caseRecord2 = new Case(Status='In Progress', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()-8,WT_Case_Title__c ='test2',Description = 'test2',WT_Respond_By__c=Date.Today()-8);
        Case caseRecord3 = new Case(Status='In Progress', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()-9,WT_Case_Title__c ='test3',Description = 'test3',WT_Respond_By__c=Date.Today()-9);
        Case caseRecord4 = new Case(Status='In Progress', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()+2,WT_Case_Title__c ='test3',Description = 'test3',WT_Respond_By__c=Date.Today()+2);
        
        listCase.add(caseRecord);
        listCase.add(caseRecord1);
        listCase.add(caseRecord2);
        listCase.add(caseRecord3);
        listCase.add(caseRecord4);
        insert listCase;
        Database.executeBatch(new WT_BatchComplianceCaseSendEmail());
        System.assertEquals(5, [select count() from Case Where recordTypeId = :RecordTypeIdCase AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void schedulerTest()
    {
        String cronexpression = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchComplianceCaseSendEmailSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}