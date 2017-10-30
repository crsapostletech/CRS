/*************************************************************************************************************
Created by: Apostletech team
Purpose: To preview CC Auth Form in pdf format(Data comes from external app) and option to send email or fax.
Class calling from a link on "Send Credit Card Authorization (CCA)" Task record
VF Page: CCAuthFormPreviewPage
*************************************************************************************************************/
public class CCAuthFormPreviewPageController
{
      public string toAddress {get;set;}
      public string subject {get;set;}
      public string emailBody{get;set;}
      public string displayIATA {get;set;}
      public string placementId {get;set;}
      Public string faxNumber {get;set;}
      
      String lastName;
      String servReqId;
      String taskId;
      Public String OwnerId; 
      
      Public CCAuthFormPreviewPageController(){
          
          lastName = '';
          servReqId = ApexPages.currentPage().getParameters().get('reqId');
          taskId = ApexPages.currentPage().getParameters().get('taskId');
          
          ServiceRequest__c serviceRequestRec = [Select Id, Opportunity__r.Policyholder__r.LastName, Claims_Document_Email__c, Hotel_Account__c from ServiceRequest__c where Id =: servReqId];
          system.debug('****************'+serviceRequestRec.id);          
          
          Set<Id> hotelAcctIds = new Set<Id>();
          for(Searches__c S : [Select Id, Hotel__c,Selected__c from Searches__c where Service_Request__c =: serviceRequestRec.id AND Hotel__c != null and Selected__c = true]){
              hotelAcctIds.add(S.Hotel__c);
          }
          
          if(!hotelAcctIds.isEmpty()){    
              List<Contact> contList = [Select Id, Claims_Document_Email__c, Claims_Document_Fax__c, LastName from Contact where accountId in: hotelAcctIds AND RecordType.Name = 'Hotel Contact' AND Name = 'Front Desk'];
              if(!contList.isEmpty()){
                  toAddress = contList[0].Claims_Document_Email__c;                  
                  faxNumber = contList[0].Claims_Document_Fax__c;
              }    
          }
          
          if(serviceRequestRec.Opportunity__r.Policyholder__r.LastName != null)    
              lastName = serviceRequestRec.Opportunity__r.Policyholder__r.LastName;
                       
          subject = 'CRS Credit Card Authorization - '+lastName;
          displayIATA = 'true';
          
          //placementId = 'a0Le0000003f0xUEAQ'; // Dummy id for testing
          
          List<Placement__c> placementList = [Select Id from Placement__c where ServiceRequest__c =: servReqId AND RecordType.Name = 'Hotel Placement' limit 1];
          if(!placementList.isEmpty()){
              placementId = placementList[0].Id;
          }
          
      }
      
      public pageReference sendEmail()
      { 
            
            pageReference pr = page.CCAuthForm;
            pr.getParameters().put('placementId',placementId);
            pr.getParameters().put('IATAFlag', displayIATA);
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
            efa.setFileName('CCA Auth Form.pdf');
            efa.setBody(b);
            
            string[] toaddresslist = New String[]{ toAddress}; 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toaddresslist);
            email.setSubject(subject);
            //email.setPlaintextbody(emailBody);
            String emailBodyString  = '<html><body>'+ emailBody + '</body></html>';
            email.setHtmlBody(emailBodyString);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            Messaging.sendEmail(New Messaging.SingleEmailMessage[] {email});
            
            
            // To complete "Send Credit Card Authorization (CCA)" task on service request
            List<Task> taskList = [Select Id, Status, ownerid, Description, Sent_File_Link_URL__c from Task where Id =: taskId AND whatId =: servReqId AND Subject = 'Send Credit Card Authorization (CCA)'];
            for(Task t : taskList){
                t.Status = 'Completed';
                OwnerId = taskList[0].ownerid;       
               }
            /* Adding attachement and updating the document link for task */
            String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            list<Attachment> DelAttachmentlist = [select id,name,ParentId from Attachment where ParentId=:taskId AND name = 'Credit Card Authorization (CCA)'];
            delete DelAttachmentlist;
            
            Attachment attRec = new Attachment();
            attRec.parentid = taskId;
            attRec.Name = 'Credit Card Authorization (CCA)';
            attRec.Body = b;
            attRec.OwnerId = OwnerId;
            attRec.contentType = 'application/pdf'; 
            insert attRec;
            
            system.debug(OwnerId+'&&&&&&&&&');
            if(!taskList.isEmpty()){
                taskList[0].Sent_File_Link_URL__c = baseUrl +'/servlet/servlet.FileDownload?file='+ attRec.Id;
                update taskList;
                 
            }
            
            
            PageReference pg = new PageReference('/'+servReqId);
            pg.setRedirect(true);            
            return pg;
      }
      
      Public PageReference sendFax(){
            
            pageReference pr = page.CCAuthForm;
            pr.getParameters().put('placementId',placementId);
            pr.getParameters().put('IATAFlag', displayIATA);
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
            attRec.Name = 'Credit Card Authorization (CCA)';
            attRec.Body = b; 
            attRec.contentType = 'application/pdf'; 
            
            String recepientFax = faxNumber.replaceAll('[^0-9]', '');          
            
            String sendFaxResultID = FaxApiCall.sendFax(attRec, recepientFax, subject);
            
            if(sendFaxResultID != null && sendFaxResultID != ''){
                
                // To complete "Send Credit Card Authorization (CCA)" task on service request
                List<Task> taskList = [Select Id, Status, ownerid, Description, Sent_File_Link_URL__c, Fax_Result_ID__c, Fax_Sent_User_ID__c from Task where Id =: taskId AND whatId =: servReqId AND Subject = 'Send Credit Card Authorization (CCA)'];
                for(Task t : taskList){
                    t.Status = 'Completed';
                    t.Fax_Result_ID__c = sendFaxResultID;
                    t.Fax_Sent_User_ID__c = Userinfo.getUserId();
                    OwnerId = taskList[0].ownerid;
                }
                /* Adding attachement and updating the document link for task */
                String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
                list<Attachment> DelAttachmentlist = [select id,name,ParentId from Attachment where ParentId=:taskId AND name = 'Credit Card Authorization (CCA)'];
                delete DelAttachmentlist;
                Attachment attRec1 = new Attachment();
                attRec1.parentid = taskId;
                attRec1.Name = 'Credit Card Authorization (CCA)';
                attRec1.Body = b;
                attRec1.OwnerId = OwnerId;
                attRec1.contentType = 'application/pdf'; 
                insert attRec1;
                if(!taskList.isEmpty()){
                    taskList[0].Sent_File_Link_URL__c = baseUrl +'/servlet/servlet.FileDownload?file='+ attRec1.Id;
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
                        
                PageReference pg = new PageReference('/'+servReqId);
                pg.setRedirect(true);            
                return pg;
            }
            else{                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to send fax'));
                return null;
            }            
      }
      
      Public PageReference changeCommissionType(){
      
          return null;
      }
      
      public pagereference cancel()
      {
          return new PageReference('/'+servReqId);    
      }
    
}