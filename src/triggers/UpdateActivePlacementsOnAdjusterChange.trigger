trigger UpdateActivePlacementsOnAdjusterChange on Opportunity (after update) 
{
    Set<Id> adjusterIds = new Set<Id>();
    Map<Id, Boolean> adjusterId_ActivePlacement = new Map<Id, Boolean>();
    Set<String> closedStatus = new Set<String>{'Moved-Out','Lost Opportunity','Closed','Cancelled'};
    
    integer i = 0;
    for (Opportunity claim : Trigger.New)    
    {
        if (Trigger.old[i].Adjuster__c != Trigger.new[i].Adjuster__c)
        {
            adjusterIds.add(Trigger.old[i].Adjuster__c);
            adjusterId_ActivePlacement.put(Trigger.old[i].Adjuster__c,false);
            adjusterIds.add(Trigger.new[i].Adjuster__c);
            adjusterId_ActivePlacement.put(Trigger.new[i].Adjuster__c,false);
        }
        i++;
    }
               
    // get active placements associated with adjusters
    placement__c [] activePlacements = [select Opportunity__r.Adjuster__c from Placement__c where RecordTypeId =: RecordTypeHelper.housingPlacementRT() and Opportunity__r.Adjuster__c in : adjusterIds and Opportunity__r.Adjuster__c != NULL and Status__c not in : closedStatus];

    for(Placement__c activePlacement : activePlacements)
    {   
        adjusterId_ActivePlacement.put(activePlacement.Opportunity__r.Adjuster__c,true);
    }
    
    Contact [] contacts = [select Id, Active_Placements__c from Contact where Status__c = 'Active' and Id in : adjusterIds];
    
    for(Contact contact : contacts)
    {
        contact.Active_Placements__c = adjusterId_ActivePlacement.get(contact.Id);
    }
    update contacts;

}