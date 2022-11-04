/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchCaseComplianceEmailAlertSchedule
* @Author			Francis Xavier
* @ModifiedBy		
* @Version			v1.0
* @CreatedDate		25 Feb 2022
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchCaseComplianceEmailAlert class on daily basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* 
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchCaseComplianceEmailAlert_T
global class WT_BatchCaseComplianceEmailAlertSchedule implements Schedulable
{
	global void execute(SchedulableContext sc) 
    {
        WT_BatchCaseComplianceEmailAlert batchComplianceEmail = new WT_BatchCaseComplianceEmailAlert(); 
        database.executebatch(batchComplianceEmail,200);
    }
}