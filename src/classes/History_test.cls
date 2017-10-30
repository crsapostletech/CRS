@isTest
private class History_test {
	static testmethod void testNotes(){
		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Placement__c' AND DeveloperName='Hotel_Placement'].Id;
		Placement__c thisPlacement = new Placement__c();
		thisPlacement.RecordTypeId = recordTypeId;
        thisPlacement.Name = 'OBTestPlacement';
        thisPlacement.Status__c = 'Moved-In'; 
        thisPlacement.approved_through_date__c = date.newInstance(2011, 11, 18);
        thisPlacement.MHS_Booking__c = 'No';
		
		insert thisPlacement;
		
		History incidentHistory = new History(thisPlacement);
		incidentHistory.buildEntries();
		System.assertEquals(0,incidentHistory.events.size());
		
		Note newNote1 = new Note(parentId = thisPlacement.id, title = 'a new note');
		insert newNote1;
		incidentHistory.buildEntries();
		System.assertEquals(1,incidentHistory.events.size());
		
		Note newNote2 = new Note(parentId = thisPlacement.id, title = 'a second new note');
		insert newNote2;
		incidentHistory.buildEntries();
		System.assertEquals(2,incidentHistory.events.size());
		
		
		// This is to get full code coverage on the Util class
		Hotel_Room__c [] hotelRooms = [SELECT Check_In__c,CheckOut__c,Cancellation_del__c,Placement__c FROM Hotel_Room__c limit 10];
		Set<Id> test = Util.getIds(hotelRooms);
		
	}
	
	static testmethod void testActivities(){
		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Placement__c' AND DeveloperName='Hotel_Placement'].Id;
		Placement__c thisPlacement = new Placement__c();
		thisPlacement.RecordTypeId = recordTypeId;
        thisPlacement.Name = 'OBTestPlacement';
        thisPlacement.Status__c = 'Moved-In'; 
        thisPlacement.approved_through_date__c = date.newInstance(2011, 11, 18);
        thisPlacement.MHS_Booking__c = 'No';
		insert thisPlacement;
		
		History incidentHistory = new History(thisPlacement);
		incidentHistory.buildEntries();
		System.assertEquals(0,incidentHistory.events.size());
		
		Task newTask = new Task(whatId = thisPlacement.id, subject='a new Task');
		insert newTask;
		
		Event newEvent1 = new Event(whatId = thisPlacement.id,  subject='a new event', DurationInMinutes = 30, ActivityDateTime = Datetime.now());
		insert newEvent1;
		
		Event newEvent2 = new Event(whatId = thisPlacement.id,  subject='a second new event', DurationInMinutes = 30, ActivityDateTime = Datetime.now());
		insert newEvent2;
		
		incidentHistory.buildEntries();
		System.assertEquals(3,incidentHistory.events.size());  
		
	}
	
	static testmethod void testHistory(){
		//This method contains no assertions because we cannot assert that customers have field history tracking set a specific way.
	/*	Contact newContact = new Contact(LastName = 'Bob');
		
		insert newContact; */
				
		Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Placement__c' AND DeveloperName='Hotel_Placement'].Id;
			Placement__c thisPlacement = new Placement__c();
		   	thisPlacement.RecordTypeId = recordTypeId;
            thisPlacement.Name = 'OBTestPlacement';
            thisPlacement.Status__c = 'Checked-In'; 
            thisPlacement.approved_through_date__c = date.newInstance(2011, 11, 18);
           	thisPlacement.MHS_Booking__c = 'No';
        insert thisPlacement;
        
		History incidentHistory = new History(thisPlacement);
		incidentHistory.buildEntries();
		System.assertEquals(0,incidentHistory.events.size());
		
		thisPlacement.MHS_Booking__c = 'Yes';
		update thisPlacement;
		
		thisPlacement.Status__c = 'Checked-Out'; 
		update thisPlacement;
		
		Placement__history thisHistory = new Placement__history(parentId = thisPlacement.id, field = 'created');
		insert thisHistory;
		
		History.FieldHistory thisUpdate = new History.FieldHistory(null, 'oldVal', 'newVal', DateTime.now(), 'itil_b__subject__c');
		incidentHistory.injectedResults.add(thisUpdate);
		
		incidentHistory.buildEntries(); 
		System.debug('\nIncident History: '+incidentHistory.events);
		
	}
	
	static testmethod void testGeneric(){
	/*	Contact newContact = new Contact(LastName = 'Bob');
		insert newContact;  */
			Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Placement__c' AND DeveloperName='Hotel_Placement'].Id;
			Placement__c thisPlacement = new Placement__c();
		   	thisPlacement.RecordTypeId = recordTypeId;
            thisPlacement.Name = 'OBTestPlacement';
            thisPlacement.Status__c = 'Moved-In'; 
            thisPlacement.approved_through_date__c = date.newInstance(2011, 11, 18);
           	thisPlacement.MHS_Booking__c = 'No';
           
		
		insert thisPlacement;
		
		History incidentHistory = new History(thisPlacement);
		incidentHistory.buildEntries();
		System.assertEquals(0,incidentHistory.events.size());
		
	/*	itil_b__Worklog__c newWorklog = new itil_b__Worklog__c(Placement__c = thisPlacement.id, name = 'a new worklog');
		insert newWorklog;
		
		incidentHistory.buildEntries();
		System.assertEquals(1,incidentHistory.events.size());  */
	}
}