/************************************************************************************************
Created By: Chiru
Purpose: To upload Signed THA document to Mulligan database. This class calling from "AgreementTriggerHelper" when THA document signed
************************************************************************************************/
global class UploadingSignedTHAControllerBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    global String agreementRecId;
    
    global UploadingSignedTHAControllerBatch(String agrId){
        agreementRecId = agrId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('Select Id, echosign_dev1__SignedPDF__c, echosign_dev1__Document__c, Claim__c from echosign_dev1__SIGN_Agreement__c where Id =: agreementRecId limit 1');
    }
    
    global void execute(Database.BatchableContext BC, List<echosign_dev1__SIGN_Agreement__c> agreementRecList){
        
        echosign_dev1__SIGN_Agreement__c  agrementRec = agreementRecList[0];
        
        if(agrementRec.Claim__c != null){            
                                      
                    Http hRef = new Http();
                    HttpRequest reqRef = new HttpRequest();
                    string firstImageURL = agrementRec.echosign_dev1__SignedPDF__c; 
                    firstImageURL = firstImageURL.replace(' ', '%20');
                    reqRef.setEndpoint(firstImageURL);
                    reqRef.setMethod('GET');                      
                    reqRef.setHeader('Content-Type', 'image/jpeg'); 
                    reqRef.setCompressed(true);
                    reqRef.setTimeout(60000); 
                    HttpResponse resRef = new HttpResponse(); 
                    
                    if(!Test.isRunningTest())     
                        resRef = hRef.send(reqRef); 
                    
                    string responseValue = ''; 
                    responseValue = resRef.getBody(); 
                    system.debug('Response Body for File: ' + responseValue);                    
                    blob image = resRef.getBodyAsBlob();
                                                        
                    Http http = new Http();
                    HttpRequest req = new HttpRequest();
                    HTTPResponse res = new HTTPResponse();
                    string instanceName = util.getInstanceName();
                    String userId = UserInfo.getUserId();
                    String queryStr = Util.getHash();   
                    req.setEndpoint('https://www.placetrakforce.com/mulligan/'+instanceName+'/Documents/UploadTHADocument?userId='+userId +'&claimRecordId='+agrementRec.Claim__c);   
                    req.setHeader('Content-Type', 'application/pdf');
                    req.setMethod('POST');
                    req.setTimeout(40000);
                   
                    if(!Test.isRunningTest()){    
                        req.setBodyAsBlob(image);
                        res = http.send(req);                        
                    }     
                    String resBody = res.getBody();
                    System.debug(res.getStatusCode()+' Reponse is :: '+resBody);                 
          } 
    }
    
    global void finish(Database.BatchableContext BC){ } 
    
}