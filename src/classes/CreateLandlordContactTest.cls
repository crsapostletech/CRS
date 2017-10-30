@isTest
private class CreateLandlordContactTest {

    static testMethod void testCreateLandlordContact() 
    {
    	RecordType landlordAccountRecordType = [select Id, Name, DeveloperName 
														from RecordType 
														where SObjectType = 'Account' 
			 											and DeveloperName = 'Landlord_Accounts'];
																							
		RecordType landlordContactRecordType = [select Id, Name, DeveloperName
														from RecordType
														where SObjectType = 'Contact'
													    and DeveloperName = 'Landlord'];																			
																						
		// When we insert a landlord account, it should create a landlord contact if one does not already exist																			
		Account acct = new Account();
		acct.RecordTypeId = landlordAccountRecordType.Id;
		
		acct.Name = 'TestInsertLandlordAccount';
		acct.Fax = '602-111-1234';
		acct.Email__c = 'abc@abc.net';
		acct.Contact_First_Name__c = 'Landlord';
		acct.Contact_Last_Name__c = 'Contact';
		acct.Mobile_Phone__c = '602-222-2134';
		acct.BillingCity = 'Phoenix';
		acct.BillingPostalCode = '85013';  
		acct.BillingState ='AZ';
		acct.BillingStreet = '3243 N. Nowhere Street';
		acct.BillingCountry = 'USA';
		acct.ShippingState = 'CT';
        acct.ShippingCountry = 'USA';
        acct.ShippingPostalCode = '11501';
        acct.ShippingCity = 'Mineola';
        acct.ShippingStreet = '134 Laurel';
        acct.Fax = '6022345675';
		 
		insert acct;
    		
		List<Contact> contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
														from Contact 
														where FirstName = 'Landlord'
       													and LastName = 'Contact'
       													and RecordTypeId = :landlordContactRecordType.Id
       													and AccountId = :acct.Id];
       													
       // we should have 1 contact    													
       System.assertEquals(1, contacts.size()); 
       
       acct.Name = 'Update Landlord Account';
       update acct;
       
       contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
															from Contact 
															where FirstName = 'Landlord'
           													and LastName = 'Contact'
           													and RecordTypeId = :landlordContactRecordType.Id
           													and AccountId = :acct.Id];
           													
       // we should still have 1 contact    													
       System.assertEquals(1, contacts.size()); 												
																							
    }    
 }