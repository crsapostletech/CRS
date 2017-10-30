/*********************************************************************************************
Created By: Chiru
Purpose: API call to send fax using Interfax. Class calling from "AdjusterCFPreviewPageController", "CCAuthFormPreviewPageController", 
"THADocumentPreviewController" apex classes
Test class:  AdjusterCFPreviewPageControllerTest
*********************************************************************************************/
Public class FaxApiCall{
    
    Public static String sendFax(Attachment attach, String faxNumber, String subject){
                        
        subject = EncodingUtil.urlEncode(subject, 'UTF-8');
        
        System.debug(faxNumber+' ************* '+subject);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();        
        String authStr = Label.faxUsername+':'+Label.faxPassword;
        Blob authBlob = Blob.valueOf(authStr);
        
        String authorization = EncodingUtil.base64Encode(authBlob);
        req.setEndpoint('https://rest.interfax.net/outbound/faxes?faxNumber='+faxNumber+'&reference='+subject);        
        req.setHeader('Content-Type', 'application/pdf');
        req.setHeader('Authorization','Basic '+authorization);
        req.setMethod('POST');
        
        String attachmentBody = EncodingUtil.base64Encode(attach.Body);
        Blob blobBody = EncodingUtil.base64Decode(attachmentBody);
        req.setBodyAsBlob(blobBody);
        if(!Test.isRunningTest())    
            res = http.send(req); 
        String resBody = res.getBody();
        
        System.debug(res.getStatusCode()+' Reponse is :: '+resBody);
        
        if(res.getStatusCode() == 201){
            String locationURL = res.getHeader('Location');             
            Database.insert(attach, false);
            
            return locationURL.subStringAfterLast('/');
        }     
        else{            
            return '';    
        } 
        
    }
}