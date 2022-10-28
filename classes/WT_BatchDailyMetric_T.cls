/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_BatchDailyMetric_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	06-21-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_BatchDailyMetric
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  TestMetricBatch()
* 	> Tests the batch class logic for WT_BankDailyMetric.  

*  TestScheduleClass()
* 	> Tests the schduler class WT_BatchDailyMetricSchedule.  
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchDailyMetric_T 
{
    @testSetup
    static void Setup()
    {        
        WT_Daily_Metric__c newMetric = new WT_Daily_Metric__c();
        newMetric.WT_Report_Date__c = System.today();
        newMetric.WT_Number_of_Action_Plans_Yesterday__c = 0;
        newMetric.WT_Number_of_Calls_Logged_Yesterday__c = 0;
        newMetric.WT_Number_of_Calls_Scheduled_Yesterday__c = 0;
        newMetric.WT_Number_of_New_Logins_Yesterday__c = 0;
        newMetric.WT_Number_of_Unique_Login_Yesterday__c = 0;
        newMetric.WT_Number_of_Walk_Ins_Yesterday__c = 0;
        newMetric.WT_Referrals_Converted_By_Mortgage_YDA__c = 0;
        newMetric.WT_Referrals_Converted_By_Retail_YDA__c = 0;        
        insert newMetric;
        
        Account newPersonAccount = WT_TestSetupHelper.GetAccount('Person Account (Prospect)');
        insert newPersonAccount;
        
        List<Lead> listReferralToAdd = new List<Lead>();
        
        User adminUser = [SELECT Id
                          FROM User
                          WHERE Profile.Name = 'System Administrator'
                          ORDER BY CreatedDate DESC
                          LIMIT 1];
        
        User retailUser = [SELECT Id
                           FROM User
                           WHERE Profile.Name = 'WT Retail'
                           AND IsActive = true
                           LIMIT 1];
        
        System.runAs(retailUser)
        {
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'New - Not Contacted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Not Converted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Converted', adminUser.Id));
        }
        
        User mortgageUser = [SELECT Id
                             FROM User
                             WHERE Profile.Name = 'WT Mortgage'
                             AND IsActive = true
                             LIMIT 1];
        
        System.runAs(mortgageUser)
        {
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'New - Not Contacted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Not Converted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Converted', adminUser.Id));
        }
        
        User wealthUser = [SELECT Id
                           FROM User
                           WHERE Profile.Name = 'WT Wealth'
                           AND IsActive = true
                           LIMIT 1];
        
        System.runAs(wealthUser)
        {
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'New - Not Contacted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Not Converted', adminUser.Id));
            listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Converted', adminUser.Id));
        }
        
        insert listReferralToAdd;
    }
    
    @isTest
    static void TestMetricBatch()
    {
        Test.startTest();
        WT_BatchDailyMetric batchDailyMetric = new WT_BatchDailyMetric();
        Database.executeBatch(batchDailyMetric);
        
        WT_Daily_Metric__c newMetric = [SELECT Id, WT_Date_Processed__c
                                        FROM WT_Daily_Metric__c
                                        LIMIT 1];
        
        Test.stopTest();
    }
    
    
    @isTest
    static void TestScheduleClass()
    {
        Test.startTest();
        WT_BatchDailyMetricSchedule dailyMetricSchedule = new WT_BatchDailyMetricSchedule();
        String cronSchedule = '0 0 23 * * ?';        
        System.schedule('Test Schedule', cronSchedule, dailyMetricSchedule);
        Test.stopTest();
    }
}