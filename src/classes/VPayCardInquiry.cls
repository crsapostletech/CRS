public with sharing class VPayCardInquiry
{
    public string CardNumber {get; set;}
 
    public VPayCardInquiry() 
    {
    }
    
    public String getCreditCardInfo() 
    {
        string actionType = 'Inquire';
        string placementIdFirst15 = '';
	    string placementIdLast3 = '';
	    string estimatedCheckOutDate = '';
	    string xml = VPayConnectCallOuts.setupCCRequest(actionType, placementIdFirst15, '', placementIdLast3, cardNumber, estimatedCheckOutDate); 
        
    	return xml;
    }
}