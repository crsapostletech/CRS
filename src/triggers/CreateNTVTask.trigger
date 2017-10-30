trigger CreateNTVTask on Placement__c (after update) 
{
    Set<Id> createNTVTaskForSearchIds1 = new Set<Id>();  //NTV tasks for Moved-In placements that have a Date To Send NTV past the min date to send
    Set<Id> createNTVTaskForSearchIds2 = new Set<Id>();  //NTV tasks for Early Move Outs that have NTV Required checked
    Set<Id> updateNTVTaskForSearchIds = new Set<Id>();   //NTV tasks needing updating on extension
    Set<Id> updatePlacementIds = new Set<Id>();          //Placements that need the Create NTV Task field unchecked
    Set<Id> searchIds = new Set<Id>();                   //Searches that need to have their tasks cancelled before new task can be created   
    
    integer i = 0; 
    
    for (Placement__c placement : Trigger.new) 
    {
        if (Trigger.old[i].Status__c != Trigger.new[i].Status__c && Trigger.new[i].Status__c == 'Moved-In')
        {
            createNTVTaskForSearchIds1.add(Trigger.new[i].Selected_Search__c);
        }
        else
        {
            if (Trigger.new[i].Create_NTV_Task__c)
            {
                createNTVTaskForSearchIds2.add(Trigger.new[i].Selected_Search__c);
                updatePlacementIds.add(placement.Id); 
            }
            else
            {
                if (Trigger.old[i].Approved_Through_Date__c < Trigger.new[i].Approved_Through_Date__c && Trigger.new[i].Selected_Search__c != null)
                {
                    updateNTVTaskForSearchIds.add(Trigger.new[i].Selected_Search__c);
                }
            }
        }
    }

    if (!createNTVTaskForSearchIds1.isEmpty() || !createNTVTaskForSearchIds2.isEmpty())
    {
        DateTime minNTVDateEmailFax = Util.getMinNTVDate('Email');
        DateTime minNTVDateMailInsured = Util.getMinNTVDate('Insured');       
    
        List<Searches__c> searches = [select Id,Name,Active_NTV_Task__c,Date_To_Send_NTV__c,NTV_Send_Via__c,NTV_Send_To__c,Service_Request__c,Placement__c,Service_Request__r.Opportunity__r.Customer_Care_Specialist__c from Searches__c where (Id = : createNTVTaskForSearchIds1 and Active_NTV_Task__c = false and Date_To_Send_NTV__c <: minNTVDateEmailFax.date() and NTV_Send_Via__c in ('Email', 'Fax')) or (Id = : createNTVTaskForSearchIds1 and Active_NTV_Task__c = false and Date_To_Send_NTV__c <: minNTVDateMailInsured.date() and NTV_Send_Via__c in ('Certified Mail', 'Insured')) or (Id = : createNTVTaskForSearchIds2)];
        
        Set<String> searchNames = new Set<String>();
        List<Task> tasks = new List<Task>();
        
        for(Searches__c search : searches) 
        {
        
            if (search.Active_NTV_Task__c == true)
            {    
                // Task already exists for this search so add it to the list of searchIds 
                searchIds.add(search.Id);
            }

            Task task = new Task();
            task.RecordTypeId = RecordTypeHelper.unsentNTVTaskRT();
            task.Type = 'Send NTV';
            task.Subject = 'Send NTV Via ' + search.NTV_Send_Via__c;
            task.Status = 'Unsent';
            task.WhoId = search.NTV_Send_To__c;
            task.WhatId = search.Service_Request__c;
            task.Placement__c = search.Placement__c;
            task.ActivityDate =  Util.getNTVTaskDueDate(search.Date_To_Send_NTV__c,search.NTV_Send_Via__c).date();
            task.OwnerId = search.Service_Request__r.Opportunity__r.Customer_Care_Specialist__c;
            task.Selected_Search__c = search.Id;
            task.Service_Request__c = search.Service_Request__c;
            tasks.add(task);
 
            // Set Active NTV Task to true so that no duplicate NTV tasks will get created for this search
            search.Active_NTV_Task__c = true;
            
            searchNames.add(search.Name);
        }

        if(!searchIds.isEmpty())
        {
            // Get ntv tasks related to searchIds and set them to cancelled status

            List<Task> ntvTasksToCancel = [select id from Task where Selected_Search__c =: searchIds and RecordTypeID !=: RecordTypeHelper.closedNTVTaskRT()];
            
            for(Task ntvTaskToCancel : ntvTasksToCancel)
            {
                ntvTaskToCancel.Status = 'Cancelled';
            }
            update ntvTasksToCancel;
        }

        insert tasks;
        update searches;

        system.debug('NTV Tasks created for the following searches: ' + searchNames);

 
        if (!updatePlacementIds.isEmpty())
        {
            // Get placements that had their create ntv task flag set to true (mulligan early move out - NTV required) and set it to false
      
            List<Placement__c> placements = [select Id from Placement__c where Id =: updatePlacementIds];

            for (Placement__c placement : placements)
            {
                placement.Create_NTV_Task__c = false;
            }
            update placements;    
        }

    } 

    if (!updateNTVTaskForSearchIds.isEmpty())
    {       
        
        // Update of Cancel tasks when an extension is done

        Set<Id> updateSearchIds = new Set<Id>(); 

        List<Task> ntvTasks = [select id,Selected_Search__c,Selected_Search__r.Date_To_Send_NTV__c,Selected_Search__r.NTV_Send_Via__c from Task where Selected_Search__c =: updateNTVTaskForSearchIds and RecordTypeID !=: RecordTypeHelper.closedNTVTaskRT()];

        for(Task task : ntvTasks)
        {
            if (task.Selected_Search__r.Date_To_Send_NTV__c > Util.getMinNTVDate(task.Selected_Search__r.NTV_Send_Via__c)) 
            {
                // Date to Send NTV is greater than the earliest day to create the ntv task so set status to cancelled
                task.Status = 'Cancelled';
                updateSearchIds.add(task.Selected_Search__c);
            }
            else
            {
                // Date to Send NTV is less than or equal to the earliest day to create the ntv task so update the due date 
                task.ActivityDate = Util.getNTVTaskDueDate(task.Selected_Search__r.Date_To_Send_NTV__c,task.Selected_Search__r.NTV_Send_Via__c).date();
            }   
        }

        update ntvTasks;

        if (!updateSearchIds.isEmpty())
        {
            List<Searches__c> updateSearches = [select id,Active_NTV_Task__c from searches__c where Id =: updateSearchIds];
            for (Searches__c updateSearch : updateSearches)
            {
                // Set Active NTV Task to true so that no duplicate NTV tasks will get created for this search
                updateSearch.Active_NTV_Task__c = false;
            }
            update updateSearches;
        } 
    }   
}