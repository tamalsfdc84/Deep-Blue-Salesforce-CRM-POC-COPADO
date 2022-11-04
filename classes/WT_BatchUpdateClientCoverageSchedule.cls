/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateClientCoverageSchedule
* @Author           Karishma Keswani <kkeswani@wintrust.com>
* @ModifiedBy       Karishma Keswani <kkeswani@wintrust.com>
* @Version          v1.0
* @CreatedDate      19-01-2021
* @UsedBy           
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to schedule the WT_BatchUpdateClientCoverageOnAccount class on daily basis.
* --------------------------------------------------------------------------------------------------------------
* @Changes 14 Oct 2021
* v1.0
* 19-01-2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchUpdateClientCoverageOnAccount_T
global class WT_BatchUpdateClientCoverageSchedule  implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        WT_BatchUpdateClientCoverageOnAccount batchClientCoverage = new WT_BatchUpdateClientCoverageOnAccount();
        WT_BatchUpdateClientCoverageRelGrpAcc relationshipGroupClientCoverage = new WT_BatchUpdateClientCoverageRelGrpAcc();
        Integer batchSize = Integer.valueOf(system.label.WT_BatchSize);
        database.executebatch(batchClientCoverage,batchSize);
        database.executebatch(relationshipGroupClientCoverage,batchSize);
    }
}