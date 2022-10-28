/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name            WT_GoalMetricsBatchScheduler
* @Author          Krupa Chinthakindi   
* @version         v1.0 
* @CreatedDate     2/4/2022
* @UsedBy          class WT_IndividualGoalBatch
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to schedule the WT_IndividualGoalBatch class on daily basis
**/

@isTest
public class WT_GoalMetricsBatchScheduler_T {
    //This method is cover batchscheduler
    @isTest static void executeTest(){
        Test.startTest();
            SchedulableContext sc = null;
            WT_GoalMetricsBatchScheduler tsc = new WT_GoalMetricsBatchScheduler();
            tsc.execute(sc);
        Test.stopTest();
         
    }  
    
}