@RestResource(urlMapping='/Quote/QuoteError/*')
global with sharing class RESTQuoteError 
{
	@HttpPost
	global static void insertQuoteError(RestRequest req)   
	{ 
		string quoteId = req.params.get('quoteId');
		string quoteError = req.params.get('quoteError');
				
	   	try
	    {
	    	Quote__c quote = [select Name,Status__c from Quote__c where Id =: quoteId];
	    	quote.Status__c = quoteError;
	   		update quote;
	    }
	    catch (QueryException e)
        {
        	 Util.sendErrorEmail('Billing system error processing quote','ERROR: ' + e + ' returned processing quote Id ' + quoteId);		
        }
	}	
}