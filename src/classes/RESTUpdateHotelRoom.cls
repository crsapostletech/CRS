@RestResource(urlMapping='/HotelRoom/UpdateHotelRoom/*')
global class RESTUpdateHotelRoom 
{
  @HttpPatch
  global static String updateHotelRoom(RestRequest req, Double avgCostRate , Double avgPriceRate, Double crsRoomRatePrice, Double hotelNightlyRate, Double avgRoomRateWithoutTaxandFees,
                                                        Double itemizedTax, Double totalUnbilled, string petFeeType, Double petFeeAmount,Boolean oneTimePetFeesTaxable, String parkingFeeType, 
                                                        Double parkingFeeAmount, Boolean oneTimeParkingFeesTaxable, String otherFeeType, Double otherFeeAmount, Boolean oneTimeOtherFeesTaxable, 
                                                        String otherFeeDescription, String userId) 
  {
      string roomId = req.RequestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
      Hotel_Room__c hr = [SELECT Id from Hotel_Room__c WHERE Id =: roomId];
       
      
      hr.Avg_Cost_Rate__c = avgCostRate;
      hr.Avg_Price_Rate__c = avgPriceRate;
      hr.CRS_Room_Rate_Price__c = crsRoomRatePrice;
      hr.Hotel_Nightly_Rate__c = hotelNightlyRate;
      hr.Average_Room_Rate_Without_Taxes_and_Fees__c = avgRoomRateWithoutTaxandFees;
      hr.Itemized_Tax__c = itemizedTax;
      hr.Total_Unbilled__c = totalUnbilled;
     
     	hr.Pet_Fee_cb__c = true;
     	hr.Pet_Fee_Type__c = petFeeType;
     	hr.Pet_Fee_Amount__c = petFeeAmount;
     	hr.One_Time_Pet_Fees_Taxable__c = oneTimePetFeesTaxable;
      if (hr.Pet_Fee_Type__c != '')
      {
      	hr.Pet_Fee_cb__c = true;
      }
      else
      {
      	hr.Pet_Fee_cb__c = false;
      }
      
      hr.Parking_Fee_Type__c = parkingFeeType;
      hr.Parking_Fee_Amount__c = parkingFeeAmount;
      hr.One_Time_Parking_Fees_Taxable__c = oneTimeParkingFeesTaxable;
    	if (hr.Parking_Fee_Type__c != '')
   		{
    		hr.Parking_Fee_cb__c = true;
    	}
    	else
    	{
        hr.Parking_Fee_cb__c = false;
      }
    
   		hr.Other_Fee_Type__c = otherFeeType;
   		hr.Other_Fee_Amount__c = otherFeeAmount;
   		hr.One_Time_Other_Fees_Taxable__c = oneTimeOtherFeesTaxable;
   		hr.Other_Fee_Description__c = otherFeeDescription;
    	if (hr.Other_Fee_Type__c != '')
    	{
    		hr.Other_Fee_cb__c = true;
    	}
    	else
    	{
        	hr.Other_Fee_cb__c = false; 
      }
      if (userId.length() > 0)
      {
        User user = new User();
        try
        {
        	user = [select FirstName,LastName from User where id =: userId];
        }
        catch (Exception e)
        {
        	user.FirstName = 'Unknown';
        	user.LastName = 'User';
        }
    
        system.debug(userId);      
  			
        hr.RC_Last_Modified_By__c = (user.FirstName + ' ' + user.LastName + ', ' + system.now().format('M/d/yyyy h:mm a'));
        if (userId.length() == 18)
        {
          hr.RC_Last_Modified_By_Id__c = userId;
        }
        else
        {
          hr.RC_Last_Modified_By_Id__c = '';
        }  
		  }

      update hr;
      return roomId + ' Updated';
   }
}