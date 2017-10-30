trigger PushContactIdsToMulligan on Contact (after insert, after update) 
{
    // Only run this code if this trigger has not previously pushed contact ids on this event
    if(!Util.hasAlreadyFired('Contact') && !system.isBatch())
    {
        Set<Id> updatedRecordIds = new Set<Id>();
            
        integer i = 0; 
        string actionType ='inserted';
        for (Contact contact : Trigger.New)    
        {
            if(trigger.isUpdate)
            {
                if (Trigger.old[i].Total_Finders_Fees_Claims__c != Trigger.new[i].Total_Finders_Fees_Claims__c
                || Trigger.old[i].Total_FRV_Claims__c != Trigger.new[i].Total_FRV_Claims__c
                || Trigger.old[i].Total_Hotel_Claims__c != Trigger.new[i].Total_Hotel_Claims__c
                || Trigger.old[i].Total_Housing_Claims__c != Trigger.new[i].Total_Housing_Claims__c
                || Trigger.old[i].Called_In_By_Last_Deal__c != Trigger.new[i].Called_In_By_Last_Deal__c
                || Trigger.old[i].Assigned_To_Last_Deal__c != Trigger.new[i].Assigned_To_Last_Deal__c
                || Trigger.old[i].Active_Placements__c != Trigger.new[i].Active_Placements__c
                || Trigger.old[i].SMS_Related_Object__c != Trigger.new[i].SMS_Related_Object__c
                || Trigger.old[i].Smagicinteract__SMSOptOut__c != Trigger.new[i].Smagicinteract__SMSOptOut__c
                || Trigger.old[i].Send_Survey__c != Trigger.new[i].Send_Survey__c
                || Trigger.old[i].Claims_Document_Email__c != Trigger.new[i].Claims_Document_Email__c
                || Trigger.old[i].Claims_Document_Fax__c != Trigger.new[i].Claims_Document_Fax__c)
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
            CallOutsToMulligan.PushUpdates('Contact', false, updatedRecordIds, actionType);
            Util.setAlreadyFired('Contact');  
        } 
    }
}