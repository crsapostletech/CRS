@isTest
public class ContactOwnerUpdateHelper_TC{
    public static testMethod void InsertRecords(){
    TriggerControlSetting__c tg = new TriggerControlSetting__c(name = 'ContactOwnerUpdate', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
         insert tg; 
     RecordType rt3 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Owner_Assignment_Map__c' AND Name='RM'];
     RecordType rt4 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Owner_Assignment_Map__c' AND Name='Default RM'];
     RecordType rt5 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Owner_Assignment_Map__c' AND Name='TSM'];    
     Owner_Assignment_Map__c oa = new Owner_Assignment_Map__c();
     oa.Name = 'test';
     oa.recordtypeId = rt3.id;
     insert oa;
     
     Owner_Assignment_Map__c oa4 = new Owner_Assignment_Map__c();
     oa4.Name = 'test';
     oa4.recordtypeId = rt3.id;
     insert oa4;
     
     Owner_Assignment_Map__c oa1 = new Owner_Assignment_Map__c();
     oa1.Name = 'test';
     oa1.recordtypeId = rt4.id;
     insert oa1;
     
     
     Owner_Assignment_Map__c oa2 = new Owner_Assignment_Map__c();
     oa2.Name = 'test';
     oa2.recordtypeId = rt5.id;
     insert oa2;
     
     Owner_Territory__c om =  new Owner_Territory__c();
     om.Name = 'Test Map';
     om.Owner_Assignment__c = oa.id;
     om.Territory_Owner__c = UserInfo.getUserId();
     om.States__c = 'AK;AL';
     insert om;
     
     Owner_Territory__c om1 =  new Owner_Territory__c();
     om1.Name = 'Test Map';
     om1.Owner_Assignment__c = oa1.id;
     om1.Territory_Owner__c = UserInfo.getUserId();
     om1.States__c = 'AK;AL';
     insert om1;
     
     Owner_Territory__c om2 =  new Owner_Territory__c();
     om2.Name = 'Test Map';
     om2.Owner_Assignment__c = oa2.id;
     om2.Territory_Owner__c = UserInfo.getUserId();
     om2.States__c = 'AK;AL';
     insert om2;
     
     RecordType rt = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Account' AND Name='Insurance Companies'];
                             
     RecordType rt2 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Contact' AND Name='Adjuster'];
                             List<Contact> conlist = new List<Contact>();
                             
     Account ac = new Account();
     ac.Name = 'test Account';
     ac.type = 'Alliance - Contractor';
     ac.Contact_Owner_Override__c = 'Always RM';
     ac.recordtypeId = rt.id;
     ac.Assigned_Map__c = oa.id;
     insert ac;
     
     Account ac2 = new Account();
     ac2.Name = 'test Account';
     ac2.type = 'Alliance - Contractor';
     ac2.Contact_Owner_Override__c = 'Always RM';
     ac2.recordtypeId = rt.id;
     ac2.Assigned_Map__c = oa4.id;
     ac2.Reset_Owner_Assignment__c = true;
     insert ac2;
     
     Contact c5 = new Contact();
     c5.recordtypeId = rt2.id;
     c5.accountId = ac2.id;
     c5.lastname = 'test';
     c5.Manual_Owner_Override__c = false;
     c5.otherstate =  'NJ';
     c5.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
     insert c5;
     
     Account ac1 = new Account();
     ac1.Name = 'test Account';
     ac1.type = 'Alliance - Contractor';
     ac1.recordtypeId = rt.id;
     insert ac1;
     ac1.Reset_Owner_Assignment__c = true;
     update ac1;
     ac1.Assigned_Map__c = oa.id;
     update ac1;
     
     Contact c = new Contact();
     c.recordtypeId = rt2.id;
     c.accountId = ac.id;
     c.lastname = 'test';
     c.Manual_Owner_Override__c = false;
     c.otherstate =  'AK';
     c.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
     insert c;
     
     
     Contact c1 = new Contact();
     c1.recordtypeId = rt2.id;
     c1.lastname = 'test';
     c1.Manual_Owner_Override__c = false;
     c1.Assigned_To_Last_Deal__c = system.today().addDays(-190);
     insert c1;
     
     c.accountid = ac1.id;
     c.Assigned_To_Last_Deal__c = system.today().addDays(-190);
     ac.Contact_Owner_Override__c = '';
     c.Called_In_By_Last_Deal__c  = null;
     update c;
     
     c1.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
     c1.Assigned_To_Last_Deal__c = null;
     update c1;
     
     Contact c3 = new Contact();
     c3.recordtypeId = rt2.id;
     c3.accountId = ac.id;
     c3.lastname = 'test';
     c3.Manual_Owner_Override__c = false;
     c3.otherstate =  'AK';
     c3.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
     insert c3;
     
      
        Test.startTest();
            ContactOwnerUpdateBatch batchRef = new ContactOwnerUpdateBatch();
            Database.executeBatch(batchRef);
            ContactOwnerSchedule sh1 = new ContactOwnerSchedule();
            String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
    }
}