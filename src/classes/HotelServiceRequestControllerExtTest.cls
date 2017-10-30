@isTest
private class HotelServiceRequestControllerExtTest 
{    
    static Contact ph = createPolicyHolder();
    static Contact adj = createAdjuster();
    static Opportunity claim = createClaim();
    static Account hotelAccount = createHotelAccount('First Hotel');
    static Account hotelAccount2 = createHotelAccount('2nd Hotel');
    static ServiceRequest__c hsr = new ServiceRequest__c();
    static ApexPages.StandardController stdCon = new ApexPages.StandardController(hsr);
    static HotelServiceRequestControllerExtension hsrce = new HotelServiceRequestControllerExtension(stdCon);
  
    
    static testMethod void testControllerMiscProperties() 
    {
        hsrce.getIsProductionOrg();
        hsrce.setIsProductionOrg(false);
        hsrce.getIsBillingSpecialist();
        hsrce.setIsBillingSpecialist(false);
        hsrce.getIsAccountingManager();
        hsrce.setIsAccountingManager(false);
        hsrce.getRateCalendarURL();
        hsrce.setRateCalendarURL('');
        hsrce.getHasRelatedPlacement();
    }
 
    static testMethod void testControllerNewServiceRequest() 
    {
        PageReference pageRef = Page.HotelEntry; 
        Test.setCurrentPage(pageRef);
        
        hsr.RecordTypeId = RecordTypeHelper.hotelServiceRequestRT();
            
        test.starttest();
        
        // Update Service Request
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('firstPropertyPresented', '7/8/2010 2:55 PM');
        ApexPages.currentPage().getParameters().put('serviceRequestOpportunity', claim.Id); 
            
              
        hsrce.SaveServiceRequest();
        hsrce.getHasCompletedClaim(); 
     
     //   System.assertEquals('2010-07-08 14:55:00', String.valueOf(hsr.First_Property_Presented__c));
        
        ApexPages.currentPage().getParameters().put('firstPropertyPresented', '');
        ApexPages.currentPage().getParameters().put('serviceRequestOpportunity', claim.Id);  
        ApexPages.currentPage().getParameters().put('serviceRequestDWOReasonCode', 'other');  
        
        hsrce.SaveServiceRequest();
        hsrce.currentUserUpdateOnSRWorkedBy();
        
        hsrce.getHasCompletedClaim();
        hsrce.setHasCompletedClaim(true);
        
        hsrce.accountId = ph.accountId;        
        hsrce.setPlacement(new Placement__c());     
        hsrce.setClaim(new Opportunity());      
        hsrce.getErrorsPresent();       
        hsrce.setHasSelectedHotelSearch(true);      
        hsrce.setHasSelectedHotelSearch(true);      
        hsrce.setInstanceName('');      
        hsrce.getHash();        
                
        Map<String,String> paramsMap = new Map<String, String>();       
        paramsMap.put('serviceRequestOpportunity', claim.Id);       
                
        test.stoptest(); 
    }
    
    static testMethod void testHotelSearches1() 
    {
        test.starttest();
        // Save a new hotel search
        Searches__c hs = hsrce.newHotelSearch;
        hs.Hotel__c = hotelAccount.Id;
        hsrce.newHotelSearch = hs;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('selectedHotelName', 'Hotel Search 1');
        ApexPages.currentPage().getParameters().put('firstPropertyPresented', '7/8/2010 2:55 PM');
        ApexPages.currentPage().getParameters().put('selectedDistance', '1.5');
        
        hsrce.saveNewHotelSearch();
               
        string paymentType = 'PayNet';
 
        // Now mark the 1st search as 'selected'
        selectHotelSearch(paymentType);
        
     //   hsrce.getNewCreditCard();
                       
        Double placementCount = hsrce.fetchPlacementCount();
        System.assertEquals(0, placementCount);
        
        // updateSelectedHotelInfo
        List<Searches__c> hotelSearches = hsrce.getHotelSearches();
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accountId', hotelSearches[0].Hotel__c);
        hsrce.updateSelectedHotelInfo();
        
        ApexPages.currentPage().getParameters().clear();
        
        hsrce.updatePlacement();
        hsrce.updateVPayCreditCard();
        hsrce.updatePayNetCreditCard();
        hsrce.deleteCreditCard(); 
        hsrce.getHistory();        
        
        hsrce.updateSelectedHotelSearch();
        system.assertEquals(false, hsrce.getHasSelectedHotelSearch());
        
        hsrce.getHistory();
      
        test.stoptest(); 
    }
    
