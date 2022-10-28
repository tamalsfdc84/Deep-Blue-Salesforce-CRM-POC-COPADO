/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name            WT_BatchMarkEventsCancelledSchedule
 * @Author          Anoop     <abattini@wintrust.com> 
 * @version         v1.0 
 * @CreatedDate     22-12-2020
 * @UsedBy          class WT_BatchMarkEventsCancelled
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description * Class is used to schedule the WT_BatchMarkEventsCancelled class on daily basis
**/
//Test class: WT_BatchMarkEventsCancelled_T
global class WT_BatchMarkEventsCancelledSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        WT_BatchMarkEventsCancelled batchEvents = new WT_BatchMarkEventsCancelled(); 
        database.executebatch(batchEvents);
    }
}