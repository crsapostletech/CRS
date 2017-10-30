/*************************************************************************************************************
Created by: Apostletech team
Purpose: When Contact is inserted or updated based on state code we need to assign the Owner Map Unassigned State Fallback Owner user as contact owner.
Class calling from a AccountAssignedMapUpdateTrigger trigger to update the values
*************************************************************************************************************/
public class ContactOwnerUpdateHelper{
    public static void ownerUpdate(List<contact> conList, Map<id, contact> oldMap, Boolean isInsert){
        
       Set<id> accids = new Set<id>();
        Id adjusterRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Adjuster').getRecordTypeId();
        
        for(contact c: conList){
            if(c.Manual_Owner_Override__c == false && c.recordTypeId == adjusterRecordTypeId && ((isInsert && c.accountId <> null) || (!isInsert && (c.accountId !=  oldMap.get(c.Id).accountId || c.Sales_Status__c != oldMap.get(c.Id).Sales_Status__c || c.otherstate != oldMap.get(c.Id).otherstate) ))){
                accids.add(c.accountId);
            }
        }
        
        Map<Id,Account> acctMap = new Map<Id,Account>([select id, Assigned_Map__c,Contact_Owner_Override__c from Account where id =: accids]);
        
        set<id> accAssessmentIds = new set<id>();
        for(Account acc : acctMap.values()){
            System.debug('****Account****'+acctMap.values());
            accAssessmentIds.add(acc.Assigned_Map__c);
        }        
        
        //Account Map Query
        List<Owner_Territory__c> ownerMapList = [select id, Owner_Assignment__c, States__c,Territory_Owner__c,Owner_Assignment__r.recordtype.name, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c from Owner_Territory__c where Owner_Assignment__c in: accAssessmentIds AND Territory_Owner__c != null AND Owner_Assignment__r.recordtype.name ='RM'];
        
        List<Owner_Territory__c> defaultRMMapList = [Select Id, Owner_Assignment__c,Owner_Assignment__r.recordtype.name, States__c, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c, Territory_Owner__c from Owner_Territory__c where Territory_Owner__c != null AND Owner_Assignment__r.recordtype.name ='Default RM'];
        List<Owner_Territory__c> TSMMapList = [Select Id, Owner_Assignment__c,Owner_Assignment__r.recordtype.name, States__c, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c, Territory_Owner__c from Owner_Territory__c where Territory_Owner__c != null AND Owner_Assignment__r.recordtype.name ='TSM'];
        
        
        Map<Id,List<Owner_Territory__c>> ownerMapListMap = new Map<Id,List<Owner_Territory__c>>();
        
        for(Owner_Territory__c oMap : ownerMapList){
            if(ownerMapListMap.keySet().contains(oMap.Owner_Assignment__c)){
                ownerMapListMap.get(oMap.Owner_Assignment__c).add(oMap);
            }
            else{
                ownerMapListMap.put(oMap.Owner_Assignment__c, new List<Owner_Territory__c>{oMap});
            }
        }  
              
        
        for(contact c: conList){  
            
            if(c.Manual_Owner_Override__c == false && c.recordTypeId == adjusterRecordTypeId && ((isInsert && c.accountId <> null) || (!isInsert && (c.accountId !=  oldMap.get(c.Id).accountId || c.Sales_Status__c != oldMap.get(c.Id).Sales_Status__c || c.otherstate != oldMap.get(c.Id).otherstate) ))){
                    System.debug('***hello1221***');
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
                                    
                                    if((c.OtherState == '' || c.OtherState == null) && oMap.Owner_Assignment__r.recordtype.name == 'Default RM'){
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
                            System.debug(c.Assigned_To_Last_Deal__c+'***hello***'+c.Sales_Status__c);
                            for(Owner_Territory__c oMap : defaultRMMapList){
                                    
                                if((c.OtherState == '' || c.OtherState == null) && oMap.Owner_Assignment__r.recordtype.name =='Default RM'){
                                    c.ownerid = oMap.Territory_Owner__c;
                                    System.debug('***hello456***');
                                    break;
                                }
                            }
                             
                             for(Owner_Territory__c oMap : TSMMapList){  
                                if(c.OtherState != '' && c.OtherState != null && oMap.States__c != null && oMap.States__c != '' ){                            
                                     System.debug('***hello123***');
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
                   
                   
        } // End of Main for loop*/
        
        
    } 
    
}