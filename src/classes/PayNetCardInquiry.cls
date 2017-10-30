public with sharing class PayNetCardInquiry 
{
	public string OrderId {get; set;}
 
    public PayNetCardInquiry() 
    {
    }
    
    public String getCreditCardInfo() 
    {
        string actionType = 'Inquire';
        string claimName = '';
	    string ServiceRequestName = '';
	    string endDate = '';
	    string xml = PayNetConnectCallOuts.setupCCRequest(actionType, 'Hotel Placement', ClaimName, ServiceRequestName, orderId, '', endDate); 
        
    	return xml;
    }

}