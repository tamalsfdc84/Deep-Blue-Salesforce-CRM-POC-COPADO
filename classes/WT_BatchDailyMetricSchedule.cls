/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchDailyMetricSchedule
* @Author			Himanshu Patel	<hpatel1@wintrust.com>
* @ModifiedBy		Himanshu Patel	<hpatel1@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-21-2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is the scheduler class for WT_BatchDailyMetric. This class will be called from automated process when 
* it needs to run the metric job
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 06-21-2021
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchDailyMetric_T
global class WT_BatchDailyMetricSchedule implements Schedulable
{    
    global void execute(SchedulableContext sc) 
    {        
        WT_BatchDailyMetric dailyMetricBatch = new WT_BatchDailyMetric();
        Id batchProcessId = Database.executeBatch(dailyMetricBatch, 1);           
    }
}