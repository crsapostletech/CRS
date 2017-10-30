trigger CreateLandlordContact on Account (after insert) 
{
	List<Account> landlordAccounts = new List<Account>();
	List<Id> landlordAccountIds = new List<Id>();
	Map<Id, Account> landlordAccountMap = new Map<Id, Account>();
	
	for (Account account : Trigger.new)
	{
		if (account.RecordTypeId == RecordTypeHelper.landlordAccountRT())
		{
			landlordAccounts.add(account);
			landlordAccountIds.add(account.Id);
			landlordAccountMap.put(account.Id, account);
		}
	}
	
	if (landlordAccounts.size() > 0)
	{
		List<Contact> contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId from Contact 
																		where FirstName = 'Landlord' 
																		and LastName = 'Contact'
           																and RecordTypeId = :RecordTypeHelper.landlordContactRT()
           																and AccountId in :landlordAccountIds];
           													
	    List<Contact> newContacts = new List<Contact>();
	           													
	    Map<Id, Contact> contactMap = new Map<Id, Contact>();
	    
	    for(Contact c : contacts)
	    {
	    	contactMap.put(c.AccountId, c);
	    }
	    
	    for(Id i :landlordAccountIds)
	    {
	    	if (!contactMap.containsKey(i))
	    	{
	    		Account acct = landlordAccountMap.get(i);
	    		
	    		Contact c = new Contact();
	    		c.AccountId = i;
	    		c.RecordTypeId = RecordTypeHelper.landlordContactRT();
	    		c.FirstName = acct.Contact_First_Name__c;
	    		c.LastName = acct.Contact_Last_Name__c;
	    		c.Status__c = 'Active';
	    		c.Fax = acct.Fax;
	    		c.Email = acct.Email__c;
	    		c.MobilePhone = acct.Mobile_Phone__c;
	    		c.MailingCity = acct.BillingCity;
	    		c.MailingPostalCode = acct.BillingPostalCode;
	    		c.MailingState = acct.BillingState;
	    		c.MailingStreet = acct.BillingStreet;
	    		c.MailingCountry = acct.BillingCountry;
	    		
	    		newContacts.add(c);
	    	}
	    }
	    insert newContacts;
	}
}