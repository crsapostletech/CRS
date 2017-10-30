@RestResource(urlMapping='/Placement/THCDocument/*')
global with sharing class RESTTHCDocument 
{ 
	@HttpPost
	global static String insertTHCDocument(RestRequest req)    
	{ 
		string placementId = req.params.get('placementId');
		string taskDescription;
	    
	    // test endpoint
        taskDescription = 'Attached File:\r\nhttps://test.salesforce.com/servlet/servlet.FileDownload?file='; 
	    
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
        {
        	// production endpoint
        	taskDescription = 'Attached File:\r\nhttps://login.salesforce.com/servlet/servlet.FileDownload?file=';    
        }
	    
	    try
	    {
		    Attachment attachment = new Attachment();
		    attachment.ParentId = placementId;
		    attachment.Name = 'THC.pdf';
		    attachment.Body = req.requestBody;
		    insert attachment;
		    
		    Task task = new Task();
		    task.Subject = 'THC Document Generated - THC.pdf';
		    task.Status = 'Completed';
		    task.WhatId = placementId;
		    task.ActivityDate = Date.today();
		    task.Description = taskDescription + attachment.Id;
		    insert task;
	    }
	    catch (Exception e)
        {
        	 Util.sendErrorEmail('Error adding the THC document to placement task list','ERROR: ' + e + ' Placement Id: ' + placementId);		
        }
	    return 'THC document recieved';
	}
	
}