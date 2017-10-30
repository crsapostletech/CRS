public class OpportunityTriggerHandler
{
  /* Chatter Follow and Unfollow for CRS TEAM Section in Opportunity*/
  /*public static void claimFollow(list<opportunity> opprecords,Map<Id,opportunity> oldMap){
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
        
   }*/
}