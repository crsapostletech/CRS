@isTest
private class RESTDocumentTest 
{
    static testMethod void myUnitTest() 
    {
      	
    	// Insert ServiceRequest 
        ServiceRequest__c serviceRequest = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.hotelServiceRequestRT(),
				    Status__c = 'Request');
		insert serviceRequest;

      	// Insert User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User
                (   Alias = 'standt',
                    Email='standarduser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='standarduser@crstemphousing.com');
        insert user;        

       	string documentName = 'Test Document';
      	      	
      	RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
      
        req.requestURI = util.getInstanceBaseURL() + '/services/apexrest/Documents';
       
        req.httpMethod = 'POST';
        
        string expectedresult = documentName + ' saved';
                
        RestContext.request = req;
		RestContext.response = res;
		
		req.addParameter('Id', serviceRequest.Id);
		req.addParameter('userId', user.Id);
		req.addParameter('name', documentName);
	
		Blob body;
		body = Blob.valueOf('This is a test doc');
		req.requestBody = body;
		
		String results = RESTDocument.insertDocument();
		System.assertEquals(expectedresult,results);
    }
}