trigger PushSearchIdsToMulligan on Searches__c (after insert, after update) 
{
	// Only run this code if this trigger has not previously pushed contact ids on this event
	if(!Util.hasAlreadyFired('Searches__c'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
	        
	    integer i = 0;
	    string actionType ='inserted'; 
	    for (Searches__c search : Trigger.New)    
	    {
	        if (Trigger.new[i].RecordTypeId == RecordTypeHelper.housingSearchRT())
	        {
		        if(trigger.isUpdate)
		        {
		       		if (Trigger.old[i].Active_NTV_Task__c != Trigger.new[i].Active_NTV_Task__c)
               		{}
                	else
		        	{
		        		updatedRecordIds.add(Trigger.new[i].Id);
		            	actionType ='updated'; 
		        	}
		        }
		        else
		        {
		            updatedRecordIds.add(Trigger.new[i].Id);    
		        }
	        }
	        i++;
	    } 
	    if (!updatedRecordIds.isEmpty())
	    {
	    	CallOutsToMulligan.PushUpdates('Searches__c', false, updatedRecordIds, actionType);
	    	Util.setAlreadyFired('Searches__c'); 
	    }
	}
}