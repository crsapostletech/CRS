@isTest
private class RESTHotelAuthorizationTest 
{
    static testMethod void myUnitTest() 
    {
      	ServiceRequest__c sr = [select id from ServiceRequest__c limit 1];
      	User user = [select id from User where isActive = true limit 1];
      	      	
      	RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
        {
            // production endpoint
            req.requestURI = 'https://login.salesforce.com/services/apexrest/HotelRoom/HotelAuthorization';
        }
        else
        {
            // test endpoint
            req.requestURI = 'https://test.salesforce.com/services/apexrest/HotelRoom/HotelAuthorization';
        }
        req.httpMethod = 'POST';
        
       
        string expectedresult = 'Hotal Authorization saved';
                
        RestContext.request = req;
		RestContext.response = res;
		
		req.addParameter('serviceRequestId', sr.Id);
		req.addParameter('userId', user.Id);
	
		Blob body;
		body = Blob.valueOf('This is a test doc');
		req.requestBody = body;
		
		String results = RESTHotelAuthorization.insertHotelAuthorization(req);
		System.assertEquals(expectedresult,results);
    }
}