    static testMethod void testHotelSearches2() 
    {
        test.starttest();
       
        // That was so much fun, let's save another hotel search 
        Searches__c hs = hsrce.newHotelSearch;
        hs.Hotel__c = hotelAccount2.Id;
        hsrce.newHotelSearch = hs;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('selectedHotelName', 'Hotel Search 2');
        ApexPages.currentPage().getParameters().put('firstPropertyPresented', '7/9/2010 3:55 PM');
        ApexPages.currentPage().getParameters().put('selectedDistance', '2.5');
    
        hsrce.saveNewHotelSearch();
        
        string paymentType = 'Mastercard';
 
        // Now mark the 1st search as 'selected'
        selectHotelSearch(paymentType);
        
   //     hsrce.getNewCreditCard();
                       
        Double placementCount = hsrce.fetchPlacementCount();
        System.assertEquals(0, placementCount);
        
        // updateSelectedHotelInfo
        List<Searches__c> hotelSearches = hsrce.getHotelSearches();
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accountId', hotelSearches[0].Hotel__c);
        hsrce.updateSelectedHotelInfo();
        
            
        test.stoptest(); 
    }
  
    static testMethod void testBuildingHotelRooms()
    {   
        PageReference pageRef = Page.HotelEntry; 
        Test.setCurrentPage(pageRef);
      
        // Save a new hotel search
        Searches__c hs = hsrce.newHotelSearch;
        hs.Hotel__c = hotelAccount.Id;
        hsrce.newHotelSearch = hs;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('selectedHotelName', 'Hotel Search 1');
        ApexPages.currentPage().getParameters().put('firstPropertyPresented', '7/8/2010 2:55 PM');
        
        hsrce.saveNewHotelSearch();
        
        // That was so much fun, let's save another hotel search
        hs = hsrce.newHotelSearch;
        hs.Hotel__c = hotelAccount2.Id;
        hsrce.newHotelSearch = hs;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('selectedHotelName', 'Hotel Search 2');
    
        hsrce.saveNewHotelSearch();
        
        test.starttest();
        
        hsrce.clearHotelRoom();
        
        // Now mark the 1st search as 'selected'
        selectHotelSearch('Direct Bill');
        
        hsrce.getNewCreditCard();
        
        // updateSelectedHotelSearchInfo
        List<Searches__c> hotelSearches = hsrce.getHotelSearches();
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accountId', hotelSearches[0].Hotel__c);
        hsrce.updateSelectedHotelInfo();
        
       
        
        boolean initalHasHotelRooms = hsrce.getHasHotelRooms();
        
        // start creating hotel rooms 
        buildEditHotelRoom(hsrce, null, 'Standard King', null, null,
                                                '', '', '', '',
                                                '7/20/2010', '7/30/2010', '140.00', '10.00',
                                                '', '', '','1','1','1');
        
        
        boolean hasHotelRooms = hsrce.getHasHotelRooms();
        system.assertEquals(true, hasHotelRooms);
        // fetch hotel room
        
        List<Hotel_Room__c> rooms = hsrce.getPlacement().Hotel_Rooms__r;
        Hotel_Room__c room = rooms[0];
        
        buildEditHotelRoom(hsrce, room.Id, 'Standard King', 'Confirmation #', null,
                                                'Daily', 'Daily', 'Daily', 'Other Fee Desc',
                                                '7/20/2010', '7/30/2010', '140.00', '10.00',
                                                '5.43', '10.10', '34.12','1','1','1');
        
        // edit hotel room
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('hotelRoomId', room.Id);
        hsrce.editHotelRoom();
        hsrce.updateHotelRoomBARRate();          
        
        hsrce.cloneHotelRoom();
        
        // add two more hotel rooms 
        buildEditHotelRoom(hsrce, null, 'Standard King', null, null,
                                                'Daily', 'Daily', 'Daily', 'Other Fee Desc',
                                                '7/20/2010', '7/30/2010', '140.00', '10.00',
                                                '5.43', '10.10', '34.12','1','1','1');
        
        buildEditHotelRoom(hsrce, null, 'Standard King', null, null,
                                                null, null, null, 'Other Fee Desc',
                                                '7/20/2010', '7/30/2010', '140.00', '10.00',
                                                '', '', '','0','0','0');    
                                                
        rooms = hsrce.getPlacement().Hotel_Rooms__r;
        room = rooms[0];
        
        hsrce.setHasHotelRooms(true);
        
        test.stoptest();
         
    }
    
    
    static testMethod void testMisc()
    {
        
        hsrce.getIsBillingCompleted();
        hsrce.setBillingCompleted();
        hsrce.getIsBillingCompleted();
        hsrce.setIsBillingCompleted(true);
        hsrce.undoBillingCompleted();
        hsrce.getHasUnbilledRooms();
        hsrce.setHasUnbilledRooms(false);
        hsrce.getHasPlacement();
        hsrce.setHasPlacement(true);
        hsrce.placement.Check_Out_Date__c = Date.toDay();
        hsrce.getIsPlacementCheckedOut();
        hsrce.setIsPlacementCheckedOut(true);
        hsrce.refreshHotelRooms();
        hsrce.undoBillingCompleted();
        hsrce.getHasUnbilledRooms();
        hsrce.setHasUnbilledRooms(false);
        hsrce.getIsManagerOrDirector();                     
        hsrce.setIsManagerOrDirector(true);                    
        hsrce.getIsOperationsDirector();        
        hsrce.setIsOperationsDirector(true);        
       
    }
     
