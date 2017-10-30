@isTest
private class TestStatementValuesDTO {

    static testMethod void myUnitTest() {
        StatementValuesDTO sv = new StatementValuesDTO();
        sv.AdjusterAddress = 'abc';
        sv.AdjusterCityState = 'av';
        sv.AdjusterCompanyName = 'big co';
        sv.AdjusterFax = 'asdf';
        sv.AdjusterName = 'bob smith';
        sv.AdjusterPhone = 'afs';
        sv.Charges = 5.00;
        sv.ClaimNumber = 'abc123';
        sv.Credits = 6.00;
        sv.CurrentBalance = 1.00;
        sv.CustomerId = 'custId';
        sv.Payments = 56.00;
        sv.PlacementId = '34322';
        sv.PolicyHolderName = 'john tucker';
        sv.PreviousBalance = -34.00;
        
        AccountingDocument[] payments = sv.PaymentsList;
        AccountingDocument[] credits = sv.CreditsList;
        AccountingDocument[] charges = sv.InvoicesList;
        
    }
}