/*****************************************************************************************************
Created By: Chiru
Purpose: To schedule "FaxStatusApiCall" to run ini 30 minutes from when send fax api called. 
Class calling from "NTVDocumnetPreviewController" apex class. 
******************************************************************************************************/
global class FaxStatusValidateScheduler Implements Schedulable
{

    global String taskRecId;
   
    global FaxStatusValidateScheduler(String taskID){
       taskRecId = taskID;
    }
   
    global void execute(SchedulableContext sc){
        FaxStatusApiCall.faxStatusValidator(taskRecId);
    }
    
}