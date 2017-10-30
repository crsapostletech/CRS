/*****************************************************************************************************
Created By: Chiru
Purpose: To schedule "PardotQueryProspectApi" to get Prospects from Pardot and to delete non adjusters
******************************************************************************************************/
global class PardotQueryProspectApiScheduler Implements Schedulable
{

    global Integer offset;
   
    global PardotQueryProspectApiScheduler(Integer offsetVal){
       offset = offsetVal;
    }
   
    global void execute(SchedulableContext sc){
        PardotQueryProspectApi.queryProspectAPI(offset);
    }
    
}