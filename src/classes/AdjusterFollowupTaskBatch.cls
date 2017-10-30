/*******************************************************************************************************
Created by: Chiru
Purpsoe: To create tasks Adjuster followup tasks. This class runs daily from schedule class
********************************************************************************************************/
Global class AdjusterFollowupTaskBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        return Database.getQueryLocator('Select Id, Due_Date__c, ownerId, X30_Day_Adjuster_Follow_Up__c , X60_Day_Adjuster_Follow_Up__c, X90_Day_Adjuster_Follow_Up__c, Is_Ghost_Adjuster_Task__c from Contact where RecordType.Name = \'Adjuster\' AND (X30_Day_Adjuster_Follow_Up__c = true OR X60_Day_Adjuster_Follow_Up__c = true OR X90_Day_Adjuster_Follow_Up__c = true OR Is_Ghost_Adjuster_Task__c = true) ');
    }  
    
    global void execute(Database.BatchableContext BC, List<Contact> contList){
        
        List<Task> taskList = new List<Task>();
        
        for(Contact c : contList){
            
            Task t = new Task();
            t.ActivityDate = c.Due_Date__c;
            t.OwnerId = c.ownerId;
            t.Priority = 'Normal';
            t.Sales_Task__c = true;
            t.Status = 'Not Started';
            t.Subject = 'Adjuster Follow Up';
            
            if(c.Is_Ghost_Adjuster_Task__c)
            {
                t.Type = 'Ghost Adjuster Follow Up';
                t.Subject = 'Ghost Adjuster Follow Up';
            }
            else{     
                if(c.X90_Day_Adjuster_Follow_Up__c){    
                    t.Type = '90 Day Adjuster Follow Up';
                    t.Subject = '90 Day Adjuster Follow Up';
                }
                else if(c.X60_Day_Adjuster_Follow_Up__c){    
                    t.Type = '60 Day Adjuster Follow Up';
                    t.Subject = '60 Day Adjuster Follow Up';
                }
                else if(c.X30_Day_Adjuster_Follow_Up__c){    
                    t.Type = '30 Day Adjuster Follow Up';
                    t.Subject = '30 Day Adjuster Follow Up';
                }  
            }  
                        
            t.WhoId = c.Id;
            
            taskList.add(t);            
        }
        
        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
    
    global void finish(Database.BatchableContext BC){ }
   
}