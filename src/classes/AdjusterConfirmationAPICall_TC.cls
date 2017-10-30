@isTest
private class AdjusterConfirmationAPICall_TC{
    static testMethod void adjusterAPITest(){
        
        AdjusterConfirmationAPICall clsRef = new AdjusterConfirmationAPICall();
        clsRef.callServiceMethod();
        
        AdjusterConfirmationAPICall.ResponseData R = new AdjusterConfirmationAPICall.ResponseData();
        R.Today = '2017-09-09';
        R.To = 'Test';
        R.Company = 'Test';
        R.FromFax = 'Test';
        R.From1 = 'Test';
        R.Phone = 'Test';
        R.Regarding = 'Test';
        R.ClaimNumber = 'Test';
        R.CRSID = 'Test';
        R.HotelFullAddress = 'Test';
        R.HotelPhone = 'Test';
        R.HotelFax = 'Test';
        R.InuranceCompany = 'Test';
        R.FromEmail = 'Test';
        R.ToFax = 'Test';
        R.ToEmail = 'Test';
        R.HotelName = 'Test';
        R.Address = 'Test';
        R.City  = 'Test';
        R.State = 'Test';
        R.Zip = 'Test';
        R.PdfImageBaseUrl = 'Test';
        R.LogoUrl = 'Test';
        R.AnniversaryEmblemUrl  = 'Test';
        
        AdjusterConfirmationAPICall.Rooms R1 = new AdjusterConfirmationAPICall.Rooms();
        R1.Number1 = 1;
        R1.CheckIn = '';
        R1.EstimatedCheckout = '';
        R1.DailyRate = 10;
        R1.RoomType = '';
        R1.OtherFee = 10;
        R1.OtherFeeDescription = '';
        R1.ParkingFee = 10;
        R1.PetFee = 10;
        R1.CheckInDateFormated = '';
        R1.EstimatedCheckoutFormated = '';
    }
}