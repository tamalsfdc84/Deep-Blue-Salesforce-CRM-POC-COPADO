/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchWeeklyMetricSchedule
* @Author			Anitha jaini	<ajaini@wintrust.com>
* @ModifiedBy		Anitha jaini	<ajaini@wintrust.com>
* @Version			v1.0
* @CreatedDate		07-29-2022
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is the scheduler class for WT_BatchWeeklyMetric. This class will be called from automated process when 
* it needs to run the metric job
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 07-29-2022
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchWeeklyMetric_T
global class WT_BatchWeeklyMetricSchedule implements Schedulable
{    
    global void execute(SchedulableContext sc) 
    {        
        WT_BatchWeeklyMetrics weeklyMetricBatch = new WT_BatchWeeklyMetrics();
        Id batchProcessId = Database.executeBatch(weeklyMetricBatch, 1);           
    }
}