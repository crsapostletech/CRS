@isTest
private class AdjusterClaimsTest 
{
    
    static testMethod void testSchedulers() 
    {
       SchedulableContext sc;
       AdjusterClaimsScheduler acs =  new AdjusterClaimsScheduler();
       acs.execute(sc);
       AdjusterClaimsClearScheduler accs =  new AdjusterClaimsClearScheduler();
       accs.execute(sc);
    }


    static testMethod void testAdjusterClaimsBatch() 
    {
        Contact contact1 = new Contact(
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    FirstName='Test',
                    LastName = 'Adjuster',
                    Status__c='Active',
                    MailingCountry ='USA',
                    MailingState = 'CT',
                    MailingStreet = '134 Laurel',
                    MailingCity = 'Mineola',
                    MailingPostalCode = '11501');
        insert contact1; 

        Contact contact2 = new Contact(
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    FirstName='Test',
                    LastName = 'Adjuster',
                    Status__c='Active',
                    MailingCountry ='USA',
                    MailingState = 'CT',
                    MailingStreet = '134 Laurel',
                    MailingCity = 'Mineola',
                    MailingPostalCode = '11501');
        insert contact2; 

        Contact contact3 = new Contact(
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    FirstName='Test',
                    LastName = 'Adjuster',
                    Status__c='Active',
                    MailingCountry ='USA',
                    MailingState = 'CT',
                    MailingStreet = '134 Laurel',
                    MailingCity = 'Mineola',
                    MailingPostalCode = '11501');
        insert contact3; 
        
        Contact contact4 = new Contact(
                    RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                    FirstName='Test',
                    LastName = 'Adjuster',
                    Status__c='Active',
                    MailingCountry ='USA',
                    MailingState = 'CT',
                    MailingStreet = '134 Laurel',
                    MailingCity = 'Mineola',
                    MailingPostalCode = '11501');
        insert contact4; 

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
  
        List <Opportunity> opportunities = new List<Opportunity>(); 
        String isr = 'Hotel';
        Id contactId = contact1.Id;      
        
        for(integer i = 0; i<40; i++)
        {
            if(i==10)
            {
                isr = 'Housing';
                contactId = contact2.Id;
            }
            if(i==20)
            {
                isr = 'FRV';
                 contactId = contact3.Id;
            }
            if(i==30)
            {
                isr = 'Finders Fees';
                 contactId = contact4.Id;
            }
        
            Opportunity opportunity = new Opportunity(
                    Name='testAccount',
                    Adjuster__c = contactId,
                    Called_In_By__c = contactId,
                    Initial_Service_Request__c=isr,
                    StageName = 'Submitted',
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Policy_Type__c = 'Homeowner',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);
            opportunities.add(opportunity);
        }
        insert opportunities;

        Id oppId;

        for(integer i = 0; i<4; i++)
        { 

            if(i==0)
            {
                oppId = opportunities[0].Id;
                contactId = contact1.Id;
            }
            if(i==1)
            {
                oppId = opportunities[11].Id;
                contactId = contact2.Id;
            }
            if(i==2)
            {
                oppId = opportunities[21].Id;
                contactId = contact3.Id;
            }
            if(i==3)
            {
                oppId = opportunities[31].Id;
                contactId = contact4.Id;
            }

        }
              
        Test.StartTest();
        AdjusterClaims ac = new AdjusterClaims();
        ac.query = 'SELECT Id,Name,Initial_Service_Request__c,Adjuster__c,CreatedDate,Adjuster_Changed_Date__c,Called_In_By__c FROM Opportunity';
        ID batchprocessid = Database.executeBatch(ac);
        Test.StopTest();

        
        AdjusterClaimsClear acc = new AdjusterClaimsClear();
        acc.query = 'select Id from Contact where Total_Hotel_Claims__c <> null or Total_Housing_Claims__c <> null or Total_FRV_Claims__c <> null or Total_Finders_Fees_Claims__c <> null';
        batchprocessid = Database.executeBatch(acc);
        
  
    }
}