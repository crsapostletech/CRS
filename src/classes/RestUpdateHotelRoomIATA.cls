@RestResource(urlMapping='/HotelRoom/UpdateHotolRoomIATA/*')
global with sharing class RestUpdateHotelRoomIATA  
{
    @HttpPatch
    global static String updateHotelRoomIATA(string hotelRoomId, Double collected,String bookingStatus,String paymentStatus)   
    { 
        try
        {
              Hotel_Room__c hotelRoom = [SELECT Id,IATA_Collected__c,Booking_Status__c,Payment_Status__c from Hotel_Room__c WHERE Id =: hotelRoomId]; 
              hotelRoom.IATA_Collected__c = collected;
              hotelRoom.Booking_Status__c = bookingStatus;
              hotelRoom.Payment_Status__c = paymentStatus;              
              update hotelRoom;
              return 'IATA updated for hotel room id ' + hotelRoomId;
        }
        catch (Exception e)
        {
           Util.sendErrorEmail('IATA Update error','ERROR: ' + e + ' returned updating the IATA information for hotel room id' + hotelRoomId);       
           return 'IATA update failed for hotel room id ' + hotelRoomId;
        }
    }
}