@isTest
private class HotelOnlyUpdaterTest {

    static testMethod void hotelOnlyUpdaterTest() 
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
       
        // Insert Account
        RecordType accountRT = [Select Id, Name from RecordType where sobjecttype='Account' and Name = 'Insurance Companies'];
        Account account = new Account
                (
                    OwnerId = user1.Id,
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
                    Fax = '6022345675');   
        insert account;

        // Insert Adjuster Contact
        RecordType contactRT = [Select Id, Name from RecordType where sobjecttype='Contact' and Name = 'Adjuster'];

        //Insert adjuster contact record 
        Contact adjusterContact = new Contact(
                    RecordTypeId = contactRT.Id,
                    FirstName='Test',
                    LastName = 'Adjuster',
                    AccountId = account.Id,
                    Status__c='Active',
                    MailingCountry ='USA',
                    MailingState = 'CT',
                    MailingStreet = '134 Laurel',
                    MailingCity = 'Mineola',
                    MailingPostalCode = '11501',
                    Last_Hotel_Only_Claim__c = null,
                    Last_Housing_Claim__c = null,
                    Total_Hotel_Claims__c = null,
                    Total_Housing_Claims__c = null);
        insert adjusterContact; 

        // Insert an Opportunity 
        Opportunity opportunity1 = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test11',
                    adjuster__c = adjusterContact.Id,
                    Initial_Service_Request__c='Hotel',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);        
        insert opportunity1;
        
         // Insert an Opportunity 
        Opportunity opportunity2 = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test12',
                    adjuster__c = adjusterContact.Id,
                    Initial_Service_Request__c='Housing',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id); 
        insert opportunity2;

        // Insert an Opportunity 
        Opportunity opportunity3 = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test13',
                    Hotel_Only__c = 'True',
                    adjuster__c = adjusterContact.Id,
                    Initial_Service_Request__c='Housing',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id); 
        insert opportunity3;
        
        // Insert DWO Hotel Service Request 
        RecordType hotelServiceRequest = [
                    Select Id, Name from 
                    RecordType where sobjecttype='ServiceRequest__c' 
                    and Name = 'Hotel'];       
        
        // Insert Hotel Service Request 
        ServiceRequest__c serviceRequest1 = new ServiceRequest__c(
                    RecordTypeId = hotelServiceRequest.id,
                    opportunity__c= opportunity1.id,
                    Status__c = 'Searching',
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest1;
        
        RecordType housingServiceRequest = [
                    Select Id, Name from 
                    RecordType where sobjecttype='ServiceRequest__c' 
                    and Name = 'Housing'];       
        
        ServiceRequest__c serviceRequest2 = new ServiceRequest__c(
                    RecordTypeId = housingServiceRequest.id,
                    opportunity__c= opportunity2.id,
                    Status__c = 'Searching',
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest2;

        ServiceRequest__c serviceRequest3 = new ServiceRequest__c(
                    RecordTypeId = housingServiceRequest.id,
                    opportunity__c= opportunity3.id,
                    Status__c = 'Lost Opportunity',
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest3;

        Test.StartTest();
        HotelOnlyUpdater hou = new HotelOnlyUpdater();
        hou.query = 'select RecordType.DeveloperName, Status__c, Opportunity__c from ServiceRequest__c where Opportunity__c <> null and LastModifiedDate = Today and RecordType.DeveloperName in (\'Housing\',\'Hotel\') order by Opportunity__c';
        ID batchprocessid = Database.executeBatch(hou);
        Test.StopTest();
       
        // Get inserted Opportunity 
        Opportunity insertedOpportunity1 = [SELECT Hotel_Only__c FROM Opportunity WHERE id =: opportunity1.Id];
        
        // Hotel Only should be True
        System.assertEquals('True', insertedOpportunity1.Hotel_Only__c); 
        
        // Get inserted Opportunity 
        Opportunity insertedOpportunity2 = [SELECT Hotel_Only__c FROM Opportunity WHERE id =: opportunity2.Id];
        
        // Hotel Only should be False
        System.assertEquals('False', insertedOpportunity2.Hotel_Only__c); 

         // Get inserted Opportunity 
        Opportunity insertedOpportunity3 = [SELECT Hotel_Only__c FROM Opportunity WHERE id =: opportunity3.Id];
        
        // Hotel Only should be null
        System.assertEquals(null, insertedOpportunity3.Hotel_Only__c); 
       
    }
}