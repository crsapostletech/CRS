@isTest
public with sharing class RESTQuoteDocumentTest 
{
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
               
        string expectedresult = 'Quote document recieved';
                
        RestContext.request = req;
        
        Blob body;
    		body = Blob.valueOf('This is a test THC doc');
    		req.requestBody = body;
    				
    		req.addParameter('placementId', placement.Id);
    		req.addParameter('quoteName',quote.Name);
    		req.addParameter('quoteId', quote.Id);
    			
    		String results = RESTQuoteDocument.insertQuoteDocument(req);
    		System.assertEquals(expectedresult,results);
       		
       		req.addParameter('placementId', placement.Id);
    		req.addParameter('quoteName',quote.Name);
    		req.addParameter('quoteId', '');
       		
      	results = RESTQuoteDocument.insertQuoteDocument(req);
    }
}