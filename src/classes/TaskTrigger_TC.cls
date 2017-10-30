//Test class for "TaskTrigger" and "TaskTriggerHelper" apex class
@isTest
private class TaskTrigger_TC{

    @testSetup private static void setupTestData(){  
            
            EntityFactory.createTriggerControlCustomSetting('ServiceRequestTrigger');
            EntityFactory.createTriggerControlCustomSetting('TaskTrigger');
            

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

        Opportunity claim = new Opportunity(
            StageName = 'Submitted',
            Name = 'TestClaim',
            Adjuster__c = adjContact.Id,
            Policyholder__c = contact1.Id,            
            Initial_Service_Request__c='Hotel',
            Customer_Care_Specialist__c=userinfo.getuserid(),
            Hotel_Customer_Care_Specialist__c=userinfo.getuserid(),
            Regional_Manager__c =userinfo.getuserid(),
            Number_of_Adults__c = 2,
            Number_of_Children__c = 2,
            Number_of_Bedrooms__c = 3,
            Number_of_Bathrooms__c = 2,
            CloseDate = Date.newInstance(2015,10,28),
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

         ServiceRequest__c serviceRequest = new ServiceRequest__c
                (
                    RecordTypeId = recordTypeHelper.hotelServiceRequestRT(),
                    Opportunity__c = claim.Id,
                    Status__c = 'Searching',
                    THC_Signed__c = Date.newInstance(2009,10,09),
                    THA_Signed__c = Date.newInstance(2009,10,09));
        insert serviceRequest;

        Task ph72HrTask = new Task(
            RecordTypeId = RecordTypeHelper.x72HourPHContactTaskRT(),
            Type = '72 Hour Policyholder Follow Up',
            Subject = '72 Hour Policyholder Follow Up',
            Status = 'In Progress',
            WhoId = contact1.Id,
            WhatId = serviceRequest.Id,
            ActivityDate = Date.Today(),
            Due_Time__c = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 18, 0, 0),
            OwnerId = claim.Hotel_Customer_Care_Specialist__c,
            Service_Request__c = serviceRequest.Id);
        insert ph72HrTask;
    }
    
    @isTest static void taskRecordsTest(){
         
            Opportunity claim=[Select id,Name,Initial_Service_Request__c,Customer_Care_Specialist__c,Adjuster__c,Policyholder__c from Opportunity where Initial_Service_Request__c='Hotel' limit 1];     
                    
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
            
            Task taskRec = [Select Id, Status from Task where Subject LIKE '%Book Hote%' ];
            taskRec.Status = 'Completed';
            update taskRec;                
    }

    @isTest static void create72HourADJContactTaskTest()
    {
        Task ph72hourTask = [select Id from task where type = '72 Hour Policyholder Follow Up'];
        ph72hourTask.Status = 'Completed';

        update ph72hourTask;

        Task adj72hourTask = [select Id,WhoId from task where type = '72 Hour Adjuster Follow Up'];

        Contact ph = [select Id from contact where LastName = 'xxxxxx'];

        system.assertEquals(ph.Id,adj72hourTask.WhoId);
    }
}