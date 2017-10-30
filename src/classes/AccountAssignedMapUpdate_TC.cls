@isTest
public class AccountAssignedMapUpdate_TC{
    public static testMethod void InsertRecords(){
    TriggerControlSetting__c tg = new TriggerControlSetting__c(name = 'AssignmentMapUserUpdate', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
         insert tg; 
    TriggerControlSetting__c tg1 = new TriggerControlSetting__c(name = 'OwnerResetUpdate', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
         insert tg1;  
         
      TriggerControlSetting__c tg2 = new TriggerControlSetting__c(name = 'DuplicateStateValidation', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
         insert tg2;     
      TriggerControlSetting__c tg3 = new TriggerControlSetting__c(name = 'inactiveUsersAssignmentUpdate', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
         insert tg3;     
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt21', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing324', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser657@testorg.com');
      insert u;
      RecordType rt21 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Owner_Assignment_Map__c' AND Name='RM'];
     Owner_Assignment_Map__c oa = new Owner_Assignment_Map__c();
     oa.Name = 'test';
     oa.recordtypeId = rt21.id;
     oa.Unassigned_State_Fallback_Owner__c = UserInfo.getUserId();
     insert oa;
     
     Owner_Territory__c om =  new Owner_Territory__c();
     om.Name = 'Test Map';
     om.Owner_Assignment__c = oa.id;
     om.Territory_Owner__c = u.id;
     om.States__c = 'AK;AL';
     insert om;
     om.States__c = 'AZ';
     update om;
     System.runAs ( new User(Id = UserInfo.getUserId()) ) {
         u.isActive = false;
         update u;
     }
     RecordType rt = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Account' AND Name='Insurance Companies'];
     Account ac8 = new Account();
     ac8.Name = 'test Account';
     ac8.type = 'Alliance - Contractor';
     ac8.recordtypeId = rt.id;
     ac8.Assigned_Map__c = oa.id;
     insert ac8;
     Account ac9 = new Account();
     ac9.Name = 'test Account';
     ac9.type = 'Alliance - Contractor';
     ac9.recordtypeId = rt.id;
     insert ac9;
     
     RecordType rt2 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Contact' AND Name='Adjuster'];
                             List<Contact> conlist = new List<Contact>();
     Contact c3 = new Contact();
     c3.recordtypeId = rt2.id;
     c3.accountId = ac9.id;
     c3.lastname = 'test';
     c3.Manual_Owner_Override__c = false;
     c3.otherstate =  'AK';
     c3.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
     insert c3;
                             
     Account ac7 = new Account();
     ac7.Name = 'test Account';
     ac7.type = 'Alliance - Contractor';
     ac7.recordtypeId = rt.id;
     insert ac7;
     Account ac6 = new Account();
     ac6.Name = 'test Account';
     ac6.type = 'Alliance - Contractor';
     ac6.recordtypeId = rt.id;
     ac6.parentId = ac7.id;
     insert ac6;
     Account ac5 = new Account();
     ac5.Name = 'test Account';
     ac5.type = 'Alliance - Contractor';
     ac5.recordtypeId = rt.id;
     ac5.parentId = ac6.id;
     insert ac5;
     Account ac4 = new Account();
     ac4.Name = 'test Account';
     ac4.type = 'Alliance - Contractor';
     ac4.recordtypeId = rt.id;
     ac4.parentId = ac5.id;
     insert ac4;
     Account ac3 = new Account();
     ac3.Name = 'test Account';
     ac3.type = 'Alliance - Contractor';
     ac3.recordtypeId = rt.id;
     ac3.parentId = ac4.id;
     insert ac3;
     Account ac2 = new Account();
     ac2.Name = 'test Account';
     ac2.type = 'Alliance - Contractor';
     ac2.recordtypeId = rt.id;
     ac2.parentId = ac3.id;
     insert ac2;
     Account ac1 = new Account();
     ac1.Name = 'test Account';
     ac1.type = 'Alliance - Contractor';
     ac1.recordtypeId = rt.id;
     ac1.parentId = ac2.id;
     insert ac1;
     Account ac = new Account();
     ac.Name = 'test Account';
     ac.type = 'Alliance - Contractor';
     ac.recordtypeId = rt.id;
     ac.parentId = ac1.id;
     insert ac;
     ac7.Assigned_Map__c = oa.id;
     update ac7;
      ac8.Reset_Owner_Assignment__c = true;
     update ac8;
    }   
}