@isTest
private class PushTaskIdsToMulliganTest 
{
	
	@testSetup static void setupTestData()
    {

    	Account account = new Account(
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
        insert account;

        Contact adjContact = new Contact(
            RecordTypeId = RecordTypeHelper.adjusterContactRT(),
            Account = account,
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
            Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity;

        Task task = new Task(
            RecordTypeId = RecordTypeHelper.portalNotesTaskRT(),
            Type = 'Conversation',
            Subject = 'Test Note',
            WhatId = opportunity.Id,
            Originating_Party__c = 'CRS',
            Publish_On_Adjuster_Portal__c = True,
            Publish_On_Policyholder_Portal__c = True,
            Description = 'Test Note for Portal',
            OwnerId = user1.Id,
            Status = 'In Progress',
            ActivityDate = Date.today(),
            Priority = 'Normal');
        insert task;

    }


	@isTest static void test_method_one() 
	{
		 Task task = [select id from Task where Subject = 'Test Note'];
		 task.Status = 'Completed';
         update task;
	}
}