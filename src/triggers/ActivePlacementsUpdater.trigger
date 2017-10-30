trigger ActivePlacementsUpdater on Placement__c (after insert, after update) 
{
    Set<Id> adjusterIds = new Set<Id>();
    Set<Id> landlordIds = new Set<Id>();
    Set<Id> opportunityIds = new Set<Id>();
    Set<Id> selectedSearchIds = new Set<Id>(); 
    
    Map<Id, Boolean> adjusterId_ActivePlacement = new Map<Id, Boolean>();
    Map<Id, Boolean> landlordId_ActivePlacement = new Map<Id, Boolean>();
    Set<String> closedStatus = new Set<String>{'Moved-Out','Lost Opportunity','Closed','Cancelled'};
    

    integer i = 0;
    for (Placement__c placement : Trigger.new)
    {
        if (placement.RecordTypeId == RecordTypeHelper.housingPlacementRT() && trigger.isInsert || placement.RecordTypeId == RecordTypeHelper.housingPlacementRT() && trigger.isUpdate && Trigger.old[i].Status__c != Trigger.new[i].Status__c)
        { 
                  
            // get all unique opp id's
            if (!opportunityIds.contains(placement.Opportunity__c))
            {
                opportunityIds.add(placement.Opportunity__c);
            }
              
            // get all unique selected search id's
            if (!selectedSearchIds.contains(placement.Selected_Search__c))
            {
                selectedSearchIds.add(placement.Selected_Search__c);
            }
         }
         i++;
    }     
    
    Opportunity [] opportunities = [Select Adjuster__c from opportunity where Id =: opportunityIds and Adjuster__c != null];
    
    for (Opportunity opportunity : opportunities)   
    {
        if (!adjusterIds.contains(opportunity.Adjuster__c))
        {
            adjusterIds.add(opportunity.Adjuster__c);
            adjusterId_ActivePlacement.put(opportunity.Adjuster__c,false);
        }
    }           
  
    Searches__c [] searches = [Select Landlord__c from Searches__c where Id =: selectedSearchIds and Landlord__c != null];
    
    for (Searches__c search : searches) 
    {
        if (!landlordIds.contains(search.Landlord__c))
        {
            landlordIds.add(search.Landlord__c);
            landlordId_ActivePlacement.put(search.Landlord__c,false);
        }
    }
    
    // get active placements associated with adjusters
    placement__c [] activePlacements = [select Opportunity__r.Adjuster__c from Placement__c where Opportunity__r.Adjuster__c = : adjusterIds and Status__c <> : closedStatus];

    for(Placement__c activePlacement : activePlacements)
    {   
        adjusterId_ActivePlacement.put(activePlacement.Opportunity__r.Adjuster__c,true);
    }
    
    // get active placements associated with landlords
    activePlacements = [select Selected_Search__r.Landlord__c from Placement__c where Selected_Search__r.Landlord__c = : landlordIds and Selected_Search__r.Landlord__c != NULL and Status__c <> : closedStatus];

    for(Placement__c activePlacement : activePlacements)
    {   
        landlordId_ActivePlacement.put(activePlacement.Selected_Search__r.Landlord__c,true);
    }
 
    
    Contact [] contacts = [select Id, RecordTypeId, Active_Placements__c from Contact where Status__c = 'Active' and (Id =: adjusterIds or Id =: landlordIds)];
    
    for(Contact contact : contacts)
    {
        if (contact.RecordTypeId == RecordTypeHelper.adjusterContactRT())
        {
            contact.Active_Placements__c = adjusterId_ActivePlacement.get(contact.Id);
        }
        else
        {
            if (contact.RecordTypeId == RecordTypeHelper.landlordContactRT())
            {
                contact.Active_Placements__c = landlordId_ActivePlacement.get(contact.Id);
            }   
        }
    }
    update contacts;
}