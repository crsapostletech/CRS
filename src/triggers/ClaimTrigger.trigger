trigger ClaimTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ClaimTriggerHandler.setOwnerAsRelationshipManager(Trigger.new);                     
    }
    /*else if(Trigger.isBefore && Trigger.isUpdate) {         
        ClaimTriggerHandler.setOwnerAsRelationshipManager(Trigger.new);     
    }*/
}