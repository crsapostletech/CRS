@isTest
private class CongaValsTest {

    static testMethod void CongaValsTest() 
    {
   	    CongaVals cv = new CongaVals();
	  
	    cv.isProductionOrg = false; 
	    
	    for (Integer i = 0; i < 2; i++)
	    {
		    Id x = cv.getHotelAuthQuery1();
		    x = cv.getHotelAuthQuery2();
		    x = cv.getHotelAuthQuery3();
		    x = cv.getHotelAuthQuery4();
		    x = cv.getHotelAuthQuery5();
		    x = cv.getHotelAuthQuery6();
		    x = cv.getHSAQuery1();
		    
		    x = cv.getHSATemplateId();
		    x = cv.gethotelAuthTemplateId();
		    x = cv.gethotelAllstateAuthTemplateId();
		    x = cv.getCRSHotelConfirmationAdjusterTemplateId();
		    x = cv.getCRSCCAuthTemplateId();
		    x = cv.getCRSDirectBillExtAuthTemplateId();
		    x = cv.getCRSCOFolioRequesthotelTemplateId();
		    x = cv.getVisaCardwithIDTemplateId();
		    x = cv.getMastercardwithIDTemplateId();
		    x = cv.getAmexEditableAuthTemplateId();
		    x = cv.getAdjusterHousingAgreementTemplateId();
		    cv.isProductionOrg = true;
	    }
	}
}