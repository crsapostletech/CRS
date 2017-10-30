@isTest
public class ContactTermsTest {
        
    static testMethod void myShareTest()
    {

        RecordType rt = [ select Id from RecordType where Name = 'Adjuster' ];
        
        /*
        Account a = new Account();
            
        a.name = 'State Farm Insurance';
        a.Type = 'Insurance Company';
        a.BillingCountry = 'US';
        a.BillingState = 'AZ';
        
        a.National_Account__c = 'Yes';
        a.National_Account_Name__c = 'State Farm';
    //  a.National_Account_Code__c = 'NATACT04';
        
        
        insert a;
        */
    //  Account new_a = [ select id from account where id = :a.Id ];
        
    //  System.debug('a.Id = ' + a.Id);
    //  System.debug('new_a.Id = ' + new_a.Id);
    
    

        Contact c = new Contact();
        
        c.RecordTypeId = rt.Id;
        
        c.FirstName = 'Darren';
        c.LastName = 'Kemp';
        
        c.Status__c = 'Active'; 
        
        c.Payment_Terms__c = '45';
        c.LeadSource = 'Other';
        c.MailingCountry = 'US';
        
        c.Type__c = 'Company';
        c.MailingState = 'AZ';
    //    c.Account = a;
    //  c.AccountId = a.Id;
        
        c.AccountID = '001S0000003HfcU';     
        
        try 
        {
            insert c;
            
            System.debug('Contact.AccountId = ' + c.AccountId);      
            System.assertEquals( '45', c.Payment_Terms__c); 
       
            Contact new_c = [ select id, Payment_Terms__c from contact where id = :c.Id ];
            System.assertEquals( '30', new_c.Payment_Terms__c ); 
                  
        } 
        catch (System.DmlException e)
        {
            System.debug('we caught a dml exception: ' + e.getDmlMessage(0));    
        }
       
    }
}