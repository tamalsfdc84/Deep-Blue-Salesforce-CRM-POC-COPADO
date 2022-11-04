/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateClientCoverageSchedule
* @Author           Vamsi Pulikallu <vpulikallu@wintrust.com>
* @ModifiedBy       Vamsi Pulikallu <vpulikallu@wintrust.com>
* @Version          v1.0
* @CreatedDate      31 Jan 2022
* @UsedBy           
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchUpdateCallsOnAccount class on yearly basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes 31 Jan 2022
* v1.0
* 31 Jan 2022
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchUpdateCallsOnAccount_T
global class WT_BatchUpdateCallsOnAccountSchedule implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        WT_BatchUpdateCallsOnAccount batchCallsUpdate = new WT_BatchUpdateCallsOnAccount();
        database.executebatch(batchCallsUpdate,200);
    }
}