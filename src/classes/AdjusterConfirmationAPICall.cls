/**********************************************************************************************************
Created By: Chiru
Purpose: To call Adjuster Confirmation api call to get data and to show on VF page. 
VF Page: AdjusterConfirmationForm
Test class: AdjusterConfirmationAPICall_TC
***********************************************************************************************************/
Public class AdjusterConfirmationAPICall{

      static string instanceName = util.getInstanceName();
      public ResponseData resData {get;set;}
      
      Public void callServiceMethod(){
             
             String placementId = ApexPages.currentPage().getParameters().get('placementId');
             String userId = UserInfo.getUserId();

             
             
             resData = new ResponseData();
             Http http = new Http();
             HttpRequest req = new HttpRequest();
             HTTPResponse res = new HTTPResponse();             
             req.setEndpoint('https://www.placetrakforce.com/mulligan/' + instanceName + '/Documents/AdjusterConfirmation?placementId='+placementId+'&userId='+userId);
             req.setMethod('GET');  
             if(!Test.isRunningTest())    
                 res = http.send(req); 
             String resBody = res.getBody();
              
             
             if(Test.isRunningTest()){
                 resBody = '{"Today":"2017-03-02","To":"Adjuster Name","Company":"Test Company","FromFax":"(888) 123-1234","From":"Craig Pollack","Phone":"(888) 345-5678","Regarding":null,"ClaimNumber":"1234567890","CRSID":"123465",'+
                             '"Rooms":[{"Number":1,"CheckIn":"2017-01-01T00:00:00","EstimatedCheckout":"2017-02-28T00:00:00","DailyRate":100.0,"RoomType":"King","KitchenFeatures":"Some stuff","OtherFee":50.0,"OtherFeeDescription":"Test Fee","ParkingFee":25.0,"PetFee":10.0}],"HotelFullAddress":"Marriott, 1234 Test Street, Phonix, AZ 85029, Phone: (888) 123-1234 Fax: (555) 555-5555","HotelPhone":"(888) 345-5678","HotelFax":"(888) 345-5678","InuranceCompany":null,"FromEmail":"cpollack@crsth.com","ToFax":null,"ToEmail":"Adjuster@email.com","HotelName":"Marriott","Address":"1234 Test Street","City":"Phoenix","State":"AZ","Zip":"85029","PdfImageBaseUrl":null,"LogoUrl":null,"AnniversaryEmblemUrl":null}';
             }
             
             System.debug(res.getStatusCode()+' ///////// '+resBody);
             
             if(resBody != null && resBody != '' && res.getStatusCode() == 200){
             
                 resBody = resBody.replaceAll('From', 'From1');
                                               
                 resData = (ResponseData) JSON.deserialize(resBody, ResponseData.class);
                 
                 if(resData.HotelFullAddress != null && resData.HotelFullAddress != ''){
                     resData.HotelFullAddress = resData.HotelFullAddress.substringBefore('Phone');
                 }
                 if(resData.Today != null && resData.Today != '' && resData.Today.contains('T')){
                     String currDate = resData.Today.substringBefore('T'); 
                     String[] dtArr = currDate.split('-');
                     if(dtArr.size() > 2){
                         DateTime currDateTime = DateTime.newInstance(Integer.valueOf(dtArr[0]), Integer.valueOf(dtArr[1]), Integer.valueOf(dtArr[2]));
                         resData.Today = currDateTime.format('EEEE') + ', '+ currDateTime.format('MMMMM') + ' ' + dtArr[2] + ', '+ dtArr[0];
                     }    
                 }
                  
                 for(Rooms HR : resData.Rooms){
                   
                         if(HR.CheckIn!= null && HR.CheckIn != ''){                         
                             String[] dateArr = HR.CheckIn.split('-'); 
                             HR.CheckInDateFormated = dateArr[1]+'/'+ dateArr[2].split('T')[0] + '/' + dateArr[0];
                         }
                         
                          if(HR.EstimatedCheckout!= null && HR.EstimatedCheckout != ''){                         
                             String[] dateArr = HR.EstimatedCheckout.split('-'); 
                             HR.EstimatedCheckoutFormated = dateArr[1]+'/'+ dateArr[2].split('T')[0] + '/' + dateArr[0];
                         }
                 }
             }    
             
      }
      
      Public class ResponseData{
      
            public String Today {get;set;}
            public String To {get;set;} 
            public String Company {get;set;} 
            public String FromFax {get;set;} 
            public String From1 {get;set;} 
            public String Phone {get;set;} 
            public String Regarding {get;set;} 
            public String ClaimNumber {get;set;} 
            public String CRSID {get;set;} 
            public List<Rooms> Rooms {get;set;} 
            public String HotelFullAddress {get;set;} 
            public String HotelPhone {get;set;} 
            public String HotelFax {get;set;} 
            public String InuranceCompany {get;set;} 
            public String FromEmail {get;set;} 
            public String ToFax {get;set;} 
            public String ToEmail {get;set;} 
            public String HotelName {get;set;} 
            public String Address {get;set;} 
            public String City {get;set;} 
            public String State {get;set;} 
            public String Zip {get;set;} 
            public String PdfImageBaseUrl {get;set;} 
            public String LogoUrl {get;set;} 
            public String AnniversaryEmblemUrl {get;set;} 
      }
      
      public class Rooms {
            
            public Integer Number1 {get;set;} 
            public String CheckIn {get;set;} 
            public String EstimatedCheckout {get;set;} 
            public Double DailyRate {get;set;} 
            public String RoomType {get;set;} 
            public String KitchenFeatures {get;set;} 
            public Double OtherFee {get;set;} 
            public String OtherFeeDescription {get;set;} 
            public Double ParkingFee {get;set;} 
            public Double PetFee {get;set;} 
            public string CheckInDateFormated{get;set;}
            public String EstimatedCheckoutFormated{get;set;} 
      }
      
      
}