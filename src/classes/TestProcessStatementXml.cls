@isTest
private class TestProcessStatementXml {
	
    @isTest
    static void myUnitTest() 
    {
	    string xml = testXML();
	    
	    ProcessStatementXml psx = new ProcessStatementXml(xml);
	    StatementValuesDTO sv = psx.ProcessXml();
	    
	    System.assertEquals('ROYE3830', sv.CustomerId);
	    AccountingDocument[] invoices = sv.InvoicesList;
	    System.assertEquals(3, invoices.size());
	    
	    AccountingDocument invoice = invoices[0];
	    System.assertEquals('IN010190', invoice.DocumentId);
	    System.assertEquals(2, invoice.LineItems.size());
	    
	    AccountingDocumentLineItem[] lineItems = invoice.LineItems;
	    AccountingDocumentLineItem lineItem = lineItems[0];
	    System.assertEquals('Hampton Inn Dec 12 - Dec 15, 2009 (4 days @ 139.32/day)', lineItem.Description);
	    
    }
    
    @isTest
    static void testEmptyResult()
    {
    	string xml = '';
    	
    	ProcessStatementXml psx = new ProcessStatementXml(xml);
	    StatementValuesDTO sv = psx.ProcessXml();
 
    }
    
    private static string testXML()
    {
      string xml = '<?xml version="1.0" encoding="UTF-8"?>';
      xml += '<statement end_date="2010-03-17T00:00:00Z" begin_date="2009-01-01T00:00:00Z">';
      xml += '  <placement><id>12232</id><name>Bettye Borum-Allen</name><claim_number>0155851611</claim_number></placement>';
      xml += '    <adjuster>';
      xml += '      <customer_id>ROYE3830</customer_id>';
      xml += '      <name>Kathy Royer</name>';
      xml += '      <company>Allstate Insurance Co.</company>';
      xml += '      <address>1200 Atwater Drive, Ste. 110</address>';
      xml += '      <city_state>Malvern, PA 19355</city_state>';
      xml += '      <phone>(800) 280-0714</phone>';
      xml += '      <fax>(866) 547-5534</fax>';
      xml += '    </adjuster>';
      xml += '<statement_summary>';
      xml += '<previous_balance>0.0</previous_balance>';
      xml += '<current_balance>-376.11</current_balance>';
      xml += '<charges>3801.64</charges>';
      xml += '<payments>3801.64</payments>';
      xml += '<credits>-376.11</credits>';
      xml += '</statement_summary>';
      xml += '<invoices>';
      xml += '<invoice date_created="2009-12-22T00:00:00Z" invoice_id="IN010190" amount="597.28">';
      xml += '<invoice_item>';
      xml += '  <description>Hampton Inn Dec 12 - Dec 15, 2009 (4 days @ 139.32/day)</description>';
      xml += '  <amount>557.28</amount>';
      xml += '</invoice_item>';
      xml += '<invoice_item>';
      xml += '  <description>CRS Hotel Service Fee</description>';
      xml += '  <amount>40.0</amount>';
      xml += '</invoice_item>';
    xml += '</invoice>';
    xml += '<invoice date_created="2010-01-08T00:00:00Z" invoice_id="IN011584" amount="2229.12">';
    xml += '  <invoice_item>';
    xml += '    <description>Hampton Inn Dec 16 - Dec 31, 2009 (16 days @ 139.32/day)</description>';
    xml += '    <amount>2229.12</amount>';
    xml += '  </invoice_item>';
    xml += '</invoice>';
    xml += '<invoice date_created="2010-01-18T00:00:00Z" invoice_id="IN012885" amount="975.24">';
    xml += '  <invoice_item>';
    xml += '    <description>Hampton Inn Jan 1 - Jan 7, 2010 (7 days @ 139.32/day)</description>';
    xml += '    <amount>975.24</amount>';
    xml += '  </invoice_item>';
    xml += '</invoice>';
    xml += '</invoices>';
    xml += '<credits>';
    xml += '<credit date_created="2010-02-11T00:00:00Z" invoice_id="CN000757" amount="-376.11">';
    xml += '  <invoice_item>';
    xml += '    <description>CR Hampton Inn Rate Decrease</description>';
    xml += '    <amount>376.11</amount>';
    xml += '  </invoice_item>';
    xml += '</credit>';
    xml += '</credits>';
    xml += '<payments>';
    xml += '<payment date_created="2010-01-27T00:00:00Z" payment_id="150698384" amount="3801.64"/>';
    xml += '</payments>';
    xml += '</statement>';
    
      return xml;
    }
}