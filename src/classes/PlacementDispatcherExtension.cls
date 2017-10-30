public with sharing class PlacementDispatcherExtension 
{
	public PlacementDispatcherExtension(ApexPages.StandardController stdController)
    {
    	Placement__c placement = (Placement__c)stdController.getRecord();
    }
  
    public PageReference getViewPlacement()
    {
    	Id id = ApexPages.currentPage().getParameters().get('id'); 
    	Placement__c placement = [select Id, RecordTypeId, ServiceRequest__c from Placement__c where Id = :id];
    	PageReference newPage;
        
	    if (placement.RecordTypeId == RecordTypeHelper.hotelPlacementRT())
	    {
	    	newPage = Page.HotelEntry;
	    }
	    else
	    {
	  		newPage = Page.HousingEntry;
	    }
	    
	    newPage.getParameters().put('id', placement.ServiceRequest__c);
	    return newPage.setRedirect(true);
	}
	
	public PageReference getEditPlacement()
    {
	  	Id id = ApexPages.currentPage().getParameters().get('id'); 
	    Placement__c placement = [select Id, RecordTypeId, ServiceRequest__c from Placement__c where Id = :id];
    	PageReference newPage;
	    
	    if (placement.RecordTypeId == RecordTypeHelper.hotelPlacementRT())
	    {
	    	newPage = Page.HotelEntry;
	    }
	    else
	    {
	 		newPage = Page.HousingEntry;	
	    }
	    
	    newPage.getParameters().put('id', placement.ServiceRequest__c);
	    return newPage.setRedirect(true);
    }
}