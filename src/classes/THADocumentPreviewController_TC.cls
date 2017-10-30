@isTest
private class THADocumentPreviewController_TC{
    static testMethod void THADocumnetPreviewTest(){
        
               
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
            Damaged_Property_City__c = 'Phoenix',
            Damaged_Property_State__c = 'AZ',
            Damaged_Property_Zip__c = '85011',
            Damaged_Property_Country__c = 'USA',
            Regional_Manager__c = userinfo.getuserid(),
            Customer_Care_Specialist__c = userinfo.getuserid(),
            Hotel_Customer_Care_Specialist__c = userinfo.getuserid());  
        insert opp;
        
        ServiceRequest__c sr=new ServiceRequest__c( 
            Opportunity__c=opp.Id,            
            Status__c= 'Request',
            Hold__c=false,
            Initial_Contact_Date__c=System.Today(),
            Initial_SR_being_worked_by__c=userinfo.getuserid(),
            Task_Attempts__c='Attempt-2',                    
            HotelSearch_BookHotel__c=true,
            CreatedDate=System.Today(),
            RecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId());    
        insert sr;
          Task newTask = new Task(subject='Send Temporary Housing Agreement(THA)', whatId = opp.id);
        insert newTask;
             
        ApexPages.currentPage().getParameters().put('reqId',opp.id);
        //ApexPages.currentPage().getParameters().put('reqId', sr.id);
        ApexPages.currentPage().getParameters().put('taskId',newTask.id);
        ApexPages.currentPage().getParameters().put('lang', 'English');
        THADocumentPreviewController clsRef = new THADocumentPreviewController();
         clsRef.oppId = '0064D000003AVQ8';
         clsRef.faxNumber = '00063725178';
        ApexPages.currentPage().getParameters().put('claimId',opp.id);
        CRSAggrementFormController CQ = new CRSAggrementFormController();
        //CQ.oppId = '0064D000003AVQ8';
        clsRef.sendFax();
        clsRef.cancel();
    }
}