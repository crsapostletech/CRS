/*************************************************************************************
Created By: Apostletech team
Purpose: Trigger on Task object,
1. To create "Temporary Housing Agreement Send Document Task", "Credit Card Authorization Send Document Task", "Adjuster Confirmation Send Document Task"
    task records when Book Hotel task completed
*************************************************************************************/
trigger TaskTrigger on Task (after insert, after update) {
    
     if(TriggerControlSetting__c.getValues('TaskTrigger') <> null &&  TriggerControlSetting__c.getValues('TaskTrigger').isActive__c)
     {        
         TriggerControlSetting__c trigControl = TriggerControlSetting__c.getValues('TaskTrigger');        
            
         if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isInsert && trigControl.isInsert__c)
             TaskTriggerHelper.createSendDocumnetTasks(Trigger.new, new Map<Id,Task>(), true);
         if(Trigger.isAfter && trigControl.isAfter__c && Trigger.isUpdate && trigControl.isUpdate__c && TaskTriggerHelper.runOnceSendDocuments())
             TaskTriggerHelper.createSendDocumnetTasks(Trigger.new, Trigger.oldMap, false);
         if(Trigger.isAfter && trigControl.isBefore__c && Trigger.isUpdate && trigControl.isUpdate__c && TaskTriggerHelper.runOnceCreate72HourADJContactTask())
             TaskTriggerHelper.create72HourADJContactTask(Trigger.new, Trigger.oldMap);
         if(Trigger.isAfter)
             TaskTriggerHelper.PopulateDocumentDates(Trigger.new);    
     }       
}