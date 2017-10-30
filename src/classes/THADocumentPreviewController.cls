/***************************************************************************************************
Created By: Chiru
Purpsoe: To send fax for THA agreement documnets. Class calling from "THADocumentLanguageController" apex class
VF Page: THADocumentPreviewPage
Test class: THADocumentPreviewController_TC
***************************************************************************************************/
Public class THADocumentPreviewController{
    
    Public string faxNumber {get;set;}
    public string subject {get;set;}
    public string language {get;set;}
    //String servReqId;
    String ClaimId;
    String taskId;
    Public string oppId {get;set;}
    
    Public THADocumentPreviewController(){
        ClaimId = ApexPages.currentPage().getParameters().get('reqId');
        taskId = ApexPages.currentPage().getParameters().get('taskId');
        language = ApexPages.currentPage().getParameters().get('lang');
        
        Opportunity ClaimRequestRec = [Select Id,Name, Policyholder__r.Claims_Document_Fax__c, Policyholder__r.LastName from opportunity where Id =: ClaimId];        
        faxNumber = ClaimRequestRec.Policyholder__r.Claims_Document_Fax__c; 
        Subject = 'Temporary Housing Agreement(THA) - '+ ClaimRequestRec.Policyholder__r.LastName;
        
        oppId = ClaimRequestRec.Id;
    }
    
    Public PageReference sendFax(){
            try{
            pageReference pr;
            if(language == 'English')
                pr = page.CRSAggrementFormEnglish;  
            else
                pr = page.CRSAggrementFormSpanish; 
            
            pr.getParameters().put('ClaimID',oppId);    
                    
            Blob b;
            if (Test.IsRunningTest())
            {
                b = Blob.valueOf('UNIT.TEST');
            }
            else
            {
                b = pr.getContent();
            }
            
            Attachment attRec = new Attachment();
            attRec.parentid = taskId;
            attRec.Name = 'Temporary Housing Agreement(THA)';
            attRec.Body = b; 
            attRec.contentType = 'application/pdf'; 
            
            String recepientFax = faxNumber.replaceAll('[^0-9]', '');          
            
            String sendFaxResultID = FaxApiCall.sendFax(attRec, recepientFax, subject);
                        
            if(sendFaxResultID != null && sendFaxResultID != ''){
                
                // To complete "Send Adjuster Confirmation" task on service request
                List<Task> taskList = [Select Id, Status, whatId, Service_Request__c, Fax_Result_ID__c, Fax_Sent_User_ID__c from Task where Id =: taskId AND whatId =: ClaimId AND Subject = 'Send Temporary Housing Agreement(THA)'];
                for(Task t : taskList){
                    t.Status = 'Completed'; 
                    t.Fax_Result_ID__c = sendFaxResultID;
                    t.Fax_Sent_User_ID__c = Userinfo.getUserId();
                    t.whatId = oppId;
                    //t.Service_Request__c = t.whatId;                   
                    //if(oppId != null && oppId != '')    
                        //t.whatId = oppId;
                }
                if(!taskList.isEmpty()){
                    update taskList;
                    
                    /* Scheduling after 1 minute */
                    //*********************************************************************************************     
                    
                   Datetime destTime = Datetime.now().addMinutes(1);
                               
                    String year =  String.valueOf(destTime.year());   
                    String month =  String.valueOf(destTime.month());
                    String day =  String.valueOf(destTime.day());        
                    String hour = String.valueOf(destTime.hour());
                    String min = String.valueOf(destTime.minute()); 
                    String ss = String.valueOf(destTime.second());
                    
                    String randomNumb = ''+ Math.random();
                    
                    //parse to cron expression
                    String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+ day + ' ' +month+ ' ? '+year;
                    
                    FaxStatusValidateScheduler sNTVpre = new FaxStatusValidateScheduler(taskList[0].Id);                    
                    System.schedule('Fax Status Validator - '+taskList[0].Id+''+ randomNumb, nextFireTime, sNTVpre);
                    //********************************************************************************************* 
                   
                }
                        
                PageReference pg = new PageReference('/'+ClaimId);
                pg.setRedirect(true);            
                return pg;
            }
            else{                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to send fax'));
                return null;
            }
           }
              
            catch(Exception e){
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));               
               return null;
               }         
      }
      
      
      public pagereference cancel()
      {
          return new PageReference('/'+ClaimId);    
      }
}