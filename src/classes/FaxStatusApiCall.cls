/**************************************************************************************************************************
Created By: Chiru
Purpose: API call to verify Fax status 
***************************************************************************************************************************/
Public class FaxStatusApiCall{
    
    @future(callout=true)
    Public static void faxStatusValidator(String taskId){
            
            Task taskRec = [Select Id, Fax_Result_ID__c, Fax_Status__c, Fax_Sent_User_ID__c, Fax_Completion_Time__c, Fax_Submit_Time__c from Task where Id =: taskId limit 1];
            
            if(taskRec.Fax_Result_ID__c != null && taskRec.Fax_Result_ID__c != ''){
            
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                HTTPResponse res = new HTTPResponse();        
                String authStr = Label.faxUsername+':'+Label.faxPassword;
                Blob authBlob = Blob.valueOf(authStr);
                
                String authorization = EncodingUtil.base64Encode(authBlob);
                req.setEndpoint('https://rest.interfax.net/outbound/faxes/'+taskRec.Fax_Result_ID__c);        
                req.setHeader('Content-Type', 'application/pdf');
                req.setHeader('Authorization','Basic '+authorization);
                req.setMethod('GET');    
                if(!Test.isRunningTest())    
                    res = http.send(req); 
                String resBody = res.getBody();
                
                if(Test.isRunningTest()){
                    resBody = '{"submitTime":"2012-06-20T06:08:18","destinationFax":"0081287282867","completionTime":"2012-06-20T06:09:08","status":"1"}';
                }
            
                System.debug(res.getStatusCode()+' Reponse is :: '+resBody);
                
                FaxStatusResponse faxResponse = (FaxStatusResponse)System.JSON.deserialize(resBody, FaxStatusResponse.class);
                 
                if(faxResponse.submitTime != null && faxResponse.submitTime != ''){
                    
                    String datePart = faxResponse.submitTime.subStringBefore('T');
                    String[] dtArr = datePart.split('-');
                    
                    String timePart = faxResponse.submitTime.subStringAfter('T');
                    String[] timeArr = timePart.split(':');
                    
                    if(dtArr.size() > 2 && timeArr.size() > 2){                        
                        taskRec.Fax_Submit_Time__c = DateTime.newInstance(Integer.valueOf(dtArr[0]), Integer.valueOf(dtArr[1]), Integer.valueOf(dtArr[2]), Integer.valueOf(timeArr[0]), Integer.valueOf(timeArr[1]), Integer.valueOf(timeArr[2]));
                    } 
                }    
                    
                if(faxResponse.completionTime != null && faxResponse.completionTime != ''){
                      
                    String datePart = faxResponse.completionTime.subStringBefore('T');
                    String[] dtArr = datePart.split('-');
                    
                    String timePart = faxResponse.completionTime.subStringAfter('T');
                    String[] timeArr = timePart.split(':');
                    
                    if(dtArr.size() > 2 && timeArr.size() > 2 && Integer.valueOf(dtArr[0]) >= 2017){                        
                        taskRec.Fax_Completion_Time__c = DateTime.newInstance(Integer.valueOf(dtArr[0]), Integer.valueOf(dtArr[1]), Integer.valueOf(dtArr[2]), Integer.valueOf(timeArr[0]), Integer.valueOf(timeArr[1]), Integer.valueOf(timeArr[2]));
                    } 
                }
                
                if(faxResponse.status < 0){
                    
                    if(taskRec.Fax_Status__c != 'In Process'){
                        taskRec.Fax_Status__c = 'In Process';
                        update taskRec;
                    }
                    /* Scheduling after 1 minute*/
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
                    if(!Test.isRunningTest()){
                        FaxStatusValidateScheduler sNTVpre = new FaxStatusValidateScheduler(taskRec.Id);                    
                        System.schedule('Fax Status Validator - '+taskRec.Id+''+ randomNumb, nextFireTime, sNTVpre);
                    }    
                    //********************************************************************************************* 
                    
                }
                if(faxResponse.status == 0){
                    taskRec.Fax_Status__c = 'Sent';
                    update taskRec;
                }
                if(faxResponse.status > 0){
                    taskRec.Fax_Status__c = 'Failed';
                    update taskRec;
                    
                    if(taskRec.Fax_Sent_User_ID__c != '' && taskRec.Fax_Sent_User_ID__c != null){
                    
                        List<User> userList = [Select Id, Name, Email from User where Id =: taskRec.Fax_Sent_User_ID__c limit 1];
                    
                        if(!userList.isEmpty()){
                            
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            email.setUseSignature(true);
                            string[] toaddresslist = New String[]{ userList[0].Email};
                            email.setToAddresses(toaddresslist);
                            email.setSubject('Fax sent to '+faxResponse.destinationFax+' failed');
                            String emailBodyString  = '<html><body>Hello '+userList[0].Name+', <br/><br/> Fax sent on below task failed. <br/>  '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskRec.Id+' </body></html>';
                            email.setHtmlBody(emailBodyString);
                                                               
                            Messaging.sendEmail(New Messaging.SingleEmailMessage[] {email});
                         }    
                    }    
                    
                }    
                
           } 
        
    }
        
    Public class FaxStatusResponse{
        
        public String submitTime;
        public Object contact;
        public String destinationFax;
        public String replyEmail;
        public String subject;
        public Integer pagesSubmitted;
        public String senderCSID;
        public Integer attemptsToPerform;
        public String pageSize;
        public String resolution;
        public String pageResolution;
        public String pageOrientation;
        public String rendering;
        public Object pageHeader;
        public String userId;
        public Integer pagesSent;
        public String completionTime;
        public String remoteCSID;
        public Integer duration;
        public Integer priority;
        public Double units;
        public Double costPerUnit;
        public Integer attemptsMade;
        public Integer id;
        public String uri;
        public Integer status;
    }
    
}