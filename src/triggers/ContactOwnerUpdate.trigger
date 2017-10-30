/*************************************************************************************************************
Created by: Apostletech team
Purpose: When Contact is inserted or updated based on state code we need to assign the Owner Map Unassigned State Fallback Owner or TSM Map user as contact owner.
Trigger calling a class contactOwnerUpdateHelper
*************************************************************************************************************/
trigger ContactOwnerUpdate on Contact (before insert, before update) {
    if(TriggerControlSetting__c.getValues('ContactOwnerUpdate') <> null && TriggerControlSetting__c.getValues('ContactOwnerUpdate').isActive__c){
            
            
         if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))     
            contactOwnerUpdateHelper.ownerUpdate(trigger.new, trigger.oldMap, Trigger.isInsert);
    }
}