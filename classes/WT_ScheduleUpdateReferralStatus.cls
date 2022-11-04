global class WT_ScheduleUpdateReferralStatus implements Schedulable {
   global void execute(SchedulableContext sc) {
     WT_UpdateReferralStatus b = new WT_UpdateReferralStatus(); 
      database.executebatch(b);
  }
}