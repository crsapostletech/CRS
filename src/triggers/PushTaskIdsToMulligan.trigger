trigger PushTaskIdsToMulligan on Task (after update)  
{
    // Only run this code if this trigger has not previously pushed task ids on this event
    if(!Util.hasAlreadyFired('Task'))
    {
        Set<Id> updatedRecordIds = new Set<Id>();
            
        integer i = 0; 
        string actionType ='inserted';
        for (Task task : Trigger.New)    
        {
            if (task.RecordTypeId == RecordTypeHelper.portalNotesCompletedTaskRT())
            {
                updatedRecordIds.add(Trigger.new[i].Id);
            }          
            i++;
        } 
        if (!updatedRecordIds.isEmpty())
        {
            CallOutsToMulligan.PushUpdates('Task', false ,updatedRecordIds, actionType);
            Util.setAlreadyFired('Task'); 
        }
    }
}