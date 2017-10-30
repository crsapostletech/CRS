@isTest
private class HousingServiceRequestControllerExtTest 
{
    static Opportunity claim1;
    static ServiceRequest__c serviceRequest1;
    static ServiceRequest__c serviceRequest2;
    static Placement__c placement1;
    static Placement__c placement2;
    
    static PageReference pageRef = Page.HousingEntry; 
    

    
    @testSetup static void setupTestData()
    {
        Account parentAccount = new Account(
            RecordTypeId = RecordTypeHelper.insuranceCompanyAccountRT(),
            name='testPAccountx',
            Active__c= true,
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
        insert parentAccount;

        Account adjAccount = new Account(
            RecordTypeId = RecordTypeHelper.insuranceCompanyAccountRT(),
            name='testAccountx',
            parentId = parentAccount.Id,
            Active__c= true,
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
        insert adjAccount;

        Contact adjContact = new Contact(
            RecordTypeId = RecordTypeHelper.adjusterContactRT(),
            Account = adjAccount,
            FirstName = 'Adj',
            LastName = 'TestAdjuster',
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
        insert adjContact;


        Contact phContact = new Contact(
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
        insert phcontact;
        

        Contact llContact = new Contact(
            RecordTypeId = RecordTypeHelper.landlordContactRT(),
            LastName='TestLandLord',
            Status__c='Active',
            MailingCountry='USA',
            MailingState='CT',
            MailingStreet='134 Laurel',
            MailingCity='Mineola',
            MailingPostalCode='11501');
        insert llContact;
        
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

        Opportunity opportunity = new Opportunity(
            StageName = 'Submitted',
            Name = 'TestClaim',
            Adjuster__c = adjContact.Id,
            Policyholder__c = phContact.Id,
            Initial_Service_Request__c='Housing',
            Number_of_Adults__c = 2,
            Number_of_Children__c = 2,
            Number_of_Bedrooms__c = 3,
            Number_of_Bathrooms__c = 2,
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


        ServiceRequest__c serviceRequest = new ServiceRequest__c();
        ApexPages.StandardController stdCon = new ApexPages.StandardController(serviceRequest);
        ServiceRequestDispatcherExtension srde = new ServiceRequestDispatcherExtension(stdCon);

        
        ApexPages.currentPage().getParameters().put('RecordType', RecordTypeHelper.housingServiceRequestRT());
        ApexPages.currentPage().getParameters().put('retURL', '/' + opportunity.Id + '?srPos=0&srKp=006' + RecordTypeHelper.housingServiceRequestRT());
        PageReference pr = srde.getNewServiceRequest();
                
     //   pr = srde.getNewServiceRequest();
        
       

//        placement1 = [select id from placement__c where placement__c.ServiceRequest__c =: serviceRequest1.Id];
//        placement2 = [select id from placement__c where placement__c.ServiceRequest__c =: serviceRequest2.Id];   

    }

    
    

    @isTest static void init()
    {
         claim1 = [select Id from opportunity where Damaged_Property_Address__c = '123 Big Test Lane'];        
         serviceRequest1 = [select Id,Name,DWO_Reason_Code__c,Opportunity__c from ServiceRequest__c where Opportunity__c =: claim1.id];
         placement1 = [select Id from placement__c where placement__c.ServiceRequest__c =: serviceRequest1.Id];
    }    
   

      @isTest static void test1() 
    {
       
        init();

        pageRef.getParameters().put('id', serviceRequest1.id); 
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(serviceRequest1);
   

        HousingServiceRequestControllerExtension hsrce = new HousingServiceRequestControllerExtension(stdCon);

      
        Test.startTest();
        
        hsrce.getHistory();
        hsrce.getHash();
        hsrce.getDocumentHash();
        hsrce.getFullFurniturePickupURL();
        hsrce.getSelectedHousingSearch();
        hsrce.getHasSelectedHousingSearch();
        hsrce.getSelectedHousingSearchFurnitureOption();
        hsrce.getSelectedHousingSearchForeclosureCheck();
        hsrce.getCostRecordTypeName();
        hsrce.getIsFirstPropertyPresentedSet();
        hsrce.getIsManagerOrDirector();
        hsrce.getIsOperationsDirector();
        hsrce.getHasRelatedPlacement();
        hsrce.get();
        hsrce.getHasFurnitureOrder();    
        hsrce.getHasFurnitureOrderCost();
        hsrce.getActiveFurnitureOrderStatus();
        hsrce.getHasQuote();
        hsrce.getQuoteStatus();
        hsrce.getHasActiveQuote();
        hsrce.getIsPlacementMovedOut();
        hsrce.getIsPlacementCancelled();
        hsrce.getPlacementHasNewATD();
    

       
        hsrce.getClaim();

       
        hsrce.setPlacement(placement1);

        hsrce.getHasCompletedClaim();
        hsrce.getHasRelatedPlacement();
        hsrce.get(); 
        hsrce.setClaim(claim1);
        hsrce.getInstanceName();

        Test.stopTest();
    }




    @isTest static void test2() 
    {
       
        init();

        pageRef.getParameters().put('id', serviceRequest1.id); 
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(serviceRequest1);
   

        HousingServiceRequestControllerExtension hsrce = new HousingServiceRequestControllerExtension(stdCon);

        
        Contact landlord = [select Id from Contact where LastName = 'TestLandLord'];
        Contact adjuster = [select Id from Contact where LastName = 'TestAdjuster'];


        Test.startTest();
        
             
        serviceRequest1.First_Property_Presented__c = Date.newInstance(2010,12,10);

        hsrce.SaveServiceRequest();

        hsrce.getClaim();

        hsrce.getIsFirstPropertyPresentedSet();

        hsrce.clearFurnitureOnlySearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOnlyPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('furnitureOnlyPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('furnitureOnlyStreetAddress1', '100 Main St.');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('furnitureOnlyState', 'AZ');
        ApexPages.currentPage().getParameters().put('furnitureOnlyZip', '85123');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCountry', 'USA');
        ApexPages.currentPage().getParameters().put('furnitureOnlySquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBedrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBathrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('furnitureOnlyExtensionIncrementDays', '15');
        
        hsrce.saveFurnitureOnlySearch();

                  
        hsrce.clearHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', 'CRS Package');
        ApexPages.currentPage().getParameters().put('housingSearchPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('housingSearchLandlord', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchStreetAddress1', '300 Test St.');
        ApexPages.currentPage().getParameters().put('housingSearchCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('housingSearchState', 'AZ');
        ApexPages.currentPage().getParameters().put('housingSearchZip', '85123');
        ApexPages.currentPage().getParameters().put('housingSearchCountry', 'USA');
        ApexPages.currentPage().getParameters().put('housingSearchSquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('housingSearchDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('housingSearchBedrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchBathrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactName', 'Tim Smith');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactNumber', '602-444-5555');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialCheckDeliveryMethod', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'FedEx Morning');
        ApexPages.currentPage().getParameters().put('housingSearchRecurringPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('housingSearchExtensionIncrementDays', '15');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendVia', 'Email');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendTo', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchForecloserCheck', '1');
        ApexPages.currentPage().getParameters().put('housingSearchOver5milesReason', 'Nothing closer');
        ApexPages.currentPage().getParameters().put('housingSearchLeaseTermApproveByAdj', '10 month');
        ApexPages.currentPage().getParameters().put('housingSearchFirstAvailableMoveInDate', '3/1/2014');
        ApexPages.currentPage().getParameters().put('housingSearchTentativeMoveOutDate', '3/21/2014');
        ApexPages.currentPage().getParameters().put('housingSearchRent', '1000.00');
        ApexPages.currentPage().getParameters().put('housingSearchRentFrequency', 'Monthly');
        ApexPages.currentPage().getParameters().put('housingSearchRSD', '200.00');
        ApexPages.currentPage().getParameters().put('housingSearchSureDeposit', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchApplicationFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchTax', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchOtherNonRefundableFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchCleaningFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchAmenityFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchAdministrationFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchReKeyingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchBreakLeaseFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchGarageRemoteFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchFencingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequiredAfterILT', '30');
        ApexPages.currentPage().getParameters().put('housingSearchProcessingTimeForApplication', '2 days');
        ApexPages.currentPage().getParameters().put('housingSearchRequirementsForQualification', 'Full time employment');
        ApexPages.currentPage().getParameters().put('housingSearchHowUtilitiesAreToBeEstablished', 'New Account Setup');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitiesPHIsResponsibleFor', 'Gas');
        ApexPages.currentPage().getParameters().put('housingSearchApplianceHookUpGasElectric', 'None');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitySetUpFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitySetUpFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchBrokerFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchWindowCoveringFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchParkingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchPHAbatementAmount', '0.00');
        ApexPages.currentPage().getParameters().put('housingSearchResponsiblePartyForVendorEntry', 'Policyholder');
        ApexPages.currentPage().getParameters().put('housingSearchPhoneNumberToConfirmVendorEntry', '602-444-5555');
                         
        hsrce.saveHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingsearchId', hsrce.housingSearch.Id); 

        hsrce.editHousingSearch();

      
     
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'cost'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '1000.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Rent'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', ''); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 

      
           
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costId', hsrce.cost.Id); 

        hsrce.editCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'fee'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '100.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Other'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', 'Test Fee'); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 

       
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costId', hsrce.cost.Id); 
      
        hsrce.editCost();
        hsrce.getCostRecordTypeName();
        hsrce.deleteCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'deposit'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '100.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Other'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', 'Test Deposit'); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 

      
       
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costId', hsrce.cost.Id); 
      
        hsrce.editCost();


        hsrce.placement.Move_In_Date__c = Date.today();
        hsrce.placement.Approved_Through_Date__c = Date.newInstance(2019,12,10);
       
        hsrce.updatePlacement();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('placementStatus', 'Searching');

        hsrce.updatePlacementStatus(); 

        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchId', hsrce.housingSearch.Id); 
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', hsrce.housingSearch.Furniture_Option__c); 
        ApexPages.currentPage().getParameters().put('housingSearchLandlordStatus', hsrce.housingSearch.Landlord_Status__c); 
       
        hsrce.updateSelectedHousingSearch();

        ApexPages.currentPage().getParameters().clear();


        hsrce.updateSelectedHousingSearch();


        Test.stopTest();

    }

    @isTest static void test3() 
    {

       init();

        pageRef.getParameters().put('id', serviceRequest1.id); 
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(serviceRequest1);
   

        HousingServiceRequestControllerExtension hsrce = new HousingServiceRequestControllerExtension(stdCon);


        Contact landlord = [select Id from Contact where LastName = 'TestLandLord'];
        Contact adjuster = [select Id from Contact where LastName = 'TestAdjuster'];


        Test.startTest();
        
             
        serviceRequest1.First_Property_Presented__c = Date.newInstance(2010,12,10);

        hsrce.SaveServiceRequest();

        hsrce.clearHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', 'CRS Package');
        ApexPages.currentPage().getParameters().put('housingSearchPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('housingSearchLandlord', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchStreetAddress1', '300 Test St.');
        ApexPages.currentPage().getParameters().put('housingSearchCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('housingSearchState', 'AZ');
        ApexPages.currentPage().getParameters().put('housingSearchZip', '85123');
        ApexPages.currentPage().getParameters().put('housingSearchCountry', 'USA');
        ApexPages.currentPage().getParameters().put('housingSearchSquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('housingSearchDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('housingSearchBedrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchBathrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactName', 'Tim Smith');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactNumber', '602-444-5555');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialCheckDeliveryMethod', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'FedEx Morning');
        ApexPages.currentPage().getParameters().put('housingSearchRecurringPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('housingSearchExtensionIncrementDays', '15');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendVia', 'Email');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendTo', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchForecloserCheck', '1');

                 
        hsrce.saveHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'cost'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '1000.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Rent'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', ''); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 

        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'fee'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '100.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Other'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', 'Test Fee'); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costType', 'deposit'); 

        hsrce.clearCost();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('costAmount', '100.00'); 
        ApexPages.currentPage().getParameters().put('costType', 'Other'); 
        ApexPages.currentPage().getParameters().put('costTypeDescription', 'Test Deposit'); 
        ApexPages.currentPage().getParameters().put('costBillableParty', adjuster.Id); 
        ApexPages.currentPage().getParameters().put('costPayableParty', landlord.Id); 
        ApexPages.currentPage().getParameters().put('costProrateType', 'Monthly');

        hsrce.saveCost(); 


        hsrce.clearFurnitureOrder();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOrderId', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderStatus', 'Working');
        ApexPages.currentPage().getParameters().put('furnitureOrderRequestedDeliveryDate', '8/2/2015 2:55 PM');
        ApexPages.currentPage().getParameters().put('furnitureOrderIsPartial', 'False');
        ApexPages.currentPage().getParameters().put('furnitureOrderComments', 'Test Furniture Order');
        ApexPages.currentPage().getParameters().put('furnitureOrderIncludePictures', '1');
        ApexPages.currentPage().getParameters().put('furnitureOrderCost', '1000.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyCost', 'Adjuster');
        ApexPages.currentPage().getParameters().put('furnitureOrderDeposit', '100.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyDeposit', 'Adjuster');
        ApexPages.currentPage().getParameters().put('furnitureOrderSetupFee', '100');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartySetupFee', 'Adjuster');
        ApexPages.currentPage().getParameters().put('furnitureOrderPetFee', '100');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyPetFee', 'Adjuster');
        ApexPages.currentPage().getParameters().put('furnitureOrderDeliveryFee', '50.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyDeliveryFee', 'Policyholder');
        ApexPages.currentPage().getParameters().put('furnitureOrderLevel', 'Level 1');
        ApexPages.currentPage().getParameters().put('furnitureOrderMasterBedroom', 'Single Twin w/ Headboard');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom1', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom2', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom3', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom4', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom5', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom6', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom7', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom8', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom9', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom10', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderLivingRoom', 'Living Room Chair');
        ApexPages.currentPage().getParameters().put('furnitureOrderDiningRoom', 'Dining Chairs (2)');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalDiningRoom', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAppliances', 'No');
        ApexPages.currentPage().getParameters().put('furnitureOrderRefrigerator', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderMicrowave', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderClothesWasher', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderClothesDryer', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderDryerType', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderRange', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderRangeType', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderHousewares', 'Yes');
        ApexPages.currentPage().getParameters().put('furnitureOrderBedroomsNeedingHousewares', '1');
        ApexPages.currentPage().getParameters().put('furnitureOrderBathroomsNeedingHousewares', '1');

        hsrce.saveFurnitureOrder();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOrderId', hsrce.furnitureOrder.Id); 
      
        hsrce.editFurnitureOrder();


        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOrderId', hsrce.furnitureOrder.Id);
        ApexPages.currentPage().getParameters().put('furnitureOrderStatus', 'Completed');
        ApexPages.currentPage().getParameters().put('furnitureOrderRequestedDeliveryDate', '8/2/2015 2:55 PM');
        ApexPages.currentPage().getParameters().put('furnitureOrderIsPartial', 'False');
        ApexPages.currentPage().getParameters().put('furnitureOrderComments', 'Test Furniture Order');
        ApexPages.currentPage().getParameters().put('furnitureOrderIncludePictures', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderCost', '1000.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyCost', 'PolicyHolder');
        ApexPages.currentPage().getParameters().put('furnitureOrderDeposit', '100.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyDeposit', 'PolicyHolder');
        ApexPages.currentPage().getParameters().put('furnitureOrderSetupFee', '100');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartySetupFee', 'PolicyHolder');
        ApexPages.currentPage().getParameters().put('furnitureOrderPetFee', '100');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyPetFee', 'PolicyHolder');
        ApexPages.currentPage().getParameters().put('furnitureOrderDeliveryFee', '50.00');
        ApexPages.currentPage().getParameters().put('furnitureOrderBillablePartyDeliveryFee', 'Adjuster');
        ApexPages.currentPage().getParameters().put('furnitureOrderLevel', 'Level 1');
        ApexPages.currentPage().getParameters().put('furnitureOrderMasterBedroom', 'Single Twin w/ Headboard');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom1', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom2', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom3', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom4', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom5', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom6', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom7', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom8', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom9', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalBedroom10', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderLivingRoom', 'Living Room Chair');
        ApexPages.currentPage().getParameters().put('furnitureOrderDiningRoom', 'Dining Chairs (2)');
        ApexPages.currentPage().getParameters().put('furnitureOrderAdditionalDiningRoom', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderAppliances', 'No');
        ApexPages.currentPage().getParameters().put('furnitureOrderRefrigerator', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderMicrowave', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderClothesWasher', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderClothesDryer', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderDryerType', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderRange', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderRangeType', '');
        ApexPages.currentPage().getParameters().put('furnitureOrderHousewares', 'Yes');
        ApexPages.currentPage().getParameters().put('furnitureOrderBedroomsNeedingHousewares', '1');
        ApexPages.currentPage().getParameters().put('furnitureOrderBathroomsNeedingHousewares', '1');

         hsrce.saveFurnitureOrder();

        hsrce.placement.Move_In_Date__c = Date.today();
        hsrce.placement.Approved_Through_Date__c = Date.newInstance(2019,12,10);
        hsrce.placement.THA_Signed_Date__c = Datetime.now();
       
        hsrce.updatePlacement();
             

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchId', hsrce.housingSearch.Id); 
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', hsrce.housingSearch.Furniture_Option__c); 
        ApexPages.currentPage().getParameters().put('housingSearchLandlordStatus', hsrce.housingSearch.Landlord_Status__c); 
       
        hsrce.updateSelectedHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('selectedHousingSearchFurnitureOption', hsrce.housingSearch.Furniture_Option__c);

        hsrce.buildQuote();


        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('quoteId', ''); 
        ApexPages.currentPage().getParameters().put('quoteStatus', ''); 
        ApexPages.currentPage().getParameters().put('quoteBillingPreferences', 'Standard'); 
        ApexPages.currentPage().getParameters().put('quoteMarkupAdjustment', ''); 
        ApexPages.currentPage().getParameters().put('quoteMarkupAuthorizedBy', ''); 
        ApexPages.currentPage().getParameters().put('quoteSpecialInstructions', hsrce.quote.Special_Instructions_New__c); 
       
        hsrce.saveQuote();

          
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('quoteId', hsrce.quote.Id); 
      
        hsrce.editQuote();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('quoteId', hsrce.quote.Id); 
        ApexPages.currentPage().getParameters().put('quoteStatus', 'Approved'); 
        ApexPages.currentPage().getParameters().put('quoteBillingPreferences', 'Standard'); 
        ApexPages.currentPage().getParameters().put('quoteMarkupAdjustment', ''); 
        ApexPages.currentPage().getParameters().put('quoteMarkupAuthorizedBy', ''); 
        ApexPages.currentPage().getParameters().put('quoteSpecialInstructions', hsrce.quote.Special_Instructions_New__c); 

        hsrce.saveQuote();

        hsrce.fetchPlacementCount();
        hsrce.getHousingExtensions();
       
     

        Test.stopTest();
        
    }

    @isTest static void test4() 
    {
       
        init();

        pageRef.getParameters().put('id', serviceRequest1.id); 
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(serviceRequest1);
   

        HousingServiceRequestControllerExtension hsrce = new HousingServiceRequestControllerExtension(stdCon);

        Contact landlord = [select Id from Contact where LastName = 'TestLandLord'];
        Contact adjuster = [select Id from Contact where LastName = 'TestAdjuster'];


        Test.startTest();
        
        serviceRequest1.First_Property_Presented__c = Date.newInstance(2010,12,10);

        hsrce.SaveServiceRequest();

        hsrce.clearFurnitureOnlySearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOnlyPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('furnitureOnlyPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('furnitureOnlyStreetAddress1', '100 Main St.');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('furnitureOnlyState', 'AZ');
        ApexPages.currentPage().getParameters().put('furnitureOnlyZip', '85123');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCountry', 'usa');
        ApexPages.currentPage().getParameters().put('furnitureOnlySquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBedrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBathrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('furnitureOnlyExtensionIncrementDays', '15');
        
        hsrce.saveFurnitureOnlySearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingsearchId', hsrce.housingSearch.Id); 
        
        hsrce.editHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('furnitureOnlyId',  hsrce.housingSearch.Id);
        ApexPages.currentPage().getParameters().put('furnitureOnlyPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('furnitureOnlyPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('furnitureOnlyStreetAddress1', '100 Main St.');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('furnitureOnlyState', 'AZ');
        ApexPages.currentPage().getParameters().put('furnitureOnlyZip', '85123');
        ApexPages.currentPage().getParameters().put('furnitureOnlyCountry', 'canada');
        ApexPages.currentPage().getParameters().put('furnitureOnlySquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBedrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyBathrooms', '2');
        ApexPages.currentPage().getParameters().put('furnitureOnlyDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('furnitureOnlyExtensionIncrementDays', '15');

        hsrce.saveFurnitureOnlySearch();

        hsrce.clearHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', 'CRS Package');
        ApexPages.currentPage().getParameters().put('housingSearchPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('housingSearchLandlord', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchStreetAddress1', '300 Test St.');
        ApexPages.currentPage().getParameters().put('housingSearchCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('housingSearchState', 'AZ');
        ApexPages.currentPage().getParameters().put('housingSearchZip', '85123');
        ApexPages.currentPage().getParameters().put('housingSearchCountry', 'usa');
        ApexPages.currentPage().getParameters().put('housingSearchSquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('housingSearchDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('housingSearchBedrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchBathrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactName', 'Tim Smith');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactNumber', '602-444-5555');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialCheckDeliveryMethod', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'FedEx Morning');
        ApexPages.currentPage().getParameters().put('housingSearchRecurringPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('housingSearchExtensionIncrementDays', '15');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendVia', 'Email');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendTo', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchForecloserCheck', '1');
        ApexPages.currentPage().getParameters().put('housingSearchOver5milesReason', 'Nothing closer');
        ApexPages.currentPage().getParameters().put('housingSearchLeaseTermApproveByAdj', '10 month');
        ApexPages.currentPage().getParameters().put('housingSearchFirstAvailableMoveInDate', '3/1/2014');
        ApexPages.currentPage().getParameters().put('housingSearchTentativeMoveOutDate', '3/21/2014');
        ApexPages.currentPage().getParameters().put('housingSearchRent', '1000.00');
        ApexPages.currentPage().getParameters().put('housingSearchRentFrequency', 'Monthly');
        ApexPages.currentPage().getParameters().put('housingSearchRSD', '200.00');
        ApexPages.currentPage().getParameters().put('housingSearchSureDeposit', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchApplicationFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchTax', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchOtherNonRefundableFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchCleaningFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchAmenityFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchAdministrationFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchReKeyingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchBreakLeaseFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchGarageRemoteFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchFencingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequiredAfterILT', '30');
        ApexPages.currentPage().getParameters().put('housingSearchProcessingTimeForApplication', '2 days');
        ApexPages.currentPage().getParameters().put('housingSearchRequirementsForQualification', 'Full time employment');
        ApexPages.currentPage().getParameters().put('housingSearchHowUtilitiesAreToBeEstablished', 'New Account Setup');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitiesPHIsResponsibleFor', 'Gas');
        ApexPages.currentPage().getParameters().put('housingSearchApplianceHookUpGasElectric', 'None');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitySetUpFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchUtilitySetUpFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchBrokerFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchWindowCoveringFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchParkingFee', '10.00');
        ApexPages.currentPage().getParameters().put('housingSearchPHAbatementAmount', '0.00');
        ApexPages.currentPage().getParameters().put('housingSearchResponsiblePartyForVendorEntry', 'Policyholder');
        ApexPages.currentPage().getParameters().put('housingSearchPhoneNumberToConfirmVendorEntry', '602-444-5555');

                 
        hsrce.saveHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingsearchId', hsrce.housingSearch.Id); 

        hsrce.editHousingSearch();

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('housingSearchId', hsrce.housingSearch.Id);
        ApexPages.currentPage().getParameters().put('housingSearchPropertyType', 'Single Family Home');
        ApexPages.currentPage().getParameters().put('housingSearchFurnitureOption', 'CRS Package');
        ApexPages.currentPage().getParameters().put('housingSearchPresentedDateTime', '3/1/2014 2:55 PM');
        ApexPages.currentPage().getParameters().put('housingSearchLandlord', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchStreetAddress1', '300 Test St.');
        ApexPages.currentPage().getParameters().put('housingSearchCity', 'Phoenix');
        ApexPages.currentPage().getParameters().put('housingSearchState', 'AZ');
        ApexPages.currentPage().getParameters().put('housingSearchZip', '85123');
        ApexPages.currentPage().getParameters().put('housingSearchCountry', 'canada');
        ApexPages.currentPage().getParameters().put('housingSearchSquareFeet', '2000');
        ApexPages.currentPage().getParameters().put('housingSearchDistanceFromDamagedProp', '10');
        ApexPages.currentPage().getParameters().put('housingSearchBedrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchBathrooms', '2');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactName', 'Tim Smith');
        ApexPages.currentPage().getParameters().put('housingSearchInitialContactNumber', '602-444-5555');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialCheckDeliveryMethod', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchInitialPaymentType', 'FedEx Morning');
        ApexPages.currentPage().getParameters().put('housingSearchRecurringPaymentType', 'Company Check');
        ApexPages.currentPage().getParameters().put('housingSearchDaysNoticeRequired', '30');
        ApexPages.currentPage().getParameters().put('housingSearchExtensionIncrementDays', '15');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendVia', 'Email');
        ApexPages.currentPage().getParameters().put('housingSearchNTVSendTo', landlord.Id);
        ApexPages.currentPage().getParameters().put('housingSearchForecloserCheck', '');

        hsrce.saveHousingSearch();

  
        hsrce.updatePlacement();

 
        hsrce.serviceRequest.DWO_Reason_Code__c = 'Other';

        hsrce.saveServiceRequest();

        Test.stopTest();
    }

    
}