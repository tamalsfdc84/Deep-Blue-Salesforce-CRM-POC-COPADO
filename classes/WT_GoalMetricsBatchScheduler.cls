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

global with sharing class WT_GoalMetricsBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        WT_IndividualGoalBatch goalscheduler = new WT_IndividualGoalBatch(); 
        database.executebatch(goalscheduler,1);

    }
}