@isTest
private class RESTCreateExtensionTest {

    static testMethod void myUnitTest() 
    {
      // Insert placement
               
      Placement__c placement = new Placement__c(
                                      RecordTypeId = recordTypeHelper.housingPlacementRT(),
                                      Name = 'testPlacementx',
                                      Status__c = 'Moved-Out',
                                      Move_In_Date__c = Date.today().addMonths(-5),
                                      Approved_Through_Date__c = Date.today());
                                        
      insert placement;
        
        
      User user = [select id from User where isActive = true and name = 'Mark Bodde' limit 1];
                
      RestRequest req = new RestRequest();
      if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW') 
      {
          // production endpoint
          req.requestURI = 'https://login.salesforce.com/services/apexrest/Placement/CreateExtension';
      }
      else
      {
          // test endpoint
          req.requestURI = 'https://test.salesforce.com/services/apexrest/Placement/CreateExtension';
      }
      req.httpMethod = 'POST';
        
      Date newApprovedThroughDate = placement.Approved_Through_Date__c.addDays(7);
                
        String placementId = placement.Id;
      String userId = '123';
      String approvedThroughDate = String.valueOf(newApprovedThroughDate);
      Boolean createNTVTask = true;     
            
        RESTCreateExtension.insertExtension(placementId,userId,approvedThroughDate,createNTVTask);

      newApprovedThroughDate = placement.Approved_Through_Date__c.addDays(-10);
        
      approvedThroughDate = String.valueOf(newApprovedThroughDate);
        
      RESTCreateExtension.insertExtension(placementId,userId,approvedThroughDate,createNTVTask);

        //setup request with bad data to cover exceptions
        
        RestContext.request = req;
          
      placementId = '123';
      userId = user.Id;
                    
        RESTCreateExtension.insertExtension(placementId,userId,approvedThroughDate,createNTVTask);
        
    }
}