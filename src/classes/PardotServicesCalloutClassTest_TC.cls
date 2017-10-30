@isTest
private class PardotServicesCalloutClassTest_TC {
     @isTest static void testCallout() {
        // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new PardotMockHttpResponseGeneratorTC ());
            PardotQueryProspectApi.queryProspectAPI(0);
            list<String> ProspectFids = new list<String>();
            ProspectFids.add('3010');
            Database.executeBatch(new PardotProspectDeleteBacth(ProspectFids),20); 
       }
      @isTest static void testschedule(){
        Test.StartTest();
            Test.setMock(HttpCalloutMock.class, new PardotMockHttpResponseGeneratorTC ());
            scheduledPardotQueryProspectApi sh1 = new scheduledPardotQueryProspectApi();
            String sch = '0 0 23 * * ?'; 
            system.schedule('PardotQueryProspectApi', sch, sh1); 
            Test.stopTest();
    }           
 }