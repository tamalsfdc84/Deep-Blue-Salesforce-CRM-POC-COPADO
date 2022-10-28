/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name            WT_BatchMarkTasksCancelledSchedule
 * @Author          Anoop     <abattini@wintrust.com> 
 * @version         v1.0 
 * @CreatedDate     22-12-2020
 * @UsedBy          class WT_BatchMarkTasksCancelled
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used to schedule the WT_BatchMarkActivitiesCancelled class on daily basis
**/
//Test class: WT_BatchMarkTasksCancelled_T
global class WT_BatchMarkTasksCancelledSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        WT_BatchMarkTasksCancelled batchTasks = new WT_BatchMarkTasksCancelled(); 
        database.executebatch(batchTasks);
    }
}