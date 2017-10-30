trigger UpdateCostsOnAdjusterChange on Opportunity (after update) 
{
    Set<Id> claimIds = new Set<Id>();
    Map<Id, Id> claimId_OldAdjusterId = new Map<Id, Id>();
    Map<Id, Id> claimId_NewAdjusterId = new Map<Id, Id>();
    integer i = 0; // No need of using the extra variable for iterating.
    
    for (Opportunity claim : Trigger.New)    
    {
        if (Trigger.old[i].Adjuster__c != Trigger.new[i].Adjuster__c)
        {
            // 
            claimIds.add(claim.Id);
            claimId_OldAdjusterId.put(claim.Id,Trigger.old[i].Adjuster__c);
            claimId_NewAdjusterId.put(claim.Id,Trigger.new[i].Adjuster__c);
        }
        i++;
    }
    
    Costs__c [] costs = [select Id,Searches__r.Service_Request__r.Opportunity__c, Billable_Party__c from costs__c where 
                                Searches__r.Service_Request__r.Opportunity__c in : claimIds and 
                                Searches__r.Placement__r.Status__c in ('Searching','Viewing','Pending Confirmation')];
    Costs__c [] updatedCosts = new Costs__c []{};
    
    for (costs__c cost : costs)
    {
        if (cost.Billable_Party__c == claimId_OldAdjusterId.get(cost.Searches__r.Service_Request__r.Opportunity__c))
        {
            cost.Billable_Party__c = claimId_NewAdjusterId.get(cost.Searches__r.Service_Request__r.Opportunity__c);
            updatedCosts.add(cost);
        }
    }
    update(updatedCosts);
}