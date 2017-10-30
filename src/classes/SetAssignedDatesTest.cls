@isTest
private class SetAssignedDatesTest {
	
	@isTest static void test1() 
	{
		  Account parentAccount = new Account(
            RecordTypeId = RecordTypeHelper.insuranceCompanyAccountRT(),
            name='testPAccountx',
            Active__c= true,
            BillingState='CT',
            BillingStreet='134 Laurel',
            BillingCity='Mineola',
            BillingPostalCode='11501',
            BillingCountry='USA',
            ShippingState = 'CT',
            ShippingCountry = 'USA',
            ShippingPostalCode = '11501',
            ShippingCity = 'Mineola',
            ShippingStreet = '134 Laurel',
            Fax = '6022345675');
        insert parentAccount;

        Account adjAccount = new Account(
            RecordTypeId = RecordTypeHelper.insuranceCompanyAccountRT(),
            name='testAccountx',
            parentId = parentAccount.Id,
            Active__c= true,
            BillingState='CT',
            BillingStreet='134 Laurel',
            BillingCity='Mineola',
            BillingPostalCode='11501',
            BillingCountry='USA',
            ShippingState = 'CT',
            ShippingCountry = 'USA',
            ShippingPostalCode = '11501',
            ShippingCity = 'Mineola',
            ShippingStreet = '134 Laurel',
            Fax = '6022345675');
        insert adjAccount;

        Contact adjContact = new Contact(
            RecordTypeId = RecordTypeHelper.adjusterContactRT(),
            Account = adjAccount,
            FirstName = 'Adj',
            LastName = 'TestAdjuster',
            Status__c='Active',
            MailingCountry='USA',
            MailingState = 'AZ',
            MailingStreet='134 Laurel',
            MailingCity='Phoenix',
            MailingPostalCode='85011',
            Type__c='TPA',
            LeadSource='Event',
            Lead_Source_Description__c='Golf Event',
            OtherCountry='USA',
            OtherState = 'AZ',
            OtherStreet='134 Laurel',
            OtherCity='Phoenix',
            OtherPostalCode='85011');    
        insert adjContact;


        Contact phContact = new Contact(
            RecordTypeId = RecordTypeHelper.policyholderContactRT(),
            FirstName = 'PolicyHolder',
            LastName = 'Contact',
            Status__c='Active',
            MailingCountry='USA',
            MailingState = 'AZ',
            MailingStreet='134 Laurel',
            MailingCity='Phoenix',
            MailingPostalCode='85011',
            Type__c='TPA',
            LeadSource='Event',
            Lead_Source_Description__c='Golf Event',
            OtherCountry='USA',
            OtherState = 'AZ',
            OtherStreet='134 Laurel',
            OtherCity='Phoenix',
            OtherPostalCode='85011');   
        insert phcontact;

        // Insert Users
        Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
        User user1 = new User
                (   Alias = 'ou1',
                    Email='operationsuser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser@crstemphousing.com');
        insert user1; 

         User user2 = new User
                (   Alias = 'ou2',
                    Email='operationsuser2@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing2', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser2@crstemphousing.com');
        insert user2;               
        
    
        Opportunity opportunity = new Opportunity(
            StageName = 'Submitted',
            Name = 'TestClaim',
            Adjuster__c = adjContact.Id,
            Policyholder__c = phContact.Id,
            Initial_Service_Request__c='Housing',
            Number_of_Adults__c = 2,
            Number_of_Children__c = 2,
            Number_of_Bedrooms__c = 3,
            Number_of_Bathrooms__c = 2,
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
            Area_Specialist__c = user1.Id,
            Housing_Coordinator__c = user1.Id,
            Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity;

        
        opportunity = [select Regional_Manager_Assigned__c,Customer_Care_Specialist_Assigned__c,Area_Specialist_Assigned__c,Housing_Coordinator_Assigned__c,Hotel_Customer_Care_Specialist_Assigned__c from opportunity where damaged_Property_Address__c = '123 Big Test Lane'];

        system.assertEquals(Date.today(), opportunity.Regional_Manager_Assigned__c.Date());
        system.assertEquals(Date.today(), opportunity.Customer_Care_Specialist_Assigned__c.Date());
        system.assertEquals(Date.today(), opportunity.Area_Specialist_Assigned__c.Date());
        system.assertEquals(Date.today(), opportunity.Housing_Coordinator_Assigned__c.Date());
        system.assertEquals(Date.today(), opportunity.Hotel_Customer_Care_Specialist_Assigned__c.Date());

        opportunity.Regional_Manager__c = user2.Id;
        opportunity.Customer_Care_Specialist__c = user2.Id;
        opportunity.Area_Specialist__c = user2.Id;
        opportunity.Housing_Coordinator__c = user2.Id;
        opportunity.Hotel_Customer_Care_Specialist__c = user2.Id;

        update opportunity;
       
    }
}