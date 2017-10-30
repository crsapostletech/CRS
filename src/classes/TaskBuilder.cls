public with sharing class TaskBuilder 
{
	// Credit Card Authorization Send Document Task
	public static Task ccAuth(Id placementId,Id srID, Id whoId, Id ownerId) 
    {
    	Integer currentHour = System.now().hour();
	    Date activityDate;
	    DateTime activityDateWithTime;
	    if(currentHour < 17)
	    {
	        activityDate = Date.toDay();                                   
	        activityDateWithTime = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
	    }
	    else
	    {
	        Date nextDayDate = Date.toDay().addDays(1);
	        DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);                                   
	                                        
	        activityDate = nextDayDate;
	        activityDateWithTime = dueDateTime;
	    }

    	Task ccAuth = new Task();
        ccAuth.Subject = 'Send Credit Card Authorization (CCA)';                     
        ccAuth.OwnerId = ownerId;
        ccAuth.Priority = 'High';                     
        ccAuth.Status = 'Not Started';                                                           
        ccAuth.Type = 'Send Document';
        ccAuth.WhoId = whoId;
        ccAuth.Service_Request__c = srId;
        ccAuth.WhatID = srId;
        ccAuth.Placement__c = placementId;
        ccAuth.ActivityDate = activityDate;                                   
        ccAuth.Due_Time__c = activityDateWithTime; 

        return ccAuth;
	}

	// Adjuster Confirmation Send Document Task
	public static Task adjConfirmation(Id placementId,Id srId, Id whoId, Id ownerId) 
    {
    	Integer currentHour = System.now().hour();
	    Date activityDate;
	    DateTime activityDateWithTime;
	    if(currentHour < 17)
	    {
	        activityDate = Date.toDay();                                   
	        activityDateWithTime = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
	    }
	    else
	    {
	        Date nextDayDate = Date.toDay().addDays(1);
	        DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);                                   
	                                        
	        activityDate = nextDayDate;
	        activityDateWithTime = dueDateTime;
	    }

    	Task adjConfirmation = new Task();
        adjConfirmation.Subject = 'Send Adjuster Confirmation';                      
        adjConfirmation.OwnerId = ownerId;
        adjConfirmation.Priority = 'High';                     
        adjConfirmation.Status = 'Not Started';                                                           
        adjConfirmation.Type = 'Send Document';
        adjConfirmation.WhoId = whoId;
        adjConfirmation.Service_Request__c = srId;
        adjConfirmation.WhatID = srId;
        adjConfirmation.Placement__c = placementId;
        adjConfirmation.ActivityDate = activityDate;                                   
        adjConfirmation.Due_Time__c = activityDateWithTime; 

        return adjConfirmation;
	}

    // 72 Hour Policyholder Follow Up Task
    public static Task x72HourPHContact(Id placementId, Id srId, Id whoId, Id ownerId) 
    {
        
        DateTime activityDateWithTime = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 18, 0, 0);

        Task x72HourPHContact = new Task();
        x72HourPHContact.RecordTypeId = RecordTypeHelper.x72HourPHContactTaskRT();
        x72HourPHContact.Type = '72 Hour Policyholder Follow Up';
        x72HourPHContact.Subject = '72 Hour Policyholder Follow Up';
        x72HourPHContact.WhoId = whoId;
        x72HourPHContact.WhatId = srId;
        x72HourPHContact.Placement__c = placementId;
        x72HourPHContact.ActivityDate = Date.Today();
        x72HourPHContact.Due_Time__c = activityDateWithTime;
        x72HourPHContact.OwnerId = ownerId;
        x72HourPHContact.Service_Request__c = srId;

        return x72HourPHContact;
    }

	// 72 Hour Adjuster Follow Up Task
	public static Task x72HourADJContact(Id placementId, Id srId, Id whoId, Id ownerId) 
    {
    	
    	DateTime activityDateWithTime = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 18, 0, 0);

    	Task x72HourADJContact = new Task();
        x72HourADJContact.RecordTypeId = RecordTypeHelper.x72HourADJContactTaskRT();
        x72HourADJContact.Type = '72 Hour Adjuster Follow Up';
        x72HourADJContact.Subject = '72 Hour Adjuster Follow Up';
        x72HourADJContact.WhoId = whoId;
        x72HourADJContact.WhatId = srId;
        x72HourADJContact.Placement__c = placementId;
        x72HourADJContact.ActivityDate = Date.Today();
        x72HourADJContact.Due_Time__c = activityDateWithTime;
        x72HourADJContact.OwnerId = ownerId;
        x72HourADJContact.Service_Request__c = srId;

        return x72HourADJContact;
	}

    // 24 Hour Follow Up Task
    public static Task x24HourContact(Id placementId, Id srId, Id whoId, Id ownerId) 
    {
        
        DateTime activityDateWithTime = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 18, 0, 0);

        Task x24HourContact = new Task();
        x24HourContact.RecordTypeId = RecordTypeHelper.x24HourFollowUpTaskRT();
        x24HourContact.Type = '24 Hour Follow Up';
        x24HourContact.Subject = '24 Hour Follow Up';
        x24HourContact.WhoId = whoId;
        x24HourContact.WhatId = srId;
        x24HourContact.Placement__c = placementId;
        x24HourContact.ActivityDate = Date.Today();
        x24HourContact.Due_Time__c = activityDateWithTime;
        x24HourContact.OwnerId = ownerId;
        x24HourContact.Service_Request__c = srId;

        return x24HourContact;
    }

}