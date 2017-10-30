@isTest
private class LandlordChangeTest {
	
	static testMethod void myUnitTest() 
    {
        Contact contact1 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.landlordContactRT(),
                    LastName='xxxxxx',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501',
                    Type__c='TPA',
                    LeadSource='Event',
                    Lead_Source_Description__c='Golf Event'
                );
        insert contact1;
        
        
        Contact contact2 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.landlordContactRT(),
                    LastName='xxxxxx',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501',
                    Type__c='TPA',
                    LeadSource='Event',
                    Lead_Source_Description__c='Golf Event'
                );
        insert contact2;
     	
     	   // Insert Users
       Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
       User user1 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser@testorg.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser@crstemphousing.com');
       insert user1; 

     	// Insert Claim 
        Opportunity opportunity = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Initial_Service_Request__c='Housing',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '123 Big Test Lane',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity;
        
        ServiceRequest__c hsr = new ServiceRequest__c();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(hsr);
        ServiceRequestDispatcherExtension hsrce = new ServiceRequestDispatcherExtension(stdCon);
        
        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeHelper.housingServiceRequestRT());
        ApexPages.currentPage().getParameters().put('retURL', '/' + opportunity.Id + '?srPos=0&srKp=006' + RecordTypeHelper.housingServiceRequestRT());
        PageReference pr = hsrce.getNewServiceRequest();
                
        ServiceRequest__c  serviceRequest1 = [select id,name from ServiceRequest__c where Opportunity__c =: opportunity.id];

        pr = hsrce.getNewServiceRequest();
        
        ServiceRequest__c serviceRequest2 = [select id from ServiceRequest__c where Opportunity__c =: opportunity.id and id !=: serviceRequest1.Id];

        Placement__c placement1 = [select id from placement__c where placement__c.ServiceRequest__c =: serviceRequest1.Id];
        Placement__c placement2 = [select id from placement__c where placement__c.ServiceRequest__c =: serviceRequest2.Id];
       
        // Insert Housing Search
    	Searches__c housingSearch1 = new Searches__c
    			(
    				RecordTypeId = RecordTypeHelper.housingSearchRT(),
    				Placement__c = placement1.Id,
    				Service_Request__c = serviceRequest1.Id,
    				Selected__c = true,
    				Property_Type__c = 'Single Family Home',
    				Furniture_Option__c = 'CRS Package',
    				Street_Addr1__c = '134 Laurel',
    				City__c = 'Mineola',
    				State__c = 'CT',
    				Zip__c = '11501',
    			    Country__c = 'USA',
    			    Initial_Contact_Name__c = 'Initial Contact',
    			    Initial_Contact_Number__c = '602-444-5555',
    			    Presented_Date__c = Date.newInstance(2014,3,01),
    			    Landlord__c = contact1.Id);
    	
        insert housingSearch1;

        Searches__c housingSearch2 = new Searches__c
    			(
    				RecordTypeId = RecordTypeHelper.housingSearchRT(),
    				Placement__c = placement2.Id,
    				Service_Request__c = serviceRequest2.Id,
    				Selected__c = true,
    				Property_Type__c = 'Single Family Home',
    				Furniture_Option__c = 'CRS Package',
    				Street_Addr1__c = '134 Laurel',
    				City__c = 'Mineola',
    				State__c = 'CT',
    				Zip__c = '11501',
    			    Country__c = 'USA',
    			    Initial_Contact_Name__c = 'Initial Contact',
    			    Initial_Contact_Number__c = '602-444-5555',
    			    Presented_Date__c = Date.newInstance(2014,3,01),
    			    Landlord__c = contact1.Id);
    	
        insert housingSearch2;
                
        // Insert Rent Cost
        Costs__c rent1 = new Costs__c
        		(	
        			Searches__c = housingSearch1.Id,
        			RecordTypeId = RecordTypeHelper.costCostsRT(),
        			Amount__c = 1000.00,
        			Type__c = 'Rent',
        			Billable_Party__c = contact2.Id,
        			Payable_Party__c = contact1.Id,
        			Prorate_Type__c = 'Monthly');
        insert rent1;

         Costs__c rent2 = new Costs__c
        		(	
        			Searches__c = housingSearch2.Id,
        			RecordTypeId = RecordTypeHelper.costCostsRT(),
        			Amount__c = 1000.00,
        			Type__c = 'Rent',
        			Billable_Party__c = contact2.Id,
        			Payable_Party__c = contact1.Id,
        			Prorate_Type__c = 'Monthly');
        insert rent2;

        placement1.Selected_Search__c = housingSearch1.Id;
        placement2.Selected_Search__c = housingSearch2.Id;
        
        update placement1;
        update placement2;	
               
        housingSearch1.Landlord__c = contact2.Id;
        
        update housingSearch1;
        
        Costs__c updatedCost = [select Payable_Party__c from Costs__c where Id =: rent1.Id];
        Contact updatedContact = [select Active_Placements__c from Contact where id =: contact2.id];
        
        System.assertEquals(housingSearch1.Landlord__c, updatedCost.Payable_Party__c);
        System.assertEquals(true, updatedContact.Active_Placements__c);

        housingSearch1.Selected__c = false;

        update housingSearch1;
       
    }
	
}