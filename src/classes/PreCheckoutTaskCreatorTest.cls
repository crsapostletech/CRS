@isTest
private class PreCheckoutTaskCreatorTest 
{
  @testSetup static void setupTestData()
    {

        DateTime currentDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
        DateTime min72hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
        DateTime max72hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
        DateTime min24hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
        DateTime max24hrDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));
        DateTime minShortTermDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));

        // Calculate min and max business days out from current date
        min72hrDate = min72hrDate.AddDays(3);
        max72hrDate = max72hrDate.AddDays(3);
        min24hrDate = min24hrDate.AddDays(1);
        max24hrDate = max24hrDate.AddDays(1);
        minShortTermDate = minShortTermDate.AddDays(-2);
    
        
        if (currentDate.format('u') == '1' || currentDate.format('u') == '2')
        {
            minShortTermDate = minShortTermDate.AddDays(-2);
        }
        else
        {
            if (currentDate.format('u') == '3')
            {
                max72hrDate = max72hrDate.AddDays(2);
            }
            else
            {
                if (currentDate.format('u') == '4' || currentDate.format('u') == '5')
                {
                    min72hrDate = min72hrDate.AddDays(2);
                    max72hrDate = max72hrDate.AddDays(2);

                    if (currentDate.format('u') == '5')
                    {
                        max24hrDate = max24hrDate.AddDays(2);
                    }
                }               
            }
        }

    Account account1 = new Account
                (
                    RecordTypeId = recordTypeHelper.landlordAccountRT(),
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
                    Contact_First_Name__c = 'Test',
                    Contact_Last_Name__c = 'Guy',
                    Fax = '6022345675'
                );
        insert account1;

        Account account2 = new Account
                (
                    RecordTypeId = recordTypeHelper.insuranceCompanyAccountRT(),
                    name='Safeco Insurance Company Headquarters',
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
                    Contact_First_Name__c = 'Test',
                    Contact_Last_Name__c = 'Guy',
                    Fax = '6022345675'
                );
        insert account2;

         Account account3 = new Account
                (
                    RecordTypeId = recordTypeHelper.insuranceCompanyAccountRT(),
                    name='Safeco Insurance Company',
                    ParentID = account2.Id,
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
                    Contact_First_Name__c = 'Test',
                    Contact_Last_Name__c = 'Guy',
                    Fax = '6022345675'
                );
        insert account3;
    
    
    Contact contactLL = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
                                                        from Contact 
                                                        where RecordTypeId = :recordTypeHelper.landlordContactRT()
                                                        and AccountId = :account1.Id];

      
        Contact contactPH = new Contact
            (
                RecordTypeId = recordTypeHelper.policyholderContactRT(),
                AccountID = account1.Id,
                LastName='TestPH',
                Status__c='Active',
                MailingCountry='USA',
                MailingState='CT',
                MailingStreet='134 Laurel',
                MailingCity='Mineola',
                MailingPostalCode='11501');
        
        insert contactPH;

        Contact contactADJ = new Contact
            (
                RecordTypeId = recordTypeHelper.adjusterContactRT(),
                AccountId = account3.Id,
                LastName='TestADJ',
                Status__c='Active',
                MailingCountry='USA',
                MailingState='CT',
                MailingStreet='134 Laurel',
                MailingCity='Mineola',
                MailingPostalCode='11501');
        
        insert contactADJ;

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
                    policyholder__c = contactPH.Id,
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
        
      
        // Insert ServiceRequest 
               
        ServiceRequest__c serviceRequest = new ServiceRequest__c
            (
                  RecordTypeId = recordTypeHelper.hotelServiceRequestRT(),
            Opportunity__c = opportunity.Id,
            Status__c = 'Searching',
            THC_Signed__c = Date.newInstance(2009,10,09),
            THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest;
               
       
        // Insert placement
               
        Placement__c placement = new Placement__c(
                                        RecordTypeId = recordTypeHelper.hotelPlacementRT(),
                                        ServiceRequest__c = serviceRequest.Id,
                                        Opportunity__c = opportunity.Id,
                                        Status__c = 'Moved-In',
                                        Name = 'testPlacementHotel');                                        
        insert placement;
    
    // Insert Hotel Room
           
      Hotel_Room__c hr1 = new Hotel_Room__c
      (
        Room_Type__c = 'Standard Double',
        Kitchen_Features__c = 'Kitchenette',
        Confirmation__c = '123',
        Check_In__c = Date.Today() - 10,
        Estimated_Check_Out_Date__c = max72hrDate.date(),
        Hotel_Nightly_Rate__c = 100.00,
        Itemized_Tax__c = 10,
        Placement__c = placement.Id,
        Policyholder__c = contactPH.Id);
        
        insert hr1;
       

        Hotel_Room__c hr2 = new Hotel_Room__c
        (
        Room_Type__c = 'Standard Double',
        Kitchen_Features__c = 'Kitchenette',
        Confirmation__c = '123',
        Check_In__c = min24hrDate.date() - 1,
        Estimated_Check_Out_Date__c = min24hrDate.date(),
        Hotel_Nightly_Rate__c = 100.00,
        Itemized_Tax__c = 10,
        Placement__c = placement.Id,
        Policyholder__c = contactPH.Id);
        
        insert hr2;

    }

    @isTest static void PreCheckoutTaskCreatorTest1() 
    {
       Test.StartTest();
       SchedulableContext sc;
       PreCheckoutTaskCreatorScheduler pcTCS =  new PreCheckoutTaskCreatorScheduler();
       pcTCS.execute(sc);
       Test.StopTest();

       AggregateResult tasks72HourPH = [Select COUNT(Id)recCount from Task where type = '72 Hour Policyholder Follow Up'];
       system.assertEquals(1,tasks72HourPH.get('recCount'));

       AggregateResult tasks24Hour = [Select COUNT(Id)recCount from Task where type = '24 Hour Follow Up'];
       system.assertEquals(1,tasks24Hour.get('recCount'));
       
    }

    @isTest static void PreCheckoutTaskCreatorTest2() 
    {
       Contact adj = [select id from Contact where LastName='TestADJ'];
       Opportunity opp = [select id from Opportunity where Damaged_Property_Address__c = '123 Big Test Lane'];
       opp.Adjuster__c = adj.Id;
       update opp;
      
       Test.StartTest();
       SchedulableContext sc;
       PreCheckoutTaskCreatorScheduler pcTCS =  new PreCheckoutTaskCreatorScheduler();
       pcTCS.execute(sc);
       Test.StopTest();

       AggregateResult tasks72HourADJ = [Select COUNT(Id)recCount from Task where type = '72 Hour Adjuster Follow Up'];
       system.assertEquals(1,tasks72HourADJ.get('recCount'));
       
    }
}