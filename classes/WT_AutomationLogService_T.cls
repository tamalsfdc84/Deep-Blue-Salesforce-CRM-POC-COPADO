@isTest
public class WT_AutomationLogService_T 
{
	@isTest
    static void TestLogging()
    {
        WT_AutomationLogService.Log('WT_AutomationLogService_T', 'TestLogging', 'N/A', 'N/A', 'Test', false, 'Test');
        System.assertEquals(1, WT_AutomationLogService.listAutomationLogToInsert.size());
    }
    
    @isTest
    static void TestCommit()
    {
        WT_AutomationLogService.Log('WT_AutomationLogService_T', 'TestLogging', 'N/A', 'N/A', 'Test', false, 'Test');
        WT_AutomationLogService.CommitLogs();
        
        List<WT_Automation_Log__c> listLog = [SELECT Id
                                              FROM WT_Automation_Log__c];
        
        System.assertEquals(1, listLog.size());
    }
}