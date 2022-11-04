/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOppTreasuryManagementSchedule
* @Author			Vamsi Pulikallu <vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		26 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchOppTreasuryManagementSchedule class on weekly basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 26 Feb 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOppTreasuryManagementSchedule implements Schedulable
{
	public void execute(SchedulableContext sc) 
    {
        WT_BatchOpportunityTreasuryManagement batchOpportunityClosed = new WT_BatchOpportunityTreasuryManagement(); 
        database.executebatch(batchOpportunityClosed,200);
    }
}