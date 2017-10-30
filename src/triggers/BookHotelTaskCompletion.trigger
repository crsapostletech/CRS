/********************************************************************************************************
Created By: Apostletech Team
Purpose: To update Hotel Room task status to Completed when Hotel room created for a Service Request
********************************************************************************************************/
trigger BookHotelTaskCompletion on Hotel_Room__c (before insert) {
     
     Set<Id> srId = new Set<Id>();
     Map<Id,Id> srId_placementId = new Map<Id,Id>();
     
     for(Hotel_Room__c H : Trigger.new){
         if(H.Service_Request__c <> null){
             srId.add(H.Service_Request__c);
             srId_placementId.put(H.Service_Request__c,H.Placement__c);
         }
     }
     
     if(!srId.isEmpty()){
     
         list<Task> taskRecords = [select id,subject,Task_Follow_Up_Status__c,status,Service_Request__c from task where Subject = 'Book Hotel' AND Status != 'Completed' AND WhatId in: srId];
          
         for(task t: taskRecords){
             t.Placement__c = srId_placementId.get(t.Service_Request__c);
             t.status = 'Completed';
         }
         
         if(!taskRecords.isEmpty())
             update taskRecords;
     }        
}