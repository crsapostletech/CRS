@isTest
public class OpportunityTriggerHandler_TC
{
    public static testMethod void createTaskMethod()
    {
        Contact contact1 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    LastName='xxxxxx',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501',
                    Type__c='TPA',
                    LeadSource='Event',
                    Lead_Source_Description__c='Golf Event');
        insert contact1;

       Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
       User user1 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser2@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser@crsth.com');
       insert user1; 
       
       User user2 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser2@crsth.com');
       insert user2; 
       
        User user3 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser3@crsth.com');
       insert user3; 
              
              
       // Insert Claim 
        Opportunity opportunity1 = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = contact1.Id,
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
        insert opportunity1;
        
                    opportunity1.Regional_Manager__c = user2.Id;
                    opportunity1.Customer_Care_Specialist__c = user3.Id;
                    opportunity1.Area_Specialist__c =  user3.Id;
                    opportunity1.Housing_Coordinator__c  = user2.Id;
                    opportunity1.Hotel_Customer_Care_Specialist__c = user2.Id;
               update opportunity1;
        
        Opportunity opportunity2 = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = contact1.Id, 
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
                    Area_Specialist__c = user1.Id,
                    Housing_Coordinator__c  = user1.Id,
                    Initial_Service_Request__c = 'Housing',
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity2;
        
        ServiceRequest__c sr=new ServiceRequest__c( 
                    Opportunity__c=opportunity2.Id,
                    Status__c= 'Request',
                    Hold__c=false,
                    Initial_Contact_Date__c=System.Today(),
                    Initial_SR_being_worked_by__c=userinfo.getuserid(),
                    Task_Attempts__c='Attempt-2',                    
                    HotelSearch_BookHotel__c=true,
                    CreatedDate=System.Today(),
                    RecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId());
                insert sr;
       Placement__c housingPlacement = new Placement__c(
                                            RecordTypeId = RecordTypeHelper.housingPlacementRT(),
                                            Name = 'testPlacementHousing',
                                            Opportunity__c = opportunity1.id,
                                            ServiceRequest__c = sr.id,
                                            Status__c = 'Searching',
                                            Move_In_Date__c = Date.newInstance(2015,09,09),
                            Approved_Through_Date__c = Date.newInstance(2016,09,09));
        insert housingPlacement;  
                            housingPlacement.Status__c = 'Moved-In';
        update housingPlacement;                           
                Test.startTest();  
                    opportunity2.Regional_Manager__c = user2.Id;
                    opportunity2.Customer_Care_Specialist__c = user3.Id;
                    opportunity2.Area_Specialist__c =  user3.Id;
                    opportunity2.Housing_Coordinator__c  = user2.Id;
                    opportunity2.Hotel_Customer_Care_Specialist__c = user2.Id;
                update opportunity2; 
        
                    sr.RecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Housing').getRecordTypeId();
                    sr.Opportunity__c=opportunity1.Id;
                update opportunity1;
                Test.stopTest();
                         
    }
      public static testMethod void createTaskMethod1()
    {
        Contact contact1 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    LastName='xxxxxx',
                    Status__c='Active',
                    MailingCountry='USA',
                    MailingState='CT',
                    MailingStreet='134 Laurel',
                    MailingCity='Mineola',
                    MailingPostalCode='11501',
                    Type__c='TPA',
                    LeadSource='Event',
                    Lead_Source_Description__c='Golf Event');
        insert contact1;

       Profile p = [SELECT Id FROM Profile WHERE Name='Operations User']; 
       User user1 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser2@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser@crsth.com');
       insert user1; 
       
       User user2 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser2@crsth.com');
       insert user2; 
       
        User user3 = new User
               (   
                   Alias = 'opsusr',
                   Email='operationsuser@crsth.com', 
                   EmailEncodingKey='UTF-8', 
                   LastName='Testing', 
                   LanguageLocaleKey='en_US',
                   LocaleSidKey='en_US', 
                   ProfileId = p.Id, 
                   TimeZoneSidKey='America/Los_Angeles', 
                   UserName='operationsuser3@crsth.com');
       insert user3; 
              
              
       // Insert Claim 
        Opportunity opportunity1 = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = contact1.Id,
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
        insert opportunity1;
        ServiceRequest__c sr1=new ServiceRequest__c( 
                    Opportunity__c=opportunity1.Id,
                    Status__c= 'Request',
                    Hold__c=false,
                    Initial_Contact_Date__c=System.Today(),
                    Initial_SR_being_worked_by__c=userinfo.getuserid(),
                    Task_Attempts__c='Attempt-2',                    
                    HotelSearch_BookHotel__c=true,
                    CreatedDate=System.Today(),
                    RecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId());
                insert sr1;
       Placement__c housingPlacement1 = new Placement__c(
                                            RecordTypeId = RecordTypeHelper.housingPlacementRT(),
                                            Name = 'testPlacementHousing',
                                            Opportunity__c = opportunity1.id,
                                            ServiceRequest__c = sr1.id,
                                            Status__c = 'Searching',
                                            Move_In_Date__c = Date.newInstance(2015,09,09),
                            Approved_Through_Date__c = Date.newInstance(2016,09,09));
        insert housingPlacement1;  
                    opportunity1.Regional_Manager__c = user2.Id;
                    opportunity1.Customer_Care_Specialist__c = user3.Id;
                    opportunity1.Area_Specialist__c =  user3.Id;
                    opportunity1.Housing_Coordinator__c  = user2.Id;
                    opportunity1.Hotel_Customer_Care_Specialist__c = user2.Id;
               update opportunity1;
          }   
    
}