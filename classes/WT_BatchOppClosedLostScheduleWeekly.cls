/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOppClosedLostScheduleWeekly
* @Author			Vamsi Pulikallu <vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		09 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchOpportunityClosedLostWeekly class on weekly basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 09 Feb 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOppClosedLostScheduleWeekly implements Schedulable
{
	public void execute(SchedulableContext sc) 
    {
        WT_BatchOpportunityClosedLostWeekly batchOpportunityClosed = new WT_BatchOpportunityClosedLostWeekly(); 
        database.executebatch(batchOpportunityClosed,200);
    }
}