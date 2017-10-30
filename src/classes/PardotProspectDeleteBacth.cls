/*****************************************************************************************************
Created By: ApostleTech
Purpose: To schedule "PardotQueryProspectApi" to get Prospects from Pardot and to delete non adjusters
******************************************************************************************************/
global class PardotProspectDeleteBacth implements Database.batchable<String>, Database.AllowsCallouts{
    global List<String> prospectIdList;

    global  pardotProspectDeleteBacth(list<String>ProspectId){
              prospectIdList = ProspectId;
   }
   global Iterable<String> start(Database.batchableContext info){ 
       return new pardotProspectDleteiterable(prospectIdList); 
   } 
      
   global void execute(Database.batchableContext info, List<String> scope){ 
            
       String API_Key = PardotAPIAuthentication.PardotAPIAuthenticationCall();     
       
       for(String S : scope){     
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            String User_key = Label.Pardot_User_Key; 
            String url = 'https://pi.pardot.com/api/prospect/version/4/do/delete/id/'+S+'?'+'api_key='+API_Key +'&user_key='+User_key+'&id='+S;
            req.setEndpoint(url);
            HttpResponse response = http.send(req);
            System.debug(' Delete API Response :: '+response.getBody()); 
       }       
   
   }     
   global void finish(Database.batchableContext info){     
   } 
}