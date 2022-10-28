/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_BatchWeeklyMetric_T
* @Author		Anitha jaini
* @version 		v1.0 
* @CreatedDate	07-29-2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_BatchWeeklyMetric
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  TestMetricBatch()
* 	> Tests the batch class logic for WT_BatchWeeklyMetric.  

*  TestScheduleClass()
* 	> Tests the schduler class WT_BatchWeeklyMetricSchedule.  
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchWeeklyMetric_T 
{
    @testSetup
    static void Setup()
    {        
        WT_Weekly_Metric__c newMetric = new WT_Weekly_Metric__c();        
        newMetric.WT_Active_Users__c = 0;
        newMetric.WT_Active_Users_Since_Last_Run__c = 0;
        newMetric.WT_Active_Users_With_SF_License__c = 0;
        newMetric.WT_Active_Users_With_SF_License_Last_Run__c = 0;
        newMetric.WT_Users_Logged_In__c = 0;
        newMetric.WT_Users_Logged_In_Since_Last_Run__c = 0;
        newMetric.WT_Newly_Created_Users_logged_In__c = 0;
        newMetric.WT_Accounts_Created__c = 0;  
        newMetric.WT_Accounts_Created_Last_Run__c = 0;
        newMetric.WT_Business_Account_Customer__c = 0;
        newMetric.WT_Bus_Acc_Cust_Created_Last_Run__c = 0;
        newMetric.WT_Business_Account_Prospect__c = 0; 
        insert newMetric;
        
        Account newPersonAccount = WT_TestSetupHelper.GetAccount('Person Account (Prospect)');
        insert newPersonAccount;   
        User currentUser = [SELECT Id
                            FROM User 
                            WHERE WT_Line_of_Business__c!=null
                            Order By CreatedDate DESC
                            LIMIT 1];
        
        List<Lead> listReferralToAdd = new List<Lead>();        
        
        listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Not Converted', currentUser.Id));
        listReferralToAdd.add(WT_TestSetupHelper.GetReferral(newPersonAccount.Id, 'Qualified - Converted', currentUser.Id));
        
        insert listReferralToAdd; 
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = newPersonAccount.id, Amount=12345,WT_New_Dollar__c=10);
        listOpportunity.add(opportunityRecord1);
        insert listOpportunity;
    }
    
    @isTest
    static void TestMetricBatch()
    {
        User newUser;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            newUser = WT_TestSetupHelper.GetUser('testfirstname', 'testlastname', 'test-user@fakeemail.com', 'test-user@fakeemail.com.wintrustbank', 'Standard User');        
            newUser.WT_Line_of_Business__c = 'Business Banking';
            insert newUser;
        }
        List<Lead> listLead = [Select Id,
                               FinServ__ReferredByUser__c 
                               FROM Lead];
        listLead[0].FinServ__ReferredByUser__c = newUser.Id;
        update listLead;
        
        List<Opportunity> listOpportunity = [Select Id,
                                             OwnerId 
                                             FROM Opportunity];
        listOpportunity[0].OwnerId = newUser.Id;
        update listOpportunity;
        
        Test.startTest();
        WT_BatchWeeklyMetrics batchWeeklyMetric = new WT_BatchWeeklyMetrics();
        Database.executeBatch(batchWeeklyMetric);        
        WT_Weekly_Metric__c newMetric = [SELECT Id,
                                         CreatedDate
                                         FROM WT_Weekly_Metric__c
                                         LIMIT 1];
        Test.stopTest();
    }
    
    @isTest
    static void TestScheduleClass()
    {
        Test.startTest();
        WT_BatchWeeklyMetricSchedule weeklyMetricSchedule = new WT_BatchWeeklyMetricSchedule();
        String cronSchedule = '0 0 6 ? * MON *';        
        System.schedule('Test Schedule', cronSchedule, weeklyMetricSchedule);
        Test.stopTest();
    } 
}