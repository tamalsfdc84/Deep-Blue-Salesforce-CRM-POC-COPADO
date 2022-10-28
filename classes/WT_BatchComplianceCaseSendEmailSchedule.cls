/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchComplianceCaseSendEmailSchedule
* @Author			Vamsi Pulikallu <vpulikallu@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu <vpulikallu@wintrust.com>
* @Version			v1.0
* @CreatedDate		21 Jan 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchComplianceCaseSendEmail class on daily basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 21 Jan 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchComplianceCaseSendEmail_T
global class WT_BatchComplianceCaseSendEmailSchedule implements Schedulable
{
	global void execute(SchedulableContext sc) 
    {
        WT_BatchComplianceCaseSendEmail batchComplianceEmail = new WT_BatchComplianceCaseSendEmail(); 
        database.executebatch(batchComplianceEmail,200);
    }
}