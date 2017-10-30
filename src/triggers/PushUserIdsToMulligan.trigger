trigger PushUserIdsToMulligan on User (after insert, after update) 
{
	// Only run this code if this trigger has not previously pushed contact ids on this event
	if(!Util.hasAlreadyFired('User'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
	        
	    integer i = 0;
	    string actionType ='inserted'; 
	    for (User user : Trigger.New)    
	    {
	        if(trigger.isUpdate)
	        {
	        	updatedRecordIds.add(Trigger.new[i].Id);
	            actionType ='updated'; 
	        }
	        else
	        {
	            updatedRecordIds.add(Trigger.new[i].Id);    
	        }
	        i++;
	    } 
	    if (!updatedRecordIds.isEmpty())
	    {
	    	CallOutsToMulligan.PushUpdates('User', false, updatedRecordIds, actionType);
	    	Util.setAlreadyFired('User'); 
	    }
	}
}