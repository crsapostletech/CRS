trigger PushQuotesToMulligan on Quote__c (after insert) {
	
	Map<Id,String> updatedQuotes = new Map<Id,String>();
		        
    integer i = 0; 
    for (Quote__c quote : Trigger.New)    
    {
      	if (Trigger.new[i].RecordTypeId == RecordTypeHelper.mulliganQuoteRT())
        {	            	
        	CallOutsToMulligan.pushNewQuoteInformation(Trigger.new[i].Id);
        }
        i++;
    }
}