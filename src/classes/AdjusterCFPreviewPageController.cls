/*********************************************************************************************
Created By: Chiru
Purpose: Apex class to preview Adjuster Confirmation form and to send Email or Fax
VF Page: AdjusterConfFormPreviewPage
Test class: AdjusterCFPreviewPageControllerTest
*********************************************************************************************/
public class AdjusterCFPreviewPageController
{
      public string toAddress {get;set;}
      public string ccAddress {get;set;}
      public string subject {get;set;}
      public string emailBody{get;set;}
      public string placementId {get;set;}
      Public string faxNumber {get;set;}
      
      String lastName;
      String servReqId;
      String taskId;
      
      Public AdjusterCFPreviewPageController()
      {
          servReqId = ApexPages.currentPage().getParameters().get('reqId');
          taskId = ApexPages.currentPage().getParameters().get('taskId');
          ccAddress = '';
          
          ServiceRequest__c serviceRequestRec = [Select Id, Opportunity__r.Claim__c, Opportunity__r.Policyholder__r.LastName, Claims_Document_Email__c, Opportunity__r.Adjuster__r.LastName, Opportunity__r.Adjuster__r.Claims_Document_Email__c, Opportunity__r.Adjuster__r.Claims_Document_Fax__c from ServiceRequest__c where Id =: servReqId];
          system.debug('****************'+serviceRequestRec.id);
          
          toAddress = serviceRequestRec.Opportunity__r.Adjuster__r.Claims_Document_Email__c;          
          
          if(serviceRequestRec.Opportunity__r.Claim__c == null)
              serviceRequestRec.Opportunity__r.Claim__c = '';
              
          subject = serviceRequestRec.Opportunity__r.Claim__c + '; '+serviceRequestRec.Opportunity__r.Policyholder__r.LastName;
          faxNumber = serviceRequestRec.Opportunity__r.Adjuster__r.Claims_Document_Fax__c;
          
          //placementId = 'a0Le0000003f0xUEAQ'; // Dummy id for testing
          
          List<Placement__c> placementList = [Select Id from Placement__c where ServiceRequest__c =: servReqId AND RecordType.Name = 'Hotel Placement' limit 1];
          if(!placementList.isEmpty()){
              placementId = placementList[0].Id;
          }
      }
      
      // To send email
      public pageReference sendEmail()
      { 
            
            pageReference pr = page.AdjusterConfirmationForm;            
            pr.getParameters().put('placementId',placementId);                      
            Blob b;
            if (Test.IsRunningTest())
            {
                b = Blob.valueOf('UNIT.TEST');
            }
            else
            {
                b = pr.getContent();
            }
            
            //system.debug('*****attachment body*********'+pr.getContent());
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('application/pdf');
            efa.setFileName('attachment.pdf');
            efa.setBody(b);
            
            string[] toaddresslist = New String[]{ toAddress};             
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toaddresslist);            
            if(ccAddress != '' && ccAddress != null){
                String[] ccaddresslist =  ccAddress.split(',');
                email.setCcAddresses(ccaddresslist);
            }     
            email.setSubject(subject);            
            //email.setPlaintextbody(emailBody);
            String emailBodyString  = '<html><body>'+ emailBody +'</body></html>';
            email.setHtmlBody(emailBodyString);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                        
            Messaging.sendEmail(New Messaging.SingleEmailMessage[] {email});
            
            // To complete "Send Adjuster Confirmation" task on service request
            List<Task> taskList = [Select Id, Status, Description from Task where whatId =: servReqId AND Subject = 'Send Adjuster Confirmation'];
            for(Task t : taskList){
                t.Status = 'Completed';
                if(emailBody != null && emailBody != ''){    
                    t.Description = emailBody.replaceAll('<[^>]+>',' ');
                    t.Description = t.Description.replaceAll('&nbsp;',' ');
                    t.Description = t.Description.replaceAll('&#39;','\'');
                    t.Description = t.Description.replaceAll('&quot;','"');   
                }    
            }
            if(!taskList.isEmpty()){
                update taskList;
            }
            
            PageReference pg = new PageReference('/'+servReqId);
            pg.setRedirect(true);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Mail sent Successfully.Thank you!'));
            return pg;
      }
      
      // To send Fax
      Public PageReference sendFax(){
            
            pageReference pr = page.AdjusterConfirmationForm;            
            pr.getParameters().put('placementId',placementId);                      
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
            attRec.Name = 'Adjuster Confirmation';
            attRec.Body = b; 
            attRec.contentType = 'application/pdf'; 
            
            String recepientFax = faxNumber.replaceAll('[^0-9]', '');          
            
            // To call Intefax API call to send Fax
            String sendFaxResultID = FaxApiCall.sendFax(attRec, recepientFax, subject);
            
            if(sendFaxResultID != null && sendFaxResultID != ''){
                
                // To complete "Send Adjuster Confirmation" task on service request
                List<Task> taskList = [Select Id, Status, Fax_Result_ID__c, Fax_Sent_User_ID__c from Task where Id =: taskId];
                for(Task t : taskList){
                    t.Status = 'Completed';
                    t.Fax_Result_ID__c = sendFaxResultID;
                    t.Fax_Sent_User_ID__c = Userinfo.getUserId();
                }
                if(!taskList.isEmpty()){
                    update taskList;
                    
                        
                        // Scheduling after 1 minute 
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
                        
                PageReference pg = new PageReference('/'+servReqId);
                pg.setRedirect(true);            
                return pg;
            }
            else{                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to send fax'));
                return null;
            }            
      }
      
      public pagereference cancel()
      {
          return new PageReference('/'+servReqId);    
      }
    
}