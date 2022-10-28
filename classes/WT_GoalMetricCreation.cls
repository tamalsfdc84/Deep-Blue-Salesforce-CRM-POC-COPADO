/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_GoalMetricCreation
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    12/10/2021
* @TestClass      WT_TestGoalMetricController_T
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to create and returns GoalMetrics Object
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/


public with sharing class WT_GoalMetricCreation {
    
    //Krupa: This method is used to create a goal Metrics and it is called in LWC comp - GoalSettings
    
    @AuraEnabled
    public static WT_Goal_Metric__c createGoalMetric(string gmName, string gmType, string gmObject, string gmActualResult,
                                                     string gmActualCriteriaLogic, string gmActualDate, string gmInPrgResult, string gmInPrgCriteriaLogic, 
                                                     string gmInPrgActualDate, String gmFieldToSum)
    {     
        WT_Goal_Metric__c gm = new WT_Goal_Metric__c();
        try 
        {
            gm.Name = gmName;
            gm.WT_Metric_Type__c = gmType;
            gm.WT_CRM_Object_API_Name__c = gmObject;
            gm.WT_Actual_Result_Criteria__c = gmActualResult;
            gm.WT_Actual_Result_Criteria_Logic__c = gmActualCriteriaLogic;
            gm.WT_Actual_Result_Date_Field_API_Name__c = gmActualDate;
            gm.WT_InProgress_Result_Criteria__c = gmInPrgResult;
            gm.WT_In_Progress_Criteria_Logic__c = gmInPrgCriteriaLogic;
            gm.WT_InProgress_Result_Date_Field_API_Name__c = gmInPrgActualDate;
            gm.WT_CRM_Field_API_Name__c = gmFieldToSum;
            insert gm;
        } 
        catch (Exception e) 
        {
            //throw new AuraHandledException(e.getMessage());
        }
        
        return gm;
    }
}