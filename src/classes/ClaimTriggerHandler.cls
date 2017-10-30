public class ClaimTriggerHandler {
    
    
    public static void setOwnerAsRelationshipManager(List<Opportunity> claims, Map<id,opportunity> oldOppMap){
        for(Opportunity claim : claims)
        {                                         
            claim.OwnerId = claim.Regional_Manager__c;
            
            if(trigger.isInsert)
            {
                if (claim.Regional_Manager__c != null)
                    claim.Regional_Manager_Assigned__c = DateTime.now();
                if(claim.Customer_Care_Specialist__c != null)
                    claim.Customer_Care_Specialist_Assigned__c = DateTime.now();
                if(claim.Area_Specialist__c != null) 
                    claim.Area_Specialist_Assigned__c = DateTime.now();
                if(claim.Housing_Coordinator__c != null)
                    claim.Housing_Coordinator_Assigned__c = DateTime.now();
                if(claim.Hotel_Customer_Care_Specialist__c != null)
                    claim.Hotel_Customer_Care_Specialist_Assigned__c = DateTime.now();
            }
            if(trigger.isUpdate)
            {
                opportunity oldOpp = oldOppMap.get(claim.id);
                if(claim.Regional_Manager__c != oldOpp.Regional_Manager__c && claim.Regional_Manager__c != null)
                    claim.Regional_Manager_Assigned__c = DateTime.now();
                if(claim.Customer_Care_Specialist__c != oldOpp.Customer_Care_Specialist__c && claim.Customer_Care_Specialist__c != null)
                    claim.Customer_Care_Specialist_Assigned__c = DateTime.now();
                if(claim.Area_Specialist__c != oldOpp.Area_Specialist__c && claim.Area_Specialist__c != null) 
                    claim.Area_Specialist_Assigned__c = DateTime.now();
                if(claim.Housing_Coordinator__c != oldOpp.Housing_Coordinator__c && claim.Housing_Coordinator__c != null)
                    claim.Housing_Coordinator_Assigned__c = DateTime.now();
                if(claim.Hotel_Customer_Care_Specialist__c != oldOpp.Hotel_Customer_Care_Specialist__c && claim.Hotel_Customer_Care_Specialist__c != null)
                    claim.Hotel_Customer_Care_Specialist_Assigned__c = DateTime.now();
            }
            
        }    
        
    }
    
    // this Method has been moved from CRSAccountNameTrigger 
    
    Public Static void CRSAccountNameTrigger(List<Opportunity> claims)
    {
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Id> adjusterIdList = new List<Id>();
        Map<Id, Id> adjusterAccIdMap = new Map<Id, Id>();
        
        /*
    Iterate the list of new Opportunity records to be saved or updated
    and store their unique Ids in a list
    */
        for (Opportunity opp:claims) {     
            if (opp.Adjuster__c != null) {                               
                adjusterIdList.add(opp.Adjuster__c);      
                opportunities.add(opp);       
            }       
        }
        
        /*
    Get the unique Ids and Account Ids of Adjuster records corresponding to the list of
    new Opportunity records to be saved or updated
    */       
        Contact[] contactAccIdList = [select Id, AccountId from Contact where id in :adjusterIdList];
        
        for (Integer i=0;i<contactAccIdList.size();i++) {      
            adjusterAccIdMap.put(contactAccIdList[i].Id, contactAccIdList[i].AccountId);
        }
        
        /*
Assign the value of Opportunity AccountId with the Account Id of its Adjuster record
*/      
        for (Opportunity opp:claims) {        
            opp.AccountId = adjusterAccIdMap.get(opp.Adjuster__c);
        }
    }
    
    // This method is being called from THATaskCreationOrUpdate it will excute in insert call 
    Public Static Void THATaskCreation(List<Opportunity> claims){
        List<Task> TaskRecords = new List<Task>();
        for(Opportunity O : claims){
            if((O.Initial_Service_Request__c == 'Hotel' || O.Initial_Service_Request__c == 'Housing')  && O.Hotel_Customer_Care_Specialist__c != null){
                
                Task tRec = new Task();
                Integer currentHour = System.now().hour();
                if(currentHour < 17){                                                
                    tRec.Due_Time__c = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
                }
                else{
                    Date nextDayDate = Date.toDay().addDays(1);
                    DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);
                    tRec.Due_Time__c = dueDateTime;
                }                      
                
                tRec.ActivityDate = Date.valueOf(tRec.Due_Time__c); 
                tRec.OwnerId = O.Hotel_Customer_Care_Specialist__c;                        
                tRec.Priority = 'Normal';                      
                tRec.WhatID = O.Id;
                tRec.Status = 'Not Started';
                tRec.Subject = 'Send Temporary Housing Agreement(THA)';                               
                tRec.Type = 'Hold Follow Up';
                trec.WhoId = O.Policyholder__c;                                      
                TaskRecords.add(trec);
            }
        }
        
        if(!TaskRecords.isEmpty()){
            insert TaskRecords;
        }
        
    }
    
    // This method is being called from THATaskCreationOrUpdate it will excute in updatecall 
    
    Public Static void THATaskUpdate(List<Opportunity> claims, Map<Id,Opportunity> oldOppMap){
        
        List<Task> taskExistList = new List<Task>();
        Set<Id> oppIds = new Set<Id>();
        
        Set<Id> claimIds = new Set<Id>(); //This is called from UpdateCostsOnAdjusterChange trigger 
        Map<Id, Id> claimId_OldAdjusterId = new Map<Id, Id>(); //This is called from UpdateCostsOnAdjusterChange trigger
        Map<Id, Id> claimId_NewAdjusterId = new Map<Id, Id>(); //This is called from UpdateCostsOnAdjusterChange trigger 
    
        for(Opportunity O : claims){
            Opportunity oppOld = oldOppMap.get(O.Id);
            
            if(O.Initial_Service_Request__c == 'Hotel' && O.Hotel_Customer_Care_Specialist__c != null){
                
                if(O.Hotel_Customer_Care_Specialist__c != oppOld.Hotel_Customer_Care_Specialist__c){
                    oppIds.add(O.Id);        
                }
            }
            
            // This is called from UpdateCostsOnAdjusterChange trigger -- Start
            if (oppOld.Adjuster__c != o.Adjuster__c)
            {                
                claimIds.add(o.Id);
                claimId_OldAdjusterId.put(o.Id,oppOld.Adjuster__c);
                claimId_NewAdjusterId.put(o.Id,o.Adjuster__c);
            }
        }
        
        
        List<costs__c> costList = [select Id,Searches__r.Service_Request__r.Opportunity__c, Billable_Party__c from costs__c where 
                                    Searches__r.Service_Request__r.Opportunity__c in : claimIds and 
                                    Searches__r.Placement__r.Status__c in ('Searching','Viewing','Pending Confirmation')];
        Boolean updateCost = false;
        for (costs__c cost : costList)
        {
            if (cost.Billable_Party__c == claimId_OldAdjusterId.get(cost.Searches__r.Service_Request__r.Opportunity__c))
            {
                cost.Billable_Party__c = claimId_NewAdjusterId.get(cost.Searches__r.Service_Request__r.Opportunity__c);
                updateCost = true;
            }
        }
        
        if(updateCost)
            update costList;
            //This is called from UpdateCostsOnAdjusterChange trigger -- END
            
        if(!oppIds.isEmpty()){
            
            taskExistList = [Select Id, ownerId, whatId from Task where whatId in: oppIds AND Subject = 'Send Temporary Housing Agreement(THA)' ];
            
            for(Opportunity O : claims){
                if(O.Initial_Service_Request__c == 'Hotel' && O.Hotel_Customer_Care_Specialist__c != null){
                    
                    Opportunity oppOld = oldOppMap.get(O.Id);
                    
                    if(O.Hotel_Customer_Care_Specialist__c != oppOld.Hotel_Customer_Care_Specialist__c){                           
                        
                        boolean isTaskFound = false;
                        for(Task T : taskExistList){
                            if(T.whatId == O.Id){
                                T.ownerId = O.Hotel_Customer_Care_Specialist__c;
                                isTaskFound = true;
                                break;
                            }
                        }
                        
                        if(isTaskFound == false){
                            
                            Task tRec = new Task();
                            Integer currentHour = System.now().hour();
                            
                            if(currentHour < 17){                                                
                                tRec.Due_Time__c = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 17, 0, 0);                                   
                            }
                            else{
                                Date nextDayDate = Date.toDay().addDays(1);
                                DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);
                                tRec.Due_Time__c = dueDateTime;
                            }                      
                            
                            tRec.ActivityDate = Date.valueOf(tRec.Due_Time__c); 
                            tRec.OwnerId = O.Hotel_Customer_Care_Specialist__c;                        
                            tRec.Priority = 'Normal';                      
                            tRec.WhatID = O.Id;
                            tRec.Status = 'Not Started';
                            tRec.Subject = 'Send Temporary Housing Agreement(THA)';                               
                            tRec.Type = 'Hold Follow Up';
                            trec.WhoId = O.Policyholder__c;                                      
                            taskExistList.add(trec);
                        }
                        
                    }
                }
            }
            
            if(!taskExistList.isEmpty()){
                upsert taskExistList;
            }
            
        }
        
    }
    
 // Moved form UpdateActivePlacementsOnAdjusterChange after update 
    Public Static void UpdateActivePlacementsOnAdjusterChange(List<Opportunity> claims, Map<Id,Opportunity> oldOppMap)
    {
      Set<Id> adjusterIds = new Set<Id>();
      Map<Id, Boolean> adjusterId_ActivePlacement = new Map<Id, Boolean>();
      Set<String> closedStatus = new Set<String>{'Moved-Out','Lost Opportunity','Closed','Cancelled'};
      
      for (Opportunity claim : claims)    
        {
            Opportunity OldOpp = oldOppMap.get(claim.id);
              if (OldOpp.Adjuster__c != claim.Adjuster__c)
              {
               adjusterId_ActivePlacement.put(OldOpp.Adjuster__c,false);
               adjusterIds.add(claim.Adjuster__c);  
               adjusterId_ActivePlacement.put(claim.Adjuster__c,false); 
              }
        
         } 
     placement__c [] activePlacements = [select Opportunity__r.Adjuster__c from Placement__c where RecordTypeId =: RecordTypeHelper.housingPlacementRT() and Opportunity__r.Adjuster__c in : adjusterIds and Opportunity__r.Adjuster__c != NULL and Status__c not in : closedStatus];

        for(Placement__c activePlacement : activePlacements)
        {   
            adjusterId_ActivePlacement.put(activePlacement.Opportunity__r.Adjuster__c,true);
        }
    Contact [] contacts = [select Id, Active_Placements__c from Contact where Status__c = 'Active' and Id in : adjusterIds];
    
       for(Contact contact : contacts)
       {
          contact.Active_Placements__c = adjusterId_ActivePlacement.get(contact.Id);
       }
    update contacts;  
    }
    
  //To reassign service request open activities to new user selected on "Hotel Customer Care Specialist" and no value on Initial_SR_being_worked_by__c field in Service Request
    Public Static void ReassignServiceRequestAutoTasks(list<Opportunity> claims, Map<Id,Opportunity> oldOppMap)
    {
        Set<Id> oppIds = new Set<Id>();
      
      for(Opportunity opp : claims){
          if(opp.Initial_Service_Request__c == 'Hotel' && opp.Hotel_Customer_Care_Specialist__c != oldOppMap.get(opp.Id).Hotel_Customer_Care_Specialist__c && opp.Hotel_Customer_Care_Specialist__c != null){
              oppIds.add(opp.Id);
          }
      }   
      
      if(!oppIds.isEmpty()){
          Map<Id,ServiceRequest__c> serviceReqMap = new Map<Id,ServiceRequest__c>([Select Id,  Opportunity__r.Hotel_Customer_Care_Specialist__c from ServiceRequest__c where Opportunity__c in: oppIds AND RecordType.Name = 'Hotel' AND Initial_SR_being_worked_by__c = null]);
     
          if(serviceReqMap.values().size() > 0){
                
                List<Task> taskRecordsList = [Select Id, whatId, OwnerId from Task where whatId in: serviceReqMap.keySet() AND Status != 'Completed' AND (Subject = 'Hotel Options' OR Subject = 'Book Hotel' OR Subject = 'Hotel Needed-Hold Follow Up Call to PH' OR Subject = 'Send Temporary Housing Agreement(THA)' OR Subject = 'Send Credit Card Authorization (CCA)' OR Subject = 'Send Adjuster Confirmation' OR Subject LIKE '%Call Attempt%' OR Subject = 'Confirm Receipt of CCA') ];
        
                for(Task t : taskRecordsList){                    
                     if(serviceReqMap.get(t.whatId) != null && serviceReqMap.get(t.whatId).Opportunity__r.Hotel_Customer_Care_Specialist__c != null)   
                        t.OwnerId = serviceReqMap.get(t.whatId).Opportunity__r.Hotel_Customer_Care_Specialist__c;                    
                } 
                
                if(!taskRecordsList.isEmpty()){
                    update taskRecordsList;
                }
          }
     }
  }
  
  /* Chatter Follow and Unfollow for CRS TEAM Section in Opportunity*/
  public static void claimFollow(list<opportunity> opprecords,Map<Id,opportunity> oldMap){
   Set<Id> oppId = new Set<Id>();
   Set<Id> UnFollowersClaimId = new Set<Id>();
   Set<Id> UnfollowersSubscriberId = new Set<Id>();
   list<EntitySubscription> FollowentitySubrecords = new list<EntitySubscription>();
   list<EntitySubscription> UnfollowentitySubrecords = new list<EntitySubscription>();
   
    Set<String> deleteRecordUserMatchSet = new Set<String>();
    Map<String,String> oppOldUserCustomerCareSpecialistMap = new Map<String,String>();
    Map<String,String> oppOldUserAreaSpecialistMap = new Map<String,String>();
    Map<String,String> oppOldUserRegionalManagerMap = new Map<String,String>();
    Map<String,String> oppOldUserHotelCustomerCareSpecialistMap = new Map<String,String>();
    Map<String,String> oppOldUserHousingCoordinatorMap =  new Map<String,String>();
   
    for(opportunity opp: opprecords){
                      
            if(Trigger.isInsert){
                
                if(opp.id <> null && opp.Customer_Care_Specialist__c <> null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Customer_Care_Specialist__c));
                }
                
                if(opp.id <> null  && opp.Area_Specialist__c <> null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Area_Specialist__c));
                }
                
                if(opp.id <> null  && opp.Regional_Manager__c <> null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Regional_Manager__c ));
                }
                
                if(opp.id <> null && opp.Hotel_Customer_Care_Specialist__c <> null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Hotel_Customer_Care_Specialist__c ));
                }
                
                if(opp.id <> null && opp.Housing_Coordinator__c <> null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Housing_Coordinator__c ));
                }
            }
            
            if(Trigger.isUpdate && ((opp.Customer_Care_Specialist__c != oldMap.get(opp.Id).Customer_Care_Specialist__c ) || (opp.Hotel_Customer_Care_Specialist__c != oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c) || (opp.Area_Specialist__c != oldMap.get(opp.Id).Area_Specialist__c) || (opp.Regional_Manager__c != oldMap.get(opp.Id).Regional_Manager__c) || (opp.Housing_Coordinator__c != oldMap.get(opp.Id).Housing_Coordinator__c))){
                
                oppId.add(opp.id);
                
                // Customer care specialist    
                if(oldMap.get(opp.Id).Customer_Care_Specialist__c != null){
                    UnfollowersSubscriberId.add(oldMap.get(opp.Id).Customer_Care_Specialist__c);
                    unFollowersClaimId.add(opp.id);
                    deleteRecordUserMatchSet.add(opp.id+''+oldMap.get(opp.Id).Customer_Care_Specialist__c);    
                    oppOldUserCustomerCareSpecialistMap.put(opp.Id, oldMap.get(opp.Id).Customer_Care_Specialist__c);                        
                }  
                if(opp.Customer_Care_Specialist__c != null){
                     FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Customer_Care_Specialist__c));
                }
                
                // Area Specialist    
                if(oldMap.get(opp.Id).Area_Specialist__c != null){
                    UnfollowersSubscriberId.add(oldMap.get(opp.Id).Area_Specialist__c);
                    unFollowersClaimId.add(opp.id);
                    deleteRecordUserMatchSet.add(opp.id+''+oldMap.get(opp.Id).Area_Specialist__c);
                    oppOldUserAreaSpecialistMap.put(opp.Id, oldMap.get(opp.Id).Area_Specialist__c);                          
                }
                if(opp.Area_Specialist__c != null){
                    FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Area_Specialist__c));
                } 
                
                // Regional Manager    
                if(oldMap.get(opp.Id).Regional_Manager__c != null){
                    UnfollowersSubscriberId.add(oldMap.get(opp.Id).Regional_Manager__c);
                    unFollowersClaimId.add(opp.id); 
                    deleteRecordUserMatchSet.add(opp.id+''+oldMap.get(opp.Id).Regional_Manager__c); 
                    oppOldUserRegionalManagerMap.put(opp.Id, oldMap.get(opp.Id).Regional_Manager__c);                          
                }
                if(opp.Regional_Manager__c != null){
                    FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Regional_Manager__c));
                }                
                
                // Hotel Customer Care Specialist    
                if(oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c != null){
                    UnfollowersSubscriberId.add(oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c);
                    unFollowersClaimId.add(opp.id); 
                    deleteRecordUserMatchSet.add(opp.id+''+oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c);
                    oppOldUserHotelCustomerCareSpecialistMap.put(opp.Id, oldMap.get(opp.Id).Hotel_Customer_Care_Specialist__c);
                }
                if(opp.Hotel_Customer_Care_Specialist__c != null){
                    FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Hotel_Customer_Care_Specialist__c));                        
                }
                
                // Housing Coordinator    
                if(oldMap.get(opp.Id).Housing_Coordinator__c != null){
                    UnfollowersSubscriberId.add(oldMap.get(opp.Id).Housing_Coordinator__c);
                    unFollowersClaimId.add(opp.id); 
                    deleteRecordUserMatchSet.add(opp.id+''+oldMap.get(opp.Id).Housing_Coordinator__c);
                    oppOldUserHousingCoordinatorMap.put(opp.Id, oldMap.get(opp.Id).Housing_Coordinator__c);
                } 
                if(opp.Housing_Coordinator__c != null){
                    FollowentitySubrecords.add(new EntitySubscription(ParentId = opp.id, SubscriberId = opp.Housing_Coordinator__c));
                } 
                    
            }
                                                                    
    }
    
    
    if(Trigger.isUpdate){    
        // Changing the followers in SR level
        list<ServiceRequest__c> SRRecords = [select id,opportunity__r.Initial_Service_Request__c,opportunity__r.Hotel_Customer_Care_Specialist__c,opportunity__c from ServiceRequest__c where opportunity__c in: oppId AND opportunity__r.Initial_Service_Request__c ='Hotel'];
        list<Placement__c>  PcRecords = [select id,opportunity__c,ServiceRequest__c,opportunity__r.Initial_Service_Request__c,opportunity__r.Hotel_Customer_Care_Specialist__c,opportunity__r.Area_Specialist__c,opportunity__r.Regional_Manager__c,opportunity__r.Customer_Care_Specialist__c,Status__c from Placement__c where opportunity__c in: oppId AND opportunity__r.Initial_Service_Request__c ='Housing'];
        
        // Changing the follower in Hotel Level
        for(ServiceRequest__c SR: SRRecords ){
            if(SR.opportunity__r.Initial_Service_Request__c == 'Hotel' && SR.opportunity__r.Hotel_Customer_Care_Specialist__c <> null){
                
                if(oppOldUserHotelCustomerCareSpecialistMap.keySet().contains(SR.opportunity__c)){   
                    unFollowersClaimId.add(SR.id);
                    deleteRecordUserMatchSet.add(SR.id+''+oppOldUserHotelCustomerCareSpecialistMap.get(SR.opportunity__c));  
                }
                FollowentitySubrecords.add(new EntitySubscription(ParentId = SR.id, SubscriberId = SR.opportunity__r.Hotel_Customer_Care_Specialist__c));
            }
            
        }
        
        // Changing the followers in Housing Level
        for(Placement__c pc: PcRecords ){
            if(pc.opportunity__r.Initial_Service_Request__c == 'Housing' && pc.opportunity__r.Regional_Manager__c <> null && pc.Status__c  != 'Moved-In'){
                if(oppOldUserRegionalManagerMap.keySet().contains(pc.opportunity__c)){      
                    unFollowersClaimId.add(PC.ServiceRequest__c);
                    deleteRecordUserMatchSet.add(PC.ServiceRequest__c+''+oppOldUserRegionalManagerMap.get(pc.opportunity__c));
                }
                    
                FollowentitySubrecords.add(new EntitySubscription(ParentId = PC.ServiceRequest__c, SubscriberId = PC.opportunity__r.Regional_Manager__c ));
            }
            if(pc.opportunity__r.Initial_Service_Request__c == 'Housing' && pc.opportunity__r.Area_Specialist__c <> null && pc.Status__c  != 'Moved-In'){
                if(oppOldUserAreaSpecialistMap.keySet().contains(pc.opportunity__c)){      
                    unFollowersClaimId.add(PC.ServiceRequest__c);
                    deleteRecordUserMatchSet.add(PC.ServiceRequest__c+''+oppOldUserAreaSpecialistMap.get(pc.opportunity__c));
                }
                
                FollowentitySubrecords.add(new EntitySubscription(ParentId = PC.ServiceRequest__c, SubscriberId = PC.opportunity__r.Area_Specialist__c ));
            }
            if(pc.opportunity__r.Initial_Service_Request__c == 'Housing' && pc.opportunity__r.Customer_Care_Specialist__c<> null && pc.Status__c  == 'Moved-In'){
                if(oppOldUserCustomerCareSpecialistMap.keySet().contains(pc.opportunity__c)){      
                    unFollowersClaimId.add(PC.ServiceRequest__c);
                    deleteRecordUserMatchSet.add(PC.ServiceRequest__c+''+oppOldUserCustomerCareSpecialistMap.get(pc.opportunity__c));
                }
                
                FollowentitySubrecords.add(new EntitySubscription(ParentId = PC.ServiceRequest__c, SubscriberId = PC.opportunity__r.Customer_Care_Specialist__c));
            }
            
        }
             
    }
       
       for(EntitySubscription eSub : [select id, parentId, SubscriberId from EntitySubscription where parentId in:unFollowersClaimId AND SubscriberId in:UnfollowersSubscriberId]){
           
           String concatStr = eSub.parentId + '' + eSub.SubscriberId;
           if(deleteRecordUserMatchSet.contains(concatStr))
              UnfollowentitySubrecords.add(eSub); 
           
       }
       
       if(!UnfollowentitySubrecords.IsEmpty())
            Database.Delete(UnfollowentitySubrecords,false);
        
       
            
        if(!FollowentitySubrecords.IsEmpty()) 
            Database.Insert(FollowentitySubrecords,false);
        
   }
  // We calling from Claim_CopyAddressToPolicyholderAccountAndContact After insert and After update
   /* public static void Claim_CopyAddressToPolicyholderAccountAndContact(list<Opportunity> claims, Map<Id,Opportunity> oldOppMap)
    {
        set<Id> contactIds = new set<Id>();
        map<Id, Id> accountIdsByContactId = new map<Id, Id>();
        map<Id, Account> accountsByContactId = new map<Id, Account>();
        
        for (Opportunity o : claims)
        {
        if (Trigger.isInsert || (Trigger.isUpdate && oldOppMap.get(o.Id).Policyholder__c == null))
            contactIds.add(o.Policyholder__c);
        }
             map<Id, Contact> contactsById = new map<Id, Contact>([select Id, AccountId from Contact where Id in :contactIds]);
        for (Contact c : contactsById.values()) {
            accountIdsByContactId.put(c.Id, c.AccountId);
        }
            map<Id, Account> accountsById = new map<Id, Account>([select Id from Account where Id in :accountIdsByContactId.values()]);
        for (Opportunity o : claims) {
        Contact c = contactsById.get(o.Policyholder__c);
        if (c != null) {
            c.MailingPostalCode = o.Damaged_Property_Zip__c;
            c.MailingState = o.Damaged_Property_State__c;
            c.MailingCountry = o.Damaged_Property_Country__c;
            c.MailingCity = o.Damaged_Property_City__c;
            c.MailingStreet = o.Damaged_Property_Address__c;
            
            Account a = accountsById.get(accountIdsByContactId.get(c.Id));
            if (a != null) {
                a.BillingPostalCode = o.Damaged_Property_Zip__c;
                a.BillingState = o.Damaged_Property_State__c;
                a.BillingCountry = o.Damaged_Property_Country__c;
                a.BillingCity = o.Damaged_Property_City__c;
                a.BillingStreet = o.Damaged_Property_Address__c;
            }   
        }
    } 
    update accountsById.values();
    update contactsById.values();   
  }*/
}