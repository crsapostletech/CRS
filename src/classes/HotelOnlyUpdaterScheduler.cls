global class HotelOnlyUpdaterScheduler implements Schedulable 
{
    global void execute(SchedulableContext SC) 
    {
        HotelOnlyUpdater hou = new HotelOnlyUpdater();
        hou.query = 'select RecordType.DeveloperName, Status__c, Opportunity__c from ServiceRequest__c where Opportunity__c <> null and LastModifiedDate = Today and RecordType.DeveloperName in (\'Housing\',\'Hotel\') order by Opportunity__c';
        database.executebatch(hou); 
    } 
}