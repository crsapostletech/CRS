@RestResource(urlMapping='/HotelRoom/HotelAuthorization/*')
global class RESTHotelAuthorization {
	@HttpPost
	global static String insertHotelAuthorization(RestRequest req) {
		string serviceRequestId = req.params.get('serviceRequestId');
	    string userId = req.params.get('userId');
	    string taskDescription;
	    
	    // test endpoint
        taskDescription = 'Attached File:\r\nhttps://test.salesforce.com/servlet/servlet.FileDownload?file='; 
	    
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
        {
        	// production endpoint
        	taskDescription = 'Attached File:\r\nhttps://login.salesforce.com/servlet/servlet.FileDownload?file=';    
        }
	    
	    Attachment attachment = new Attachment();
	    attachment.ParentId = serviceRequestId;
	    attachment.Name = 'CRS CC Auth Hotel.pdf';
	    attachment.Body = req.requestBody;
	    insert attachment;
	    
	    Task task = new Task();
	    task.Subject = 'Hotel Authorization Generated';
	    task.Status = 'Completed';
	    task.WhatId = serviceRequestId;
	    task.ActivityDate = Date.today();
	    task.OwnerId = userId;
	    task.Description = taskDescription + attachment.Id;
	    insert task;
	    
		return 'Hotal Authorization saved';
	}
}