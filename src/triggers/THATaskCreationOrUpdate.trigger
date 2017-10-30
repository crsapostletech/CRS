/*************************************************************************************************************
Created By: Chiru
Purpose: To create or update THA document task when Opportunity is creaated or when Hotel_Customer_Care_Specialist__c  is changed
*************************************************************************************************************/
trigger THATaskCreationOrUpdate on Opportunity (after insert, after update) {
    
    // Insert operation
    if(Trigger.isInsert){
        
        List<Task> TaskRecords = new List<Task>();
        
        for(Opportunity O : Trigger.new){
            if((O.Initial_Service_Request__c == 'Hotel' || O.Initial_Service_Request__c == 'Housing')  && O.Hotel_Customer_Care_Specialist__c != null){
                
                     Task tRec = new Task();
                     Integer currentHour = System.now().hour();
                     if(currentHour < 17){                                                
                         tRec.Due_Time__c = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
                     }
                     else{
                          Date nextDayDate = Date.toDay().addDays(1);
                          DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);
                          tRec.Due_Time__c = dueDateTime;
                     }                      
                      
                      tRec.ActivityDate = Date.valueOf(tRec.Due_Time__c); 
                      tRec.OwnerId = O.Hotel_Customer_Care_Specialist__c;                        
                      tRec.Priority = 'Normal';                      
                      tRec.WhatID = O.Id;
                      tRec.Status = 'Not Started';
                      tRec.Subject = 'Send Temporary Housing Agreement(THA)';                               
                      tRec.Type = 'Hold Follow Up';
                      trec.WhoId = O.Policyholder__c;                                      
                      TaskRecords.add(trec);
            }
        }
        
        if(!TaskRecords.isEmpty()){
            insert TaskRecords;
        }
        
    }  
    
    // Update operation
    if(Trigger.isUpdate){
         
         List<Task> taskExistList = new List<Task>();
         Set<Id> oppIds = new Set<Id>();
         
         for(Opportunity O : Trigger.new){
             if(O.Initial_Service_Request__c == 'Hotel' && O.Hotel_Customer_Care_Specialist__c != null){
                 
                 Opportunity oppOld = Trigger.oldMap.get(O.Id);
                 if(O.Hotel_Customer_Care_Specialist__c != oppOld.Hotel_Customer_Care_Specialist__c){
                     oppIds.add(O.Id);        
                 }
             }
         }
         
         if(!oppIds.isEmpty()){
             
              taskExistList = [Select Id, ownerId, whatId from Task where whatId in: oppIds AND Subject = 'Send Temporary Housing Agreement(THA)' ];
              
              for(Opportunity O : Trigger.new){
                  if(O.Initial_Service_Request__c == 'Hotel' && O.Hotel_Customer_Care_Specialist__c != null){
                  
                      Opportunity oppOld = Trigger.oldMap.get(O.Id);
                      
                      if(O.Hotel_Customer_Care_Specialist__c != oppOld.Hotel_Customer_Care_Specialist__c){                           
                           
                           boolean isTaskFound = false;
                           for(Task T : taskExistList){
                               if(T.whatId == O.Id){
                                   T.ownerId = O.Hotel_Customer_Care_Specialist__c;
                                   isTaskFound = true;
                                   break;
                               }
                           }
                           
                           if(isTaskFound == false){
                               
                                 Task tRec = new Task();
                                 Integer currentHour = System.now().hour();
                                                                  
                                 if(currentHour < 17){                                                
                                     tRec.Due_Time__c = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
                                 }
                                 else{
                                      Date nextDayDate = Date.toDay().addDays(1);
                                      DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);
                                      tRec.Due_Time__c = dueDateTime;
                                 }                      
                                  
                                  tRec.ActivityDate = Date.valueOf(tRec.Due_Time__c); 
                                  tRec.OwnerId = O.Hotel_Customer_Care_Specialist__c;                        
                                  tRec.Priority = 'Normal';                      
                                  tRec.WhatID = O.Id;
                                  tRec.Status = 'Not Started';
                                  tRec.Subject = 'Send Temporary Housing Agreement(THA)';                               
                                  tRec.Type = 'Hold Follow Up';
                                  trec.WhoId = O.Policyholder__c;                                      
                                  taskExistList.add(trec);
                           }
                                      
                      }
                  }
              }
              
              if(!taskExistList.isEmpty()){
                  upsert taskExistList;
              }
              
         }
         
    }
      
   
}