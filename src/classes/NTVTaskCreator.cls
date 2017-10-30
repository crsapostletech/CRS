global class NTVTaskCreator implements Database.Batchable<sObject> 
{
	Public String query { get; set;}  
			  
    global database.queryLocator start(Database.BatchableContext BC)
    {
  		system.debug(query);
  		return database.getQueryLocator(query);   		
    }
		
	global void execute(Database.BatchableContext BC, list <Searches__c> scope) 
   	{
   		Set<String> searchNames = new Set<String>();
   		List<Task> tasks = new List<Task>();
   		
		for(Searches__c search : scope) 
    	{
    		Task task = new Task();
			task.RecordTypeId = RecordTypeHelper.unsentNTVTaskRT();
    		task.Type = 'Send NTV';
    		task.Subject = 'Send NTV Via ' + search.NTV_Send_Via__c;
    		task.Status = 'Unsent';
    		task.WhoId = search.NTV_Send_To__c;
    		task.WhatId = search.Service_Request__c;
    		task.Placement__c = search.Placement__c;
   			task.ActivityDate = Util.getNTVTaskDueDate(search.Date_To_Send_NTV__c,search.NTV_Send_Via__c).date();
    		task.OwnerId = search.Service_Request__r.Opportunity__r.Customer_Care_Specialist__c;
    		task.Selected_Search__c = search.Id;
    		task.Service_Request__c = search.Service_Request__c;
 	    	tasks.add(task);
 
    		search.Active_NTV_Task__c = true;
    		searchNames.add(search.Name);
    	}

    	insert tasks;
    	update scope;

    	system.debug(searchNames);
	}
	
	global void finish(Database.BatchableContext BC) 
	{
		
	}
	
}