    private static void buildEditHotelRoom(HotelServiceRequestControllerExtension ce,
                                                                                Id hotelRoomId, 
                                                                                string roomType, 
                                                                                string confirmation, 
                                                                                string cancellation, 
                                                                                string parkingFeeType,
                                                                                string petFeeType,
                                                                                string otherFeeType,
                                                                                string otherFeeDesc,
                                                                                string checkIn,
                                                                                string checkOut,
                                                                                string nightlyRate,
                                                                                string itemizedTax,
                                                                                string parkingFeeAmount,
                                                                                string petFeeAmount,
                                                                                string otherFeeAmount,
                                                                                string oneTimePetFeesTaxable,
                                                                                string oneTimeParkingFeesTaxable,
                                                                                string oneTimeOtherFeesTaxable
                                                                                )
    {
        ApexPages.currentPage().getParameters().clear();
        
        if (hotelRoomId != null)
        {
            ApexPages.currentPage().getParameters().put('hotelRoomId', hotelRoomId);
        }
        
        if (roomType != null)
        {
            ApexPages.currentPage().getParameters().put('roomType', roomType);
        }
    
        if (confirmation != null)
        {
            ApexPages.currentPage().getParameters().put('confirmation', confirmation);
        }
        
        if (cancellation != null)
        {
            ApexPages.currentPage().getParameters().put('cancellation', cancellation);
        }
        
        if (parkingFeeType != null)
        {
            ApexPages.currentPage().getParameters().put('parkingFeeType', parkingFeeType);
        }
        
        if (petFeeType != null)
        {
            ApexPages.currentPage().getParameters().put('petFeeType', petFeeType);
        }
        
        if (otherFeeType != null)
        {
            ApexPages.currentPage().getParameters().put('otherFeeType', otherFeeType);
        }
        
        if (otherFeeDesc != null)
        {
            ApexPages.currentPage().getParameters().put('otherFeeDesc', otherFeeDesc);
        }
        
        if (checkIn != null)
        {
            ApexPages.currentPage().getParameters().put('checkIn', checkIn);
        }
        
        if (checkOut != null)
        {
            ApexPages.currentPage().getParameters().put('checkOut', checkOut);
        }
        
        if (nightlyRate != null)
        {
            ApexPages.currentPage().getParameters().put('nightlyRate', nightlyRate);
        }
        
        if (itemizedTax != null)
        {
            ApexPages.currentPage().getParameters().put('itemizedTax', itemizedTax);
        }
        
        if (parkingFeeAmount != null)
        {
            ApexPages.currentPage().getParameters().put('parkingFeeAmount', parkingFeeAmount);
        }
        
        if (petFeeAmount != null)
        {
            ApexPages.currentPage().getParameters().put('petFeeAmount', petFeeAmount);
        }
        
        if (otherFeeAmount != null)
        {
            ApexPages.currentPage().getParameters().put('otherFeeAmount', otherFeeAmount);
        }
        
        if (oneTimePetFeesTaxable != null)
        {
            ApexPages.currentPage().getParameters().put('oneTimePetFeesTaxable', oneTimePetFeesTaxable);
        }
        
        if (oneTimeParkingFeesTaxable != null)
        {
            ApexPages.currentPage().getParameters().put('oneTimeParkingFeesTaxable', oneTimeParkingFeesTaxable);
        }
        
        if (oneTimeOtherFeesTaxable != null)
        {
            ApexPages.currentPage().getParameters().put('oneTimeOtherFeesTaxable', oneTimeOtherFeesTaxable);
        }
        
        ce.saveHotelRoom();
        
    }
  
