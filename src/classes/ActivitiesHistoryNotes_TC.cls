@isTest
public class ActivitiesHistoryNotes_TC{
    public static testMethod void InsertRecords(){
        RecordType rt = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Account' AND Name='Insurance Companies'];
         Account ac8 = new Account();
         ac8.Name = 'test Account';
         ac8.type = 'Alliance - Contractor';
         ac8.recordtypeId = rt.id;
         insert ac8;
          RecordType rt2 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Contact' AND Name='Adjuster'];
                             List<Contact> conlist = new List<Contact>();
         Contact c5 = new Contact();
         c5.recordtypeId = rt2.id;
         c5.accountId = ac8.id;
         c5.lastname = 'test';
         c5.Manual_Owner_Override__c = false;
         c5.otherstate =  'NJ';
         c5.Called_In_By_Last_Deal__c  = system.today().addDays(-10);
         insert c5;
         RecordType rt3 = [SELECT id,Name 
                             FROM RecordType 
                             WHERE SobjectType='Task' AND Name='Activity'];
                             
         Task t = new Task();
         t.type = 'Feedback';
         t.subject = 'call';
         t.whoId = c5.id;
         t.OwnerId = userInfo.getUserId();
         t.status = 'Not Started';
         t.priority = 'Normal';
         t.ActivityDate = system.today();
         insert t;
         
         t.status = 'Completed';
         Task t1 = new Task();
         t1.type = 'Feedback';
         t1.subject = 'call';
         t1.whoId = c5.id;
         t1.OwnerId = userInfo.getUserId();
         t1.status = 'Not Started';
         t1.priority = 'Normal';
         t1.ActivityDate = system.today();
         insert t1;
         update t;
         Event e = new Event();
         e.type = 'Feedback';
         e.subject = 'call';
         e.whoId = c5.id;
         e.OwnerId = userInfo.getUserId();
         e.StartDateTime = system.now();
         e.EndDateTime = system.now();
         insert e;
            
            ApexPages.StandardController SC1 = new ApexPages.StandardController(c5);
            ActivitiesNotes Activities1 = New  ActivitiesNotes(SC1);
           // Activities1.activeTasks():
            Activities1.newTask();
            Activities1.newEvent();
            Activities1.activeTasks();
            Activities1.ProfileSelection = 'sales';
            ApexPages.StandardController SC = new ApexPages.StandardController(c5);
            ActivitiesHistoryNotes Activities = New  ActivitiesHistoryNotes(SC);
            Activities.ProfileSelection = 'sales';
            Activities.ProfileSelection = 'ops';
            Activities.historyTasks();
            Activities.mailMerge();
            Activities.sendEmail();
            Activities.viewAll();
            Activities.newTask();
            Activities.sendFax();
            Activities.updateFaxStatus();
            //Activities.deleteTask();
            //Activities.deleteEvent();
    }
}