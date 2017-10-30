/*
File..................: Test class - TestSearches 
Object................: Searches
Created by............: M.Bodde
Created Date..........: 3-1-2010
Description...........: Test class for searches object

Last Modified by......: 
Last Modified Date....: 
Last Modified Reason..: 

Company URL : http://crstemphousing.com
*/
@isTest
private class TestSearches {

    static testMethod void testSetFirstAvailableMoveInDate() 
    {
        // Insert Users
        Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
        User user1 = new User
                (   
                    Alias = 'standt',
                    Email='operationsuser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser@crstemphousing.com');
        insert user1; 



        // Insert an Opportunity 
        Opportunity opportunity = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test11',
                    Initial_Service_Request__c='Hotel',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity;
         
        // Insert Service Request 
        RecordType housingServiceRequest = [
                    Select Id, Name from 
                    RecordType where sobjecttype='ServiceRequest__c' 
                    and Name = 'Housing'];       
        
        ServiceRequest__c serviceRequest = new ServiceRequest__c(
                    RecordTypeId = housingServiceRequest.id,
                    opportunity__c= opportunity.id,
                    Status__c = 'Searching',
                    THA_Signed__c = Date.newInstance(2009,10,09)
                    );
        insert serviceRequest;
        
        // Insert Property
        Properties__c  property = new Properties__c(
                                                    Name = 'XYZP',
                                                    Type_of_Property__c = 'House',
                                                    Address_Line_1__c='111 farewell',
                                                    Address_Line_2__c='234 unit',
                                                    City__c='mineola',
                                                    State_ID__c='NY',
                                                    Zip__c='11507',
                                                    Country__c='USA',
                                                    Bathrooms__c='1',
                                                    Bedrooms__c='1',
                                                    Rent_Frequency__c='Daily',
                                                    Rent__c=1500.00,
                                                    Send_Via__c='US Mail',
                                                    Lease_Start__c=Date.newInstance(2009,09,09),
                                                    Lease_End__c=Date.newInstance(2010,09,09),
                                                    Rent_Due__c=2,
                                                    Days_Notice_Required__c=1,
                                                    Days_to_Increment_Extension__c=2,
                                                    Is_Month_to_Month_Lease_Same_Rent__c='Yes',
                                                    Pay_Rent_to_Landlord__c='True',
                                                    Prorate_Amount__c=25.00);
        insert property;
                             
        RecordType housingRT = [
                 Select Id, Name from 
                 RecordType where sobjecttype='Searches__c' 
                 and Name = 'Housing'];       
        
        // Insert Search with record type of Housing
        Searches__c  housingSearch = new Searches__c (
                                               RecordTypeId = housingRT.id,
                                               Service_Request__c = serviceRequest.id,
                                               Selected__c=true,
                                               Property__c=property.Id
                                               );
        insert housingSearch;
        
        // Get inserted search 
        Searches__c insertedHousingSearch = [SELECT X_1st_Available_Move_In_Date__c, X1st_Available_Move_In_Date_Time__c FROM Searches__c WHERE id =: housingSearch.Id];
        
        // Validate
     //   System.assertEquals(insertedHousingSearch.X1st_Available_Move_In_Date_Time__c, DateTime.valueOf(String.valueOf(insertedHousingSearch.X_1st_Available_Move_In_Date__c) + ' 08:00:00'));     
            
        RecordType hotelRT = [
                 Select Id, Name from 
                 RecordType where sobjecttype='Searches__c' 
                 and Name = 'Hotel'];       
        
        // Insert Search with record type of Hotel
        Searches__c  hotelSearch1 = new Searches__c (
                                               RecordTypeId = hotelRT.id,
                                               Service_Request__c = serviceRequest.id,
                                               Selected__c=true,
                                               Property__c=property.Id
                                               );
        insert hotelSearch1;
        
        // Get inserted search 
        Searches__c insertedHotelSearch1 = [SELECT X_1st_Available_Move_In_Date__c, X1st_Available_Move_In_Date_Time__c FROM Searches__c WHERE id =: hotelSearch1.Id];
        
        // Validate
        if (DateTime.Now().hour() >= 15)
        {
        //	System.assertEquals(insertedHotelSearch1.X1st_Available_Move_In_Date_Time__c, DateTime.valueOf(String.valueOf(insertedHotelSearch1.X_1st_Available_Move_In_Date__c) + ' ' + String.valueOf(DateTime.Now().hour() + 1) + ':00:00'));     
        }
        else
        {
        //	System.assertEquals(insertedHotelSearch1.X1st_Available_Move_In_Date_Time__c, DateTime.valueOf(String.valueOf(insertedHotelSearch1.X_1st_Available_Move_In_Date__c) + ' 15:00:00'));     
        }
	}
}