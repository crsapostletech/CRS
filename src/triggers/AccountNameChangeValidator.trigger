trigger AccountNameChangeValidator on Account (before update) 
{
    String profileName = Util.getUserProfileName();
    for (Account account : Trigger.new)
    {
        if (account.RecordTypeId == RecordTypeHelper.landlordAccountRT())
        {
            if (Trigger.old[0].Name != Trigger.new[0].Name)
            {
                integer count = [select count() from Placement__c where Status__c IN ('Moved-In','Moved-Out','Closed','Cancelled') and selected_search__r.Landlord__r.Account.Id =: account.Id];
                if (count > 0 && profileName != 'Accounting Manager' && profileName != 'CRS Billing Specialist' && 
                    profileName != 'System Administrator')
                {
                    account.Name.addError('You cannot change the name of this account.' + '<br/>' + 'Please contact accounting if you need this account name changed.',false);
                }
            }
        }
    }
}