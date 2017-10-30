@isTest
private class TestPTForceFetcher {

    @isTest
    static void myUnitTest() {
      
        Test.setMock(HttpCalloutMock.class, new StatementHttpCalloutMock());  
      string xml = PTForceFetcher.FetchStatement('23323', date.newinstance(2009, 1, 1), date.today());
      
    }
}