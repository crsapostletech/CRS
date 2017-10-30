/*****************************************************************************************************
Created By: Chiru
Purpose: To schedule "PardotQueryProspectApi" to get Prospects from Pardot and to delete non adjusters
******************************************************************************************************/
global class PardotProspectDeleteBacthScheduler Implements Schedulable
{

    global list<String> ProspectFids;
   
    global PardotProspectDeleteBacthScheduler(list<String> ProspectFidList){
       ProspectFids = ProspectFidList;
    }
   
    global void execute(SchedulableContext sc){
        Database.executeBatch(new PardotProspectDeleteBacth(ProspectFids), 20); 
    }
    
}