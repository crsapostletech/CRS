@isTest
private class CCAuthFormPreviewPageControllerTest{
    static testMethod void myUnitTest() 
    {        
         
         Account hotelAccount = new Account(
             recordTypeId = RecordTypeHelper.hotelAccountRT(),
             Name = 'Test Account'
         );
         insert hotelAccount;
         
         Contact hotelContact = new Contact(
             recordTypeId = RecordTypeHelper.hotelContactRT(),
             accountId = hotelAccount.Id,
             LastName = 'Test',
             FirstName = 'Test',
             Email = 'test@org.com'
         );
         insert hotelContact;
         
         Contact contact1 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.hotelContactRT(),
                    LastName='Front Desk',
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
        Opportunity opportunity1 = new Opportunity
                (
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = contact1.Id,
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
        insert opportunity1;
        
        // Insert DWO Hotel Service Request 
        RecordType hotelServiceRequest = [
                    Select Id, Name from 
                    RecordType where sobjecttype='ServiceRequest__c' 
                    and Name = 'Hotel'];       
        
        // Insert Hotel Service Request 
        ServiceRequest__c serviceReq = new ServiceRequest__c(
                    RecordTypeId = hotelServiceRequest.id,
                    opportunity__c= opportunity1.id,
                    Status__c = 'Searching',
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceReq;
        
        //Placement__c placement1 = [select id from placement__c where placement__c.ServiceRequest__c =: serviceReq.Id];
        
        Searches__c housingSearch = new Searches__c
          (
            RecordTypeId = RecordTypeHelper.housingSearchRT(),
            //Placement__c = placement1.Id,
            Service_Request__c = serviceReq.Id,
            Hotel__c = hotelAccount.Id,
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
        
        Task newTask = new Task(subject='Send Credit Card Authorization (CCA)',whatId = serviceReq.Id);
        insert newTask;
        
        ApexPages.currentPage().getParameters().put('reqId',serviceReq.id);
        ApexPages.currentPage().getParameters().put('taskId',newTask.id);
        CCAuthFormPreviewPageController clsRef = new CCAuthFormPreviewPageController();
        
        clsRef.placementId = 'a0Le0000003f0xUEAQ';
        clsRef.toAddress  = 'krishna@apostletech.com';
        clsRef.subject  = 'Hello';
        clsRef.emailBody = 'Test Email Body';
        clsRef.faxNumber = '00063725178';
        clsRef.displayIATA = 'true';
        clsRef.sendEmail();
        clsRef.sendFax();
        clsRef.changeCommissionType();
        clsRef.cancel();
    }
}