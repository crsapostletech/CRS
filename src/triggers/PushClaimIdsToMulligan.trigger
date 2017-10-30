trigger PushClaimIdsToMulligan on Opportunity (after insert, after update) 
{
    // Only run this code if this trigger has not previously pushed contact ids on this event
    if(!Util.hasAlreadyFired('Claim'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
            
        integer i = 0; 
        string actionType ='inserted';
        for (Opportunity claim : Trigger.New)    
        {
            if(trigger.isUpdate)
            {
                if (Trigger.old[i].Hotel_Only__c != Trigger.new[i].Hotel_Only__c)
                {}
                else
                {
                    updatedRecordIds.add(Trigger.new[i].Id);
                    actionType ='updated';
                }     
            }
            else
            {
                updatedRecordIds.add(Trigger.new[i].Id);    
            }
            i++;
        }
        if (!updatedRecordIds.isEmpty())
        {
            CallOutsToMulligan.PushUpdates('Claim', false, updatedRecordIds, actionType);
            Util.setAlreadyFired('Claim'); 
        } 
    }
}