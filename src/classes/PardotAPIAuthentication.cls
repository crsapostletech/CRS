/**********************************************************************************************************
Created By: Apostletech
Purpose: To call pardot API Key Generation. 
Test class: PardotMockHttpResponseGeneratorTC 
***********************************************************************************************************/

Public Class PardotAPIAuthentication{

    public static String PardotAPIAuthenticationCall()
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        String userEmail = Label.Pardot_Email;
        String Password = Label.Pardot_Password;
        String User_key = Label.Pardot_User_Key;
        String url = 'https://pi.pardot.com/api/login/version/4?'+'email='+userEmail+'&password='+Password+'&user_key='+User_key ;
        req.setEndpoint(url);
        HttpResponse response = http.send(req);
        String responseAPI = response.getBody();
        String Key;
        if(responseAPI != null){
             Key =  responseAPI.substringBetween('<api_key>','</api_key>');
             system.debug('@@@@@@@@@@@'+Key);
        }
        System.debug('REST response is :: '+response.getBody());
        return Key;
     }
   
}