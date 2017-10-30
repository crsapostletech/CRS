global class HotelOnlyUpdater implements Database.Batchable<sObject>
{

	Public String query { get; set;}  
			  
    global database.queryLocator start(Database.BatchableContext BC)
    {
  		return database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, list <ServiceRequest__c> scope) 
    {
    	Set<Id> housingClaimIds = new Set<Id>();
    	Set<Id> hotelClaimIds = new Set<Id>();
    	Set<Id> allClaimIds = new Set<Id>();
    	    	
    	// loop through all the service requests 
	    for(ServiceRequest__c serviceRequest : scope) 
	    {
	    	if (serviceRequest.RecordType.DeveloperName == 'Housing' && serviceRequest.Status__c <> 'Lost Opportunity')
	    	{
	    		housingClaimIds.add(serviceRequest.opportunity__c);
	    	}
	    	else
	    	{
	    		if (serviceRequest.RecordType.DeveloperName == 'Hotel' && serviceRequest.Status__c <> 'Lost Opportunity')
	    		{
	    			hotelClaimIds.add(serviceRequest.opportunity__c);
	    		}
	       	}
	    	allClaimIds.add(serviceRequest.Opportunity__c);
	    }
	    
	    List<Opportunity> claims = [select id, Hotel_Only__c, (select id from Service_Requests__r where status__c <> 'Lost Opportunity' and RecordType.DeveloperName in ('Housing','Hotel')) from opportunity where Account.Owner.IsActive = true and Adjuster__r.RecordType.DeveloperName = 'Adjuster' and Id in: allClaimIds];
	    List<Opportunity> changedClaims = new List<Opportunity>();
	    
	    for (Opportunity claim : claims)
	    {
	    	if (housingClaimIds.contains(claim.Id))
	    	{
	    		if (claim.Hotel_Only__c != 'False')
	    		{
	    			claim.Hotel_Only__c = 'False';
	    			changedClaims.add(claim);
	    		}
	       	}
	       	else
	       	{
	       		if (hotelClaimIds.contains(claim.Id))
	    		{
		       		if (claim.Hotel_Only__c != 'True')
		       		{
		       			claim.Hotel_Only__c = 'True';
		       			changedClaims.add(claim);
		       		}
		       	}
		       	else
		       	{
		       		if (claim.Hotel_Only__c != null && claim.Service_Requests__r.size() == 0)
			       	{
			       		system.debug('We got here');
			       		claim.Hotel_Only__c = null;
			       		changedClaims.add(claim);
			       	}
		       	}
	       	}
	    }
        update (changedClaims);
    }
    
    global void finish(Database.BatchableContext ctx)
    {

    }    
}