/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_GoalPopulationLogic
* @Author           Krupa Chinthakindi
* @Version          v1.0
* @CreatedDate      2-4-2022
* @UsedBy      
* -----------------------------------------------------------------------------------------------------------------------------
* @Description      This is a test class for WT_IndividualGoalBatch
------------------------------------------------------------------------------------------------------------------------------------------
**/



@isTest
public with sharing class WT_IndividualGoalBatch_T {

    //This method is to insert test goal to cover GoalBatch
    @isTest
    public static void WT_TestBatch() {
        
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
        WT_IndividualGoalBatch obj = new WT_IndividualGoalBatch();  
        Database.executeBatch( obj );  
        Test.stopTest(); 

    }
}