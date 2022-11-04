/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_GoalMetricController_T
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    12/29/2021
* -----------------------------------------------------------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/

@isTest
public with sharing class WT_GoalMetricController_T {
    //This  method is to cover the createGoalMetrics method in WT_GoalMetricCreation
    @isTest
    static void TestCreateGoalMetrics(){

        Test.startTest();
        WT_Goal_Metric__c gm = WT_GoalMetricCreation.createGoalMetric('Test1','SUM','Opportunity','Amount','[{"field":"Amount","operator":"equals","value":"7890"},{},{},{},{},{},{}]','1', '12/03/2021', 'Test090', 'Test123', '12/03/2021'); 
        Test.stopTest();

    }
    //This  method is to cover the expection scenraio by passing the null params
    @isTest
    static void TestNegativeGoalMetrics(){
        Test.startTest();
        WT_Goal_Metric__c gm = WT_GoalMetricCreation.createGoalMetric('123','SUM','Opportunity','','','','','','','');
        Test.stopTest();
    }

}