public with sharing class CallOutsToMulligan 
{
	static string instanceName = util.getInstanceName();
	
	// Future annotation to mark the method as async.
    @Future(callout=true)
    public static void SetBillingCompleted(Id placementId)  
    {
        HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
                       
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/Services/SetBillingCompleted?recordId=' + placementId);
                 
        req.setHeader ('content-length','0');
        req.setMethod('POST');
    
        // Send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        new CustomCalloutException();
        
        // Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
                res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
            }
        }
        catch(System.CalloutException e) 
        {
        	system.debug(e.getMessage());
            throw new CustomCalloutException('ERROR: ' + e + ' setting billing completed in Mulligan: ' + placementId);
        }
        
        System.Debug(res);  
        if (res.getStatusCode() != 200) 
        {
            throw new CustomCalloutException('Http response ' + res.getStatusCode() + ' ' + res.getStatus() + ' setting billing completed in Mulligan: ' + placementId);
        }
    }
    
    // Future annotation to mark the method as async.
    @Future(callout=true)
    public static void pushUpdates(string objectType, Boolean isDelete, Set<Id> updatedRecordIds, string actionType) 
    {
  
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeStringField('type', objectType);
        gen.writeBooleanField('isDelete', isDelete);
        gen.writeObjectField('recordIds', updatedRecordIds);
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
              
        HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
        
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/SalesForceCache/Changes');
             
        req.setHeader ('content-length',JSONString.length().format());
        req.setMethod('POST');
                  
        req.setBody(JSONString);
        
        // Send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        new CustomCalloutException();
        
        // Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
                res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
            }
        }
        catch(System.CalloutException e) 
        {
            System.Debug(e.getMessage());
            throw new CustomCalloutException('ERROR: ' + e + ' pushing the following ' + actionType + ' ' + objectType + ' ids ' + updatedRecordIds + ' to the cache');
        }
             
        System.Debug(objectType);
        System.Debug(isDelete);  
        System.Debug(updatedRecordIds);  
        System.Debug(actionType);  

        if (res.getStatusCode() != 200) 
        {
            throw new CustomCalloutException('Http response ' + res.getStatusCode() + ' pushing the following ' + actionType + ' ' + objectType + ' ids ' + updatedRecordIds + ' to the cache');
        }
    }
    
     public static void pushUpdatesSync(string objectType, Boolean isDelete, Set<Id> updatedRecordIds, string actionType) 
     {
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeStringField('type', objectType);
        gen.writeBooleanField('isDelete', isDelete);
        gen.writeObjectField('recordIds', updatedRecordIds);
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
              
        HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
        
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/SalesForceCache/Changes');
               
        req.setHeader ('content-length',JSONString.length().format());
        req.setMethod('POST');
                  
        req.setBody(JSONString);
        
        //send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        new CustomCalloutException();
        
        //Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
                res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
            }
        }
        catch(System.CalloutException e) 
        {
            System.Debug(e.getMessage());
            throw new CustomCalloutException('ERROR: ' + e + ' pushing the following ' + actionType + ' ' + objectType + ' ids ' + updatedRecordIds + ' to the cache');
        }
             
        System.Debug(objectType);
        System.Debug(isDelete);  
        System.Debug(updatedRecordIds);  
        System.Debug(actionType);  
        
        if (res.getStatusCode() != 200) 
        {
            throw new CustomCalloutException('Http response ' + res.getStatusCode() + ' pushing the following ' + actionType + ' ' + objectType + ' ids ' + updatedRecordIds + ' to the cache');
        }
    }
    
    //Future annotation to mark the method as async.
    @Future(callout=true)    
    public static void pushNewQuoteInformation(Id quoteId)  
    {
        boolean costs = true;
                
        Quote__c quote = [select Id,Claim_Name__c,Claim_Entity__c,Searches__c,Status__c,Contract_Number__c,Move_In_Date__c,Approved_Through_Date__c,Claim_Team_Number__c,
         						 Temporary_Address_New__c,Billing_Preference__c,Housewares_Provided_New__c,Appliances_Provided_New__c,Days_Notice_Required_New__c,
         						 Bedrooms_New__c,Number_Of_Children_New__c,Number_Of_Adults_New__c,Number_Of_Pets_New__c,Initial_Check_Delivery_Method__c,
         						 Initial_Payment_Type__c,Adjuster__c,Policyholder__c,Claim_Number_New__c,Property_Type_New__c,Landlord__c,Adjuster_To_Pay__c,
         						 Return_Deposit_To_New__c,Name,Claim_Owner__c,Placement_Lookup__c,Special_Instructions_New__c,Markup__c,Markup_Adjustment__c,Prorate__c,
         						 Prorate_Adjustment__c,Damaged_Property_State__c,Damaged_Property_Zip__c,Adjuster_Name__c,Policyholder_Name__c,
         						 Adjuster_Account_Name__c,Adjuster_Phone__c,Adjuster_Fax__c,Furniture_Option__c
         				  from Quote__c where Id =: quoteId];
        
        List<Quote_Costs__c> quoteCosts = new List<Quote_Costs__c>();
        
        try
        {
        	quoteCosts = [select Record_Type_Name__c,Start_Date__c,End_Date__c,Amount__c,Type__c,Type_Description__c,Billable_Party__c,Payable_Party__c,
        						 Prorate_Type__c
        				  from Quote_Costs__c where Quote__c =: quoteId];
        }
        catch (QueryException e)
        {
        	costs = false;
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('quote', quote);
        if (costs)
        {
	      	gen.writeObjectField('cost', quoteCosts);
        }    
                  
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
   
   		system.debug(JSONString);
        
        // Modify JSON string for mulligan 
        JSONString = JSONString.replace('"quote" : {\n','');
        JSONString = JSONString.replace('\n  },\n  "Costs"',',\n  "Costs"');
                
        system.debug(JSONString);
    		
   		// Callout stuff:
 		HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
        
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/HousingQuote/Create');
              
        req.setHeader ('content-length',JSONString.length().format());
        req.setHeader ('content-type', 'application/json');
        req.setMethod('POST');
                  
        req.setBody(JSONString);
        
        // Send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        new CustomCalloutException();
        
        //Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
                res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
            }
        }
        catch(System.CalloutException e) 
        {
            System.Debug(e.getMessage());
            throw new CustomCalloutException('ERROR: ' + e + ' sending a quote. JSON: ' + JSONString);
        }
             
        if (res.getStatusCode() != 200) 
        {
            throw new CustomCalloutException('Http response ' + res.getStatusCode() + ' sending a quote. JSON: ' + JSONString);
        }
    }
    
    public static boolean pushUpdatedQuoteInformation(Id quoteId, string quoteStatus)    
    { 
       	Map<Id,String> updatedQuote = new Map<Id,String>();
    	updatedQuote.put(quoteId,quoteStatus);
    	JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
      	gen.writeStringField('Id', quoteId);
     	gen.writeStringField('Status', quoteStatus);
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
       
        system.debug(JSONString);
              
        
   		// Callout stuff:
        HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
               
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/HousingQuote/ProcessStatusChange');
                       
        req.setHeader ('content-length',JSONString.length().format());
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
                  
        req.setBody(JSONString);
        
        // Send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        new CustomCalloutException();
        
        // Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
                res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
            }
        }
        catch(System.CalloutException e) 
        {
            Util.sendErrorEmail('Error updating quote status in the billing system','ERROR: ' + e + ' updating quote status to ' + quoteStatus + ' for quote Id ' + quoteId);
            return false;
        }
             
        System.Debug(res);  
        if (res.getStatusCode() != 200)  
        {
           	Util.sendErrorEmail('Error updating quote status in the billing system','Recieved Http response ' + res.getStatusCode() + ' updating quote status to ' + quoteStatus + ' for quote Id ' + quoteId);
        	return false; 
        }
        else
        {
        	return true;
        }
    }
    
    public static Decimal getProrateAmount(Id housingPlacementId, Id selectedSearchId)  
    {
    	Decimal prorate;
    	List<Costs__c> costs = new List<Costs__c>();
    	try
    	{
    		costs = [select Start_Date__c,End_Date__c,Amount__c,Prorate_Type__c from Costs__c where RecordTypeId =: RecordTypeHelper.costCostsRT() and Payable_Party_is_Landlord__c = true and Searches__c =: selectedSearchId];
    	}
        catch (QueryException e)
        {
        	throw e;
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('costs', costs);
                          
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
   
        system.debug(JSONString);
        
        // Modify JSON string for mulligan 
        JSONString = JSONString.replace('\n  },\n  "Costs"',',\n  "Costs"');
                
        system.debug(JSONString);

              
    	HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
                       
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/services/CalculateProrate');
                    
        req.setHeader ('content-length',JSONString.length().format());
        req.setHeader ('content-type', 'application/json');
        req.setMethod('POST');
                  
        req.setBody(JSONString);
    
        //send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        
        new CustomCalloutException();
        
        // Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
              res = http.send(req);
            }
            else
            {
                res.setStatusCode(200);
                res.setBody('100');
            }
        }
        catch(System.CalloutException e) 
        {
            Util.sendErrorEmail('Error getting prorate from billing system','ERROR: ' + e + ' getting prorate for placement ' + housingPlacementId + ' from the billing system');
           
        	return -1;
        }
             
        System.Debug(res);  
        if (res.getStatusCode() != 200) 
        {
            Util.sendErrorEmail('Error getting prorate from billing system','Recieved Http response ' + res.getStatusCode() + ' getting prorate for placement ' + housingPlacementId + ' from the billing system');
           
        	return -1;
        }
        else
        {
        	return  decimal.valueOf(res.getBody());	
        }
    }
    
    public static Decimal getMarkupAmount(Id housingPlacementId, Id selectedSearchId, string contractNumber, string selectedSearchFurnitureOption)   
    {
    	Decimal markup;
    	Costs__c rent;
    	Searches__c search;
    	Costs__c furniture;
    	Furniture_Order__c furnitureOrder; 
    	string startDate;
	    string endDate;
	    string rentAmount;
	    Double numberOfAdults;
	    Double numberOfChildren;
	    Double numberOfPets;
	    string numberPersons;
	    string numberPets;
	    string body;
    	
    	if (selectedSearchFurnitureOption != 'Furniture Only')
    	{
    		try
	    	{
	    		
	    		rent = [select Start_Date__c,End_Date__c,Amount__c,Prorate_Type__c,Searches__r.State__c,Searches__r.Zip__c,
	    					   Searches__r.Property_Type__c,Searches__r.Furniture_Option__c,
	    					   Searches__r.Service_Request__r.Opportunity__r.Number_Of_Adults__c,
	    					   Searches__r.Service_Request__r.Opportunity__r.Number_of_Children__c,
	    					   Searches__r.Service_Request__r.Opportunity__r.Number_Of_Pets__c
	    				from Costs__c where Type__c = 'Rent' and Searches__c =: selectedSearchId];
	    	}
	        catch (QueryException e)
	        {
	        	throw e;
	        }
    	}
    	else
    	{
    		try
	    	{
	    		
	    		search = [select Id,State__c,Zip__c,Property_Type__c,Furniture_Option__c,Placement__r.Move_In_Date__c,
	    						 Placement__r.Approved_Through_Date__c,Service_Request__r.Opportunity__r.Number_Of_Adults__c,
	    					     Service_Request__r.Opportunity__r.Number_of_Children__c,Service_Request__r.Opportunity__r.Number_Of_Pets__c
	    						 from Searches__c where Id =: selectedSearchId];
	    	}
	        catch (QueryException e)
	        {
	        	throw e;
	        }
    	}
             
        try
    	{
        	furnitureOrder = [select Id,Cost__c
                           	  from Furniture_Order__c 
                           	  where Status__c = 'Completed' and Placement__c =: housingPlacementId limit 1];
    	}
    	catch (QueryException e)
        {
        	furnitureOrder = new Furniture_Order__c();
        }
    	    	    	
    	HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
                       
        // Set endpoint
        req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/services/GetMarkup');
               
        string isFurnished;
        string furnitureAmount;
        if (furnitureOrder.Id != null)
        {
        	isFurnished = 'true';
        	Double furnitureCost = furnitureOrder.Cost__c;
        	if (furnitureCost == null)
        	{
        		furnitureCost = 0;
        	}
        	furnitureAmount = string.valueOf(furnitureCost);
        	
        }
        else
        {
        	isFurnished = 'false';
        	furnitureAmount = '0';
        }
        
        if (selectedSearchFurnitureOption != 'Furniture Only')
    	{
	        startDate = string.valueOf(rent.Start_Date__c);
	        endDate = string.valueOf(rent.End_Date__c);
	        if (rent.Prorate_Type__c == 'Daily')
	        {
	        	rentAmount = string.valueOf(rent.Amount__c * 30);
	        }
	        else
	        {
	        	rentAmount = string.valueOf(rent.Amount__c);
	        }
	        
	        numberOfAdults = rent.Searches__r.Service_Request__r.Opportunity__r.Number_Of_Adults__c;
	        numberOfChildren = rent.Searches__r.Service_Request__r.Opportunity__r.Number_Of_Children__c;
	        numberOfPets = rent.Searches__r.Service_Request__r.Opportunity__r.Number_Of_Pets__c;
	        
	        if (numberOfAdults == null)
	        {
	        	numberOfAdults = 0;
	        }
	        if (numberOfChildren == null)
	        {
	        	numberOfChildren = 0;
	        }
	        if (numberOfPets == null)
	        {
	        	numberOfPets = 0;
	        }
	        numberPersons = string.valueOf(numberOfAdults + numberOfChildren);
	        numberPets = string.valueOf(numberOfPets);
    	
    		body = 'ContractNumber=' + EncodingUtil.urlEncode(contractNumber, 'UTF-8') +
        		   '&isFurnished=' + EncodingUtil.urlEncode(isFurnished, 'UTF-8') +
        		   '&StartDate=' + EncodingUtil.urlEncode(startDate, 'UTF-8') +
        	       '&EndDate=' + EncodingUtil.urlEncode(endDate, 'UTF-8') +
        		   '&MonthlyFurnitureRent=' + EncodingUtil.urlEncode(furnitureAmount, 'UTF-8') +
        		   '&MonthlyRent=' + EncodingUtil.urlEncode(rentAmount, 'UTF-8') +
        		   '&NumberPersons=' + EncodingUtil.urlEncode(numberPersons, 'UTF-8') +
        		   '&NumberPets=' + EncodingUtil.urlEncode(numberPets, 'UTF-8') +
        		   '&PlacementId=' + EncodingUtil.urlEncode(housingPlacementId, 'UTF-8') +
        		   '&SearchId=' + EncodingUtil.urlEncode(rent.Searches__c, 'UTF-8') +
        		   '&PropertyType=' + EncodingUtil.urlEncode(rent.Searches__r.Property_Type__c, 'UTF-8') +
        		   '&FurnitureOption=' + EncodingUtil.urlEncode(rent.Searches__r.Furniture_Option__c, 'UTF-8') +
        		   '&State=' + EncodingUtil.urlEncode(rent.Searches__r.State__c, 'UTF-8') +
        		   '&ZIP=' + EncodingUtil.urlEncode(rent.Searches__r.Zip__c, 'UTF-8');
    	}
    	else
    	{
    		startDate = string.valueOf(search.Placement__r.Move_In_Date__c);
	        endDate = string.valueOf(search.Placement__r.Approved_Through_Date__c);
	        rentAmount = '0';
	        numberOfAdults = search.Service_Request__r.Opportunity__r.Number_Of_Adults__c;
	        numberOfChildren = search.Service_Request__r.Opportunity__r.Number_Of_Children__c;
	        numberOfPets = search.Service_Request__r.Opportunity__r.Number_Of_Pets__c;
	               
	        if (numberOfAdults == null)
	        {
	        	numberOfAdults = 0;
	        }
	        if (numberOfChildren == null)
	        {
	        	numberOfChildren = 0;
	        }
	        if (numberOfPets == null)
	        {
	        	numberOfPets = 0;
	        }
	        numberPersons = string.valueOf(numberOfAdults + numberOfChildren);
	        numberPets = string.valueOf(numberOfPets);
    	
    		body = 'ContractNumber=' + EncodingUtil.urlEncode(contractNumber, 'UTF-8') +
        		   '&isFurnished=' + EncodingUtil.urlEncode(isFurnished, 'UTF-8') +
        		   '&StartDate=' + EncodingUtil.urlEncode(startDate, 'UTF-8') +
        		   '&EndDate=' + EncodingUtil.urlEncode(endDate, 'UTF-8') +
        		   '&MonthlyFurnitureRent=' + EncodingUtil.urlEncode(furnitureAmount, 'UTF-8') +
        		   '&MonthlyRent=' + EncodingUtil.urlEncode(rentAmount, 'UTF-8') +
        		   '&NumberPersons=' + EncodingUtil.urlEncode(numberPersons, 'UTF-8') +
        		   '&NumberPets=' + EncodingUtil.urlEncode(numberPets, 'UTF-8') +
        		   '&PlacementId=' + EncodingUtil.urlEncode(housingPlacementId, 'UTF-8') +
        		   '&SearchId=' + EncodingUtil.urlEncode(search.Id, 'UTF-8') +
        		   '&PropertyType=' + EncodingUtil.urlEncode(search.Property_Type__c, 'UTF-8') +
        		   '&FurnitureOption=' + EncodingUtil.urlEncode(search.Furniture_Option__c, 'UTF-8') +
        		   '&State=' + EncodingUtil.urlEncode(search.State__c, 'UTF-8') +
        		   '&ZIP=' + EncodingUtil.urlEncode(search.Zip__c, 'UTF-8');
    	}
    
        system.debug(body);
           
        req.setMethod('POST');
   		req.setHeader ('content-length',body.length().format());	
   		req.setBody(body);
   		    
        //send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        
        new CustomCalloutException();
        
        //Execute web service call here  
        try
        {     
            if (!Test.isRunningTest())
            {
               res = http.send(req); 
            }
            else
            {
                res.setStatusCode(200);
                res.setBody('100');
            }
        }
        catch(System.CalloutException e) 
        {
           	Util.sendErrorEmail('Error getting markup from billing system','ERROR: ' + e + ' getting markup for placement ' + housingPlacementId + ' from the billing system');
	      
        	return -1;
        }
               
        if (res.getStatusCode() != 200) 
        {
           	Util.sendErrorEmail('Error getting markup from billing system','Recieved Http response ' + res.getStatusCode() + ' getting markup for placement ' + housingPlacementId + ' from the billing system');
                   
           	return -1;
        }
        else
        {
        	return  decimal.valueOf(res.getBody());	
        }
    }
}