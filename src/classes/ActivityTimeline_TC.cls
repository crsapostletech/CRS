@isTest
public class ActivityTimeline_TC {
    public static testMethod void InsertRecords(){
         RecordType rt2 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Contact' AND Name='Policyholder'];
        Contact contact1 = new Contact
                (
                    RecordTypeId = rt2.id,
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
                    Policyholder__c = contact1.id,
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Area_Specialist__c = user1.Id,
                    Housing_Coordinator__c  = user1.Id,
                    Initial_Service_Request__c = 'Housing',
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert opportunity2;
          Task t = new Task();
         t.type = 'Feedback';
         t.subject = 'call';
         t.whatId = opportunity2.id;
         t.OwnerId = userInfo.getUserId();
         t.status = 'Not Started';
         t.priority = 'Normal';
         t.ActivityDate = system.today();
         insert t;
         
         t.status = 'Completed';
         Task t1 = new Task();
         t1.type = 'Feedback';
         t1.subject = 'call';
         t1.whatId = opportunity2.id;
         t1.OwnerId = userInfo.getUserId();
         t1.status = 'Not Started';
         t1.priority = 'Normal';
         t1.ActivityDate = system.today();
         insert t1;
         update t;
         Event e = new Event();
         e.type = 'Feedback';
         e.subject = 'call';
         e.whatId = opportunity2.id;
         e.OwnerId = userInfo.getUserId();
         e.StartDateTime = system.now();
         e.EndDateTime = system.now();
         insert e;
         Note n = new Note();
         n.title = 'test';
         n.ParentId = opportunity2.Id;
         insert n;
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
                smagicinteract__smsMagic__c sm = new smagicinteract__smsMagic__c();
                sm.smagicinteract__Contact__c = contact1.Id;
                sm.smagicinteract__external_field__c = 'ABCD-123';
                insert sm;
            ApexPages.StandardController SC1 = new ApexPages.StandardController(opportunity2);
            ActivityTimeline Activities1 = New  ActivityTimeline(SC1);
           Activities1.historyTasks();
            
    }
}