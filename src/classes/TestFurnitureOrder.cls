/*
File..................: Test class - TestFurnitureOrder 
Object................: Furniture_Order
Created by............: M.Bodde
Created Date..........: 3-1-2010
Description...........: Test class for furniture order object

Last Modified by......: 
Last Modified Date....: 
Last Modified Reason..: 

Company URL : http://crstemphousing.com
*/
@isTest
private class TestFurnitureOrder 
{
    static testMethod void testStatusChange() 
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
        Opportunity opportunity = new Opportunity(
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
              
        RecordType housingServiceRequest = [Select Id, Name from RecordType where sobjecttype='ServiceRequest__c' and Name = 'Housing'];       
        
        // Insert Service Request with record type Housing
        ServiceRequest__c serviceRequest = new ServiceRequest__c(
											                    RecordTypeId = housingServiceRequest.id,
											                    opportunity__c= opportunity.id,
											                    Status__c = 'Searching',
											                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest;
        
        // Insert property
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
        
        // Insert search
        Searches__c  search = new Searches__c (
        									   Service_Request__c = serviceRequest.id,
                                               Selected__c=true,
                                               Property__c=property.Id);
        insert search;
                                                  		 
    	RecordType completedFurnitureOrderRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Furniture_Order__c' AND Name = 'Completed Furniture Order'];
        RecordType cancelledFurnitureOrderRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Furniture_Order__c' AND Name = 'Cancelled Furniture Order'];
                           
        // Insert furniture order - cancelled
        Furniture_Order__c  furnitureOrder = new Furniture_Order__c(
                                               			            Status__c='Working',
                                               			            Service_Request_Lookup__c=serviceRequest.Id);
        insert furnitureOrder;
        
        furnitureOrder.Status__c = 'Cancelled';
        update furnitureOrder;
        
        // Get inserted Furniture Order
        Furniture_Order__c updatedFurnitureOrder = [SELECT RecordTypeId FROM Furniture_Order__c WHERE id =: furnitureOrder.Id];
        
        // Furniture order record type should equal Cancelled
        System.assertEquals(updatedFurnitureOrder.RecordTypeId, cancelledFurnitureOrderRT.Id); 
        
        // Insert furniture order - completed
        furnitureOrder = new Furniture_Order__c(
                                                Status__c='Completed',
                                               	Service_Request_Lookup__c=serviceRequest.Id);
     	try 
 	    {
 	    	insert furnitureOrder;
        }
        catch (exception e)
        {
        }
        
        // Get inserted Furniture Order
        Furniture_Order__c insertedFurnitureOrder = [SELECT RecordTypeId FROM Furniture_Order__c WHERE id =: furnitureOrder.Id];
        
        // Furniture order record type should equal Completed
        System.assertEquals(insertedFurnitureOrder.RecordTypeId, completedFurnitureOrderRT.Id);  
	}
}