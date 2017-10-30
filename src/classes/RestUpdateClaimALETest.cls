@isTest
private class RestUpdateClaimALETest {
	
	@testSetup static void setupTestData()
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
            FirstName = 'phContact',
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
        

        Contact llContact = new Contact(
            RecordTypeId = RecordTypeHelper.landlordContactRT(),
            LastName='TestLandLord',
            Status__c='Active',
            MailingCountry='USA',
            MailingState='CT',
            MailingStreet='134 Laurel',
            MailingCity='Mineola',
            MailingPostalCode='11501');
        insert llContact;

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
    }

	@isTest static void test_method_one() {
		
		Opportunity claim = [select id from opportunity where Damaged_Property_Address__c = '123 Big Test Lane'];

		RestRequest req = new RestRequest();
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {
            // production endpoint
            req.requestURI = 'https://login.salesforce.com/services/apexrest/Claim/UpdateClaimALE';
        }
        else
        {
            // test endpoint
            req.requestURI = 'https://test.salesforce.com/services/apexrest/Claim/UpdateClaimALE';
        }
        req.httpMethod = 'PATCH';
        
       
        string expectedresult = 'ALE updated for claim id ' + claim.Id;
                
        RestContext.request = req;
			
		String claimId = claim.Id;
		Double claimALESpent = 250.00;
		Double claimALEScheduled = 100.00;
		    	
		String results = RESTUpdateClaimALE.updateClaimALE(claimId,claimALESpent,claimALEScheduled);
		System.assertEquals(expectedresult,results);
		
		
		//setup request with bad data to cover exceptions 

		expectedresult = 'ALE update failed for claim id ' + claim.Id;

		claimALESpent = 350.00;
		claimALEScheduled = 11111111111100.00;
		
		
		results = RESTUpdateClaimALE.updateClaimALE(claimId,claimALESpent,claimALEScheduled);
		System.assertEquals(expectedresult,results);
		
	}
	
}