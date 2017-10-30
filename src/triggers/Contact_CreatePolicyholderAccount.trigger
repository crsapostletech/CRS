trigger Contact_CreatePolicyholderAccount on Contact (before insert) {
    map<Contact, Account> accountsByContact = new map<Contact, Account>();
    
    for (Contact c : Trigger.new) {
        system.debug(c);
        if (c.AccountId == null && c.RecordTypeId == RecordTypeHelper.policyholderContactRT()) {
            string name;
            
            if (c.FirstName == null) {
                name = c.LastName;
            } else {
                name = c.FirstName + ' ' + c.LastName;
            }
            
            accountsByContact.put(c, new Account(
                Name = name,
                Phone = c.HomePhone,
                Mobile_Phone__c = c.MobilePhone,
                BillingPostalCode =  c.MailingPostalCode,
                BillingState = c.MailingState,
                BillingCountry = c.MailingCountry,                
                BillingCity = c.MailingCity,
                BillingStreet = c.MailingStreet,
                RecordTypeId = RecordTypeHelper.householdAccountRT()
            ));
        }
    }
    
    system.debug(accountsByContact);
    insert accountsByContact.values();
    
    for (Contact c : accountsByContact.keySet()) {
        c.AccountId = accountsByContact.get(c).Id;
    }
}