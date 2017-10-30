@isTest
private class PayNetCardInquiryTest 
{
	@isTest static void test_method_one() 
	{
		PayNetCardInquiry pnci = new PayNetCardInquiry();
		PageReference pageRef = Page.PayNetCardInquiry;
        Test.setCurrentPage(pageRef);

        pnci.getCreditCardInfo();
	}
}