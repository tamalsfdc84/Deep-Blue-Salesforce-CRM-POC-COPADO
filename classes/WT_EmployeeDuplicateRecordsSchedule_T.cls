@isTest
public class WT_EmployeeDuplicateRecordsSchedule_T 
{
	@isTest
    static void TestScheduleClass()
    {   
        Id ruleId = [SELECT Id, DeveloperName FROM DuplicateRule WHERE DeveloperName = 'WT_Merge_Employee_Duplicate'].Id;
        
        WT_Employee__c employee1 = New WT_Employee__c(WT_First_Name__c = 'FirstName1', WT_Last_Name__c = 'LastName1');
        insert employee1;
        WT_Employee__c employee2 = New WT_Employee__c(WT_First_Name__c = 'FirstName2', WT_Last_Name__c = 'LastName2');
        insert employee2;
        
        DuplicateRecordSet recordSet = New DuplicateRecordSet(DuplicateRuleId = ruleId);
        insert recordSet;
        
        DuplicateRecordItem recordItem1 = New DuplicateRecordItem(DuplicateRecordSetId = recordSet.Id, RecordId = employee1.Id);
        insert recordItem1;
        
        DuplicateRecordItem recordItem2 = New DuplicateRecordItem(DuplicateRecordSetId = recordSet.Id, RecordId = employee2.Id);
        insert recordItem2;
        
        Date createdDate = [SELECT EndDate FROM Period WHERE type = 'Quarter' and StartDate = LAST_QUARTER].EndDate;
        Test.setCreatedDate(recordSet.Id, createdDate);
        
        Test.startTest();
        WT_EmployeeDuplicateRecordsSchedule apySchedule = New WT_EmployeeDuplicateRecordsSchedule();
        String cronSchedule = '0 0 23 * * ?';        
        System.schedule('Test Schedule', cronSchedule, apySchedule);
        Test.stopTest();
    }
}