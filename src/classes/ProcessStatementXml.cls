public with sharing class ProcessStatementXml {
  
  private string xml;
  private XmlStreamReader xsr;
  private StatementValuesDTO sv;
  
  public ProcessStatementXml(string xml)
  {
    this.xml = xml;
    this.xsr = new XmlStreamReader(xml);
    this.xsr.setCoalescing(true);
    
    this.sv = new StatementValuesDTO();
    
  }
  
  public StatementValuesDTO ProcessXml()
  {
    
    if (xml == null || xml.length() == 0)
    {
    	return sv;
    }
    
    
    try
    {
    
    while (xsr.hasNext())
	  {
	    if (xsr.getEventType() == XmlTag.START_ELEMENT )
	    {
	      string localName = xsr.getLocalName();
	      if ( localName == 'placement' || localName == 'adjuster' || localName == 'statement_summary')
	      {
	        processPlacement(xsr, localName);
	      }
	      else if (localName == 'invoices' || localName == 'credits' || localName == 'payments')
	      {
	        processInvoices(xsr, localName);
	      }
	    }
	    
	    xsr.next();
	  }
	  
	  System.debug(LoggingLevel.INFO, 'Invoice Count: ' + sv.InvoicesList.size());
	  System.debug(LoggingLevel.INFO, 'Credits Count: ' + sv.CreditsList.size());
	  System.debug(LoggingLevel.INFO, 'Payment Count: ' + sv.PaymentsList.size());
  
    }
    catch (System.XmlException ex)
    {
    	return sv;
    }
  
    return this.sv;
  }
  
  private void processInvoices(XmlStreamReader xsr, string parentElementName)
  {
    while(xsr.hasNext())
    {
      if (xsr.getEventType() ==  XmlTag.END_ELEMENT && xsr.getLocalName() == parentElementName) 
      { 
      	System.debug(LoggingLevel.INFO, 'End Element found: ' + xsr.getLocalName());
      	break; 
      }
      else if (xsr.getEventType() == XmlTag.START_ELEMENT && xsr.getLocalName() != parentElementName)
      {
        string elementName = xsr.getLocalName();
        
        
        System.debug(LoggingLevel.INFO, 'ParentElementName = '+ parentElementName + ', ElementName = ' + elementName);
        System.debug(LoggingLevel.INFO, 'There are ' + xsr.getAttributeCount() + ' attributes on this element');
        
        if (elementName == 'invoice' || elementName == 'credit' || elementName == 'payment')
        {
          // process invoice
          string documentIdAttribute = 'invoice_id';
          if (elementName == 'payment')
          {
            documentIdAttribute = 'payment_id';
          }
          
          // Should be into <[Invoice, Credit, Payment]/> tags now
          AccountingDocument ad = new AccountingDocument();
          
          string amountString = xsr.getAttributeValue(null, 'amount');
          System.debug(LoggingLevel.INFO, 'amountString = ' + amountString);
          
          string documentId = xsr.getAttributeValue(null, documentIdAttribute);
          System.debug(LoggingLevel.INFO, 'documentId = ' + documentId);
          
          string documentLink = xsr.getAttributeValue(null, 'doc_link');
            
          ad.DocumentId = documentId;
          ad.Amount = Decimal.valueOf(amountString);
          ad.DateCreated = Date.valueOf(xsr.getAttributeValue(null, 'date_created'));
          ad.DocumentLink = documentLink;
          
          // call processLineItems here
          // return line item & append to ad.adli
          processLineItems(xsr, elementName, ad);
          
          if (elementName == 'invoice')
          {
            sv.InvoicesList.add(ad);
          }
          else if (elementName == 'credit')
          {
            sv.CreditsList.add(ad);
          }
          else if (elementName == 'payment')
          {
            sv.PaymentsList.add(ad);
          }
            
        }
     
      }
      
      xsr.next();
    }
  }

  private void processLineItems(XmlStreamReader xsr, string parentElementName, AccountingDocument ad)
  {
    System.debug(LoggingLevel.INFO, '### Starting processLineItems ### parentElementName => ' + parentElementName );
    
    AccountingDocumentLineItem adli; // = new AccountingDocumentLineItem();
    //ad.LineItems.add(adli);
    
    string lastStartElementFound = '';
    
    while(xsr.hasNext())
    {
    	string elementName = xsr.getLocalName();
    	
    	System.debug(LoggingLevel.INFO, 'elementName => ' + elementName + ', EventType => ' + xsr.getEventType());
    	
      if (xsr.getEventType() ==  XmlTag.END_ELEMENT && elementName == parentElementName) 
      { 
        System.debug(LoggingLevel.INFO, 'processLineItems => End Element found: ' + elementName + '; parentElement: ' + parentElementName);
        break; 
      }
      else if (xsr.getEventType() == XmlTag.END_ELEMENT && elementName != parentElementName)
      {
        lastStartElementFound = '';
        System.debug(LoggingLevel.INFO, 'processLineItems => End Element found: ' + elementName);
      }
      else if (xsr.getEventType() == XmlTag.START_ELEMENT && elementName != parentElementName)
      {
        lastStartElementFound = elementName;
        System.debug(LoggingLevel.INFO, 'processLineItems => Start Element found: ' + elementName);
        
        if (elementName == 'invoice_item')
        {
        	System.debug(LoggingLevel.INFO, 'Initializing AccountingDocumentLineItem');
        	
          adli = new AccountingDocumentLineItem();
          ad.LineItems.add(adli);
        }
        
      }
      else if (xsr.getEventType() == XmlTag.CHARACTERS)
      {
        System.debug(LoggingLevel.INFO, 'processLineItems => Characters found: ' + xsr.getText());
        if (lastStartElementFound == 'description')
        {
          adli.Description = xsr.getText();
          System.debug(LoggingLevel.INFO, 'Setting ' + lastStartElementFound + ' to: ' + xsr.getText());
        }
        else if (lastStartElementFound == 'amount')
        {
          adli.Amount = Decimal.valueOf(xsr.getText());
          System.debug(LoggingLevel.INFO, 'Setting ' + lastStartElementFound + ' to: ' + Decimal.valueOf(xsr.getText()));
        }
      }
      
      System.debug(LoggingLevel.INFO, '### calling xsr.next() call in processLineItems ###'); 
      xsr.next();
    }
    
    System.debug(LoggingLevel.INFO, '### Ending processLineItems ###'); 
  }
  
  private void processPlacement(XmlStreamReader xsr, string parentElementName)
  {
        
    while(xsr.hasNext())
    {
      if (xsr.getEventType() == XmlTag.END_ELEMENT ) { break; }
      else if (xsr.getEventType() == XmlTag.START_ELEMENT && xsr.getLocalName() != parentElementName )
      {
        string elementName = xsr.getLocalName();
        
        while(xsr.hasNext())
        {
          
          if (xsr.getEventType() == XmlTag.END_ELEMENT  )
          {
            break;
          }
          else if (xsr.getEventType() == XmlTag.CHARACTERS)
          {
            string elementValue = xsr.getText();
            
            if (parentElementName == 'placement' || parentElementName == 'adjuster' || parentElementName == 'statement_summary')
            {
              assignLocalElementValuesForPlacement(elementValue, elementName, parentElementName);
            }
          }
          
          xsr.next();
        }
       
      }
      
      xsr.next();
    }
  }
  
  private void assignLocalElementValuesForPlacement(string elementValue, string currentElementName, string parentElementName)
  {
    if (currentElementName == 'id')
    {
      sv.PlacementId = elementValue;
    }
    else if (currentElementName == 'name' && parentElementName == 'placement')
    {
      sv.PolicyHolderName = elementValue;
    }
    else if (currentElementName == 'name' && parentElementName == 'adjuster')
    {
      sv.AdjusterName = elementValue;
    }
    else if (currentElementName == 'claim_number')
    {
      sv.ClaimNumber = elementValue;
    }
    else if (currentElementName == 'customer_id')
    {
      sv.CustomerId = elementValue;
    }
    else if (currentElementName == 'company')
    {
      sv.AdjusterCompanyName = elementValue;
    }
    else if (currentElementName == 'address')
    {
      sv.AdjusterAddress = elementValue;
    }
    else if (currentElementName == 'city_state')
    {
      sv.AdjusterCityState = elementValue;
    }
    else if (currentElementName == 'phone')
    {
      sv.AdjusterPhone = elementValue;
    }
    else if (currentElementName == 'fax')
    {
      sv.AdjusterFax = elementValue;
    }
    else if (currentElementName == 'previous_balance')
    {
      sv.PreviousBalance = Decimal.valueOf(elementValue);
    }
    else if (currentElementName == 'current_balance')
    {
      sv.CurrentBalance = Decimal.valueOf(elementValue);
    }
    else if (currentElementName == 'charges')
    {
      sv.Charges = Decimal.valueOf(elementValue);
    }
    else if (currentElementName == 'payments')
    {
      sv.Payments = Decimal.valueOf(elementValue);
    }
    else if (currentElementName == 'credits')
    {
      sv.Credits = Decimal.valueOf(elementValue);
    }  
  
  }
  
}