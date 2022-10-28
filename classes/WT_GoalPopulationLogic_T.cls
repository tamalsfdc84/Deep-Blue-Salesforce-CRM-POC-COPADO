/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_GoalPopulationLogic_T
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    12/29/2021
  @Description    This test class is for WT_GoalPopulationLogic
* -----------------------------------------------------------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/
@isTest
public with sharing class WT_GoalPopulationLogic_T {
      //This method is insert goal metrics with actual criteria and Inprogress Criteria
   @isTest
    static void TestupdateGoal() {
       
        User user = WT_DataFactory.createUser('WT Business Administrator');
        insert user; 
        
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',user.Id);
        insert listCustomerAccount;
        
        List<Opportunity> ListOppty = WT_DataFactory.createOppty(1);
        ListOppty[0].AccountID = listCustomerAccount[0].Id;
        ListOppty[0].OwnerId = user.Id;
        ListOppty[0].StageName = 'Stage 1 - Opportunity Identified';
        insert ListOppty;
      
        WT_Goal_Metric__c gm = new WT_Goal_Metric__c();
        gm.Name = 'test1123';
        gm.WT_Metric_Type__c = 'SUM';
        gm.WT_CRM_Object_API_Name__c = 'Opportunity';
        gm.WT_CRM_Field_API_Name__c = 'Amount';
        gm.WT_Actual_Result_Criteria__c = '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        gm.WT_Actual_Result_Criteria_Logic__c = '1';
        gm.WT_Actual_Result_Date_Field_API_Name__c = 'CloseDate';
        gm.WT_InProgress_Result_Criteria__c  =  '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        gm.WT_In_Progress_Criteria_Logic__c = '1';
        gm.WT_InProgress_Result_Date_Field_API_Name__c = 'WT_Actual_Close_Date__c';
        List<WT_Goal_Metric__c> gmLst = new List<WT_Goal_Metric__c>();
        gmLst.add(gm);
        system.runAs(user){
            insert gmLst;
          
        }

        WT_Goal__c tg = new WT_Goal__c();
        tg.Name = 'Test123';
        tg.WT_Should_Roll_Up_From_Child__c = false;
        tg.WT_Goal_Metric__c = gmLst[0].Id;
        tg.WT_Date_From__c = Date.newInstance(2022, 1, 12);
        tg.WT_Date_To__c = Date.newInstance(2022, 6, 12);
        tg.WT_Percentage_Achieved__c = 1;
        tg.WT_Actual__c = 10000;
        tg.WT_In_Progress__c = 7000;
        tg.WT_Target__c = 5000;
        tg.WT_Run_Rate_To_Goal__c = 1;
        tg.WT_Goal_Owner__c = user.Id;
        system.runAs(user){
            insert tg;
           
        }
        List<Id> tgIds = new List<Id>();
        tgIds.add(tg.Id);
        Test.startTest();
        WT_GoalPopulationLogic.updateGoal(tgIds);
        Test.stopTest(); 
    }
    //This method is to insert goal metrics and goal records to cover the ParentGoals
       @isTest
       static void testParentUpdateGoal() {
       
        User user = WT_DataFactory.createUser('WT Business Administrator');
        insert user; 
           
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',user.Id);
        insert listCustomerAccount;
        
        List<Opportunity> ListOppty = WT_DataFactory.createOppty(1);
        ListOppty[0].AccountID = listCustomerAccount[0].Id;
        ListOppty[0].OwnerId = user.Id;
        ListOppty[0].StageName = 'Stage 1 - Opportunity Identified';
        insert ListOppty;
        
        WT_Goal_Metric__c gm = new WT_Goal_Metric__c();
        gm.Name = 'test1123';
        gm.WT_Metric_Type__c = 'SUM';
        gm.WT_CRM_Object_API_Name__c = 'Opportunity';
        gm.WT_CRM_Field_API_Name__c = 'Amount';
        gm.WT_Actual_Result_Criteria__c = '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        gm.WT_Actual_Result_Criteria_Logic__c = '1';
        gm.WT_Actual_Result_Date_Field_API_Name__c = 'CloseDate';
        gm.WT_InProgress_Result_Criteria__c  = '';
        gm.WT_In_Progress_Criteria_Logic__c = '';
        gm.WT_InProgress_Result_Date_Field_API_Name__c = '';
        List<WT_Goal_Metric__c> gmLst = new List<WT_Goal_Metric__c>();
        gmLst.add(gm);
        system.runAs(user){
            insert gmLst;
          
        }

        WT_Goal__c tg = new WT_Goal__c();
        tg.Name = 'Test123';
        tg.WT_Should_Roll_Up_From_Child__c = false;
        tg.WT_Goal_Metric__c = gmLst[0].Id;
        tg.WT_Date_From__c = Date.newInstance(2022, 1, 12);
        tg.WT_Date_To__c = Date.newInstance(2022, 6, 12);
        tg.WT_Should_Roll_Up_From_Child__c = true;
        tg.WT_Percentage_Achieved__c = 1;
        tg.WT_Actual__c = 10000;
        tg.WT_In_Progress__c = 8000;
        tg.WT_Target__c = 5000;
        tg.WT_Run_Rate_To_Goal__c = 1;
        tg.WT_Goal_Owner__c = user.Id;
        system.runAs(user){
            insert tg;
           
        }
           
        WT_Goal__c tg1 = new WT_Goal__c();
        tg1.Name = 'Test123';
        tg1.WT_Goal_Metric__c = gmLst[0].Id;
        tg.WT_Date_From__c = Date.newInstance(2022, 1, 12);
        tg.WT_Date_To__c = Date.newInstance(2022, 6, 12);
        tg1.WT_Parent_Goal__c = tg.Id;   
        tg1.WT_Should_Roll_Up_From_Child__c = true;
        tg1.WT_Percentage_Achieved__c = 1;
        tg1.WT_Actual__c = 1;
        tg1.WT_In_Progress__c = 1;
        tg1.WT_Target__c = 5000;
        tg1.WT_Run_Rate_To_Goal__c = 1;
        system.runAs(user){
            insert tg1;
           
        }
           
        List<Id> tgIds = new List<Id>();
        tgIds.add(tg1.Id);
        tgIds.add(tg.Id);
        Test.startTest();
        WT_GoalPopulationLogic.updateGoal(tgIds);
        Test.stopTest(); 
    }
    //This method is to cover the metrictype as Count for Inprogress Criteria
    @isTest
    static void testInProgressToGoal() {
       
        User user = WT_DataFactory.createUser('WT Business Administrator');
        insert user; 
       
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',user.Id);
        insert listCustomerAccount;
        
        List<Opportunity> ListOppty = WT_DataFactory.createOppty(1);
        ListOppty[0].AccountID = listCustomerAccount[0].Id;
        ListOppty[0].OwnerId = user.Id;
        ListOppty[0].StageName = 'Stage 1 - Opportunity Identified';
        insert ListOppty;
        
        WT_Goal_Metric__c gm1 = new WT_Goal_Metric__c();
        gm1.Name = 'test1123';
        gm1.WT_Metric_Type__c = 'COUNT';
        gm1.WT_CRM_Object_API_Name__c = 'Opportunity';
        gm1.WT_CRM_Field_API_Name__c = '';
        gm1.WT_InProgress_Result_Criteria__c  = '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        gm1.WT_In_Progress_Criteria_Logic__c = '1';
        gm1.WT_InProgress_Result_Date_Field_API_Name__c = 'CloseDate';
        List<WT_Goal_Metric__c> gmLst = new List<WT_Goal_Metric__c>();
        gmLst.add(gm1);
        system.runAs(user){
            insert gmLst;
        }
        WT_Goal__c tg2 = new WT_Goal__c();
        tg2.Name = 'Test123';
        tg2.WT_Goal_Metric__c = gm1.Id;
        tg2.WT_Date_From__c = Date.Today() - 30;
        tg2.WT_Date_To__c = Date.Today(); 
        tg2.WT_Should_Roll_Up_From_Child__c = true;
        tg2.WT_Percentage_Achieved__c = 1;
       // tg2.WT_Actual__c = 1;
        tg2.WT_In_Progress__c = 1;
        tg2.WT_Target__c = 5000;
        tg2.WT_Run_Rate_To_Goal__c = 1;
        system.runAs(user){
            insert tg2;
        }
        Date dateToday=System.Today(); 
        WT_Goal__c tg1 = new WT_Goal__c();
        tg1.Name = 'Test123';
        tg1.WT_Should_Roll_Up_From_Child__c = false;
        tg1.WT_Parent_Goal__c = tg2.Id;  
        tg1.WT_Goal_Metric__c = gmLst[0].Id;
        tg1.WT_Date_From__c = Date.Today() - 30;
        tg1.WT_Date_To__c = Date.Today(); 
        tg1.WT_Percentage_Achieved__c = 1;
        //tg1.WT_Actual__c = 1;
        tg1.WT_In_Progress__c = 1;
        tg1.WT_Target__c = 5000;
        tg1.WT_Run_Rate_To_Goal__c = 1;
        tg1.WT_Goal_Owner__c = user.Id;
        system.runAs(user){
            insert tg1; 
        }
        List<Id> tgIds = new List<Id>();
        tgIds.add(tg1.Id);
        tgIds.add(tg2.Id);

        Test.startTest();
          WT_GoalPopulationLogic.updateGoal(tgIds);
        Test.stopTest(); 
    }   
}