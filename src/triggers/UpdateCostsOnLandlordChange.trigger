trigger UpdateCostsOnLandlordChange on Searches__c (after update) 
{
	Set<Id> searchIds = new Set<Id>();
	Map<Id, Id> searchId_OldLandlordId = new Map<Id, Id>();
	Map<Id, Id> searchId_NewLandlordId = new Map<Id, Id>();
	integer i = 0; 
	
	for (Searches__c search : Trigger.New)    
	{
		if (Trigger.old[i].Landlord__c != Trigger.new[i].Landlord__c)
		{
			// 
            searchIds.add(search.Id);
            searchId_OldLandlordId.put(search.Id,Trigger.old[i].Landlord__c);
            searchId_NewLandlordId.put(search.Id,Trigger.new[i].Landlord__c);
        }
		i++;
	}
    
    Costs__c [] costs = [select Id,Searches__c, Payable_Party__c from costs__c where Searches__c = : searchIds and Searches__r.Placement__r.Status__c in ('Searching','Viewing','Pending Confirmation')];
		
	for (costs__c cost : costs)
	{
		if (cost.Payable_Party__c == searchId_OldLandlordId.get(cost.Searches__c))
		{
			cost.Payable_Party__c = searchId_NewLandlordId.get(cost.Searches__c);
		}
	}
	update(costs);
}