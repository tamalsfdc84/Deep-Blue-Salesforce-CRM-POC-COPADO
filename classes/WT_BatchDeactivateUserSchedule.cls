/**
* --------------------------------------------------------------------------------------------------------------
* @Name           WT_BatchDeactivateUserSchedule
* @Author         Vasavi K   <VKolusu@wintrust.com> 
* @ModifiedBy     Vasavi K   <VKolusu@wintrust.com>
* @Version        v1.0
* @CreatedDate    03-02-2022
* @UsedBy         Scheduler Class for WT_BatchDeactivateUser
* --------------------------------------------------------------------------------------------------------------
* @Description
* Class is used to schedule the  WT_BatchDeactivateUser class on start of every quarter basis 
Command to Schedule Job in Anonymous:
String sch ='0 0 9 1 1/3 ? *';
system.schedule('WT_BatchDeactivateUserSchedule', sch, new WT_BatchDeactivateUserSchedule());
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchDeactivateUser_T
global class WT_BatchDeactivateUserSchedule implements Schedulable {
 global void execute(SchedulableContext sc) {
        WT_BatchDeactivateUser b = new WT_BatchDeactivateUser();
        database.executebatch(b);
    }
}