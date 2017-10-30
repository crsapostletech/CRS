@isTest
private class FaxStatusApiCallTest 
{
    @isTest static void FaxStatusApiCallTestMethod(){
    
        Util.setAlreadyFired('Account');
        Util.setAlreadyFired('Contact');
        Util.setAlreadyFired('Claim'); 
        Util.setAlreadyFired('ServiceRequest__c');  
        Util.setAlreadyFired('Task');      
        
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
        
        Task newTask = new Task(subject='Send Adjuster Confirmation', whatId = serviceReq.Id, Fax_Result_ID__c = '123456', Fax_Sent_User_ID__c = Userinfo.getUserId());
        insert newTask;
        
        FaxStatusApiCall.faxStatusValidator(newTask.Id);
    }

}