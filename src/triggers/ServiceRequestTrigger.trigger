/*******************************************************************************************
Developed by: Apostletech team
Purpose: Trigger on ServiceRequest__c object to, 
1. To update First Service Request ID field in Opportunity(Claim)
2. To Update Hotel Options and Book Hotel tasks status to "Deferred" when the hold check is selected
3. To create or Update Hotel Options and Book Hotel tasks status to "In Progress" when the hold checkbox is unchecked
4. To delete Tasks when Service Request status is "Lost Opportunity"
5. To assign open activities to new user selected in "Initial_SR_being_worked_by__c" field in Service Request

Test class: ServiceRequestTrigger_TC
*******************************************************************************************/
trigger ServiceRequestTrigger on ServiceRequest__c (after insert, after update, after delete, Before Insert) {
     
     // To activate or deactivate trigger functionality from custom setting
     if(TriggerControlSetting__c.getValues('ServiceRequestTrigger') <> null &&  TriggerControlSetting__c.getValues('ServiceRequestTrigger').isActive__c){
             
             TriggerControlSetting__c trigControl = TriggerControlSetting__c.getValues('ServiceRequestTrigger');
             
             // To update First Service Request ID field in Opportunity(Claim)
             //**************************** START ***********************************************************************
             if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isInsert && trigControl.isInsert__c){
                 ServiceRequestTriggerHelper.updateFirstServiceRequestIDInClaim(Trigger.new);
             }
             if(Trigger.isAfter && trigControl.isAfter__c &&  Trigger.isDelete && trigControl.isDelete__c){
                 ServiceRequestTriggerHelper.updateFirstServiceRequestIDInClaim(Trigger.old);
             }
             //**************************** ENDT ***********************************************************************
             
             // To Update Hotel Options and Book Hotel tasks status when the hold check is selected or unselected
             if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isInsert && trigControl.isInsert__c){
                  ServiceRequestTriggerHelper.updateTaskStatusOnHoldChange(Trigger.new, new Map<Id,ServiceRequest__c>(), true);        
             } 
             // To Update Hotel Options and Book Hotel tasks status when the hold check is selected or unselected
             if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isUpdate && trigControl.isUpdate__c){
                  ServiceRequestTriggerHelper.updateTaskStatusOnHoldChange(Trigger.new, Trigger.oldMap, false);        
             } 
             
             if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isUpdate && trigControl.isUpdate__c){
                  ServiceRequestTriggerHelper.deleteTasksWhenStatusLost(Trigger.new, Trigger.oldMap);
             } 
             
             // To assign open activities to new user selected in "Initial_SR_being_worked_by__c" field in Service Request
             if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isUpdate && trigControl.isUpdate__c){
                  ServiceRequestTriggerHelper.reassignOpenTasksToInitialSRBeingWorked(Trigger.new, Trigger.oldMap);
             } 
             // To update emials for CRS Team while Service Request Creation
             if(Trigger.isBefore){
                  ServiceRequestTriggerHelper.ServiceRequestCreation(Trigger.new);
             }
             if(Trigger.isAfter){
                  ServiceRequestTriggerHelper.UpdateCostsandFurnitureOnATPorPTPChange(Trigger.new, Trigger.oldMap);
             }
             
      }       
}