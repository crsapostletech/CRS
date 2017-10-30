trigger PushHotelRoomIdsToMulligan on Hotel_Room__c (after insert, after update) 
{
	// Only run this code if this trigger has not previously pushed contact ids on this event
	if(!Util.hasAlreadyFired('Hotel_Room__c'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
	        
	    integer i = 0;
	    string actionType ='inserted'; 
	    for (Hotel_Room__c hotelRoom : Trigger.New)    
	    {
	        if(trigger.isUpdate)
	        {
	       	    if (Trigger.old[i].Name != Trigger.new[i].Name
	            || Trigger.old[i].Check_In__c != Trigger.new[i].Check_In__c
	            || Trigger.old[i].CheckOut__c != Trigger.new[i].CheckOut__c
	            || Trigger.old[i].Confirmation__c != Trigger.new[i].Confirmation__c
	            || Trigger.old[i].Cancellation_del__c != Trigger.new[i].Cancellation_del__c
	            || Trigger.old[i].Room_Type__c != Trigger.new[i].Room_Type__c
	            || Trigger.old[i].Estimated_Check_Out_Date__c != Trigger.new[i].Estimated_Check_Out_Date__c
	            || Trigger.old[i].Kitchen_Features__c != Trigger.new[i].Kitchen_Features__c
	            || Trigger.old[i].Billed_Through_Date__c != Trigger.new[i].Billed_Through_Date__c)
	            {  
	        		updatedRecordIds.add(Trigger.new[i].Id);
	            	actionType ='updated'; 
	            }   
	        }
	        else
	        {
	            updatedRecordIds.add(Trigger.new[i].Id);    
	        }
	        i++;
	    } 
	    if (!updatedRecordIds.isEmpty())
	    {
	    	CallOutsToMulligan.PushUpdates('Hotel_Room__c', false, updatedRecordIds, actionType);
	    	Util.setAlreadyFired('Hotel_Room__c'); 
	    }
	}
}