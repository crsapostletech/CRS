global class PreCheckoutTaskCreator implements Database.Batchable<sObject>, Database.Stateful 
{

	DateTime currentDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	DateTime min72hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	DateTime max72hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	DateTime min24hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	DateTime max24hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	DateTime minShortTermDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
	String query;


	global database.queryLocator start(Database.BatchableContext BC)
    {
     	// Calculate min and max business days out from current date
    	min72hrDate = min72hrDate.AddDays(3);
		max72hrDate = max72hrDate.AddDays(3);
		min24hrDate = min24hrDate.AddDays(1);
		max24hrDate = max24hrDate.AddDays(1);
		minShortTermDate = minShortTermDate.AddDays(-2);
	
		
		if (currentDate.format('u') == '1' || currentDate.format('u') == '2')
		{
			minShortTermDate = minShortTermDate.AddDays(-2);
		}
		else
		{
			if (currentDate.format('u') == '3')
			{
				max72hrDate = max72hrDate.AddDays(2);
			}
			else
			{
				if (currentDate.format('u') == '4' || currentDate.format('u') == '5')
				{
					min72hrDate = min72hrDate.AddDays(2);
					max72hrDate = max72hrDate.AddDays(2);

					if (currentDate.format('u') == '5')
					{
						max24hrDate = max24hrDate.AddDays(2);
					}
				}				
			}
		}

  		// Get all Hotel Rooms that need a checkout task created
  		query = 'select Id,Name, Estimated_Check_Out_Date__c,Placement__r.Opportunity__r.Policyholder__c,Placement__r.Opportunity__r.Adjuster__c,Placement__r.ServiceRequest__c,' +
		        'Placement__c,Placement__r.Opportunity__r.Hotel_Customer_Care_Specialist__c,Placement__r.Opportunity__r.Account.Parent.Name,' +
			    'Placement__r.Opportunity__r.Account.Name,Placement__r.Opportunity__r.Account.BillingCity,Placement__r.Opportunity__r.Policyholder__r.Smagicinteract__SMSOptOut__c,' + 
			    'Placement__r.Opportunity__r.Policyholder__r.MobilePhone from Hotel_Room__c ' +
			    'where (CheckOut__c = null and Estimated_Check_Out_Date__c >= ' + min72hrDate.format('YYYY-MM-dd') + ' and Estimated_Check_Out_Date__c <= ' + max72hrDate.format('YYYY-MM-dd') + ' and Check_In__c < ' + currentDate.format('YYYY-MM-dd') + ') or ' +
			    '(CheckOut__c = null and Estimated_Check_Out_Date__c >= ' + min24hrDate.format('YYYY-MM-dd') + ' and Estimated_Check_Out_Date__c <= ' + max24hrDate.format('YYYY-MM-dd') + ' and ((Check_In__c >= ' + minShortTermDate.format('YYYY-MM-dd') + 
			    ' ) or (Previous_Estimated_Check_Out_Date__c >= ' + minShortTermDate.format('YYYY-MM-dd') + '))) order by placement__r.serviceRequest__c';
  		
  		system.debug(query);
  		return Database.getQueryLocator(query); 

    }
		
	global void execute(Database.BatchableContext BC, list <Hotel_Room__c> scope) 
   	{
   		Set<String> hotelRoomNames = new Set<String>();
   		List<Task> tasks = new List<Task>();
   		DateTime activityDateWithTime = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 18, 0, 0); 
   		Id old72HourTaskSR;
   		Id old24HourTaskSR;
   		   		
		
		for(Hotel_Room__c hotelRoom : scope) 
		{
			if (hotelRoom.Estimated_Check_Out_Date__c >= min72hrDate.date() && hotelRoom.Estimated_Check_Out_Date__c <= max72hrDate.date())
    		{
    			
    			if (old72HourTaskSR != hotelRoom.Placement__r.ServiceRequest__c)
    			{
	    			old72HourTaskSR = hotelRoom.Placement__r.ServiceRequest__c;

		    		if (hotelRoom.Placement__r.Opportunity__r.Account.Parent.Name != 'Liberty Mutual Insurance Headquarters' && hotelRoom.Placement__r.Opportunity__r.Account.Parent.Name != 'Safeco Insurance Company Headquarters' && hotelRoom.Placement__r.Opportunity__r.Account.Name != 'Safeco Insurance Company Headquarters' && hotelRoom.Placement__r.Opportunity__r.Account.Parent.Name != 'American Family Insurance Headquarters' ||
		    			hotelRoom.Placement__r.Opportunity__r.Account.Parent.Name == 'American Family Insurance Headquarters' && hotelRoom.Placement__r.Opportunity__r.Account.BillingCity != 'Atlanta')
		    		{
		    			// Create 72 hour policyholder follow up task
			 	    	tasks.add(TaskBuilder.x72HourPHContact(hotelRoom.Placement__c,hotelRoom.Placement__r.ServiceRequest__c,hotelRoom.Placement__r.Opportunity__r.Policyholder__c,hotelRoom.Placement__r.Opportunity__r.Hotel_Customer_Care_Specialist__c));	
			 	    }
			 	    else
			 	    {
			 	    	// Create 72 hour adjuster follow up task
			    		tasks.add(TaskBuilder.x72HourADJContact(hotelRoom.Placement__c,hotelRoom.Placement__r.ServiceRequest__c,hotelRoom.Placement__r.Opportunity__r.Policyholder__c,hotelRoom.Placement__r.Opportunity__r.Hotel_Customer_Care_Specialist__c));	
			 	    }
		 		}
		 	}
		 	else
		 	{
	 			if (old24HourTaskSR != hotelRoom.Placement__r.ServiceRequest__c)
	 			{
	 				old24HourTaskSR = hotelRoom.Placement__r.ServiceRequest__c;

		 			// Create 24 hour follow up task
					tasks.add(TaskBuilder.x24HourContact(hotelRoom.Placement__c,hotelRoom.Placement__r.ServiceRequest__c,hotelRoom.Placement__r.Opportunity__r.Policyholder__c,hotelRoom.Placement__r.Opportunity__r.Hotel_Customer_Care_Specialist__c));	
	 	    	}
		 	}
			
    		hotelRoomNames.add(hotelRoom.Name);
    	}

    	insert tasks;
    	
    	system.debug(hotelRoomNames);  
	}
	
	global void finish(Database.BatchableContext BC) 
	{
		
	}
	
}