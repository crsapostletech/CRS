public with sharing class StatementController 
{
  
  public StatementParams__c sp {get;  set;}
  public String xml {get;  set;}
  
  public StatementValuesDTO sv {get; set;}
  
  public StatementController(ApexPages.StandardController stdController) {
    StatementParams__c spc = (StatementParams__c)stdController.getRecord();
    
    Map<String, String> params = ApexPages.currentPage().getParameters();
    
    if (params.containsKey('claim'))
    {
      string claim = params.get('claim');
      spc.Placement_Id__c = claim;
    }
       
    if (spc.Begin_Date__c == null) { spc.Begin_Date__c = date.newinstance(2009, 1, 1); }
    if (spc.End_Date__c == null) { spc.End_Date__c = date.today(); }
    
    this.sp = spc;  
    
    if (this.sv == null) { this.sv = new StatementValuesDTO(); }
  }
  
  public pageReference runStatement()
  {
    
    try    
    {

      this.xml = fetchStatement();
      
      ProcessStatementXml psx = new ProcessStatementXml(this.xml);
      this.sv = psx.ProcessXml();
      
      //XmlStreamReader xsr = new XmlStreamReader(this.xml);

      return Page.StatementView.setRedirect(false);
     
    }
    catch (Exception ex) 
    {
      throw ex;
    }
        
    return null; //for now!
    
  }
  
  public PageReference checkParams()
  {
    
    Map<String, String> params = ApexPages.currentPage().getParameters();
    boolean hasClaim = false;
    string claim = '';
    
    if (params.containsKey('claim'))
    {
    	hasClaim = true;
      claim = params.get('claim');
      sp.Placement_Id__c = claim;
    }
    
   // if (sp.Placement_Id__c == null || sp.Begin_Date__c == null || sp.End_Date__c == null)
   // {
    	PageReference pr = Page.StatementParams;
    
    	
    	if (hasClaim)
    	{
    		pr.getParameters().put('claim', claim);
    	}
    	
      return pr.setRedirect(true);
      //return Page.StatementParams.setRedirect(true);
  //  }    

 //   return null;
  }
  
  private string fetchStatement()
  {
	  string retval = PTForceFetcher.FetchStatement(sp.Placement_Id__c, sp.Begin_Date__c, sp.End_Date__c);
	  return retval;
  }
  
  
}