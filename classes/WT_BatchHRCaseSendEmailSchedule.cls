/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchHRCaseSendEmailSchedule
* @Author			Vamsi Pulikallu <vpulikallu@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikallu@wintrust.com>
* @Version			v1.0
* @CreatedDate		22 June 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchHRCaseSendEmail class on daily basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 22 June 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchHRCaseSendEmail_T
global class WT_BatchHRCaseSendEmailSchedule implements Schedulable
{
	global void execute(SchedulableContext sc) 
    {
        WT_BatchHRCaseSendEmail batchHREmail = new WT_BatchHRCaseSendEmail(); 
        database.executebatch(batchHREmail);
    }
}