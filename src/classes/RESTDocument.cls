@RestResource(urlMapping='/Documents/*')
global class RESTDocument {
	@HttpPost
	global static String insertDocument() {
		
		RestRequest req = RestContext.request;
		string relatedToId = req.params.get('Id');
	    string userId = req.params.get('userId');
	    string documentName = req.params.get('name');
	    string taskDescription;
	    
	    taskDescription = 'Attached File:\r\n' + util.getInstanceBaseURL() + '/servlet/servlet.FileDownload?file='; 
	    	    
	    Attachment attachment = new Attachment();
	    attachment.ParentId = relatedToId;
	    attachment.Name = documentName + '.pdf';
	    attachment.Body = req.requestBody;
	    insert attachment;
	    
	    Task task = new Task();
	    task.Subject = documentName + ' Generated';
	    task.Status = 'Completed';
	    task.WhatId = relatedToId;
	    task.ActivityDate = Date.today();
	    task.OwnerId = userId;
	    task.Description = taskDescription + attachment.Id;
	    insert task;
	    
		return documentName + ' saved';
	}
}