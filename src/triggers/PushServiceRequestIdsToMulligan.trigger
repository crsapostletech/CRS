trigger PushServiceRequestIdsToMulligan on ServiceRequest__c (after insert, after update) 
{
	// Only run this code if this trigger has not previously pushed Service Request ids on this event
	if(!Util.hasAlreadyFired('ServiceRequest__c'))
    {
		Set<Id> updatedRecordIds = new Set<Id>();
			
	   	integer i = 0;
	   	string actionType ='inserted'; 
	   	
	   	
	  	for (ServiceRequest__c serviceRequest : Trigger.new) 
	    {
          	if(trigger.isUpdate)
		    {
		    	if (Trigger.old[i].Name != Trigger.new[i].Name
		    	|| Trigger.old[i].RecordTypeId != Trigger.new[i].RecordTypeId
		    	|| Trigger.old[i].Status__c != Trigger.new[i].Status__c
		    	|| Trigger.old[i].First_Property_Presented__c != Trigger.new[i].First_Property_Presented__c
		    	|| Trigger.old[i].DWO_Reason_Code__c != Trigger.new[i].DWO_Reason_Code__c
		    	|| Trigger.old[i].THC_Signed__c != Trigger.new[i].THC_Signed__c
				|| Trigger.old[i].THA_Signed__c != Trigger.new[i].THA_Signed__c
				|| Trigger.old[i].CRS_Hotel_Confirmation_Created_Date__c != Trigger.new[i].CRS_Hotel_Confirmation_Created_Date__c
				|| Trigger.old[i].Cost_Benefit_Analysis_Created_Date__c != Trigger.new[i].Cost_Benefit_Analysis_Created_Date__c
				|| Trigger.old[i].Move_In_Confirmation_Created_Date__c != Trigger.new[i].Move_In_Confirmation_Created_Date__c)
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
	    	CallOutsToMulligan.PushUpdates('ServiceRequest', false, updatedRecordIds, actionType);
	    	Util.setAlreadyFired('ServiceRequest__c');  
	    } 
	}
}