@isTest
private class THADocumentLanguageController_TC{
    static testMethod void THALanguageSelectTest(){
    
         Contact c = new Contact
        (
            RecordTypeId = RecordTypeHelper.policyholderContactRT(),
            FirstName = 'PolicyHolder',
            LastName = 'Contact',
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
            Fax = '12121212',
            Claims_Document_Fax__c = '123456789');   
    
        insert c;
        
        
        Contact adj = new Contact 
        (
            RecordTypeId = RecordTypeHelper.adjusterContactRT(),
            FirstName = 'Adj',
            LastName = 'Contact',
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
            OtherPostalCode='85011');    
    
        insert adj;
        
        Opportunity opp = new Opportunity
        (            
            Policyholder__c = c.Id,
            Adjuster__c = adj.Id,
            Name = 'abc123',
            Initial_Service_Request__c='Hotel',
            CloseDate = Date.today(),   
            StageName = 'Submitted',
            Type_of_Loss__c = 'Mold',
            Damaged_Property_Type__c = 'Apartment',
            Damaged_Property_Address__c = '123 Big Test Lane',
            Damaged_Property_City__c = 'Ottawa',
            Damaged_Property_State__c = 'QC',
            Damaged_Property_Zip__c = 'J0E 1B0',
            Damaged_Property_Country__c = 'Canada',
            Regional_Manager__c = userinfo.getuserid(),
            Customer_Care_Specialist__c = userinfo.getuserid(),
            Hotel_Customer_Care_Specialist__c = userinfo.getuserid());  
        insert opp;
        
       
          Task newTask = new Task(subject='Send Temporary Housing Agreement(THA)', whatId = opp.id);
        insert newTask;
        
        ApexPages.currentPage().getParameters().put('taskId',newTask.id);
        ApexPages.currentPage().getParameters().put('whatId',opp.id);
        THADocumentLanguageController clsRef = new THADocumentLanguageController();
        
        clsRef.redirectToEchosignPage();
        clsRef.cancel();
        clsRef.selectedMethod = 'Fax';
        clsRef.redirectToEchosignPage();
    }
}