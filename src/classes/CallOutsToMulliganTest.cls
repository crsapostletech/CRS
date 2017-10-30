@isTest
private class CallOutsToMulliganTest {

   static testMethod void testCallOutsToMulligan1() 
   {
        RecordType accountRT = [Select Id, Name from RecordType where sobjecttype='Account' and Name = 'Hotel Accounts'];
        Account account = new Account
                (
                    RecordTypeId = accountRT.Id,
                    name='testAccountx',
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
                    Fax = '6022345675'
                );
        insert account;
        
        account.Fax = '6022354565';
        
        Util.unsetAlreadyFired('Account');
            
        update account;
        
        
         // Insert placement
        RecordType hotelplacementRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Placement__c' AND Name = 'Hotel Placement'];
        
        Placement__c placement = new Placement__c(
                                        RecordTypeId = hotelPlacementRT.Id,
                                        Name = 'testPlacementx');
                                        
        insert placement;
        
        CallOutsToMulligan.SetBillingCompleted(placement.Id);
        
        placement.Accounting_Instructions__c = 'Testing';
        
        Util.unsetAlreadyFired('Placement__c');
        
        update placement;
        
        Util.unsetAlreadyFired('Placement__c');
        
        delete placement;
        
        
        RecordType contactRT = [Select Id, Name from RecordType where sobjecttype='Contact' and Name='Adjuster'];
        Contact contact = new Contact
                (
                    RecordTypeId = contactRT.Id,
                    LastName='xxxxxx',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501',
                    Type__c='TPA',
                    LeadSource='Event',
                    Lead_Source_Description__c='Golf Event'
                );
        insert contact;
        
        Util.unsetAlreadyFired('Contact');
        
        update contact;
        
   }
    
   static testMethod void testCallOutsToMulligan2() 
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

        // Insert Claim 
        Opportunity opportunity = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Initial_Service_Request__c='Hotel',   
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
        
        Util.unsetAlreadyFired('Claim');
        
        opportunity = [Select Id from Opportunity where Damaged_Property_Address__c = '123 Big Test Lane' limit 1];
        
        update opportunity;
        
        // Insert ServiceRequest 
        RecordType housingServiceRequest = [Select Id, Name from RecordType where sobjecttype='ServiceRequest__c' and Name = 'Housing'];       
        
        ServiceRequest__c serviceRequest = new ServiceRequest__c
                (
                    RecordTypeId = housingServiceRequest.id,
                    Opportunity__c= opportunity.id,
                    Status__c = 'Searching',
                    THC_Signed__c = Date.newInstance(2009,10,09),
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest;
                
        Util.unsetAlreadyFired('ServiceRequest__c');
        
        // Get inserted Service Request
        serviceRequest = [SELECT Id FROM ServiceRequest__c WHERE id =: serviceRequest.Id];
                
        update serviceRequest;
        
        
        // Insert Property
        Properties__c  property = new Properties__c
                (
                     Name = 'Test Property',
                     Type_of_Property__c = 'House',
                     Address_Line_1__c='111 farewell',
                     Address_Line_2__c='234 unit',
                     City__c='mineola',
                     State_ID__c='NY',
                     Zip__c='11507',
                     Country__c='USA',
                     Bathrooms__c='1',
                     Bedrooms__c='1',
                     Rent_Frequency__c='Daily',
                     Rent__c=1500.00,
                     Send_Via__c='US Mail',
                     Lease_Start__c=Date.newInstance(2009,09,09),
                     Lease_End__c=Date.newInstance(2010,09,09),
                     Rent_Due__c=2,
                     Days_Notice_Required__c=1,
                     Days_to_Increment_Extension__c=2,
                     Is_Month_to_Month_Lease_Same_Rent__c='Yes',
                     Pay_Rent_to_Landlord__c='True',
                     Prorate_Amount__c=25.00);
                                                    
        insert property;
        
        Util.unsetAlreadyFired('Properties__c');
        
        property = [SELECT Id FROM Properties__c WHERE id =: property.Id];
        
        update property;
        
        
        // Insert HotelRoom
        Hotel_Room__c hotelRoom = new Hotel_Room__c
                (
                    Check_In__c = Date.newInstance(2010,12,10)
                );
        insert hotelRoom;
        
        Util.unsetAlreadyFired('Hotel_Room__c');
        
        hotelRoom.Billed_Through_Date__c = Date.newInstance(2011,12,10);
        
        update hotelRoom;
        
       
         // Insert Housing Search
            RecordType housingSearchRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Searches__c' AND Name = 'Housing'];
            
            Searches__c housingSearch = new Searches__c
                    (
                        Property_Type__c = 'Single Family Home',
                        Furniture_Option__c = 'CRS Package',
                        Street_Addr1__c = '134 Laurel',
                        City__c = 'Mineola',
                        State__c = 'CT',
                        Zip__c = '11501',
                        Country__c = 'USA',
                        Initial_Contact_Name__c = 'Initial Contact',
                        Initial_Contact_Number__c = '602-444-5555',
                        Presented_Date__c = Date.newInstance(2014,3,01));
            
            insert housingSearch;
            
            Util.unsetAlreadyFired('Search__c');
            
            housingSearch.City__c = 'Phoenix';
            
            Update housingSearch;
            
        
             
       // Update Note
        
     /*   Note note = [select id from Note where Id = '0027000000IDZ9MAAX'];        
                
        update note;
     */
    }
    
