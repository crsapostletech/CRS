trigger CreateFrontDeskContact on Account (after insert) 
{
	
	List<Account> hotelAccounts = new List<Account>();
	List<Id> hotelAccountIds = new List<Id>();
	Map<Id, Account> hotelAccountMap = new Map<Id, Account>();
	
	
	for (Account account : Trigger.new)
	{
		if (account.RecordTypeId == RecordTypeHelper.hotelAccountRT())
		{
			hotelAccounts.add(account);
			hotelAccountIds.add(account.Id);
			hotelAccountMap.put(account.Id, account);
		}
	}
	
	if (hotelAccounts.size() > 0)
	{
				
		List<Contact> contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
															from Contact 
															where FirstName = 'Front'
           													and LastName = 'Desk'
           													and RecordTypeId = :RecordTypeHelper.hotelContactRT()
           													and AccountId in :hotelAccountIds];
           													
    List<Contact> newContacts = new List<Contact>();
           													
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    
    for(Contact c : contacts)
    {
    	contactMap.put(c.AccountId, c);
    }
    
    for(Id i :hotelAccountIds)
    {
    	if (!contactMap.containsKey(i))
    	{
    		Account acct = hotelAccountMap.get(i);
    		
    		Contact c = new Contact();
    		c.AccountId = i;
    		c.RecordTypeId = RecordTypeHelper.hotelContactRT();
    		c.Status__c = 'Active';
    		c.FirstName = 'Front';
    		c.LastName = 'Desk';
    		c.Fax = acct.Fax;
    		c.Email = acct.Email__c;
    		c.Primary_Email__c = acct.Email__c;
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