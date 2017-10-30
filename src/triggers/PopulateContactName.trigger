trigger PopulateContactName on Task (before insert, before update) 
{
	for(task task : Trigger.new)
    {
    	if (task.RecordTypeId == RecordTypeHelper.portalNotesTaskRT())
        {
        	if (task.WhoId != null)
        	{
        		String ContactName = [select name from contact where id =: task.WhoId].Name;
        		task.Contact_Name__c = ContactName;
        		task.WhoId = null;
        	}	
        }	
    }
}