trigger SearchSequencing on Searches__c (before insert) 
{
	Set<Searches__c> searches = new Set<Searches__c>();
	Set<Id> serviceRequestIds = new Set<Id>();
	Map<Id,Decimal> SRIdMaxSeq = new Map<Id,Decimal>();
	for(Searches__c search : Trigger.new)
    {
    	 searches.add(search);
    	 serviceRequestIds.add(search.Service_Request__c);
	}

	List<Searches__c> maxSeqSearches = [select Service_Request__c,Sequence_Number__c from Searches__c where Service_Request__c =: serviceRequestIds and Sequence_Number__c != null order by Sequence_Number__c desc limit 1]; 
    
	for(Searches__c maxSeqSearch : maxSeqSearches)
    {
    	SRIdMaxSeq.put(maxSeqSearch.Service_Request__c,maxSeqSearch.Sequence_Number__c);
    }

    for(Searches__c search : searches)
    {
    	decimal maxSeq = SRIdMaxSeq.get(search.Service_Request__c);
    	if (maxSeq == null)
    	{
    		maxSeq = 0;
    	}
    	search.Sequence_Number__c = maxSeq + 1;
    	SRIdMaxSeq.put(search.Service_Request__c,search.Sequence_Number__c);
    }
}