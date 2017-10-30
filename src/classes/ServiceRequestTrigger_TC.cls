//Test class for "ServiceRequestTrigger"
@isTest
private class ServiceRequestTrigger_TC{

    @testSetup private static void setupTestData(){    
                
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
                    Regional_Manager__c=userinfo.getuserid(), 
                    Customer_Care_Specialist__c=userinfo.getuserid(),
                    Hotel_Customer_Care_Specialist__c = userinfo.getuserid(),
                    Area_Specialist__c =  userinfo.getuserid(),
                    Housing_Coordinator__c  = userinfo.getuserid(),
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
                    ALE_Spent_Outside_Of_CRS__c = null);
                insert claim;
                   
        }

        @isTest static void serviceRequestInsert(){
                
                                
                Opportunity claim=[Select id,Name,Housing_Coordinator__c,Initial_Service_Request__c,Area_Specialist__c,Hotel_Customer_Care_Specialist__c,Customer_Care_Specialist__c,Adjuster__c,Policyholder__c from Opportunity where Initial_Service_Request__c='Hotel' limit 1];     
                    
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
                               
                sr.Hold__c=true;
                sr.Hold_Follow_Up_Date__c=System.today();
                update sr;
                
                sr.Hold_Follow_Up_Date__c = System.today().addDays(1);
                sr.Initial_SR_being_worked_by__c= null;
                update sr;
                
                sr.Initial_SR_being_worked_by__c=userinfo.getuserid();               
                sr.Hold__c=false; 
                update sr; 
                
            }
            
            @isTest static void serviceRequestDelete(){
            
                Opportunity claim=[Select id,Name,Initial_Service_Request__c,Customer_Care_Specialist__c,Adjuster__c,Policyholder__c from Opportunity where Initial_Service_Request__c='Hotel' limit 1];     
                    
                ServiceRequest__c sr=new ServiceRequest__c( 
                    Opportunity__c=claim.Id,
                    Status__c= 'Request',
                    Hold__c=false,
                    Initial_Contact_Date__c=System.Today(),
                    Initial_SR_being_worked_by__c=userinfo.getuserid(),
                    Task_Attempts__c='Attempt-2',                    
                    HotelSearch_BookHotel__c=true,
                    CreatedDate=System.Today());
                    sr.RecordTypeId=[Select Id from RecordType where SObjectType='ServiceRequest__c' and Name='Hotel' limit 1].Id;
                insert sr; 
                
                sr.Status__c = 'Lost Opportunity';
                update sr;
                
                delete sr;    
            }
        
}