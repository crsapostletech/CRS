@isTest
private class HousingPlacementsToMovedOutTest {

	static testMethod void myUnitTest() 
    {
        	Placement__c housingPlacement = new Placement__c
    	(
        	RecordTypeId = RecordTypeHelper.housingPlacementRT(), 
	        Name = 'testPlacementHousing',
	        Status__c = 'Moved-In',
	        Move_In_Date__c = Date.newInstance(2013,09,09),
		    Approved_Through_Date__c = Date.newInstance(2014,01,01));
		   
		insert housingPlacement;
    	    	
    	HousingPlacementsToMovedOut HPsToMovedOut = new HousingPlacementsToMovedOut();
    	
    	housingPlacement = [select Status__c from Placement__c where id =: housingPlacement.Id];
    	
    	System.assertEquals('Moved-Out', housingPlacement.Status__c); 
        
        // Test scheduler
        
        SchedulableContext sc;
        HousingPlacementsToMovedOutScheduler MoveOutScheduler = new HousingPlacementsToMovedOutScheduler();	   
        MoveOutScheduler.execute(sc);
   }
}