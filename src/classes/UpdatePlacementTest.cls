@isTest
private class UpdatePlacementTest {

    static testMethod void myUnitTest() {
        
        // Insert placement
        Placement__c placement1 = new Placement__c(
                                      RecordTypeId = RecordTypeHelper.hotelPlacementRT(),
                                      Credit_Card_Type__c = 'vPay',
                                      Credit_Card_Number__c = '370268023664444',
                                      Name = 'testPlacementx');
                                        
        insert placement1;
        
         Hotel_Room__c hotelRoom1 = new Hotel_Room__c
                (
                    placement__c = placement1.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2013,12,10),
                    Estimated_Check_Out_Date__c = Date.newInstance(2014,12,10));
                    
        insert hotelRoom1;
        
        Hotel_Room__c hotelRoom2 = new Hotel_Room__c
                (
                    placement__c = placement1.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2013,11,10),
                    Estimated_Check_Out_Date__c = Date.newInstance(2014,12,14));
                    
        insert hotelRoom2;
        
        hotelRoom1.Cancellation_del__c = '123';
        update hotelRoom1;
        
        hotelRoom2.Cancellation_del__c = '123';
        update hotelRoom2;
        
        Hotel_Room__c hotelRoom3 = new Hotel_Room__c
                (
                    placement__c = placement1.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2014,01,10),
                    Estimated_Check_Out_Date__c = Date.newInstance(2014,06,10));
                    
        insert hotelRoom3;
        
        hotelRoom3.CheckOut__c = Date.newInstance(2014,02,1);
        update hotelRoom3;
        
         Hotel_Room__c hotelRoom4 = new Hotel_Room__c
                (
                    placement__c = placement1.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2014,01,1),
                    Estimated_Check_Out_Date__c = Date.newInstance(2016,07,10));
                    
        insert hotelRoom4;
                    
        hotelRoom4.CheckOut__c = Date.Today();
        update hotelRoom4;
        
    }
    
    static testMethod void myUnitTest2() {
    	 
        // Insert placement
        Placement__c placement2 = new Placement__c(
                                      RecordTypeId = RecordTypeHelper.hotelPlacementRT(),
                                      Credit_Card_Type__c = 'PayNet',
                                      Credit_Card_Number__c = '370268023664444',
                                      Name = 'testPlacementx');
                                        
        insert placement2;
        
        
        Hotel_Room__c hotelRoom5 = new Hotel_Room__c
                (
                    placement__c = placement2.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2014,01,1),
                    Estimated_Check_Out_Date__c = Date.newInstance(2014,07,10));
                    
        insert hotelRoom5;
        
        hotelRoom5.Cancellation_del__c = '123';
        update hotelRoom5;
        
        Hotel_Room__c hotelRoom6 = new Hotel_Room__c
                (
                    placement__c = placement2.Id,
                    Room_Type__c = 'Standard Double',
                    Confirmation__c = '123',
                    Check_In__c = Date.newInstance(2014,01,1),
                    Estimated_Check_Out_Date__c = Date.newInstance(2014,07,10));
                    
        insert hotelRoom6;
        
        hotelRoom6.CheckOut__c = Date.Today();
        update hotelRoom6;
    	
    	
    }
}