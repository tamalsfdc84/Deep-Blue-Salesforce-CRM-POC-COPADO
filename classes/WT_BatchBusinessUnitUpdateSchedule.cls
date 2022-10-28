/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name            WT_BatchBusinessUnitUpdateSchedule
 * @Author          Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
 * @ModifiedBy      Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
 * @version         v1.0 
 * @CreatedDate     11-18-2020
 * @UsedBy          class WT_BatchBUEntityUpdate
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used to schedule the WT_BatchBUEntityUpdate class.
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Changes
 * vx.x             <user id>
 * MM-DD-YYYY       <Explanation> 
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
//Test class: WT_BatchBusinessUnitUpdate_T
global class WT_BatchBusinessUnitUpdateSchedule implements Schedulable
{
    global void execute(SchedulableContext batchBusinessUnitEntityUpdateSchedule)
    {
        WT_BatchBusinessUnitUpdate businessUnit = new WT_BatchBusinessUnitUpdate();
        ID batchProcessId = Database.executeBatch(businessUnit);           
    }
}