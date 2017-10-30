/*******************************************************************************************************
Created by: Chiru
Purpsoe: To create tasks Adjuster followup tasks. This class runs daily from schedule class
********************************************************************************************************/
global class AdjusterFollowupTaskBatchSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
        
        Database.executeBatch(new AdjusterFollowupTaskBatch());
   }
}