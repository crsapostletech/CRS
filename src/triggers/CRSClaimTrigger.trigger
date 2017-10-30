/*
###########################################################################
# File..................: <<Trigger - CRSAccountNameTrigger>>
# Created by............: <<ApostleTech LLC.>>
# Description...........: <<This trigger overwrites the Account Name in Opportunity record with the Adjuster's Account>>
# Created by the ApostleTech.
###########################################################################*/

trigger CRSClaimTrigger on Opportunity (before insert, before update,after insert, after update) {

    Trigger_Settings__c settings = Trigger_Settings__c.getInstance('CRSClaimTrigger');
    
    if(settings!= null && settings.isActive__c && Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        system.debug(settings+'git testing123');
        ClaimTriggerHandler.setOwnerAsRelationshipManager(Trigger.new,trigger.oldMap);
        ClaimTriggerHandler.CRSAccountNameTrigger(Trigger.new);                     
    }
    
    else if(settings!= null && settings.isActive__c && Trigger.isAfter)
    {
       system.debug(settings+'Entry1');
        if(Trigger.isInsert){
            ClaimTriggerHandler.THATaskCreation(Trigger.new);
         ClaimTriggerHandler.claimFollow(Trigger.New, Trigger.oldMap);
        
            //ClaimTriggerHandler.Claim_CopyAddressToPolicyholderAccountAndContact(Trigger.New,Trigger.OldMap);
        }
        else if(Trigger.isUpdate){
            ClaimTriggerHandler.THATaskUpdate(Trigger.new,Trigger.oldMap);
            ClaimTriggerHandler.UpdateActivePlacementsOnAdjusterChange(Trigger.new,Trigger.oldMap);
            ClaimTriggerHandler.ReassignServiceRequestAutoTasks(Trigger.New,Trigger.oldMap);
            ClaimTriggerHandler.claimFollow(Trigger.New, Trigger.oldMap);
            //ClaimTriggerHandler.Claim_CopyAddressToPolicyholderAccountAndContact(Trigger.New,Trigger.OldMap);
        }
    }
      
}