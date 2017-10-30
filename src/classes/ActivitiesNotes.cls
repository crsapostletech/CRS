/* 
Created By : Kalyan
Description : VF Viewer in Contact layout, that will show Activities for the Contact
VF Pages : Contact Activities
*/
Public Class ActivitiesNotes
{
    Public Contact Con{get;set;}
    Public String ConId{get;set;} 
    Public Boolean active{get;set;}
    Public Event tid{get;set;}
    public String roleName{get;set;}
    public String sStartdate{get;set;}
    public DateTime startDate{get;set;}
    Public List<Task> taskList{get;set;}
    Public List<Event> EventList{get;set;}
    Public List<Task> activeTaskList{get;set;}
    Public List<Event> activeEventList{get;set;}
    Public List<SelectOption> ProfilesList{get;set;}
    Public String ProfileSelection{get;set;}
    Public List<wrapperClass> wraplist{get;set;}
    public String eventId{get;set;}
    Public ActivitiesNotes(ApexPages.StandardController controller)
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
       activeTasks();
      
    }
    /************************************* Open Activities ************************************/
    public void deleteTask(){
       tid = new Event();
       System.debug('****Event ID ****'+eventId);
       tid = [Select id from event where id = :eventId];
       delete tid;
    }
    //Task Method
    
   public pagereference newTask(){
       PageReference t = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Task&retURL=%2F'+ConId+'&00N0g000003MAep=1&save_new_url=%2F00T%2Fe%3Fwho_id%3D'+ConId+'%2600N4D000000co6Z%3D1%26retURL%3D%2F'+ConId);
        return t;
    }
    
     public pagereference newTaskAll(){
       PageReference t = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Task&retURL=%2F'+ConId+'&save_new_url=%2F00T%2Fe%3Fwho_id%3D'+ConId+'%2600N4D000000co6Z%3D1%26retURL%3D%2F'+ConId);
        return t;
    }
    
    //Event Method
    
    /*public pagereference newEvent(){
       PageReference t = new PageReference('/00U/e?who_id='+ConId+'&00N0g000003MAep=1&retURL=%2F'+ConId);
        return t;
    }*/
    
     public pagereference newEventAll(){
       PageReference t = new PageReference('/00U/e?who_id='+ConId+'&retURL=%2F'+ConId);
        return t;
    }
    
     
    
    
    Public void activeTasks(){
    
        wraplist = new List<wrapperClass>();
        activeTaskList = new List<Task>();
        activeEventList = new List<Event>();
        
        startDate = DateTime.now();
        
        Date d = system.today();
        Datetime dt = system.now();
         String TaskQuery = 'SELECT id, createdDate, Owner_Role__c, Placement__c, Owner.profile.Name, Due_Time__c, Placement__r.Name, Subject, Status, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, Description, LastModifiedDate FROM Task where whoId =: ConId and Status != \'Completed\''; 
        
         String EventQuery = 'SELECT id, createdDate , Owner_Role__c, Placement__c, Owner.profile.Name, Placement__r.Name, Subject, EndDateTime, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, Description, StartDateTime, LastModifiedDate FROM Event where whoId =: ConId And (Activitydate = null or StartDateTime >= : dt )'; 
         
        if(ProfileSelection == 'sales')
        {
            TaskQuery += ' And Sales_Task__c = true';
            EventQuery += ' And Sales_Task__c = true';
        }
        if(ProfileSelection == 'ops')
        {
            TaskQuery += ' And Sales_Task__c = false';
            EventQuery += ' And Sales_Task__c = false';
        }
        system.debug('Kalyan'+TaskQuery);
         TaskQuery = TaskQuery + ' order by createdDate';
        EventQuery = EventQuery + ' order by createdDate';
        activeTaskList = database.query(TaskQuery);
        activeEventList = database.query(EventQuery); 
        
            
            for(Task t : activeTaskList)
            {
                wrapperclass w = new wrapperclass();
                w.taskinfo = t;
                w.subject = t.subject;
                w.type = t.type;
                w.relateto = t.WhatId;
                w.actDate = t.ActivityDate;
                w.dNumber = t.Due_Time__c != null ? t.Due_Time__c : t.ActivityDate;
                w.placement = t.Placement__c;
                w.duedate = t.Due_Time__c;
                w.createdDate = t.createdDate;
                w.cNumber = t.createdDate;
                w.assignedTo = t.OwnerId;
                w.status = t.status;
                w.comments = t.description;
                w.isTask = true;
                wraplist.add(w);
            }
            
            for(event e : activeEventList)
            {
                wrapperclass w = new wrapperclass();
                w.eventinfo = e;
                w.subject = e.subject;
                w.type = e.type;
                w.duetime = e.EndDateTime;
                w.dNumber = e.EndDateTime != null ? e.EndDateTime: e.EndDateTime;
                w.relateto = e.WhatId;
                w.placement = e.Placement__c;
                //w.duedate = e.ActivityDate;
                w.createdDate = e.createdDate;
                w.cNumber = e.createdDate;
                w.assignedTo = e.OwnerId;
                w.status = '';
                w.comments = e.description;
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
        public Id relateto{get;set;}
        public DateTime duedate{get;set;}
        public Date actDate{get;set;} 
        public DateTime createdDate{get;set;}
        public Id assignedTo{get;set;}
        public String status{get;set;}
        public DateTime dNumber{get;set;}
        public DateTime cNumber{get;set;}
        public String comments{get;set;}
        public DateTime duetime{get;set;}
        public Id placement {get;set;}
    }
   /****Activity History****/
  
  
   Public void historyTasks(){
   }
   
    
}