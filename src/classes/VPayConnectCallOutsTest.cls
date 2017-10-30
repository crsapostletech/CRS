@isTest
private class VPayConnectCallOutsTest {

    static testMethod void myUnitTest() {
       
       string test1 = VPayConnectCallOuts.setupCCRequest('update','123456789012345','SR-12345','123','123456789012345','2013-01-01');
       VPayConnectCallOuts.setupCCRequestAsync('update','123456789012345','SR-12345','123','123456789012345','2013-01-01');
    }
}