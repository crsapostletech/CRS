/************************************************************************************************************************************************************************
Created by: Chiru
Purpose: To reassign service request open activities to new user selected on "Hotel Customer Care Specialist" and no value on Initial_SR_being_worked_by__c field in Service Request
************************************************************************************************************************************************************************/
trigger ReassignServiceRequestAutoTasks on Opportunity (after update) {
          
      Set<Id> oppIds = new Set<Id>();
      
      for(Opportunity opp : Trigger.new){
          if(opp.Initial_Service_Request__c == 'Hotel' && opp.Hotel_Customer_Care_Specialist__c != Trigger.oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c && opp.Hotel_Customer_Care_Specialist__c != null){
              oppIds.add(opp.Id);
          }
      }   
      
      if(!oppIds.isEmpty()){
          Map<Id,ServiceRequest__c> serviceReqMap = new Map<Id,ServiceRequest__c>([Select Id,  Opportunity__r.Hotel_Customer_Care_Specialist__c from ServiceRequest__c where Opportunity__c in: oppIds AND RecordType.Name = 'Hotel' AND Initial_SR_being_worked_by__c = null]);
     
          if(serviceReqMap.values().size() > 0){
                
                List<Task> taskRecordsList = [Select Id, whatId, OwnerId from Task where whatId in: serviceReqMap.keySet() AND Status != 'Completed' AND (Subject = 'Hotel Options' OR Subject = 'Book Hotel' OR Subject = 'Hotel Needed-Hold Follow Up Call to PH' OR Subject = 'Send Temporary Housing Agreement(THA)' OR Subject = 'Send Credit Card Authorization (CCA)' OR Subject = 'Send Adjuster Confirmation' OR Subject LIKE '%Call Attempt%' OR Subject = 'Confirm Receipt of CCA') ];
        
                for(Task t : taskRecordsList){                    
                     if(serviceReqMap.get(t.whatId) != null && serviceReqMap.get(t.whatId).Opportunity__r.Hotel_Customer_Care_Specialist__c != null)   
                        t.OwnerId = serviceReqMap.get(t.whatId).Opportunity__r.Hotel_Customer_Care_Specialist__c;                    
                } 
                
                if(!taskRecordsList.isEmpty()){
                    update taskRecordsList;
                }
          }
      } 
             
}