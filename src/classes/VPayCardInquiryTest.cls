@isTest
private class VPayCardInquiryTest {

    static testMethod void testVPayCardInquiry() 
    {
    	//Test converage for the myPage visualforce page
		PageReference pageRef = Page.VPayCardInquiry;
		Test.setCurrentPageReference(pageRef);
		
		VPayCardInquiry controller = new VPayCardInquiry();
		
		controller.CardNumber = '370268023665727';
		controller.getCreditCardInfo();
		
    }
}