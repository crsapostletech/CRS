public with sharing class VPayConnectCallOuts 
{
	public static string setupCCRequest(string actionType, string placementIdFirst15, string serviceRequestName, string placementIdLast3, string cardNumber, string endDate) 
	{
		xmlStreamWriter xmlWriter = new XmlStreamWriter();  
        xmlWriter.writeStartDocument('UTF-8','1.0');
        xmlWriter.writeStartElement(null,'CCRequest',null);
        
        AddXMLElement('ActionType',actionType,xmlWriter);
        AddXMLElement('PlacementIdFirst15',placementIdFirst15,xmlWriter);
        AddXMLElement('ServiceRequestName',serviceRequestName,xmlWriter);
        AddXMLElement('PlacementIdLast3',placementIdLast3,xmlWriter);
        if (cardNumber != '')
        {
        	 AddXMLElement('CardNumber',cardNumber,xmlWriter);	
        }
        if (endDate != '')
        {
        	 AddXMLElement('EndDate',endDate,xmlWriter);	
        }
		xmlWriter.writeEndElement();
        xmlWriter.writeEndDocument();
        
        system.debug(xmlWriter.getXmlString());
        string result = CallOut(xmlWriter.getXmlString());
        xmlWriter.close();
        
        return result;
	}
	
	//Future annotation to mark the method as async.
    @Future(callout=true)
    
	public static void setupCCRequestAsync(string actionType, string placementIdFirst15, string serviceRequestName, string placementIdLast3, string cardNumber, string endDate) 
	{
		xmlStreamWriter xmlWriter = new XmlStreamWriter();  
        xmlWriter.writeStartDocument('UTF-8','1.0');
        xmlWriter.writeStartElement(null,'CCRequest',null);
        
        AddXMLElement('ActionType',actionType,xmlWriter);
        AddXMLElement('PlacementIdFirst15',placementIdFirst15,xmlWriter);
        AddXMLElement('ServiceRequestName',serviceRequestName,xmlWriter);
        AddXMLElement('PlacementIdLast3',placementIdLast3,xmlWriter);
        if (cardNumber != '')
        {
        	 AddXMLElement('CardNumber',cardNumber,xmlWriter);	
        }
        if (endDate != '')
        {
        	 AddXMLElement('EndDate',endDate,xmlWriter);	
        }
		xmlWriter.writeEndElement();
        xmlWriter.writeEndDocument();
        
        system.debug(xmlWriter.getXmlString());
        string result = CallOut(xmlWriter.getXmlString());
        xmlWriter.close();
    }
	
	private static string CallOut(string xml) 
    {
    	HttpRequest req = new HttpRequest();
        
        // Set timeout value to 60 seconds;
        req.setTimeout(60000);
        
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {
        	// production endpoint 
      		req.setEndpoint('http://64.42.119.250/VPayConnect/SetupCCRequest');
        }
        else
        {       
        	// test endpoint 
        	req.setEndpoint('http://64.42.119.250/VPayConnectTest/SetupCCRequest');
        }
       
        req.setHeader ('content-length',xml.length().format());
        req.setMethod('POST');
    
        String username = 'crs/mbodde'; 
        String password = 'SkinnyBoy123';
    
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        req.setBody(xml); 
   
      	//send the request
        Http http = new Http();
        HttpResponse res = new HttpResponse();
    
        //Execute web service call here  
        try
        {   
        	if (!Test.isRunningTest())
	    	{
	    		res = http.send(req);
	    	}
	    	else
	    	{
	    		res.setStatusCode(200);
	    	}  
        }
        catch(System.CalloutException e) 
        {
  			System.Debug(e);
  			return '';
        }
        
       
        if (res.getStatusCode() != 200) 
        {
        	System.Debug(res);  
  			return '';
        }
        
        return res.getBody();
    }
    
    private static void AddXMLElement(String fieldName, String value, xmlStreamWriter xmlWriter) 
    {
        if (value <> null)
        {
            xmlWriter.writeStartElement(null,fieldName,null);
            xmlWriter.writeCharacters(value);
            xmlWriter.writeEndElement();
        }
        else
        {
            xmlWriter.writeEmptyElement(null,fieldName,null);    
        }   
    }
}