/************************************************************************************************
Created By: Chiru
Purpose: To upload Signed THA document to Mulligan database. This class calling from "AgreementTriggerHelper" when THA document signed
************************************************************************************************/
global class UploadingSignedTHAController{
    
    @future (callout=true)
    Public static void uploadSignedDocument(String agrRecId){
            
            echosign_dev1__SIGN_Agreement__c  agrementRec = [Select Id, echosign_dev1__SignedPDF__c, echosign_dev1__Document__c, Service_Request__c, Service_Request__r.Opportunity__c from echosign_dev1__SIGN_Agreement__c where Id =: agrRecId];
            
            if(agrementRec.Service_Request__c != null){
            
                // To get signed THA document
                Attachment attRec = [Select Id, Name, Body from Attachment where ParentId =: agrementRec.Id order by CreatedDate Desc limit 1];
                
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                HTTPResponse res = new HTTPResponse();
                string instanceName = util.getInstanceName();
                String userId = UserInfo.getUserId();
                String queryStr = Util.getHash();   
                req.setEndpoint('https://www.placetrakforce.com/mulligan/'+instanceName+'/Documents/UploadTHADocument?userId='+userId +'&claimRecordId='+agrementRec.Service_Request__r.Opportunity__c);   
                req.setHeader('Content-Type', 'application/pdf');
                req.setMethod('POST');
                req.setBodyAsBlob(attRec.Body);
                if(!Test.isRunningTest())    
                    res = http.send(req); 
                String resBody = res.getBody();
                
                System.debug(res.getStatusCode()+' Reponse is :: '+resBody);
            }  
    }
}