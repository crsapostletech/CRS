@isTest
private class AdjusterFollowupTaskBatchScheduleTest{

    static testMethod void testAdjusterFollowupTask(){
    
         List<Contact> contList = new List<Contact>();
         
         
         contList .add(new Contact (
                        RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                        FirstName = 'Adj1',
                        LastName = 'Contact1',
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
                        Called_In_By_Last_Deal__c = Date.toDay() - 29,
                        Assigned_To_Last_Deal__c = Date.toDay() - 29
                        )
                      );  
                      
          contList .add(new Contact (
                        RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                        FirstName = 'Adj2',
                        LastName = 'Contact2',
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
                        Called_In_By_Last_Deal__c = Date.toDay() - 59,
                        Assigned_To_Last_Deal__c = Date.toDay() - 59
                        )
                      );                
        
            
          contList .add(new Contact (
                        RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                        FirstName = 'Adj3',
                        LastName = 'Contact3',
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
                        Called_In_By_Last_Deal__c = Date.toDay() - 89,
                        Assigned_To_Last_Deal__c = Date.toDay() - 89
                        )
                      ); 
          
          contList .add(new Contact (
                        RecordTypeId = RecordTypeHelper.adjusterContactRT(),
                        FirstName = 'Adj3',
                        LastName = 'Contact3',
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
                        Called_In_By_Last_Deal__c = Date.toDay() - 181,
                        Assigned_To_Last_Deal__c = Date.toDay() - 181
                        )
                      ); 
                      
          insert  contList;
          
          AdjusterFollowupTaskBatchSchedule sh1 = new AdjusterFollowupTaskBatchSchedule();
          String sch = '0 0 23 * * ?'; system.schedule('Test adjuster tasks', sch, sh1); 
          
          Database.executeBatch(new AdjusterFollowupTaskBatch());
                  
    } 
    
}