@isTest
Public class WT_UpdateReferralStatusTest{
    Private static testMethod void unitTest1(){
        Lead ld = new Lead();
        ld.FirstName = 'Test FirstName';
        ld.LastName= 'Test LastName';
        ld.Company = 'Test Company';
        ld.WT_Date_Referred__c = system.today().addDays(20);
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        ld.RecordTypeId = leadRecordTypeId ;
        ld.Status = 'New - Not Contacted';
        Insert ld;
        WT_ScheduleUpdateReferralStatus sh1 = new WT_ScheduleUpdateReferralStatus();
        String sch = '0 0 23 * * ?'; 
        System.schedule('ReferralUpdate Job', sch, sh1); 
    }
    
    Private static testMethod void unitTest2(){
        Lead ld = new Lead();
        ld.FirstName = 'Test FirstName';
        ld.LastName= 'Test LastName';
        ld.Company = 'Test Company';
        ld.WT_Date_Referred__c = system.today().addDays(20);
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        ld.RecordTypeId = leadRecordTypeId ;
        ld.Status = 'New - Not Contacted';
        Insert ld;
        Database.ExecuteBatch(New WT_UpdateReferralStatus());
    }
}