@isTest
private class UpdateCostsandFurnitureOnATPorPTPTest {

    static testMethod void myUnitTest() 
    {
    	RecordType adjusterRT = [Select Id, Name from RecordType where sobjecttype='Contact' and Name='Adjuster'];
        Contact contact1 = new Contact
                (
                    RecordTypeId = adjusterRT.Id,
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
        
        RecordType policyholderRT = [Select Id, Name from RecordType where sobjecttype='Contact' and Name='Policyholder'];
        Contact contact2 = new Contact
                (
                    RecordTypeId = policyholderRT.Id,
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
     	     	
     	// Insert Claim 
        Opportunity opportunity = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = contact1.Id,
                    Policyholder__c = contact2.Id,
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
        
        RecordType housingServiceRequest = [Select Id, Name from RecordType where sobjecttype='ServiceRequest__c' and Name = 'Housing'];       
        
        ServiceRequest__c serviceRequest = new ServiceRequest__c
        		(
                	RecordTypeId = housingServiceRequest.id,
				    Opportunity__c= opportunity.id,
				    Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    THC_Signed__c = Date.newInstance(2009,10,09),
				    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest;
        
        // Insert placement
        RecordType housingPlacementRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Placement__c' AND Name = 'Housing Placement'];
        
        Placement__c placement = new Placement__c(
                                        RecordTypeId = housingPlacementRT.Id,
                                        Name = 'testPlacementHousing',
                                        Status__c = 'Searching',
                                        Move_In_Date__c = Date.newInstance(2015,09,09),
	    								Approved_Through_Date__c = Date.newInstance(2016,09,09));
                                        
	    insert placement;
        
        // Insert Housing Search
    	RecordType housingSearchRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Searches__c' AND Name = 'Housing'];
    	
    	Searches__c housingSearch = new Searches__c
    			(
    				Placement__c = placement.Id,
    				Service_Request__c = serviceRequest.Id,
    				Property_Type__c = 'Single Family Home',
    				Furniture_Option__c = 'CRS Package',
    				Street_Addr1__c = '134 Laurel',
    				City__c = 'Mineola',
    				State__c = 'CT',
    				Zip__c = '11501',
    			    Country__c = 'USA',
    			    Initial_Contact_Name__c = 'Initial Contact',
    			    Initial_Contact_Number__c = '602-444-5555',
    			    Presented_Date__c = Date.newInstance(2014,3,01));
    	
        insert housingSearch;
                
        // Insert Deposit Cost
        RecordType depositRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='costs__c' AND Name = 'Deposit'];
        
        Costs__c deposit = new Costs__c
        		(	
        			Searches__c = housingSearch.Id,
        			RecordTypeId = depositRT.Id,
        			Amount__c = 1000.00,
        			Type__c = 'Security Deposit',
        			Billable_Party__c = contact1.Id,
        			Payable_Party__c = contact2.Id,
        			Prorate_Type__c = 'Monthly');
        insert deposit;
        
        // Insert Fee Cost
        RecordType feeRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='costs__c' AND Name = 'Fee'];
        
        Costs__c fee = new Costs__c
        		(	
        			Searches__c = housingSearch.Id,
        			RecordTypeId = feeRT.Id,
        			Amount__c = 1000.00,
        			Type__c = 'Pet Fee',
        			Billable_Party__c = contact1.Id,
        			Payable_Party__c = contact2.Id,
        			Prorate_Type__c = 'Monthly');
        insert fee;
        
     
        Furniture_Order__c fo = new Furniture_Order__c
        		(	
        			Status__c = 'Working',
        			Service_Request__c = serviceRequest.Id,
        			Placement__c = placement.Id,
        			Is_partial_order__c = 'Yes',
        			Deposit__c = 1000.00,
        			Billable_Party_Deposit__c = 'Adjuster',
        			Delivery_Fee__c = 1000.00,
        			Billable_Party_Delivery_Fee__c = 'Adjuster',
        			Pet_Fee__c = 1000.00,
        			Billable_Party_Pet_Fee__c = 'Adjuster',
        			Setup_Fee__c = 1000.00,
        			Billable_Party_Setup_Fee__c = 'Adjuster');
        			
        insert fo;
               
        serviceRequest.Adjuster_to_Pay__c = 'Will Not Pay';
        serviceRequest.Policyholder_to_Pay__c = 'Deposits and Fees';
        
        update serviceRequest;
        
        Costs__c updatedDeposit = [select Billable_Party__c from Costs__c where Id =: deposit.Id];
        Costs__c updatedFee = [select Billable_Party__c from Costs__c where Id =: fee.Id];
        Furniture_Order__c updatedFO = [select Billable_Party_Deposit__c,Billable_Party_Delivery_Fee__c,Billable_Party_Pet_Fee__c,Billable_Party_Setup_Fee__c from Furniture_Order__c where Id =: fo.Id];
        
        System.assertEquals(contact2.Id, updatedDeposit.Billable_Party__c);
        System.assertEquals(contact2.Id, updatedFee.Billable_Party__c);
        System.assertEquals('Policyholder', updatedFO.Billable_Party_Deposit__c);
        System.assertEquals('Policyholder', updatedFO.Billable_Party_Delivery_Fee__c);
        System.assertEquals('Policyholder', updatedFO.Billable_Party_Pet_Fee__c);
        System.assertEquals('Policyholder', updatedFO.Billable_Party_Setup_Fee__c);
        
        serviceRequest.Adjuster_to_Pay__c = 'Deposits and Fees';
        serviceRequest.Policyholder_to_Pay__c = 'Will Not Pay';
        
        update serviceRequest;
        
        updatedDeposit = [select Billable_Party__c from Costs__c where Id =: deposit.Id];
        updatedFee = [select Billable_Party__c from Costs__c where Id =: fee.Id];
        updatedFO = [select Billable_Party_Deposit__c,Billable_Party_Delivery_Fee__c,Billable_Party_Pet_Fee__c,Billable_Party_Setup_Fee__c from Furniture_Order__c where Id =: fo.Id];
        
        System.assertEquals(contact1.Id, updatedDeposit.Billable_Party__c);
        System.assertEquals(contact1.Id, updatedFee.Billable_Party__c);
        System.assertEquals('Adjuster', updatedFO.Billable_Party_Deposit__c);
        System.assertEquals('Adjuster', updatedFO.Billable_Party_Delivery_Fee__c);
        System.assertEquals('Adjuster', updatedFO.Billable_Party_Pet_Fee__c);
        System.assertEquals('Adjuster', updatedFO.Billable_Party_Setup_Fee__c);
        
    }
}