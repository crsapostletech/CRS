public class HousingPlacementsToMovedOut 
{
	public HousingPlacementsToMovedOut() 
	{
		Placement__c [] HPsReadyForMoveout = [select id from Placement__c where RecordTypeId =: RecordTypeHelper.housingPlacementRT() 
										   and status__c = 'Moved-In' and Approved_Through_Date__c <> null and Approved_Through_Date__c <: system.Today()];	
			
		for (Placement__c HPReadyForMoveout : HPsReadyForMoveout)
		{
			HPReadyForMoveout.Status__c = 'Moved-Out';
		}
		update HPsReadyForMoveout;
	}

}