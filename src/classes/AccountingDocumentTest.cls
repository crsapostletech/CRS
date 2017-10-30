@isTest
private class AccountingDocumentTest {

    static testMethod void myUnitTest() {
        AccountingDocument ad = new AccountingDocument();
        ad.Amount = 5.00;
        ad.DateCreated = Date.today();
        ad.DocumentId = 'AD1234';
        ad.DocumentLink = 'abd123';
        AccountingDocumentLineItem[] adli = ad.LineItems;
    }
}