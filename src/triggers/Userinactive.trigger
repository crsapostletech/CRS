/*************************************************************************************************************
Created by: Apostletech team
Purpose: When a user is made inactive to update the owner Territory object territory owner field user
trigger calling class a inactiveUsersAssignmentUpdate to update the owner Territory object territory owner field user
*************************************************************************************************************/
trigger Userinactive on User (before update){
 inactiveUsersAssignmentUpdate.Userupdate(trigger.new,trigger.oldMap);
}