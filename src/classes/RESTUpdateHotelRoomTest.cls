@isTest
private class RESTUpdateHotelRoomTest {

    static testMethod void myUnitTest() {
        
        Hotel_Room__c hr = new Hotel_Room__c();
        hr.Room_Type__c = 'Standard Double';
        hr.Kitchen_Features__c = 'Kitchenette';
        hr.Confirmation__c = '123';
        hr.Check_In__c = Date.newInstance(2011,7,1);
        hr.Estimated_Check_Out_Date__c = Date.newInstance(2011,7,11);
        hr.Hotel_Nightly_Rate__c = 100.00;
        hr.Itemized_Tax__c = 10;
        
        insert hr;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {
            // production endpoint
            req.requestURI = 'https://login.salesforce.com/services/apexrest/HotelRoom/UpdateHotelRoom/' + hr.Id;
        }
        else
        {
            // test endpoint
            req.requestURI = 'https://test.salesforce.com/services/apexrest/HotelRoom/UpdateHotelRoom/' + hr.Id;
        }
        req.httpMethod = 'PATCH';
        
       
        string expectedresult = hr.Id + ' Updated';
                
        RestContext.request = req;
		RestContext.response = res;
		
		string petFeeType = 'Daily';
		string parkingFeeType = 'Daily';
		string otherFeeType = 'Daily';
		string otherFeeDescription = 'Exta bed'; 
		double avgCostRate = 100.00;
		double avgPriceRate = 120.00;
		double crsRoomRatePrice = 140.00;
		double hotelNightlyRate = 130.00;
		double avgRoomRateWithoutTaxandFees = 100.00;
		double itemizedTax = 12;
		double totalUnbilled = 2000.00;
		double petFeeAmount = 10.00;
		double parkingFeeAmount = 10.00;
		double otherFeeAmount = 10.00;
    	boolean oneTimePetFeesTaxable = true;
    	boolean oneTimeParkingFeesTaxable = false; 
    	boolean oneTimeOtherFeesTaxable = true;
    	string userId = [select id from User where alias = 'extapi'].id; 
    	
		String results = RESTUpdateHotelRoom.updateHotelRoom(req,avgCostRate,avgPriceRate,crsRoomRatePrice,hotelNightlyRate,avgRoomRateWithoutTaxandFees,
															 itemizedTax,totalUnbilled,petFeeType,petFeeAmount,oneTimePetFeesTaxable,parkingFeeType,parkingFeeAmount,
															 oneTimeParkingFeesTaxable,otherFeeType,otherFeeAmount,oneTimeOtherFeesTaxable,otherFeeDescription,userId);
		System.assertEquals(expectedresult,results);
		
		
		//setup request with bad data to cover exceptions 

		petFeeType = '';
		parkingFeeType = '';
		otherFeeType = '';
		userId = '123';
		
		results = RESTUpdateHotelRoom.updateHotelRoom(req,avgCostRate,avgPriceRate,crsRoomRatePrice,hotelNightlyRate,avgRoomRateWithoutTaxandFees,
			                                          itemizedTax,totalUnbilled,petFeeType,petFeeAmount,oneTimePetFeesTaxable,parkingFeeType,parkingFeeAmount,
			                                          oneTimeParkingFeesTaxable,otherFeeType,otherFeeAmount,oneTimeOtherFeesTaxable,otherFeeDescription,userId);
		System.assertEquals(expectedresult,results);
	
	}
}