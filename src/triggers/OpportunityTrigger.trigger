/************** To update Opportunity count in contact *************/
trigger OpportunityTrigger on Opportunity (After insert, After Update){
  
  /*if(Trigger.isInsert || Trigger.isupdate)
       OpportunityTriggerHandler.claimFollow(Trigger.New, Trigger.oldMap);
   */     
}