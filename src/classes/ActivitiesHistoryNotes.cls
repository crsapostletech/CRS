/* 
Created By : Kalyan
Description : VF Viewer in Contact layout, that will show Activities for the Contact
VF Pages : Contact Activities
*/
Public Class ActivitiesHistoryNotes
{
    Public Contact Con{get;set;}
    Public String ConId{get;set;} 
    Public Boolean active{get;set;}
    Public Event eid{get;set;}
    Public Task tid{get;set;}
    public String roleName{get;set;}
    public String aid{get;set;}
    Public List<Task> taskList{get;set;}
    Public List<Event> EventList{get;set;}
    Public List<Task> activeTaskList{get;set;}
    Public List<Event> activeEventList{get;set;}
    Public List<SelectOption> ProfilesList{get;set;}
    Public String ProfileSelection{get;set;}
    Public List<wrapperClass> wraplist{get;set;}
    public String eventId{get;set;}
    public String taskId{get;set;}
    Public ActivitiesHistoryNotes(ApexPages.StandardController controller)
    {
       ProfilesList = New List<SelectOption>();
       taskList  = New List<Task>();
       wraplist = new List<wrapperClass>();
       active = False;
       Con = (Contact)controller.getRecord();
       ConId = Con.Id;
       String uRoleId = UserInfo.getUserRoleId();
       System.debug('****Role****'+uRoleId);
       roleName = [select Id, Name, UserRole.Name from User where Id = :UserInfo.getUserId() And UserRoleId =: uRoleId].UserRole.Name;
       System.debug('****Role Name****'+roleName);
       contact c = [select id, AccountId from contact where id =: ConId];
       aid = c.AccountId;
       /* Profile selection options for Activities */
       ProfilesList.add(new SelectOption('','All'));
       ProfilesList.add(new SelectOption('sales','Sales'));
       ProfilesList.add(new SelectOption('ops', 'Ops'));
       if(roleName == 'Accounting Manager' || roleName == 'CRS Billing Specialist' || roleName == 'Procurement' || roleName == 'Security Deposit Team' || roleName == 'Human Resourses' || roleName == 'Inactive User' || roleName == 'IT / Sys Admin')
           ProfileSelection = 'All';
       if(roleName == 'Sales Director' || roleName == 'Business Development Manager' || roleName == 'Collections' || roleName == 'CRS Marketing' || roleName == 'Relationship Manager Supervisor' || roleName == 'Relationship Manager' || roleName == 'Territory Sales Manager' )
           ProfileSelection = 'sales';
       if(roleName == 'After Hours' || roleName == 'Operations Director' || roleName == 'Customer Care Manager' || roleName == 'Customer Care Supervisor' || roleName == 'Senior Customer Care Specialist' || roleName == 'CCS1' || roleName == 'Customer Care Specialist' || roleName == 'Hotel Customer Care Specialist' || roleName == 'Customer Experience Manager' || roleName == 'Quality Coach' || roleName == 'Relocation Services Manager' || roleName == 'Residence Specialist Supervisor' || roleName == 'Senior Residence Specialist' || roleName == 'Residence Specialist' || roleName == 'Senior VMT' || roleName == 'Vendor Management Team' || roleName == 'Training')
           ProfileSelection = 'ops';
       historyTasks();
      
    }
    /************************************* History Activities ************************************/
   
    public pagereference mailMerge(){
       PageReference mailp= new PageReference('/mail/mmchoose.jsp?id='+ConId+'&retURL='+'%2F'+ConId);
        return mailp;
    }
    
    public pagereference sendEmail(){
       PageReference emailmailp= new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ConId+'&rtype=003&retURL='+'%2F'+ConId);
        return emailmailp;
    }
    
    public pagereference viewAll(){
       PageReference view = new PageReference('/ui/core/activity/ViewAllActivityHistoryPage?retURL='+'%2F'+ConId+'&id='+ConId);
        return view;
    }
    
    public pagereference newTask(){
       DateTime dt = DateTime.now();
       String dateTimeStr = dt.format('MM/dd/yyyy hh:mm a');
       String dateOutput = dt.format('MM/dd/yyyy');
       PageReference t = new PageReference('/setup/ui/recordtypeselect.jsp?close=1&tsk4='+dateOutput+'&ent=Task&retURL=%2F'+ConId+'&00N0g000003MAep=1&00N70000003jshq='+dateTimeStr+'&00N70000003jsho='+dateTimeStr+'&save_new_url=%2F00T%2Fe%3Fwho_id%3D'+ConId+'%2600N4D000000co6Z%3D1%26retURL%3D%2F'+ConId);
        return t;
    }
    
    public pagereference newTaskAll(){
       DateTime dt = DateTime.now();
       String dateTimeStr = dt.format('MM/dd/yyyy hh:mm a');
       String dateOutput = dt.format('MM/dd/yyyy');
       PageReference t = new PageReference('/setup/ui/recordtypeselect.jsp?close=1&tsk4='+dateOutput+'&ent=Task&retURL=%2F'+ConId+'&00N70000003jshq='+dateTimeStr+'&00N70000003jsho='+dateTimeStr+'&save_new_url=%2F00T%2Fe%3Fwho_id%3D'+ConId+'%2600N4D000000co6Z%3D1%26retURL%3D%2F'+ConId);
        return t;
    }
     public pagereference sendFax(){
       PageReference view = new PageReference('https://myfaxv3.cs71.visual.force.com/apex/FaxAuthor?p2_lkid='+ConId+'&p3_lkid='+aid+'&retURL=%2F'+ConId);
        return view;
    }
    
    public pagereference updateFaxStatus(){
       PageReference t = new PageReference('https://myfaxv3.cs71.visual.force.com/apex/FaxUpdate?retURL=/'+ConId);
        return t;
    }
    
    public pagereference ArchivedActivity(){
       PageReference t = new PageReference('https://myfaxv3.cs71.visual.force.com/apex/FaxUpdate?retURL=/'+ConId);
        return t;
    }
   
    
     public pagereference goToList(){
       PageReference t = new PageReference('/007?id='+ConId+'&rlid=RelatedHistoryList&closed='+1);
       return t;
    }
    public void deleteEvent(){
       eid = new Event();
       System.debug('****Event ID ****'+eventId);
       eid = [Select id from event where id = :eventId];
       delete eid;
    }
    
    public void deleteTask(){
       tid = new Task();
       tid = [Select id from Task where id = :taskId];
       delete tid;
    }
    
    Public void historyTasks(){
        wraplist = new List<wrapperClass>();
        taskList = new List<Task>();
        EventList = new List<Event>();
         Datetime dt = system.now();
          Date d = system.today();
         String TaskHistoryQuery = 'SELECT id, createdDate,Completed_Date__c, Owner_Role__c, Placement__c, Owner.profile.Name, Due_Time__c, Placement__r.Name, Subject, Status, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, Description, LastModifiedDate FROM Task where whoId =: ConId And (isclosed = true) And ActivityDate = LAST_N_DAYS:365';
        
         String EventHistoryQuery = 'SELECT id, createdDate,Completed_Date__c, Owner_Role__c, Placement__c, Placement__r.Name, Owner.profile.Name, Subject, description, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, EndDateTime, LastModifiedDate FROM Event where whoId =: ConId And ActivityDate<= : d And ActivityDate = LAST_N_DAYS:365'; 
         
        if(ProfileSelection == 'sales')
        {
            TaskHistoryQuery += ' And Sales_Task__c = true';
            EventHistoryQuery += ' And Sales_Task__c = true';
        }
        if(ProfileSelection == 'ops')
        {
            TaskHistoryQuery += ' And Sales_Task__c = false';
            EventHistoryQuery += ' And Sales_Task__c = false';
        }
        system.debug('Kalyan'+TaskHistoryQuery);
         TaskHistoryQuery = TaskHistoryQuery + ' order by createdDate';
        EventHistoryQuery = EventHistoryQuery + ' order by createdDate';
        taskList = database.query(TaskHistoryQuery);
        EventList = database.query(EventHistoryQuery); 
        
            
            for(Task t : taskList)
            {
                wrapperclass w = new wrapperclass();
                w.taskinfo = t;
                w.subject = t.subject;
                w.type = t.type;
                w.relateto = t.WhatId;
                w.placement = t.Placement__c;
                w.duedate = t.Due_Time__c;
                w.dNumber = t.Due_Time__c != null ? t.Due_Time__c : t.ActivityDate;
                w.actDate = t.ActivityDate;
                w.createdDate = t.createdDate;
                w.cNumber = t.createdDate;
                w.assignedTo = t.OwnerId;
                w.completedDate = t.Completed_Date__c;
                w.comments = t.description;
                w.lastmodified = t.LastModifiedDate;
                w.isTask = true;
                wraplist.add(w);
            }
            
            for(event e : EventList)
            {
                wrapperclass w = new wrapperclass();
                w.eventinfo = e;
                w.subject = e.subject;
                w.type = e.type;
                w.relateto = e.WhatId;
                w.placement = e.Placement__c;
                //w.duedate = e.ActivityDate;
                w.duetime = e.EndDateTime;
                w.dNumber = e.EndDateTime != null ? e.EndDateTime: e.EndDateTime;
                w.createdDate = e.createdDate;
                w.cNumber = e.createdDate;
                w.assignedTo = e.OwnerId;
                w.comments = e.description;
                w.lastmodified = e.LastModifiedDate;
                w.isTask = false;
                
                wraplist.add(w);
            }
    }
    
    public class wrapperClass{
        public event eventinfo{get;set;}
        public task taskinfo{get;set;}
        public boolean isTask{get;set;}
        public String subject{get;set;}
        public String type{get;set;}
        public DateTime dNumber{get;set;}
        public DateTime cNumber{get;set;}
        public Id relateto{get;set;}
        public DateTime duedate{get;set;}
        public Date actDate{get;set;} 
        public DateTime completedDate{get;set;}
        public DateTime createdDate{get;set;}
        public DateTime duetime{get;set;}
        public Id assignedTo{get;set;}
        public String status{get;set;}
        public String comments{get;set;}
        public Id placement {get;set;}
        public DateTime lastmodified {get;set;}
    }
   
    
}