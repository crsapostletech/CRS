/*************************************************************************************************************
Created by: Apostletech team
Purpose: When user is made inactive to update the owner Territory object territory owner field user
Class calling from a Userinactive trigger to update the values
*************************************************************************************************************/
public class InactiveUsersAssignmentUpdate{
    
    public static void Userupdate(list<user> userslist, Map<Id,user> oldOwnerMap){
        Set<Id> Userid = new Set<Id>();
        for(user u: userslist ){
            if(u.IsActive == False && oldOwnerMap.get(u.id).IsActive <> false){
                Userid.add(u.id);
                System.debug('***User Id ****'+u.id);
            }
        }
        List<Owner_Territory__c> ownerTerritoryList = [select id, Territory_Owner__c, Owner_Assignment__c, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c from Owner_Territory__c where Territory_Owner__c =:Userid ];
        List<id> updateOwnerList = new List<id>();
        if(ownerTerritoryList.size() > 0){
          for(user u: userslist){
            for(Owner_Territory__c ot : ownerTerritoryList){
                if(u.id == ot.Territory_Owner__c  && ot.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c <> null){
                    updateOwnerList.add(ot.id);
                }
            }
          }
        }
        if(!updateOwnerList.isEmpty()){
            UpdateOwnerTerritoryOwner.updateOwnerTerritory(updateOwnerList);
            System.debug('***Hello***');
        }
    } 
}