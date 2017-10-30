@isTest
private class ServiceRequestDispatcherExtensionTest {

   	@testSetup static void setupTestData()
   	{
		// Insert Users
        Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
        User user1 = new User
                (   
                    Alias = 'standt',
                    Email='operationsuser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser@crstemphousing.com');
        insert user1; 

		Opportunity opportunity = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'testopportunity',
                    Initial_Service_Request__c='Housing',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '123 Big Test Lane',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity;

   		ServiceRequest__c frvSR = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.frvServiceRequestRT(),
				    Opportunity__c = opportunity.Id,
				    Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    THC_Signed__c = Date.newInstance(2009,10,09),
				    THA_Signed__c = Date.newInstance(2009,10,09));		    
        insert frvSR;              
		
		
		ServiceRequest__c housingSRwithPlacement = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.housingServiceRequestRT(),
				    Opportunity__c = opportunity.Id,
				    Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    THC_Signed__c = Date.newInstance(2009,10,09),
				    THA_Signed__c = Date.newInstance(2009,10,09));
		insert housingSRwithPlacement;	
		
		ServiceRequest__c housingSRwithoutPlacement = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.housingServiceRequestRT(),
				    Opportunity__c = opportunity.Id,
				    Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    THC_Signed__c = Date.newInstance(2009,10,10),
				    THA_Signed__c = Date.newInstance(2009,10,09));
		insert housingSRwithoutPlacement;		    
		
		ServiceRequest__c hotelSR = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.hotelServiceRequestRT(),
                	Opportunity__c = opportunity.Id,
                	Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    THC_Signed__c = Date.newInstance(2009,10,09),
				    THA_Signed__c = Date.newInstance(2009,10,09));		    
        insert hotelSR;

        ServiceRequest__c existingHotelSR = new ServiceRequest__c
        		(
                	RecordTypeId = RecordTypeHelper.hotelServiceRequestRT(),
                	Opportunity__c = opportunity.Id,
                	Status__c = 'Searching',
				    Adjuster_to_Pay__c = 'Deposits and Fees',
				    Policyholder_to_Pay__c = 'Will Not Pay',
				    Initial_Call_Date__c = Date.newInstance(2009,10,09),
				    Initial_Contact_Date__c = Date.newInstance(2009,10,09),
            		First_Property_Presented__c = Date.newInstance(2009,10,09),
				    THC_Signed__c = Date.newInstance(2009,10,10),
				    THA_Signed__c = Date.newInstance(2009,10,09));		    
        insert existingHotelSR;    
        
        Placement__c housingPlacement = new Placement__c(
                                        RecordTypeId = RecordTypeHelper.housingPlacementRT(),
                                        Name = 'testhousingPlacement',
                                        Status__c = 'Searching',
                                        ServiceRequest__c = housingSRwithPlacement.Id, 
                                        Move_In_Date__c = Date.newInstance(2015,09,09),
	    								Approved_Through_Date__c = Date.newInstance(2016,09,09));
                                        
	    insert housingPlacement;
   	}


   	static testMethod void testViewServiceRequest() 
	{
		ServiceRequest__c frvSR = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.frvServiceRequestRT()];
		ServiceRequest__c housingSRwithPlacement = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.housingServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,09)];
		ServiceRequest__c housingSRwithoutPlacement = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.housingServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,10)];
		ServiceRequest__c hotelSR = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.hotelServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,09)];
			
		ServiceRequest__c hsr = new ServiceRequest__c();
		ApexPages.StandardController stdCon = new ApexPages.StandardController(hsr);
	    ServiceRequestDispatcherExtension hsrce = new ServiceRequestDispatcherExtension(stdCon);
 		
 		ApexPages.currentPage().getParameters().put('id', housingSRwithPlacement.Id);
 		PageReference pr = hsrce.getViewServiceRequest();
 		
 		ApexPages.currentPage().getParameters().clear();
 		
 		ApexPages.currentPage().getParameters().put('id', hotelSR.Id);
 		pr = hsrce.getViewServiceRequest();
 		
 		ApexPages.currentPage().getParameters().clear();
 		
 		ApexPages.currentPage().getParameters().put('id', frvSR.Id);
 		pr = hsrce.getViewServiceRequest();
 				
	}
	
	static testMethod void testNewServiceRequest()
	{
		ServiceRequest__c housingSRwithoutPlacement = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.housingServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,10)];
		ServiceRequest__c hotelSR = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.hotelServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,09)];
		Opportunity opportunity = [select id from Opportunity where Damaged_Property_Address__c = '123 Big Test Lane'];
					
		ServiceRequest__c hsr = new ServiceRequest__c();
	    ApexPages.StandardController stdCon = new ApexPages.StandardController(hsr);
	    ServiceRequestDispatcherExtension hsrce = new ServiceRequestDispatcherExtension(stdCon);
	    
	    ApexPages.currentPage().getParameters().put('RecordType', RecordTypeHelper.hotelServiceRequestRT());
	    ApexPages.currentPage().getParameters().put('retURL', '/' + opportunity.Id + '?srPos=0&srKp=006' + RecordTypeHelper.hotelServiceRequestRT());
        PageReference pr = hsrce.getNewServiceRequest();
 		
 		ApexPages.currentPage().getParameters().clear();
 		
     	ApexPages.currentPage().getParameters().put('id', hotelSR.Id);
 		ApexPages.currentPage().getParameters().put('retURL', '/' + RecordTypeHelper.hotelServiceRequestRT());
 		ApexPages.currentPage().getParameters().put(RecordTypeHelper.hotelServiceRequestRT() + '_lkid', RecordTypeHelper.hotelServiceRequestRT());
    	ApexPages.currentPage().getParameters().put(RecordTypeHelper.hotelServiceRequestRT(), RecordTypeHelper.hotelServiceRequestRT());
        
        pr = hsrce.getNewServiceRequest();
        
        
        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeHelper.housingServiceRequestRT());
	    ApexPages.currentPage().getParameters().put('retURL', '/' + opportunity.Id + '?srPos=0&srKp=006' + RecordTypeHelper.housingServiceRequestRT());
        pr = hsrce.getNewServiceRequest();
        
        ApexPages.currentPage().getParameters().clear();
 		
     	ApexPages.currentPage().getParameters().put('id', housingSRwithoutPlacement.Id);
 		ApexPages.currentPage().getParameters().put('retURL', '/' + RecordTypeHelper.housingServiceRequestRT());
 		ApexPages.currentPage().getParameters().put(RecordTypeHelper.housingServiceRequestRT() + '_lkid', RecordTypeHelper.housingServiceRequestRT());
    	ApexPages.currentPage().getParameters().put(RecordTypeHelper.housingServiceRequestRT(), RecordTypeHelper.housingServiceRequestRT());
        
        pr = hsrce.getNewServiceRequest();
		
	}
	
	static testMethod void testEditServiceRequest()
	{
		ServiceRequest__c frvSR = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.frvServiceRequestRT()];
		ServiceRequest__c housingSRwithPlacement = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.housingServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,09)];
		ServiceRequest__c hotelSR = [select id from ServiceRequest__c where recordTypeid =: RecordTypeHelper.hotelServiceRequestRT() and THC_Signed__c =: Date.newInstance(2009,10,09)];

		ServiceRequest__c hsr = new ServiceRequest__c();
	    ApexPages.StandardController stdCon = new ApexPages.StandardController(hsr);
	    ServiceRequestDispatcherExtension hsrce = new ServiceRequestDispatcherExtension(stdCon);
	    
	    ApexPages.currentPage().getParameters().put('id', hotelSR.Id);
	    hsrce.getEditServiceRequest();
	    
	    ApexPages.currentPage().getParameters().clear();
	    
	    ApexPages.currentPage().getParameters().put('id', housingSRwithPlacement.Id);
	    hsrce.getEditServiceRequest();
	    
	    ApexPages.currentPage().getParameters().clear();
	    
	    ApexPages.currentPage().getParameters().put('id', frvSR.Id);
	    hsrce.getEditServiceRequest();
	}
}