@isTest
private class HotelOnlyUpdaterSchedulerTest {

    static testMethod void myUnitTest() {
       SchedulableContext sc;
       HotelOnlyUpdaterScheduler hous =  new HotelOnlyUpdaterScheduler();
       hous.execute(sc);
    }
}