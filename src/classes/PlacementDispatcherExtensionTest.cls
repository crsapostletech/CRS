@isTest
private class PlacementDispatcherExtensionTest {

   	@testSetup static void setupTestData()
   	{
   		Placement__c housingPlacement = new Placement__c(
                                            RecordTypeId = RecordTypeHelper.housingPlacementRT(),
                                            Name = 'testPlacementHousing',
                                            Status__c = 'Searching',
                                            Move_In_Date__c = Date.newInstance(2015,09,09),
	    							        Approved_Through_Date__c = Date.newInstance(2016,09,09));
        insert housingPlacement;	

        Placement__c hotelPlacement = new Placement__c(
                                          RecordTypeId = RecordTypeHelper.hotelPlacementRT(),
                                          Name = 'testPlacementHotel',
                                          Status__c = 'Searching',
                                          Move_In_Date__c = Date.newInstance(2015,09,09),
	    							      Approved_Through_Date__c = Date.newInstance(2016,09,09));
        insert hotelPlacement;	
   	}


   	static testMethod void testViewPlacement() 
	{
		Placement__c placement = new Placement__c();
   		ApexPages.StandardController stdCon = new ApexPages.StandardController(placement);
    	PlacementDispatcherExtension placementDispatcher = new PlacementDispatcherExtension(stdCon);
 		
    	Placement__c housingPlacement = [select id from Placement__c where name = 'testPlacementHousing'];

 		ApexPages.currentPage().getParameters().put('id', housingPlacement.Id);
 		PageReference pr = placementDispatcher.getViewPlacement();
 		
 		Placement__c hotelPlacement = [select id from Placement__c where name = 'testPlacementHotel'];

 		ApexPages.currentPage().getParameters().put('id', hotelPlacement.Id);
 		pr = placementDispatcher.getViewPlacement();
	}
	
	static testMethod void testEditPlacement()
	{
    	Placement__c placement = new Placement__c();
   		ApexPages.StandardController stdCon = new ApexPages.StandardController(placement);
    	PlacementDispatcherExtension placementDispatcher = new PlacementDispatcherExtension(stdCon);

    	Placement__c housingPlacement = [select id from Placement__c where name = 'testPlacementHousing'];
 		
 		ApexPages.currentPage().getParameters().put('id', housingPlacement.Id);
 		PageReference pr = placementDispatcher.getEditPlacement();

 		Placement__c hotelPlacement = [select id from Placement__c where name = 'testPlacementHotel'];
 		
 		ApexPages.currentPage().getParameters().put('id', hotelPlacement.Id);
 		pr = placementDispatcher.getEditPlacement();
 	}
}