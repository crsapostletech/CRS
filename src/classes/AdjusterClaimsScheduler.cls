global class AdjusterClaimsScheduler implements Schedulable 
{
    global void execute(SchedulableContext SC) 
    {
        AdjusterClaims ac = new AdjusterClaims();
        ac.query = 'SELECT Id,Name,Initial_Service_Request__c,Adjuster__c,CreatedDate,Adjuster_Changed_Date__c,Called_In_By__c FROM Opportunity WHERE (not Name LIKE\'6%\') AND (not Name LIKE\'7%\') AND (not Name LIKE\'8%\') AND Initial_Service_Request__c in (\'Housing\',\'FRV\',\'Finders Fees\',\'Hotel\')';
        database.executebatch(ac); 
    } 
}