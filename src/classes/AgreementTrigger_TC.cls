@isTest
private class AgreementTrigger_TC{
    static testMethod void agreementTriggerTest(){
        
        EntityFactory.createTriggerControlCustomSetting('AgreementTrigger');
        EntityFactory.createTriggerControlCustomSetting('ServiceRequestTrigger');
        
        Contact contact1 = new Contact
                (
                    RecordTypeId = RecordTypeHelper.policyholderContactRT(),
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
        
        
        
        
                Contact adjContact = new Contact(
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),                    
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
                    OtherPostalCode='85011',
                    Payment_Terms__c='20',
                    Billing_Communication_Preferences__c='Fax');   
                insert adjContact;   
        
                Opportunity claim = new Opportunity(
                    StageName = 'Submitted',
                    Name = 'TestClaim',
                    Adjuster__c = adjContact.Id,
                    Policyholder__c = contact1.Id,                    
                    Initial_Service_Request__c='Hotel',
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
                    ALE_Unbilled__c = null,
                    ALE_Spent__c = null,
                    ALE_Limit_Amount__c = null,
                    ALE_Spent_Outside_Of_CRS__c = null, 
                    Regional_Manager__c = userinfo.getuserid(),
                    Customer_Care_Specialist__c = userinfo.getuserid(),
                    Hotel_Customer_Care_Specialist__c = userinfo.getuserid());
                insert claim;
                
                ServiceRequest__c sr=new ServiceRequest__c( 
                    Opportunity__c=claim.Id,
                    Status__c= 'Request',
                    Hold__c=false,
                    Initial_Contact_Date__c=System.Today(),
                    Initial_SR_being_worked_by__c=userinfo.getuserid(),
                    Task_Attempts__c='Attempt-2',                    
                    HotelSearch_BookHotel__c=true,
                    CreatedDate=System.Today(),
                    RecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId());
               
                   
                insert sr;  
        
        echosign_dev1__SIGN_Agreement__c ag = new echosign_dev1__SIGN_Agreement__c();
        ag.claim__c = claim.Id;
        ag.Name = 'test';
        ag.echosign_dev1__Status__c = 'Draft';
        ag.echosign_dev1__SignedPDF__c = 'Http.salesforce.com';
        insert ag; 
                
        Task t = new Task();
        t.whatId = claim.Id;
        t.Subject = 'Send Temporary Housing Agreement(THA)';
        t.ownerId = Userinfo.getUserId();
        insert t;
        
        ag.echosign_dev1__Status__c = 'Out for Signature';
        update ag;
        
        Attachment attach = new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=ag.id;
        insert attach;
        
        ag.echosign_dev1__Status__c = 'Signed';
        update ag; 
        
        Database.executebatch(new UploadingSignedTHAControllerBatch(ag.Id));      
        
    }
}