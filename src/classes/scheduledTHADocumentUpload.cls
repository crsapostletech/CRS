global class scheduledTHADocumentUpload implements Schedulable {
   
   global String agreementRecId;
   
   global scheduledTHADocumentUpload(String agrRecId){
       agreementRecId = agrRecId;
   }
   
   global void execute(SchedulableContext SC) {
       
       Database.executebatch(new UploadingSignedTHAControllerBatch(agreementRecId));
   }
   
}