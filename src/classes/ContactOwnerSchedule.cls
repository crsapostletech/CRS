global class ContactOwnerSchedule implements Schedulable{
   global void execute(SchedulableContext sc) {
      ContactOwnerUpdateBatch ct = new ContactOwnerUpdateBatch();
      Database.executeBatch (ct);
   }
}