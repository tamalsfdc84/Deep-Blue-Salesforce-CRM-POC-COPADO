/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name            WT_AccountMergeBatchSchedule
* @Author          Vamsi Pulikallu   <vpulikal@wintrust.com> 
* @version         v1.0 
* @CreatedDate     19 May 2021
* @UsedBy          class WT_AccountMergeBatch
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to schedule the WT_AccountMergeBatch class on daily basis
**/
//Test class: WT_AccountMergeBatch_T
global class WT_AccountMergeBatchSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        WT_AccountMergeBatch batchAccountMerge = new WT_AccountMergeBatch(); 
        database.executebatch(batchAccountMerge);
    }
}