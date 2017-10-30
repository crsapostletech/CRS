trigger BillingCompletedForHotelPlacement on Placement__c (after update) 
{
	 	integer i = 0;     
   	for (Placement__c placement : Trigger.New)    
   	{		
   	    if (placement.RecordTypeId ==  RecordTypeHelper.hotelPlacementRT())
   	    {
   	   			if(Trigger.old[i].Billing_Completed__c != Trigger.new[i].Billing_Completed__c && Trigger.new[i].Billing_Completed__c == True)
				{
   	   	   			CallOutsToMulligan.SetBillingCompleted(Placement.Id);
   	   	   		}
          }
        i++;
	}
}