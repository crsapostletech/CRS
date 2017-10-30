@isTest
public class TestStatementController 
{
    @isTest
    static void StatementControllerTest() 
	{
	  Test.setMock(HttpCalloutMock.class, new StatementHttpCalloutMock());  
	    
	  StatementParams__c sp = new StatementParams__c();
	  
         ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('claim', '1234'); 
      
        
	ApexPages.standardController controller = new ApexPages.standardController(sp);
    StatementController sc = new StatementController(controller);
 
    sc.checkParams();
    sp.Placement_Id__c = '12232';
    sc.checkParams();
    
 
    sc.runStatement();
    
    
	}
}