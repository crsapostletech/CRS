/*************************************************************************************************************
Created by: Apostletech team
Purpose: When any changes made to the Owner Map states, RM Owner and TSM Owner Reset Owner Assignment   field in Account object is updated then we need to run the batch class to update the contact owner assignment
Class calling from a scheduledBatchContactOwnerUpdate schedule class to update the owner.
*************************************************************************************************************/
global class ContactOwnerUpdateBatch implements Database.Batchable<sObject> {    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, accountId, account.Reset_Owner_Assignment__c, Sales_Status__c, OtherState FROM Contact where (account.Reset_Owner_Assignment__c = true OR ( accountId = null AND (Sales_Status__c = \'Actual Customer\' OR Sales_Status__c = \'Target Customer\'))) And Manual_Owner_Override__c = false And RecordType.Name = \'Adjuster\'';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
         
         Set<id> accids = new Set<id>();
         
         for(Contact c : conList){
             if(c.accountid <> null){
                accids.add(c.accountId);
             }         
         }
         
         Map<Id,Account> acctMap = new Map<Id,Account>([select Id, Assigned_Map__c, Contact_Owner_Override__c from Account where Id in: accids]);
         set<id> accAssessmentIds = new set<id>();
         
         for(Account acc : acctMap.values()){
         
             acc.Reset_Owner_Assignment__c = false;
         
              if(acc.Assigned_Map__c != null)
                  accAssessmentIds.add(acc.Assigned_Map__c);
         }
        
        
        //Account Map Query
        List<Owner_Territory__c> ownerMapList = [select id, Owner_Assignment__c, States__c, Territory_Owner__c, Owner_Assignment__r.recordtype.Name, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c from Owner_Territory__c where Owner_Assignment__c in: accAssessmentIds];
        Map<Id,List<Owner_Territory__c>> ownerMapListMap = new Map<Id,List<Owner_Territory__c>>();
        
        for(Owner_Territory__c oMap : ownerMapList){
            if(ownerMapListMap.keySet().contains(oMap.Owner_Assignment__c)){
                ownerMapListMap.get(oMap.Owner_Assignment__c).add(oMap);
            }
            else{
                ownerMapListMap.put(oMap.Owner_Assignment__c, new List<Owner_Territory__c>{oMap});
            }
        }
        
        List<Owner_Territory__c> defaultRMMapList = [Select Id, Owner_Assignment__c, States__c, Owner_Assignment__r.recordtype.Name, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c, Territory_Owner__c from Owner_Territory__c  where Owner_Assignment__r.recordtype.Name ='Default RM' AND Territory_Owner__c != null];
        List<Owner_Territory__c> TSMMapList = [Select Id, Owner_Assignment__c, States__c, Owner_Assignment__r.recordtype.Name, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c, Territory_Owner__c from Owner_Territory__c where Owner_Assignment__r.recordtype.Name ='TSM' AND Territory_Owner__c != null];
                
        for(contact c: conList){
            
            // Account Map assignment
                    if( (c.accountid == null && c.Sales_Status__c == 'Actual Customer') || (c.accountid <> null && acctMap.get(c.accountid) != null && (acctMap.get(c.accountid).Contact_Owner_Override__c == 'Always RM' || ((acctMap.get(c.accountid).Contact_Owner_Override__c == '' || acctMap.get(c.accountid).Contact_Owner_Override__c == null) && c.Sales_Status__c == 'Actual Customer'))) ){
                    
                            List<Owner_Territory__c> ownerMapDummyList = new List<Owner_Territory__c>();                    
                            
                            // When Contact has Account and that Account has value in Assigned_Map__c field
                            //************************************************** START ****************************************************************************
                            if(c.accountid <> null && acctMap.get(c.accountid) != null && ownerMapListMap.get(acctMap.get(c.accountid).Assigned_Map__c) != null){                        
                                ownerMapDummyList = ownerMapListMap.get(acctMap.get(c.accountid).Assigned_Map__c);
                            }
                            //************************************************** END ****************************************************************************
                    
                            // When contact doesn't has Account OR contact has Account but no value in Assigned_Map__c field 
                            //************************************************** START ****************************************************************************                   
                            if(c.accountid == null || (c.accountid != null && ownerMapListMap.get(acctMap.get(c.accountid).Assigned_Map__c) == null)){                    
                                ownerMapDummyList = defaultRMMapList;
                            }
                            //************************************************** END ****************************************************************************
                            
                            if(!ownerMapDummyList.isEmpty()){
                                
                                for(Owner_Territory__c oMap : ownerMapDummyList){
                                    
                                    if((c.OtherState == '' || c.OtherState == null) && oMap.Owner_Assignment__r.recordtype.Name =='Default RM'){
                                        c.ownerid = oMap.Territory_Owner__c;
                                        break;
                                    }
                                    
                                    if(c.OtherState != '' && c.OtherState != null && oMap.States__c != null && oMap.States__c != '' ){                            
                                         
                                          List<String> states = oMap.States__c.split(';');
                                          Set<String> statecodes = new Set<String>();
                                          statecodes.addAll(states);
                                          
                                          if(statecodes.contains(c.otherstate)){
                                                if(oMap.Territory_Owner__c <> null){
                                                     c.ownerid = oMap.Territory_Owner__c;
                                                     break;
                                                }
                                          }
                                          else{
                                              if(oMap.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c <> null){
                                                  c.ownerid = oMap.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c;
                                              }
                                          }
                                    }
                                }
                            }
                            
                    }
                    
                    // TSM Map Assignment
                    if( (c.accountid == null && c.Sales_Status__c == 'Target Customer') || (c.accountid <> null && acctMap.get(c.accountid) != null && (acctMap.get(c.accountid).Contact_Owner_Override__c == 'Always TSM' || ((acctMap.get(c.accountid).Contact_Owner_Override__c == '' || acctMap.get(c.accountid).Contact_Owner_Override__c == null) && c.Sales_Status__c == 'Target Customer'))) ){
                        
                            for(Owner_Territory__c oMap : defaultRMMapList){
                                    
                                if((c.OtherState == '' || c.OtherState == null) && oMap.Owner_Assignment__r.recordtype.name =='Default RM'){
                                    c.ownerid = oMap.Territory_Owner__c;
                                    System.debug('***hello456***');
                                    break;
                                }
                            }
                                for(Owner_Territory__c oMap : TSMMapList){  
                                if(c.OtherState != '' && c.OtherState != null && oMap.States__c != null && oMap.States__c != '' ){                            
                                     
                                      List<String> states = oMap.States__c.split(';');
                                      Set<String> statecodes = new Set<String>();
                                      statecodes.addAll(states);
                                      
                                      if(statecodes.contains(c.otherstate)){
                                            if(oMap.Territory_Owner__c <> null){
                                                 c.ownerid = oMap.Territory_Owner__c;
                                                 break;
                                            }
                                      }
                                      else{
                                           if(oMap.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c <> null){
                                                  c.ownerid = oMap.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c;
                                            }
                                      }
                                }
                            }
                    }        
                
        } // End of Main for loop 
         
        update conList;
        
        if(!acctMap.values().isEmpty()){
            Util.setAlreadyFired('Account');
            update acctMap.values();
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    } 
}