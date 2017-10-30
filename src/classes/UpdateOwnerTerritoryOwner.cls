/*************************************************************************************************************
Created by: Apostletech team
Purpose: When user is made inactive to update territory owner user values
Class calling from a class inactiveUsersAssignmentUpdate to update territory owner user values
*************************************************************************************************************/
public class UpdateOwnerTerritoryOwner{
  @future
  public static void updateOwnerTerritory(List<id> updateOwnerList) {
       List<Owner_Territory__c> territoryUpdateList = new List<Owner_Territory__c>(); 
       List<Owner_Territory__c> ownerterList = [select id, Owner_Assignment__r.Unassigned_State_Fallback_Owner__c from Owner_Territory__c where id =: updateOwnerList];
       for(Owner_Territory__c terId : ownerterList){
       System.debug('***Hello***');
           terId.Territory_Owner__c = terId.Owner_Assignment__r.Unassigned_State_Fallback_Owner__c;
           territoryUpdateList.add(terId);
       }
       if(!territoryUpdateList.isEmpty()) {
          Util.setAlreadyFired('Account');
          update territoryUpdateList;
       }
  }
}