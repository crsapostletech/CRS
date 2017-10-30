trigger PushPlacementIdsToMulligan on Placement__c (after delete, after insert, after update) 
{
    // Only run this code if this trigger has not previously pushed contact ids on this event
    if(!Util.hasAlreadyFired('Placement__c'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
            
        integer i = 0;
        string actionType ='inserted'; 
        
        if (trigger.isDelete)
        {
            for (Placement__c placement : Trigger.old)    
            {
                updatedRecordIds.add(placement.Id);
                actionType ='deleted';
                i++;    
            }
        }   
        else
        {       
            for (Placement__c placement : Trigger.new) 
            {
               
                if(trigger.isUpdate)
                {
                    if (Trigger.old[i].Move_In_Docs_Missing__c != Trigger.new[i].Move_In_Docs_Missing__c)
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
        }
        if (!updatedRecordIds.isEmpty())
        {
            CallOutsToMulligan.PushUpdates('Placement__c', trigger.isDelete, updatedRecordIds, actionType);
            Util.setAlreadyFired('Placement__c');  
        } 
    }
}