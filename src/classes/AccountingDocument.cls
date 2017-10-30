public with sharing class AccountingDocument {

  public string DocumentId {get; set;}
  public decimal Amount {get; set;}
  public date DateCreated {get; set;}
  public string DocumentLink {get; set;}
  
  
  public AccountingDocumentLineItem[] LineItems {get; set;}

  public AccountingDocument()
  {
    this.LineItems = new List<AccountingDocumentLineItem>();
  }
  
}