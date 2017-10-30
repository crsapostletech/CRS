/*****************************************************************************************************
Created By: ApostleTech
Purpose: To schedule "PardotQueryProspectApi" to get Prospects from Pardot and to delete non adjusters
Batch Class: PardotQueryProspectApi
******************************************************************************************************/
global class scheduledPardotQueryProspectApi implements Schedulable {
   global void execute(SchedulableContext SC) {
       PardotQueryProspectApi.queryProspectAPI(0);
   }
   
}