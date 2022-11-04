/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchTMCallPastDueSendEmailSchedule
* @Author			Vamsi Pulikallu <vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		26 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchTMCallPastDueSendEmail class
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 09 Feb 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchTaskTMCall_T
public class WT_BatchTaskTMCompletedSendEmailSchedule implements Schedulable
{
	public void execute(SchedulableContext sc) 
    {
        WT_BatchTaskTMCallCompletedSendEmail batchOpportunityClosed = new WT_BatchTaskTMCallCompletedSendEmail(); 
        database.executebatch(batchOpportunityClosed,200);
    }
}