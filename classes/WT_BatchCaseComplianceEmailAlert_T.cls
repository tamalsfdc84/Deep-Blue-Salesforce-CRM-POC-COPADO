@isTest
public class WT_BatchCaseComplianceEmailAlert_T 
{
    @isTest
    public static void setUpData()
    {
        test.startTest();
        List<Case> listCase = new List<Case>();
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_Compliance_Complaint').getRecordTypeId();
        Case caseRecord = new Case(Status='Awaiting Approval', RecordTypeId=RecordTypeIdCase, WT_Date_Received__c=Date.Today()-10,WT_Case_Title__c ='test',Description = 'test',WT_Respond_By__c=Date.Today()-10);
        insert caseRecord; 
        Database.executeBatch(new WT_BatchCaseComplianceEmailAlert());
        System.assertEquals(1, [select count() from Case Where recordTypeId = :RecordTypeIdCase AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void schedulerTest()
    {
        String cronexpression = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchCaseComplianceEmailAlertSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}