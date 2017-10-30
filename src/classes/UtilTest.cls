@isTest
private class UtilTest {

    static testMethod void myUnitTest() {
       util.hasAlreadyFired('account');
       util.setAlreadyFired('account');
       util.unsetAlreadyFired('account');
       util.hasAlreadyFired('claim');
       util.setAlreadyFired('claim');
       util.unsetAlreadyFired('claim');
       util.hasAlreadyFired('contact');
       util.setAlreadyFired('contact');
       util.unsetAlreadyFired('contact');
       util.hasAlreadyFired('hotel_room__c');
       util.setAlreadyFired('hotel_room__c');
       util.unsetAlreadyFired('hotel_room__c');
       util.hasAlreadyFired('furniture_order__c');
       util.setAlreadyFired('furniture_order__c');
       util.unsetAlreadyFired('furniture_order__c');
       util.hasAlreadyFired('placement__c');
       util.setAlreadyFired('placement__c');
       util.unsetAlreadyFired('placement__c');
       util.hasAlreadyFired('note');
       util.setAlreadyFired('note');
       util.unsetAlreadyFired('note');
       util.hasAlreadyFired('searches__c');
       util.setAlreadyFired('searches__c');
       util.unsetAlreadyFired('searches__c');
       util.hasAlreadyFired('user');
       util.setAlreadyFired('user');
       util.unsetAlreadyFired('user');
       util.hasAlreadyFired('task');
       util.setAlreadyFired('task');
       util.unsetAlreadyFired('task');
       util.hasAlreadyFired('');
       util.sendErrorEmail('Test', 'This is a test email');
       
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
  
       // Insert an Opportunity 
       Opportunity opportunity1 = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test11',
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

       Opportunity[] opps = [select Id,Type_of_Loss__c from opportunity where Type_of_Loss__c = 'Mold'];

       util.getIDs(opps);
       util.getIDFields(opps,'Id');
       
       util.getInstanceName();
       util.getInstanceBaseURL();
       util.getUserProfileName();
       
    }
}