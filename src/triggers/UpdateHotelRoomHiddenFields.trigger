trigger UpdateHotelRoomHiddenFields on Hotel_Room__c (before insert, before update) 
{
	integer i = 0; 
    for(Hotel_Room__c hotelRoom : Trigger.new)
    {
    	if(hotelRoom.Original_Check_In_Date__c == null)
    	{
    		hotelRoom.Original_Check_In_Date__c = hotelRoom.Check_In__c;
    	}
    	
    	if(hotelRoom.Original_Check_Out_Date__c == null)
    	{
    		hotelRoom.Original_Check_Out_Date__c = hotelRoom.CheckOut__c;
    	}
    	
    	if(hotelRoom.Original_Estimated_Check_Out_Date__c == null)
    	{
    		hotelRoom.Original_Estimated_Check_Out_Date__c = hotelRoom.Estimated_Check_Out_Date__c;
    	}
    	
    	
    	if(trigger.isUpdate)
		{
	    	if(Trigger.old[i].Estimated_Check_Out_Date__c != Trigger.new[i].Estimated_Check_Out_Date__c) 
	    	{
	    	    hotelRoom.Previous_Estimated_Check_Out_Date__c = Trigger.old[i].Estimated_Check_Out_Date__c;
            }                

            if(Trigger.old[i].Estimated_Check_Out_Date__c < Trigger.new[i].Estimated_Check_Out_Date__c) 
            {    
                if (hotelRoom.Number_of_Extensions__c != null)
                {
                    hotelRoom.Number_of_Extensions__c ++;
                }
                else
                {
                    hotelRoom.Number_of_Extensions__c = 1;
                }
	    	}
		}
        i++;
    }

}