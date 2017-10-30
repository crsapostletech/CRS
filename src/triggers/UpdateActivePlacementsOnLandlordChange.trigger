trigger UpdateActivePlacementsOnLandlordChange on Searches__c (after update) 
{
    Set<Id> landlordIds = new Set<Id>();
    Map<Id, Boolean> landlordId_ActivePlacement = new Map<Id, Boolean>();
    Set<String> closedStatus = new Set<String>{'Moved-Out','Lost Opportunity','Closed','Cancelled'};
    
    integer i = 0;
    for (Searches__c search : Trigger.new)
    {
        if (search.RecordTypeId == RecordTypeHelper.housingSearchRT())
        {
	        if (Trigger.old[i].Landlord__c != Trigger.new[i].Landlord__c && Trigger.new[i].Selected__c == true || Trigger.old[i].Selected__c != Trigger.new[i].Selected__c)
	        { 
	            if (Trigger.old[i].Landlord__c != null)
	            {
	            	landlordIds.add(Trigger.old[i].Landlord__c);
	            	landlordId_ActivePlacement.put(Trigger.old[i].Landlord__c,false);
	            }
	            landlordIds.add(Trigger.new[i].Landlord__c);
	            if (Trigger.new[i].Selected__c == true)
	            {
	            	landlordId_ActivePlacement.put(Trigger.new[i].Landlord__c,true);
	            }
	            else
	            {
	            	landlordId_ActivePlacement.put(Trigger.new[i].Landlord__c,false);
	            }       
	        }
	    }
        i++;
    }     
    
    // get active placements associated with landlords
    placement__c [] activePlacements = [select Selected_Search__r.Landlord__c from Placement__c where RecordTypeId =: RecordTypeHelper.housingPlacementRT() and Selected_Search__r.Landlord__c in : landlordIds and Selected_Search__r.Landlord__c != NULL and Status__c not in : closedStatus];

    for(Placement__c activePlacement : activePlacements)
    {   
        landlordId_ActivePlacement.put(activePlacement.Selected_Search__r.Landlord__c,true);
    }
 
    
    Contact [] contacts = [select Id, Active_Placements__c from Contact where Status__c = 'Active' and Id in : landlordIds];
    
    for(Contact contact : contacts)
    {
    	contact.Active_Placements__c = landlordId_ActivePlacement.get(contact.Id);
    }
    update contacts;
}