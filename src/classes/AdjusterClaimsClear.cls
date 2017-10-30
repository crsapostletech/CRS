global class AdjusterClaimsClear implements Database.Batchable<sObject>
{
	Public String query { get; set;}  

	global database.queryLocator start(Database.BatchableContext BC)
    {
  		return database.getQueryLocator(query);   		
    }

    global void execute(Database.BatchableContext BC, list <Contact> scope) 
    {

    	for(Contact contact : scope) 
    	{
    		contact.Total_Finders_Fees_Claims__c = null;
			contact.Total_FRV_Claims__c = null;
			contact.Total_Hotel_Claims__c = null;
			contact.Total_Housing_Claims__c = null;
    	}
    	update scope;
    }

    global void finish(Database.BatchableContext ctx)
    {

    }

}