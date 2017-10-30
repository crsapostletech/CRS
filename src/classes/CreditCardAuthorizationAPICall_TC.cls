@isTest
Private class CreditCardAuthorizationAPICall_TC{
    static testMethod void ccAuthApiCallTest(){
        CreditCardAuthorizationAPICall clsRef = new CreditCardAuthorizationAPICall();
        clsRef.callServiceMethod();
        
        CreditCardAuthorizationAPICall.ResponseData R = new CreditCardAuthorizationAPICall.ResponseData();
        R.AddressHeader = '';
        R.CRSID = '';
        R.CreditCardInformation = '';
        R.Header = '';
        R.ImageURL = '';
        R.PolicyHolderName = '';
        R.Today = '';
        R.Account = new CreditCardAuthorizationAPICall.Account();
        
        CreditCardAuthorizationAPICall.Account R1 = new CreditCardAuthorizationAPICall.Account();
        R1.BillingStreet = '';
        R1.City = '';
        R1.Fax = '';
        R1.Name = '';
        R1.Phone = '';
        R1.State = '';
        R1.ZipCode = '';
        
        CreditCardAuthorizationAPICall.HotelRooms R2 = new CreditCardAuthorizationAPICall.HotelRooms();
        R2.ConfirmationNumber = '';
        R2.OtherFee = 0;
        R2.OtherFeeDescription = '';
        R2.ParkingFee = 0;
        R2.PetFee = 0;
        
        CreditCardAuthorizationAPICall.Segments R3 = new CreditCardAuthorizationAPICall.Segments();
        R3.DailyRate = 0;
        R3.OtherFee = 0;
        R3.OtherFeeDescription = '';
        R3.ParkingFee = 0;
        R3.PetFee = 0;
        R3.Tax = 0;
        R3.TotalNightlyRate = 0;
        
    }
}