    static testMethod void testCallOutsToMulligan3() 
    {
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser )
        {
            RecordType contactRT = [Select Id, Name from RecordType where sobjecttype='Contact' and Name='Landlord'];
            Contact contact = new Contact
                (
                    RecordTypeId = contactRT.Id,
                    LastName='TestLandLord',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501');
            
            insert contact;
                    
            // Insert placement
            RecordType housingPlacementRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Placement__c' AND Name = 'Housing Placement'];
            
            Placement__c placement = new Placement__c(
                                            RecordTypeId = housingPlacementRT.Id,
                                            Name = 'testPlacementHousing',
                                            Move_In_Date__c = Date.newInstance(2015,09,09),
                                            Approved_Through_Date__c = Date.newInstance(2016,09,09));
                                            
            insert placement;
            
            // Insert Housing Search
            RecordType housingSearchRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='Searches__c' AND Name = 'Housing'];
            
            Searches__c housingSearch = new Searches__c
                    (
                        Placement__c = placement.Id,
                        Property_Type__c = 'Single Family Home',
                        Furniture_Option__c = 'CRS Package',
                        Selected__c = true,
                        Street_Addr1__c = '134 Laurel',
                        City__c = 'Mineola',
                        State__c = 'CT',
                        Zip__c = '11501',
                        Country__c = 'USA',
                        Initial_Contact_Name__c = 'Initial Contact',
                        Initial_Contact_Number__c = '602-444-5555',
                        Presented_Date__c = Date.newInstance(2014,3,01),
                        Landlord__c = contact.Id);
            
            insert housingSearch;
            
            // Insert Rent Cost
            RecordType costRT = [SELECT Id, Name FROM RecordType WHERE sobjecttype='costs__c' AND Name = 'Cost'];
            
            Costs__c rent = new Costs__c
                    (   
                        Searches__c = housingSearch.Id,
                        RecordTypeId = costRT.Id,
                        Amount__c = 1000.00,
                        Type__c = 'Rent',
                        Billable_Party__c = contact.Id,
                        Payable_Party__c = contact.Id,
                        Prorate_Type__c = 'Monthly');
            insert rent;
            
            CallOutsToMulligan.getProrateAmount(placement.Id, housingSearch.Id);
            
            CallOutsToMulligan.getMarkupAmount(placement.Id, housingSearch.Id, '123', housingSearch.Furniture_Option__c);
            
            housingSearch.Furniture_Option__c = 'Furniture Only';
            
            CallOutsToMulligan.getMarkupAmount(placement.Id, housingSearch.Id, '123', housingSearch.Furniture_Option__c);
            
            // Insert Quote
            
            RecordType quoteRT = [Select Id, Name from RecordType where sobjecttype='Quote__c' and Name = 'Mulligan Quote'];
            
            Quote__c quote = new Quote__c
                    (
                        RecordTypeId = quoteRT.Id,
                        Status__c = 'Submitted',
                        Placement_Lookup__c = placement.Id,
                        Claim_Name__c = '123456',
                        Contract_Number__c = '123456',
                        Move_In_Date__c = Date.newInstance(2015,09,09),
                        Approved_Through_Date__c = Date.newInstance(2016,09,09),
                        Claim_Team_Number__c = 1);
            insert quote;
            
            quote.Status__c = 'Rejected';
            
            Update quote;
            
            CallOutsToMulligan.pushUpdatedQuoteInformation(quote.Id, quote.Status__c);
           
        }
       
               
        Profile p = [select id from profile where name='Contract Manager'];
        UserRole r = [Select id from userrole where name='IT / Sys Admin'];
        User user = new User
                        (
                        alias = 'standt', 
                        email='standarduser@testorg.com', 
                        emailencodingkey='UTF-8', 
                        lastname='Testing', 
                        languagelocalekey='en_US', 
                        localesidkey='en_US', 
                        profileid = p.Id, 
                        userroleid = r.Id,
                        timezonesidkey='America/Los_Angeles', 
                        Username='testguy@testorg.com');
         
        insert user;
        Util.unsetAlreadyFired('User');
        
        user.IsActive = false;
        update user;
        
        set<Id> updatedRecordIds = new set<id>{'a0L70000002eNUGEA2'};
        CallOutsToMulligan.PushUpdatesSync('Placement__c', false, updatedRecordIds, 'updated'); 
    }
}