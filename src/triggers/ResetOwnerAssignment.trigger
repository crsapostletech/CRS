trigger ResetOwnerAssignment on Owner_Territory__c(after insert, after update,before insert,before update) {
     if(TriggerControlSetting__c.getValues('OwnerResetUpdate') <> null && TriggerControlSetting__c.getValues('OwnerResetUpdate').isActive__c){
        if(Trigger.isafter && TriggerControlSetting__c.getValues('OwnerResetUpdate').IsAfter__c){     
            OwnerResetUpdate.accountresetUpdate(trigger.new, trigger.oldMap, Trigger.isInsert);
        }
     }
     if(TriggerControlSetting__c.getValues('DuplicateStateValidation') <> null && TriggerControlSetting__c.getValues('DuplicateStateValidation').isActive__c){
        if(Trigger.isbefore && TriggerControlSetting__c.getValues('DuplicateStateValidation').IsBefore__c){     
            DuplicateStateAlert.duplicateAlert(trigger.new);
        }
     }

}