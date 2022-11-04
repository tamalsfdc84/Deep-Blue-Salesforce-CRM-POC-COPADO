/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOpportunitySendEmailSchedule
* @Author			Vamsi Pulikallu <vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		09 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchOpportunitySendEmail class on daily basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 09 Feb 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOppSendEmailSchedule implements Schedulable
{
	public void execute(SchedulableContext sc) 
    {
        WT_BatchOpportunitySendEmail batchOpportunityEmail = new WT_BatchOpportunitySendEmail(); 
        database.executebatch(batchOpportunityEmail,200);
    }
}