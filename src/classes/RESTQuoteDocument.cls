@RestResource(urlMapping='/Quote/QuoteDocument/*')
global class RESTQuoteDocument {
	@HttpPost
	global static String insertQuoteDocument(RestRequest req)  
	{ 
		string placementId = req.params.get('placementId');
		string quoteName = req.params.get('quoteName');
		string quoteId = req.params.get('quoteId');
	    string taskDescription;
	    
	    // test endpoint
        taskDescription = 'Attached File:\r\nhttps://c.cs1.content.force.com/servlet/servlet.FileDownload?file='; 
	    
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
        {
        	// production endpoint
        	taskDescription = 'Attached File:\r\nhttps://na5.salesforce.com/servlet/servlet.FileDownload?file=';    
        }
	    
	    Attachment attachment = new Attachment();
	    attachment.ParentId = placementId;
	    attachment.Name = quoteName + '.pdf';
	    attachment.Body = req.requestBody;
	    insert attachment;
	    
	    Task task = new Task();
	    task.Subject = 'Quote Document Generated - ' + quoteName + '.pdf';
	    task.Status = 'Completed';
	    task.WhatId = placementId;
	    task.ActivityDate = Date.today();
	    task.Description = taskDescription + attachment.Id;
	    insert task;
	    
	   	try
	    {
	    	Quote__c quote = [select quote_Document_Recieved__c from Quote__c where Id =: quoteId];
	    	quote.Quote_Document_Recieved__c = true;
	   		update quote;
	    }
	    catch (QueryException e)
        {
        	 Util.sendErrorEmail('Error updating Quote_Document_Recieved__c field','ERROR: ' + e + ' on quote ' + quoteName);		
        }
            
        return 'Quote document recieved';
	}
	
}