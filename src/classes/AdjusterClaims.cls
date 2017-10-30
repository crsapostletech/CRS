global class AdjusterClaims implements Database.Batchable<sObject>
{
	Public String query { get; set;}  
		  
    global database.queryLocator start(Database.BatchableContext BC)
    {
  		return database.getQueryLocator(query);   		
    }

    global void execute(Database.BatchableContext BC, list <Opportunity> scope) 
    {
		Set<Id> contactIds = new Set<Id>();
		Set<Id> opportunityIds = new Set<Id>();
		for(Opportunity opportunity : scope) 
    	{
    		if (opportunity.Adjuster__c != null)
    		{
    			contactIds.add(opportunity.Adjuster__c);
    		}
    		if (opportunity.Called_In_By__c != null)
    		{
    			contactIds.add(opportunity.Called_In_By__c);
    		}
    		opportunityIds.add(opportunity.Id);
    	}
    	
    /*	List<OpportunityContactRole> ocrs = [SELECT ContactId, OpportunityId, CreatedDate FROM OpportunityContactRole WHERE Role = 'Called In By' and OpportunityId in: opportunityIds ORDER BY CreatedDate];
		
		
		for(OpportunityContactRole ocr : ocrs) 
    	{
    		if (ocr.ContactId != null)
    		{
    			contactIds.add(ocr.ContactID);
    		}
    	}
	*/   
		
		// Create a list of contacts that will be updated
		List<Contact> adjusterContacts = [SELECT Id,Total_Finders_Fees_Claims__c,Total_FRV_Claims__c,Total_Hotel_Claims__c,Total_Housing_Claims__c,Called_In_By_Last_Deal__c,Assigned_To_Last_Deal__c FROM Contact WHERE ID in: contactIds];
					
		DateTime assignedDate;
		DateTime calledInDate;
		Id contactIdCalledIn;
		Id contactIdAssigned;
				
		for(Opportunity opportunity : scope) 
    	{
    		assignedDate = null;
    		calledInDate = null;
       		contactIdCalledIn = null;
       		contactIdAssigned = null;
   
    /*		for(OpportunityContactRole ocr: ocrs)
	    	{
				if (ocr.OpportunityId == opportunity.id)
				{
					contactIdCalledIn = ocr.ContactId;
					calledInDate = ocr.CreatedDate;
				}
			}
	*/
		
			if (opportunity.Adjuster__c != null)
			{
    			contactIdAssigned = opportunity.Adjuster__c;
				if (opportunity.Adjuster_Changed_Date__c != null)
				{
					assignedDate = opportunity.Adjuster_Changed_Date__c;
				}
				else
				{
					assignedDate = opportunity.CreatedDate;

				}
			}

			if (opportunity.Called_In_By__c != null)
			{
    			contactIdCalledIn = opportunity.Called_In_By__c;
				calledInDate = opportunity.CreatedDate;
			}

		  	if(contactIdCalledIn != null || contactIdAssigned != null)
	    	{
		   	    if(opportunity.Initial_Service_Request__c == 'Housing')
	    	    {
	    	    	// This is a housing or hotel into housing
	    	    	for(Contact contactHousing : adjusterContacts) 
	    	    	{
						if (contactHousing.Id == contactIdAssigned)
						{
							if (assignedDate != null)
							{
								if (Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day()) > contactHousing.Assigned_To_Last_Deal__c || contactHousing.Assigned_To_Last_Deal__c == null)
	    	    				{
	    	    					contactHousing.Assigned_To_Last_Deal__c = Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day());	 	
	    	    				}
    	    				}
     					}
						if (contactHousing.Id == contactIdCalledIn)
						{
							if (calledInDate != null)
							{
								if (Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day()) > contactHousing.Called_In_By_Last_Deal__c || contactHousing.Called_In_By_Last_Deal__c == null)
	    	    				{
	    	    					contactHousing.Called_In_By_Last_Deal__c = Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day());	 	
	    	    				}
    	    				}
     					    if (contactHousing.Total_Housing_Claims__c != null)
    	    				{	
								contactHousing.Total_Housing_Claims__c = contactHousing.Total_Housing_Claims__c + 1;
    	    				}
    	    				else
    	    				{
    	    					contactHousing.Total_Housing_Claims__c = 1;
    	    				}
	    	    		}
					}
				}
	    	    else
	    	    {
	    	    	if(opportunity.Initial_Service_Request__c == 'Hotel')
	    	    	{
			   	    	// This is a hotel 
			   	    	for(Contact contactHotel: adjusterContacts)
		    	    	{
							if (contactHotel.Id == contactIdAssigned)
							{
								if (assignedDate != null)
								{
									if (Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day()) > ContactHotel.Assigned_To_Last_Deal__c || ContactHotel.Assigned_To_Last_Deal__c == null)
		    	    				{
		    	    					ContactHotel.Assigned_To_Last_Deal__c = Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day());	 	
		    	    				}
	    	    				}
	     					}
							if (ContactHotel.Id == contactIdCalledIn)
							{
								if (calledInDate != null)
								{
									if (Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day()) > ContactHotel.Called_In_By_Last_Deal__c || ContactHotel.Called_In_By_Last_Deal__c == null)
		    	    				{
		    	    					ContactHotel.Called_In_By_Last_Deal__c = Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day());	 	
		    	    				}
	    	    				}
     							if (ContactHotel.Total_Hotel_Claims__c != null)
	    	    				{	
									ContactHotel.Total_Hotel_Claims__c = ContactHotel.Total_Hotel_Claims__c + 1;
	    	    				}
	    	    				else
	    	    				{
	    	    					ContactHotel.Total_Hotel_Claims__c = 1;
	    	    				}
							}
						} 
	    	    	}
	    	    	else
	    	    	{
		    	    	if(opportunity.Initial_Service_Request__c == 'FRV')
		    	    	{
				   	    	// This is a FRV 
				   	    	for(Contact contactFRV: adjusterContacts)
			    	    	{
								if (contactFRV.Id == contactIdAssigned)
								{
									if (assignedDate != null)
									{
										if (Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day()) > contactFRV.Assigned_To_Last_Deal__c || contactFRV.Assigned_To_Last_Deal__c == null)
			    	    				{
			    	    					contactFRV.Assigned_To_Last_Deal__c = Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day());	 	
			    	    				}
		    	    				}
		     					}
								if (contactFRV.Id == contactIdCalledIn)
								{
									if (calledInDate != null)
									{
										if (Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day()) > contactFRV.Called_In_By_Last_Deal__c || contactFRV.Called_In_By_Last_Deal__c == null)
			    	    				{
			    	    					contactFRV.Called_In_By_Last_Deal__c = Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day());	 	
			    	    				}
		    	    				}
		     						if (contactFRV.Total_FRV_Claims__c != null)
		    	    				{	
										contactFRV.Total_FRV_Claims__c = contactFRV.Total_FRV_Claims__c + 1;
		    	    				}
		    	    				else
		    	    				{
		    	    					contactFRV.Total_FRV_Claims__c = 1;
		    	    				}
			    	    		}
							} 
		    	    	}
		    	    	else
	    	    		{
			    	    	if(opportunity.Initial_Service_Request__c == 'Finders Fees')
			    	    	{
					   	    	// This is a Finders Fees 
					   	    	for(Contact contactFindersFees: adjusterContacts)
				    	    	{
									if (contactFindersFees.Id == contactIdAssigned)
									{
										if (assignedDate != null)
										{
											if (Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day()) > contactFindersFees.Assigned_To_Last_Deal__c || contactFindersFees.Assigned_To_Last_Deal__c == null)
				    	    				{
				    	    					contactFindersFees.Assigned_To_Last_Deal__c = Date.newInstance(assignedDate.year(),assignedDate.month(),assignedDate.day());	 	
				    	    				}
			    	    				}
			     					}
									if (contactFindersFees.Id == contactIdCalledIn)
									{
										if (calledInDate != null)
										{
											if (Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day()) > contactFindersFees.Called_In_By_Last_Deal__c || contactFindersFees.Called_In_By_Last_Deal__c == null)
				    	    				{
				    	    					contactFindersFees.Called_In_By_Last_Deal__c = Date.newInstance(calledInDate.year(),calledInDate.month(),calledInDate.day());	 	
				    	    				}
			    	    				}
			     						if (contactFindersFees.Total_Finders_Fees_Claims__c != null)
			    	    				{	
											contactFindersFees.Total_Finders_Fees_Claims__c = contactFindersFees.Total_Finders_Fees_Claims__c + 1;
			    	    				}
			    	    				else
			    	    				{
			    	    					contactFindersFees.Total_Finders_Fees_Claims__c = 1;
			    	    				}
				    				}
								} 
			    	    	}
	    	    		}
	    	    	}
	    	    }
	       	}
    	}
    	update adjusterContacts; 
    } 

    global void finish(Database.BatchableContext ctx)
    {

    }
}