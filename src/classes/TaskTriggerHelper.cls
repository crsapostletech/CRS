/*************************************************************************************
Created By: Apostletech team
Purpose: Helper class for Trigger on Task object,
1. To create "Temporary Housing Agreement Send Document Task", "Credit Card Authorization Send Document Task", "Adjuster Confirmation Send Document Task"
    task records when Book Hotel task completed   
*************************************************************************************/
Public class TaskTriggerHelper{
    
    // After event
    // To create Send Document tasks when Book Hotel task completed
    // ***************************************** Method Start ***********************************************************
    Public static void createSendDocumnetTasks(List<Task> taskList, Map<Id,Task> oldTaskMap, Boolean isInsert)
    {
        
        List<Task> sendDocTaskList = new List<Task>();
        
        for(Task t : taskList)
        {
            if(t.Status == 'Completed' && t.Subject == 'Book Hotel' && (isInsert || (!isInsert && t.Status != oldTaskMap.get(t.Id).Status)))
            {
                sendDocTaskList.add(TaskBuilder.ccAuth(t.Placement__c,t.Service_Request__c,t.WhoId,t.OwnerId));    
                sendDocTaskList.add(TaskBuilder.adjConfirmation(t.Placement__c,t.Service_Request__c,t.WhoId,t.OwnerId));    
            }
        }
         
         if(!sendDocTaskList.isEmpty()){
             insert sendDocTaskList;
         }
         
    }
    // ***************************************** Method End ***********************************************************
    
        
    // To stop Send document tasks duplicate creation
    private static boolean runSendDocuments = true;
    public static boolean runOnceSendDocuments(){
        if(runSendDocuments){
             runSendDocuments=false;
             return true;
        }else{
            return runSendDocuments;
        }
    }

    Public static void create72HourADJContactTask(List<Task> taskList, Map<Id,Task> oldTaskMap)
    {
        
        List<Task> x72HourADJContactTasks = new List<Task>();
       
        for(Task task : taskList)
        {
            if (task.RecordTypeId == RecordTypeHelper.x72HourPHContactTaskRT() && task.Status != oldTaskMap.get(task.Id).Status && task.Status == 'Completed')
            {
    
                x72HourADJContactTasks.add(TaskBuilder.x72HourADJContact(task.Placement__c,task.WhatId,task.WhoId,task.OwnerId));
            }
        }

        insert x72HourADJContactTasks;
    }    
     // We have copied this trigger from PopulateDocumentDates after insert
      Public Static void PopulateDocumentDates(list<Task> TaskRecords)
      {
          Date cutOffDate = Date.newInstance(2015,10,28);
        Set<ID> TaskID = new Set<ID>();
        for(Task task : TaskRecords){
            string whatIdVal = task.whatId;
            if(whatIdVal.startsWith('a0P'))
                TaskID.add(task.WhatId);
        }
        Map<Id,ServiceRequest__c> SrMap = New Map<Id,ServiceRequest__c>([select id,CRS_Hotel_Confirmation_Created_Date__c,Cost_Benefit_Analysis_Created_Date__c,Move_In_Confirmation_Created_Date__c,CreatedDate from serviceRequest__c where Id IN: TaskID]);
        for (Task task : TaskRecords)    
        {
            if (task.subject == 'HotelConfirmation Generated')
            {
                //ServiceRequest__c serviceRequest = [select CRS_Hotel_Confirmation_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
                //if (serviceRequest.CRS_Hotel_Confirmation_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
                if (SrMap.get(task.whatid).CRS_Hotel_Confirmation_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
                {
                    SrMap.get(task.whatid).CRS_Hotel_Confirmation_Created_Date__c = Datetime.now();
                    //update serviceRequest; 
                }
            }
            else if (task.subject == 'Liberty Mutual Cost Benefit Analysis')
            {
                //ServiceRequest__c serviceRequest = [select Cost_Benefit_Analysis_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
                //if (serviceRequest.Cost_Benefit_Analysis_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
                if(SrMap.get(task.whatid).Cost_Benefit_Analysis_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
                {
                    SrMap.get(task.whatid).Cost_Benefit_Analysis_Created_Date__c = Datetime.now();
                }
            }
            else if (task.subject == 'MoveInConfirmation Generated')
            {
                //ServiceRequest__c serviceRequest = [select Cost_Benefit_Analysis_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
                //if (serviceRequest.Cost_Benefit_Analysis_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
                if(SrMap.get(task.whatid).Move_In_Confirmation_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
                {
                    SrMap.get(task.whatid).Move_In_Confirmation_Created_Date__c = Datetime.now();
                }
            }
        }  
        if(SrMap.size()>0)
            update SrMap.values();
      }

     // To stop 72 hour adj contact tasks duplicate creation
    private static boolean runCreate72HourADJContactTask = true;
    public static boolean runOnceCreate72HourADJContactTask(){
        if(runCreate72HourADJContactTask){
             runCreate72HourADJContactTask=false;
             return true;
        }else{
            return runCreate72HourADJContactTask;
        }
    }   
}