public with sharing class PTForceFetcher 
{

  public static string FetchStatement(string placementId, Date BeginDate, Date EndDate)
  {
  	string instanceName = util.getInstanceName();
  	
    Http h = new Http(); 
    HttpRequest req = new HttpRequest();
    
    string bd = String.valueOf(BeginDate.year()) + twoDigit(String.valueOf(BeginDate.month())) + twoDigit(String.valueOf(BeginDate.day()));
    string ed = String.valueOf(EndDate.year()) + twoDigit(String.valueOf(EndDate.month())) + twoDigit(String.valueOf(EndDate.day()));
  
   	PageReference pageRef = new PageReference('https://www.placetrakforce.com/mulligan/' + instanceName + '/statementforclaim/' + placementId);
    pageRef.getParameters().put('type', 'xml');
    pageRef.getParameters().put('beginDate', bd);
    pageRef.getParameters().put('endDate', ed); 
   
    req.setMethod('GET');
    req.setEndpoint(pageRef.getUrl());
    req.setTimeout(60000);
        
    HttpResponse res = h.send(req); 
    string responseBody = res.getBody();
    
    System.debug(LoggingLevel.INFO, 'responseBody: ' + responseBody);
    
    return responseBody.substring(1);
  }
  
	private static string twoDigit(string param)
	  {
	    if (param.length() == 1) 
	    {
	      param = '0' + param;
	    }
	    
	    return param;
	    
	  }
}