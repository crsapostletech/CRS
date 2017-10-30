/*************************************************************************************************************
Created by: Apostletech team
Purpose: When Assignment Map is updated in parent account we need to update all the child Account Assignment Map values.
Class calling from a AccountAssignedMapUpdateTrigger trigger to update the values
*************************************************************************************************************/

public class AccountAssignedMapUpdate{

    public static void accountUpdate(List<Account> accountRecords,  Map<Id, Account> oldAccountRecords){
        System.debug('***hello****');
        set<id> accids = new set<id>();
        for(Account ac: accountRecords){
           
            if(ac.Assigned_Map__c <> oldAccountRecords.get(ac.id).Assigned_Map__c || ac.Contact_Owner_Override__c <> oldAccountRecords.get(ac.id).Contact_Owner_Override__c){
                System.debug('***Test***'+ac.Assigned_Map__c);
                accids.add(ac.id);
            }
        }
        
        List<Account> accList = [select id, Contact_Owner_Override__c, Active__c, Assigned_Map__c , parentId, parent.ParentId, parent.parent.ParentId, parent.parent.parent.ParentId, parent.parent.parent.parent.ParentId, parent.parent.parent.parent.parent.ParentId from Account where parentId =: accids OR parent.ParentId =: accids OR parent.parent.parentId =: accids OR parent.parent.parent.parentId =: accids OR parent.parent.parent.parent.parentId =: accids OR parent.parent.parent.parent.parent.parentId =: accids];
        
        System.debug('****Account Size1***'+accList.size());
        set<id> accchildids = new set<id>();
        for(Account acc: accList){
           if(acc.parent.parent.parent.parent.parent.parentId <> null){
              accchildids.add(acc.parent.parent.parent.parent.parent.parentId);
           }
        }
        
        List<Account> accchildList = [select id, Assigned_Map__c,Active__c, Contact_Owner_Override__c, parentId, parent.ParentId, parent.parent.ParentId, parent.parent.parent.ParentId, parent.parent.parent.parent.ParentId, parent.parent.parent.parent.parent.ParentId from Account where parentId =: accchildids OR parent.ParentId =: accchildids OR parent.parent.parentId =: accchildids OR parent.parent.parent.parentId =: accchildids OR parent.parent.parent.parent.parentId =: accchildids OR parent.parent.parent.parent.parent.parentId =: accchildids];
        
        List<Account> updateAccountList = new List<Account>();
        set<id> duplicateSet = new set<id>();
        for(Account a : accountRecords){
            for(Account ac : accList){
                if(a.id == ac.parentid || a.id == ac.parent.parentId || a.id == ac.parent.parent.parentId || a.id == ac.parent.parent.parent.parentId || a.id == ac.parent.parent.parent.parent.parentId || a.id == ac.parent.parent.parent.parent.parent.parentId){
                       ac.Assigned_Map__c = a.Assigned_Map__c;
                       ac.Contact_Owner_Override__c = a.Contact_Owner_Override__c;
                       ac.Reset_Owner_Assignment__c = true;
                       if(!duplicateSet.contains(ac.id)){
                           duplicateset.add(ac.id);
                           updateAccountList.add(ac);
                       }
                       
                       if(a.id == ac.parent.parent.parent.parent.parent.parentId){
                           for(Account acchild : accchildList ){
                                    if(a.id == acchild.parentid || a.id == acchild.parent.parentId || a.id == acchild.parent.parent.parentId || a.id == acchild.parent.parent.parent.parentId || a.id == acchild.parent.parent.parent.parent.parentId || a.id == acchild.parent.parent.parent.parent.parent.parentId){
                                       acchild.Assigned_Map__c = a.Assigned_Map__c;
                                       acchild.Contact_Owner_Override__c = a.Contact_Owner_Override__c;
                                       acchild.Reset_Owner_Assignment__c = true;
                                       if(!duplicateSet.contains(acchild.id)){
                                             duplicateset.add(acchild.id);
                                             updateAccountList.add(acchild);
                                       }
                                    }
                            }
                       }
                }
            }
            
        }
        
        List<Account> activeAccountList = new List<Account>();
        for(Account a : updateAccountList){
            if(a.Active__c == true){
                 activeAccountList.add(a);   
            }
        }
         update activeAccountList;  
        //list<Database.SaveResult> results = Database.update(activeAccountList, false);
        //System.debug('****DebugErrors****'+results);
    }
    
    // In a account Assigned Map and contact Owner Override checkbox is Edited//
    
    public static void accountCheckboxUpdate(List<Account> accountRecords,  Map<Id, Account> oldAccountRecords){
        set<id> accids = new set<id>();
        for(Account ac: accountRecords){
            if(ac.Assigned_Map__c <> oldAccountRecords.get(ac.id).Assigned_Map__c || ac.Contact_Owner_Override__c <> oldAccountRecords.get(ac.id).Contact_Owner_Override__c){
                accids.add(ac.id);
                System.debug('***hello****');
            }
        }
        
        List<Account> accList = [select id, Contact_Owner_Override__c,Reset_Owner_Assignment__c ,  Assigned_Map__c from Account where id =: accids];
       
        if(accList.size() > 0){
            for(Account ac: accountRecords){
                    ac.Reset_Owner_Assignment__c = true;
                    System.debug('***hello123****');
            }
        }
        
        
    }
    public static boolean firstRun = true; 
    
    
}