@isTest
private class RecordTypeHelperTest {

    static testMethod void myUnitTest() 
    {
        /*
            If one of these tests fail, it indicates that our lookup isn't working as expected. 
            Look at the SOQL query and find out why. Likely the record type was renamed or deleted?
        */
        
        String rt;   

        rt = RecordTypeHelper.claimRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.policyholderContactRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.adjusterContactRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.landlordContactRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.hotelContactRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.hotelServiceRequestRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.housingServiceRequestRT();
        System.assertNotEquals(rt, null);
            
        rt = RecordTypeHelper.frvServiceRequestRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.findersFeesServiceRequestRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.hotelPlacementRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.housingPlacementRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.hotelAccountRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.insuranceCompanyAccountRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.householdAccountRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.landlordAccountRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.hotelSearchRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.housingSearchRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.costCostsRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.feeCostsRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.depositCostsRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.furnitureDepositCostsRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.furnitureFeeCostsRT();
        System.assertNotEquals(rt, null);
        
        rt = RecordTypeHelper.mulliganQuoteRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.unsentNTVTaskRT();
        System.assertNotEquals(rt, null);
    
        rt = RecordTypeHelper.portalNotesTaskRT();
        System.assertNotEquals(rt, null);
    
        rt = RecordTypeHelper.portalNotesCompletedTaskRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.newCaseRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.assignedCaseRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.closedNTVTaskRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.x72HourPHContactTaskRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.x72HourADJContactTaskRT();
        System.assertNotEquals(rt, null);

        rt = RecordTypeHelper.x24HourFollowUpTaskRT();
        System.assertNotEquals(rt, null);
    }
}