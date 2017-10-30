@isTest
private class RESTQuoteErrorTest {

    static testMethod void myUnitTest() 
    {
    	
    	Placement__c placement = new Placement__c(
                                        RecordTypeId = recordTypeHelper.housingPlacementRT(),
                                        Name = 'testPlacementHousing',
                                        Move_In_Date__c = Date.newInstance(2015,09,09),
	    								Approved_Through_Date__c = Date.newInstance(2016,09,09));
                                        
        insert placement;
               
               
        Quote__c quote = new Quote__c(
                                        RecordTypeId = recordTypeHelper.mulliganQuoteRT(),
                                        Placement_Lookup__c = placement.Id);
                                        
        insert quote;
    	
    	    	
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
        
       
                
        RestContext.request = req;
				
		req.addParameter('quoteId', quote.Id);
		req.addParameter('quoteError', 'Failed');
			
		RESTQuoteError.insertQuoteError(req);
		
		
		req.addParameter('quoteId', '');
		req.addParameter('quoteError', 'Failed');
			
		RESTQuoteError.insertQuoteError(req);
    }
}