@isTest
private class NTVDocumnetPreviewControllerTest 
{
      
      @isTest static void NTVDocumnetPreviewTest() 
      {
        
            Account account = new Account
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
                    Email__c = 'testemail@org1.com',
                    Fax = '6022345675'
                );
            insert account;
        
        
            Contact contactLL = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
                                                            from Contact 
                                                            where RecordTypeId = :recordTypeHelper.landlordContactRT()
                                                            and AccountId = :account.Id];
           
          
            Contact contactPH = new Contact
                (
                    RecordTypeId = recordTypeHelper.policyholderContactRT(),
                    Account = account,
                    LastName='TestPH',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501');
            
            insert contactPH;
    
    
            // Insert Users
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User user1 = new User
                    (   Alias = 'standt',
                        Email='standarduser@testorg.com', 
                        EmailEncodingKey='UTF-8', 
                        LastName='Testing', 
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', 
                        ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', 
                        UserName='standarduser@crstemphousing.com');
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
                      RecordTypeId = recordTypeHelper.housingServiceRequestRT(),
                Opportunity__c = opportunity.Id,
                Status__c = 'Searching',
                THC_Signed__c = Date.newInstance(2009,10,09),
                THA_Signed__c = Date.newInstance(2009,10,09));
            insert serviceRequest;
                   
           
            // Insert placement
                   
            Placement__c placement = new Placement__c(
                                            RecordTypeId = recordTypeHelper.housingPlacementRT(),
                                            ServiceRequest__c = serviceRequest.Id,
                                            Opportunity__c = opportunity.Id,
                                            Status__c = 'Moved-In',
                                            Name = 'testPlacementHousing',
                                            Move_In_Date__c = Date.newInstance(2015,09,09),
                                            Move_Out_Date__c = Date.toDay(),
                          Approved_Through_Date__c = Date.today().addDays(30));
                                            
            insert placement;
        
        // Insert Housing Search
               
          Searches__c housingSearch = new Searches__c
              (
                Service_Request__c = serviceRequest.Id,
                        RecordTypeId = recordTypeHelper.housingSearchRT(),
                Placement__c = placement.Id,
                Property_Type__c = 'Single Family Home',
                Furniture_Option__c = 'CRS Package',
                Selected__c = true,
                Street_Addr1__c = '134 Laurel',
                City__c = 'Mineola',
                State__c = 'CT',
                Zip__c = '11501',
                  Country__c = 'USA',
                  Extension_Increment_days__c = 30,
                  Bedrooms__c = '3',
                  Bathrooms__c = '2',
                  NTV_Send_Via__c = 'Email',
                  NTV_Send_To__c = contactLL.Id,
                  THC_Comments__c = 'test',
                  Initial_Contact_Name__c = 'Initial Contact',
                  Initial_Contact_Number__c = '602-444-5555',
                  Presented_Date__c = Date.newInstance(2014,3,01),
                  Days_Notice_Required__c = 30,
                  Landlord__c = contactLL.Id);
          
            insert housingSearch;
         
            placement.Selected_Search__c = housingSearch.Id;
            update placement;
            
            Task t = new Task();
            t.Subject = 'NTV Task';
            t.ownerId = Userinfo.getUserId();
            t.whatId = serviceRequest.Id;
            t.status = 'In Progress';
            t.Fax_Result_ID__c = '1234567';
            t.Fax_Sent_User_ID__c = Userinfo.getUserId();
            
            insert t;
         
            Test.StartTest();
            ApexPages.currentPage().getParameters().put('reqId', serviceRequest.Id); 
            ApexPages.currentPage().getParameters().put('taskId', t.Id);
            
            NTVDocumnetPreviewController ntvTC = new NTVDocumnetPreviewController();   
            ntvTC.sendEmail(); 
            ntvTC.sendFax();          
            Test.StopTest();
      
      }
}