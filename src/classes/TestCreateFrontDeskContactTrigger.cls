@isTest
private class TestCreateFrontDeskContactTrigger {

    static testMethod void testInsertHotelAccount() {
        RecordType hotelAccountRecordType = [select Id, Name, DeveloperName 
																				from RecordType 
																				where SObjectType = 'Account' 
																							and DeveloperName = 'HotelAccounts'];
																							
				RecordType hotelContactRecordType = [select Id, Name, DeveloperName
																				from RecordType
																				where SObjectType = 'Contact'
																					    and DeveloperName = 'Hotel_Contact'];																			
																							
				// When we insert a hotel account, it should create a hotel contact if one does not already exist																			
				Account acct = new Account();
				acct.RecordTypeId = hotelAccountRecordType.Id;
				
				acct.Name = 'TestInsertHotelAccount';
				acct.Fax = '602-111-1234';
    		acct.Email__c = 'abc@abc.net';
    		acct.Mobile_Phone__c = '602-222-2134';
    		acct.BillingCity = 'Phoenix';
    		acct.BillingPostalCode = '85013';  
    		acct.BillingState ='AZ';
    		acct.BillingStreet = '3243 N. Nowhere Street';
    		acct.BillingCountry = 'USA';
    		 
    		insert acct;
    		
    		List<Contact> contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
															from Contact 
															where FirstName = 'Front'
           													and LastName = 'Desk'
           													and RecordTypeId = :hotelContactRecordType.Id
           													and AccountId = :acct.Id];
           													
       // we should have 1 contact    													
       System.assertEquals(1, contacts.size()); 
       
       acct.Name = 'Update Hotel Account';
       update acct;
       
       contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
															from Contact 
															where FirstName = 'Front'
           													and LastName = 'Desk'
           													and RecordTypeId = :hotelContactRecordType.Id
           													and AccountId = :acct.Id];
           													
       // we should still have 1 contact    													
       System.assertEquals(1, contacts.size()); 												
																							
    }
    
    static testMethod void createNonHotelRecordTypeAccount()
    {
    	RecordType householdAccountRecordType = [select Id, Name, DeveloperName 
																				from RecordType 
																				where SObjectType = 'Account' 
																							and DeveloperName = 'Household_Accounts'];
																							
			RecordType hotelContactRecordType = [select Id, Name, DeveloperName
																				from RecordType
																				where SObjectType = 'Contact'
																					    and DeveloperName = 'Hotel_Contact'];					
    	
    	Account acct = new Account();
			acct.RecordTypeId = householdAccountRecordType.Id;
				
			acct.Name = 'TestInsertHotelAccount';
			acct.Fax = '602-111-1234';
   		acct.Email__c = 'abc@abc.net';
    	acct.Mobile_Phone__c = '602-222-2134';
    	acct.BillingCity = 'Phoenix';
   		acct.BillingPostalCode = '85013';  
    	acct.BillingState ='AZ';
    	acct.BillingStreet = '3243 N. Nowhere Street';
    	acct.BillingCountry = 'USA';
    		 
    	insert acct;
    		
    	List<Contact> contacts = [select Id, Name, FirstName, LastName, AccountId, RecordTypeId
															from Contact 
															where FirstName = 'Front'
           													and LastName = 'Desk'
           													and RecordTypeId = :hotelContactRecordType.Id
           													and AccountId = :acct.Id];
           													
      // we shouldn't have any contacts.    													
      System.assertEquals(0, contacts.size()); 
    
    }
}