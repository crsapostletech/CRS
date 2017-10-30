@isTest
private class RESTTHCDocumentTest 
{
    static testMethod void myUnitTest() 
    {
       	        
        Placement__c placement = new Placement__c(
                                        RecordTypeId = recordTypeHelper.housingPlacementRT(),
                                        Name = 'testPlacementHousing',
                                        Move_In_Date__c = Date.newInstance(2015,09,09),
	    								Approved_Through_Date__c = Date.newInstance(2016,09,09));
                                        
        insert placement;
      	      	      	
      	RestRequest req = new RestRequest();
        
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
        {
            // production endpoint
            req.requestURI = 'https://login.salesforce.com/services/apexrest//Placement/THCDocument/';
        }
        else
        {
            // test endpoint
            req.requestURI = 'https://test.salesforce.com/services/apexrest//Placement/THCDocument/';
        }
        req.httpMethod = 'POST';
               
        string expectedresult = 'THC document recieved';
                
        RestContext.request = req;
				
		req.addParameter('placementId', placement.Id);
			
		Blob body;
		body = Blob.valueOf('This is a test THC doc');
		req.requestBody = body;
		
		String results = RESTTHCDocument.insertTHCDocument(req);
		System.assertEquals(expectedresult,results);

        //setup request with bad data to cover exceptions 

        RestContext.request = req;  

        req.addParameter('placementId', '123');
        results = RESTTHCDocument.insertTHCDocument(req);
        System.assertEquals(expectedresult,results);

    }
}