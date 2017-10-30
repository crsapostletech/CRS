/**********************************************************************************
Created By: Siva
Purpose: Trigger on Agreement,
 - To update "Temporary Housing Agreement" task status to Completed when sent for signature
 - To upload THA document to Mulligan database when it is signed
Test class: 
**********************************************************************************/
trigger AgreementTrigger on echosign_dev1__SIGN_Agreement__c (before insert, after insert, after update) {
    
       if(TriggerControlSetting__c.getValues('AgreementTrigger') <> null &&  TriggerControlSetting__c.getValues('AgreementTrigger').isActive__c){            
                
                TriggerControlSetting__c trigControl = TriggerControlSetting__c.getValues('AgreementTrigger');
                
                if(Trigger.isBefore && Trigger.isInsert){
                    AgreementTriggerHelper.copyOpportunityId(Trigger.new);
                }    
                
                // To update "Temporary Housing Agreement" task status to Completed when sent for signature
                // ***************************** START *********************************************                
                if(Trigger.isAfter && trigControl.IsAfter__c && Trigger.isInsert && trigControl.isInsert__c){
                    AgreementTriggerHelper.updateTHATask(Trigger.new, new Map<Id,echosign_dev1__SIGN_Agreement__c>(), true);                    
                }
                if(Trigger.isAfter && trigControl.IsAfter__c && Trigger.isUpdate && trigControl.isUpdate__c){        
                    AgreementTriggerHelper.updateTHATask(Trigger.new, Trigger.oldMap, false);                    
                }
                // ***************************** END *********************************************
                
                // To upload THA document to Mulligan database when it is signed
                // ***************************** START *********************************************                
                if(Trigger.isAfter && trigControl.IsAfter__c && Trigger.isInsert && trigControl.isInsert__c){
                    AgreementTriggerHelper.uploadSignedTHAToMulliganDatabase(Trigger.new, new Map<Id,echosign_dev1__SIGN_Agreement__c>(), true);                    
                }
                if(Trigger.isAfter && trigControl.IsAfter__c && Trigger.isUpdate && trigControl.isUpdate__c){        
                    AgreementTriggerHelper.uploadSignedTHAToMulliganDatabase(Trigger.new, Trigger.oldMap, false);                    
                }                
                // ***************************** END *********************************************
                
        }
}