    private static void selectHotelSearch(string paymentType)
    {
        List<Searches__c> hotelSearches = hsrce.getHotelSearches();
        
        system.assertEquals(false, hsrce.getHasSelectedHotelSearch());
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('hotelSearchId', hotelSearches[0].Id);
        ApexPages.currentPage().getParameters().put('placementPaymentType', paymentType);
                   
        hsrce.updateSelectedHotelSearch();
        
        system.assertEquals(true, hsrce.getHasSelectedHotelSearch());
        
        Searches__c selected_search = hsrce.getSelectedHotelSearch();
        system.assertEquals(selected_search.Id, hotelSearches[0].Id);
        hsrce.updateSearchDistanceToDamagedProp();      
        hsrce.clearHotelSearch();
    }
  
    private static Contact createPolicyHolder()
    {
        Contact c = new Contact
        (
            RecordTypeId = RecordTypeHelper.policyholderContactRT(),
            FirstName = 'PolicyHolder',
            LastName = 'Contact',
            Status__c='Active',
            MailingCountry='USA',
            MailingState = 'AZ',
            MailingStreet='134 Laurel',
            MailingCity='Phoenix',
            MailingPostalCode='85011',
            Type__c='TPA',
            LeadSource='Event',
            Lead_Source_Description__c='Golf Event',
            OtherCountry='USA',
            OtherState = 'AZ',
            OtherStreet='134 Laurel',
            OtherCity='Phoenix',
            OtherPostalCode='85011');   
    
        insert c;
    
        return c;   
    }
  
    private static Contact createAdjuster()
    {
        Contact c = new Contact 
        (
            RecordTypeId = RecordTypeHelper.adjusterContactRT(),
            FirstName = 'Adj',
            LastName = 'Contact',
            Status__c='Active',
            MailingCountry='USA',
            MailingState = 'AZ',
            MailingStreet='134 Laurel',
            MailingCity='Phoenix',
            MailingPostalCode='85011',
            Type__c='TPA',
            LeadSource='Event',
            Lead_Source_Description__c='Golf Event',
            OtherCountry='USA',
            OtherState = 'AZ',
            OtherStreet='134 Laurel',
            OtherCity='Phoenix',
            OtherPostalCode='85011');    
    
        insert c;
    
        return c;
    }
  
    private static Opportunity createClaim()
    {
        
        // Insert Users
        Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
        User user1 = new User
                (   
                    Alias = 'opsusr',
                    Email='operationsuser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser@crstemphousing.com');
        insert user1; 

        Opportunity opp = new Opportunity
        (                            
            Policyholder__c = ph.Id,
            Adjuster__c = adj.Id,
            Name = 'abc123',
            Initial_Service_Request__c='Hotel',
            CloseDate = Date.today(),   
            StageName = 'Submitted',
            Type_of_Loss__c = 'Mold',
            Damaged_Property_Type__c = 'Apartment',
            Damaged_Property_Address__c = '123 Big Test Lane',
            Damaged_Property_City__c = 'Phoenix',
            Damaged_Property_State__c = 'AZ',
            Damaged_Property_Zip__c = '85011',
            Damaged_Property_Country__c = 'USA', 
            Regional_Manager__c = user1.Id,
            Customer_Care_Specialist__c = user1.Id,
            Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opp;
    
        return opp;
    }
  
    private static Account createHotelAccount(string hotelName)
    {
        Account ha = new Account
        (
            RecordTypeId = RecordTypeHelper.hotelAccountRT(),
            Active__c = true,
            Name = hotelName,
            BillingState='CT',
            BillingStreet='134 Laurel',
            BillingCity='Mineola',
            BillingPostalCode='11501',
            BillingCountry='USA',
            ShippingState = 'CT',
            ShippingCountry = 'USA',
            ShippingPostalCode = '11501',
            ShippingCity = 'Mineola',
            ShippingStreet = '134 Laurel',
            Fax = '6022345675');
        
        insert ha;
    
        return ha;
    }
}