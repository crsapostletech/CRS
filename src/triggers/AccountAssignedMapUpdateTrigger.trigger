/*************************************************************************************************************
Created by: Apostletech team
Purpose: When Assignment Map is updated in parent account we need to update all the child Account Assignment Map values.
trigger calling class a AccountAssignedMapUpdate to update the values
*************************************************************************************************************/
trigger AccountAssignedMapUpdateTrigger on Account (after Update, before update) {
    if(TriggerControlSetting__c.getValues('AssignmentMapUserUpdate') <> null && TriggerControlSetting__c.getValues('AssignmentMapUserUpdate').isActive__c){
        if(Trigger.isUpdate && TriggerControlSetting__c.getValues('AssignmentMapUserUpdate').isActive__c && AccountAssignedMapUpdate.firstRun){ 
             
            if(Trigger.isafter && TriggerControlSetting__c.getValues('AssignmentMapUserUpdate').IsAfter__c){         
                AccountAssignedMapUpdate.firstRun = false; 
                AccountAssignedMapUpdate.accountUpdate(trigger.new,trigger.oldMap);
                
            }
            
            if(Trigger.isbefore && TriggerControlSetting__c.getValues('AssignmentMapUserUpdate').IsBefore__c){      
                AccountAssignedMapUpdate.accountCheckboxUpdate(trigger.new,trigger.oldMap);
            }
        }
    }

}