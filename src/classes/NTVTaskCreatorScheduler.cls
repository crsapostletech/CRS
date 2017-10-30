global class NTVTaskCreatorScheduler implements Schedulable
{
	global void execute(SchedulableContext sc) 
	{
				
		// Get Min and Max Date To Send NTV  		
 		DateTime minNTVDateEmailFax = Util.getMinNTVDate('Email');
        DateTime minNTVDateMailInsured = Util.getMinNTVDate('Insured');
        DateTime maxNTVDateEmailFax = Util.getMaxNTVDate('Email');
        DateTime maxNTVDateMailInsured = Util.getMaxNTVDate('Insured');    

		// Get all Searches/Service Requests that need to have an NTV task created

		NTVTaskCreator ntvTC = new NTVTaskCreator();
		ntvTC.query = 'select Id,Name,Active_NTV_Task__c,Date_To_Send_NTV__c,NTV_Send_Via__c,NTV_Send_To__c,Service_Request__c,placement__c,Service_Request__r.Opportunity__r.Customer_Care_Specialist__c from searches__c where (Selected__c = true and RecordTypeId =  \'' + RecordTypeHelper.housingSearchRT() + '\' and Active_NTV_Task__c = false and Placement__r.Status__c = \'Moved-In\' and Date_To_Send_NTV__c >= ' + minNTVDateEmailFax.format('YYYY-MM-dd') + ' and Date_To_Send_NTV__c <= ' + maxNTVDateEmailFax.format('YYYY-MM-dd') + ' and NTV_Send_Via__c in (\'Email\', \'Fax\')) or (Selected__c = true and RecordTypeId = \'' + RecordTypeHelper.housingSearchRT() + '\' and Active_NTV_Task__c = false and Placement__r.Status__c = \'Moved-In\' and Date_To_Send_NTV__c >= ' + minNTVDateMailInsured.format('YYYY-MM-dd') + ' and Date_To_Send_NTV__c <= ' + maxNTVDateMailInsured.format('YYYY-MM-dd') + ' and NTV_Send_Via__c in (\'Certified Mail\', \'Insured\'))';
		database.executebatch(ntvTC); 
	}
}