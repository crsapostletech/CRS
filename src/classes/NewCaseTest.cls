@isTest
private class NewCaseTest 
{
	
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

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 

        User user = new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='standarduser@crstemphousing.com');
        insert user;

    }


	@isTest static void test_method_one() 
	{
        
        User user = [select id from User where Username = 'standarduser@crstemphousing.com'];

        Contact adjContact = [select id from Contact where LastName = 'TestAdjuster'];


        Case newCase = new Case(
            RecordTypeId = RecordTypeHelper.newCaseRT(),
            Case_Assigned_To__c = user.Id,
            ContactId = adjContact.Id,
            Origin = 'Email',
            Reason ='Deposit');  

        insert newCase;      
		

        CaseComment caseComment = new CaseComment(
      
            ParentId = newCase.Id,
            CommentBody = 'Test Comment');

        insert caseComment;
	}
}