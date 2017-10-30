public with sharing class StatementValuesDTO {

  public string PlacementId {get; set;}
  public string PolicyHolderName {get; set;}
  public string ClaimNumber {get; set;}
  
  public string CustomerId {get; set;}
  public string AdjusterName {get; set;}
  public string AdjusterCompanyName {get; set;}
  public string AdjusterAddress {get; set;}
  public string AdjusterCityState {get; set;}
  public string AdjusterPhone {get; set;}
  public string AdjusterFax {get; set;}
  
  public decimal PreviousBalance {get; set;}
  public decimal CurrentBalance {get; set;}
  public decimal Charges {get; set;}
  public decimal Payments {get; set;}
  public decimal Credits  {get; set;}
  
  public AccountingDocument[] InvoicesList {get; set;}
  public AccountingDocument[] CreditsList {get; set;}
  public AccountingDocument[] PaymentsList {get; set;}
  
  public StatementValuesDTO()
  {
    this.InvoicesList = new List<AccountingDocument>();
    this.CreditsList = new List<AccountingDocument>();
    this.PaymentsList = new List<AccountingDocument>();
    
  }
  
}