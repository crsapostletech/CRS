/***************************************************************************************************
Developed By: Apostletech Team
Purpose: To call CC Auth API call and to generate a PDF document to send in email
VF Page: CCAuthForm
***************************************************************************************************/
Public class CreditCardAuthorizationAPICall{

       static string instanceName = util.getInstanceName();    
       Public ResponseData resData {get;set;}
       
       Public void callServiceMethod(){
             
             //callCCAuthService('a0Le0000003f0xUEAQ', true);
             String placementId = ApexPages.currentPage().getParameters().get('placementId');
             String displayIATA = ApexPages.currentPage().getParameters().get('IATAFlag');             
             
             resData = new ResponseData();
             
             Http http = new Http();
             HttpRequest req = new HttpRequest();
             HTTPResponse res = new HTTPResponse(); 
                          
             req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/Documents/CCAuth?placementId='+placementId+'&displayIATA='+displayIATA+'&useAverage=false');
             
             req.setMethod('GET');  
             if(!Test.isRunningTest())    
                 res = http.send(req); 
             String resBody = res.getBody(); 
             
             System.debug(' ///// resBody ::  '+resBody);
             // When running from test class
             if(Test.isRunningTest()){
                 resBody = '{"Account":{"BillingStreet":"test","City":"test","Fax":"test","Name":"test","Phone":"test","State":"test","ZipCode":"test"},"AddressHeader":"test","AuthorizationPoints":["test","test1","test2"],'+
                 '"CRSID":"test","CreditCardInformation":"test","Header":"test","HotelRooms":[{"ConfirmationNumber":"12345","OtherFee":100.0,"OtherFeeDescription":"Test","ParkingFee":null,"PetFee":10,'+
                 '"Segments":[{"CheckInDate":"2017-01-01T00:00:00","CheckOut":"2017-01-31T00:00:00","DailyRate":100.0,"OtherFee":50.0,"OtherFeeDescription":"test","ParkingFee":10,"PetFee":10,"Tax":0.0,"TotalNightlyRate":150.0}]}],"ImageURL":"test","PolicyHolderName":"test","Today":"Friday, March 03, 2017"}';
             }
             
             System.debug('resBody..!'+resBody); 
             
             if(resBody != null && resBody != '' && res.getStatusCode() == 200){  
                 resBody = resBody.replace('class','style');
                 resBody = resBody.replace('bold','font-weight:bold;');
                 resBody = resBody.replace('underline','text-decoration:underline;');
                 resData = (ResponseData) JSON.deserialize(resBody, ResponseData.class);
                 
                 resData.AuthorizationPointsDummy = new List<String>();
                 for(String S : resData.AuthorizationPoints){
                     resData.AuthorizationPointsDummy.add(s);
                 }
                 for(HotelRooms HR : resData.HotelRooms){
                     for(Segments S : HR.Segments){                     
                         
                         if(S.CheckInDate != null && S.CheckInDate != ''){                         
                             String[] dateArr = S.CheckInDate.split('-'); 
                             S.CheckInDateFormated = dateArr[1]+'/'+ dateArr[2].split('T')[0] + '/' + dateArr[0];
                         }
                         if(S.CheckOut != null && S.CheckOut != ''){                         
                             String[] dateArr = S.CheckOut.split('-'); 
                             S.CheckOutDateFormated = dateArr[1]+'/'+ dateArr[2].split('T')[0] + '/' + dateArr[0];
                         }                                              
                     }                                       
                 } 
             }
           
           System.debug(' ***** response data ******* '+resData); 
      }    
       Public class ResponseData{
       
           public String AddressHeader {get;set;}
           public List<String> AuthorizationPoints {get;set;} 
           public List<String> AuthorizationPointsDummy {get;set;}
           public String CRSID {get;set;} 
           public String CreditCardInformation {get;set;} 
           public String Header {get;set;} 
           public List<HotelRooms> HotelRooms {get;set;} 
           public String ImageURL {get;set;} 
           public String PolicyHolderName {get;set;} 
           public String Today {get;set;}
           public Account Account {get;set;}
       }
       
       public class Account {
            public String BillingStreet {get;set;} 
            public String City {get;set;} 
            public String Fax {get;set;} 
            public String Name {get;set;} 
            public String Phone {get;set;} 
            public String State {get;set;} 
            public String ZipCode {get;set;} 
       }    
       
       public class HotelRooms {
            public String ConfirmationNumber {get;set;} 
            public Double OtherFee {get;set;} 
            public String OtherFeeDescription {get;set;} 
            public Double ParkingFee {get;set;} 
            public Double PetFee {get;set;} 
            public List<Segments> Segments {get;set;} 
       }
       
       public class Segments {            
            public String CheckInDate {get;set;} 
            public String CheckOut {get;set;} 
            public Double DailyRate {get;set;} 
            public Double OtherFee {get;set;} 
            public String OtherFeeDescription {get;set;} 
            public Double ParkingFee {get;set;} 
            public Double PetFee {get;set;} 
            public Double Tax {get;set;} 
            public Double TotalNightlyRate {get;set;} 
            Public String CheckInDateFormated {get;set;}   
            Public String CheckOutDateFormated {get;set;}
       }      
          
       
}