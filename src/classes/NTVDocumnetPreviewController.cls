Public class NTVDocumnetPreviewController{
    
    public string toAddress {get;set;}
    public string subject {get;set;}
    public string emailBody{get;set;}
    Public string faxNumber {get;set;}
    Public String ccEmailString {get;set;}
    
    Public boolean isSendNTVEmail {get;set;}
    Public boolean isSendNTVFax {get;set;}
      
    Public String servReqId {get;set;}
    String taskId;  
    String contactId;  
    String oppRecId;
    
    
    Public Task taskRecod {get;set;}
    
    Public NTVDocumnetPreviewController(){
        
        isSendNTVEmail = false;
        isSendNTVFax = false;
        taskRecod = new Task();
        String claimID = '';
                
        servReqId = ApexPages.currentPage().getParameters().get('reqId');
        taskId = ApexPages.currentPage().getParameters().get('taskId');
        
        taskRecod = [Select ID, Subject, Status, Type, Fax_Result_ID__c, Fax_Sent_User_ID__c, Description from Task where Id =: taskId];
        
        List<Placement__c> placementList = [Select Id, Selected_Search__r.NTV_Send_To__r.Name,
                                                       Selected_Search__r.NTV_Send_To__c,
                                                       Selected_Search__r.NTV_Send_To__r.Claims_Document_Email__c,
                                                       Selected_Search__r.NTV_Send_To__r.Email,
                                                       Selected_Search__r.NTV_Send_To__r.Claims_Document_Fax__c,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingStreet,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingCity,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingState,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingCountry,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode,
                                                       Selected_Search__r.NTV_Send_To__r.Account.NTV_CC_Emails__c,
                                                       ServiceRequest__r.Opportunity__r.Name,
                                                       ServiceRequest__r.Opportunity__c,
                                                       ServiceRequest__r.Opportunity__r.Policyholder__r.LastName
                                                        from Placement__c where ServiceRequest__c =: servReqId limit 1];
        
        String billingAddress = '';
        String policyholderName = '';
                
        
        if(!placementList.isEmpty()){
        
            policyholderName = placementList[0].ServiceRequest__r.Opportunity__r.Policyholder__r.LastName;
            claimID = placementList[0].ServiceRequest__r.Opportunity__r.Name;
        
            faxNumber = placementList[0].Selected_Search__r.NTV_Send_To__r.Claims_Document_Fax__c;  
            toAddress = placementList[0].Selected_Search__r.NTV_Send_To__r.Email;
            contactId = placementList[0].Selected_Search__r.NTV_Send_To__c;
            oppRecId =  placementList[0].ServiceRequest__r.Opportunity__c;
            
            if(placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingStreet != null && placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingStreet != ''){
                billingAddress = placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingStreet;
            }
            if(placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCity != null && placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCity != ''){
                billingAddress = billingAddress + ', ' + placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCity; 
            }
            if(placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingState != null && placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingState != ''){
                billingAddress = billingAddress + ', ' + placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingState;
            }
            if(placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode != null && placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode != ''){
                billingAddress = billingAddress + ' ' + placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode;
            } 
            if(placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCountry != null && placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCountry != ''){
                billingAddress = billingAddress + ', ' + placementList[0].Selected_Search__r.NTV_Send_To__r.Account.BillingCountry;
            }
            
            ccEmailString =  placementList[0].Selected_Search__r.NTV_Send_To__r.Account.NTV_CC_Emails__c;
            
        } 
        
        if(ccEmailString == null)
            ccEmailString = '';
            
        subject = 'Notice to Vacate: '+ billingAddress + ' - ' + policyholderName + ' ' + claimID;           
    } 
    
    // To send email
    public pageReference sendEmail()
    { 
          try{      
                list<EmailServicesAddress>  EmailToSalesforceRecords = [Select LocalPart, EmailDomainName,RunAsUserId From EmailServicesAddress where RunAsUserId  =: UserInfo.getUserId()];
                system.debug(EmailToSalesforceRecords+'@@@@@');
                pageReference pr = page.NTVDocumentPage;            
                pr.getParameters().put('reqId',servReqId);                      
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
                efa.setFileName('Notice to Vacate.pdf');
                efa.setBody(b);
                
                string[] toaddresslist = New String[]{ toAddress}; 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                email.setUseSignature(true);
                email.setToAddresses(toaddresslist);
                
                if(!EmailToSalesforceRecords.isEmpty())    
                    email.setBccAddresses(New String[]{'emailtosalesforce@'+EmailToSalesforceRecords[0].EmailDomainName});
                            
                if(ccEmailString != '' && ccEmailString != null){                
                    String[] ccEmailArr = ccEmailString.split(',');
                    email.setCcAddresses(ccEmailArr);
                }
                
                
                email.setSubject(subject);
                //email.setPlaintextbody(emailBody);
                String emailBodyString  = '<html><body>'+ emailBody + '  <br/>  \n <font color="white" size="1">ref: '+servReqId+' </font> </body></html>';
                email.setHtmlBody(emailBodyString);
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                           
                Messaging.sendEmail(New Messaging.SingleEmailMessage[] {email});            
               
                // To update "Send NTV via Email" task Status
                taskRecod.Status = 'Completed'; 
                if(emailBody != null && emailBody != ''){
                    taskRecod.Description = emailBody.replaceAll('<[^>]+>',' ');
                    taskRecod.Description = taskRecod.Description.replaceAll('&nbsp;',' ');
                    taskRecod.Description = taskRecod.Description.replaceAll('&#39;','\'');
                    taskRecod.Description = taskRecod.Description.replaceAll('&quot;','"'); 
                }     
                Database.update(taskRecod, false); 
                
                PageReference pg = new PageReference('/'+servReqId);
                pg.setRedirect(true);
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Mail sent Successfully.Thank you!'));
                return pg;
           }
           catch(Exception e){
               
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));               
               return null;
           }     
    }
    
    // To send Fax
    Public PageReference sendFax(){
            
            pageReference pr = page.NTVDocumentPage;            
            pr.getParameters().put('reqId',servReqId);                      
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
            attRec.Name = 'NTV Document';
            attRec.Body = b; 
            attRec.contentType = 'application/pdf'; 
            
            String recepientFax = faxNumber.replaceAll('[^0-9]', '');          
            
            // To call Intefax API call to send Fax
            String sendFaxResultID = FaxApiCall.sendFax(attRec, recepientFax, subject);
            
            if(sendFaxResultID != null && sendFaxResultID != ''){
                
                // To complete "Send Adjuster Confirmation" task on service request                
                taskRecod.Status = 'Completed';
                taskRecod.Fax_Result_ID__c = sendFaxResultID;
                taskRecod.Fax_Sent_User_ID__c = Userinfo.getUserId();                            
                update taskRecod;
                
                 
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
                    
                    FaxStatusValidateScheduler sNTVpre = new FaxStatusValidateScheduler(taskRecod.Id);                    
                    System.schedule('Fax Status Validator - '+taskRecod.Id+''+ randomNumb, nextFireTime, sNTVpre);
                    
                    //*********************************************************************************************  
               
                
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