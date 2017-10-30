/*************************************************************************************************************
Created by: Apostletech team
Purpose: Cannot Create morethan one recordtype for Default RM and TSM Records.
*************************************************************************************************************/

trigger ValidationSingleTSMandRM on Owner_Assignment_Map__c(before insert, before update) {
    if(TriggerControlSetting__c.getValues('ValidationSingleTSMandRM') <> null && TriggerControlSetting__c.getValues('ValidationSingleTSMandRM').isActive__c){
        ValidationSingleTSMandRMhelperClass.ValidateRecordType(trigger.new);
    }

}