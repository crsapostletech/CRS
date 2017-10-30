trigger Claim_CopyAddressToPolicyholderAccountAndContact on Opportunity (after insert, after update) {
    set<Id> contactIds = new set<Id>();
    map<Id, Id> accountIdsByContactId = new map<Id, Id>();
    map<Id, Account> accountsByContactId = new map<Id, Account>();
    
    for (Opportunity o : Trigger.new)
    {
        if (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(o.Id).Policyholder__c == null))
            contactIds.add(o.Policyholder__c);
    }
    
    map<Id, Contact> contactsById = new map<Id, Contact>([select Id, AccountId from Contact where Id in :contactIds]);
    
    for (Contact c : contactsById.values()) {
        accountIdsByContactId.put(c.Id, c.AccountId);
    }

    map<Id, Account> accountsById = new map<Id, Account>([select Id from Account where Id in :accountIdsByContactId.values()]);

    for (Opportunity o : Trigger.new) {
        Contact c = contactsById.get(o.Policyholder__c);
        if (c != null) {
            c.MailingPostalCode = o.Damaged_Property_Zip__c;
            c.MailingState = o.Damaged_Property_State__c;
            c.MailingCountry = o.Damaged_Property_Country__c;
            c.MailingCity = o.Damaged_Property_City__c;
            c.MailingStreet = o.Damaged_Property_Address__c;
            
            Account a = accountsById.get(accountIdsByContactId.get(c.Id));
            if (a != null) {
                a.BillingPostalCode = o.Damaged_Property_Zip__c;
                a.BillingState = o.Damaged_Property_State__c;
                a.BillingCountry = o.Damaged_Property_Country__c;
                a.BillingCity = o.Damaged_Property_City__c;
                a.BillingStreet = o.Damaged_Property_Address__c;
            }   
        }
    }
    
    update accountsById.values();
    update contactsById.values();
}