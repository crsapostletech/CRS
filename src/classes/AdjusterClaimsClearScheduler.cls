global  class AdjusterClaimsClearScheduler implements Schedulable 
{
	global void execute(SchedulableContext SC) 
    {
        AdjusterClaimsClear acc = new AdjusterClaimsClear();
        acc.query = 'select Id from Contact where Total_Hotel_Claims__c <> null or Total_Housing_Claims__c <> null or Total_FRV_Claims__c <> null or Total_Finders_Fees_Claims__c <> null';
        database.executebatch(acc); 
    } 
}