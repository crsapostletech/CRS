/*************************************************************************************************************
Created by: Apostletech team
Purpose: In the Owner when Unassigned State Fallback Owner and States are changed we need to check the Reset Owner Assignment.
Class calling from a AccountAssignedMapUpdateTrigger trigger to update the values
*************************************************************************************************************/
public class OwnerResetUpdate{

    public static void accountresetUpdate(List<Owner_Territory__c> ownerMapRecords,  Map<Id, Owner_Territory__c> oldOwnerMapRecords, Boolean isInsert){
        
        Set<id> ownerIds = new Set<id>();
        
        for(Owner_Territory__c oMap : ownerMapRecords){
            
            if(isInsert || (!isInsert && ( (oMap.States__c != oldOwnerMapRecords.get(oMap.Id).States__c) || (oMap.Territory_Owner__c != oldOwnerMapRecords.get(oMap.Id).Territory_Owner__c)) ) ){
            
                if(oMap.Owner_Assignment__c != null)    
                    ownerIds.add(oMap.Owner_Assignment__c);
            }
            
        }
        
        List<Contact> conList = [select id, Account.Assigned_Map__c, Account.Reset_Owner_Assignment__c from Contact where RecordType.Name = 'Adjuster' And(Account.Assigned_Map__c =: ownerIds or Account.Assigned_Map__c = null)];
        set<id> accIds = new set<id>();
        for(Contact c : conList)
        {
            if(c.accountId <> null){
               accIds.add(c.AccountId);
              
            }
        }
        List<Account> AcctToUpdate = new List<Account>();
        for(id acId : accIds)
        {
            System.debug('*****123');
            Account acc = new Account(id = acId,Reset_Owner_Assignment__c = true);
            AcctToUpdate.add(acc);
        }
        if(AcctToUpdate.size()>0) 
        update AcctToUpdate;
        
    }
}