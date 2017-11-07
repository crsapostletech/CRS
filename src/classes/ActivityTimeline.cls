/* 
Created By : Kalyan
Description : VF Viewer in Contact layout, that will show Activities for the Contact
VF Pages : Contact Activities
*/
Public Class ActivityTimeline
{

  
    public ActivityTimeline() {

    }

    Public Opportunity opp{get;set;}
    Public String opId{get;set;}
    Public ServiceRequest__c srRec{get;set;}
    Public String srId{get;set;}
    public String claim{get;set;}
    Set <id> serClaimIds = new Set<id>();
    Public String srRequestClaim{get;set;}
    Public Event eid{get;set;}
    Public Task tid{get;set;}
    Public String conId{get;set;}
    Public Note nid{get;set;}
    public String cid{get;set;}
    public List<ServiceRequest__c> srList{get;set;}
    public List<smagicinteract__smsMagic__c> smsHistoryList{get;set;}
    public List<smagicinteract__Incoming_SMS__c> incomingList{get;set;}
    Public List<Task> taskList{get;set;}
    Public List<Event> EventList{get;set;}
    Public List<Note> notList{get;set;}
    Public List<wrapperClass> wraplist{get;set;}
    public String eventId{get;set;}
    public String taskId{get;set;}
    set<id> srids = new set<id>();
    set<id> smsids = new set<id>();
    set<id> incids = new set<id>();
    Public ActivityTimeline(ApexPages.StandardController controller)
    {
       taskList  = New List<Task>();
       notList = new List<note>();
       EventList = new List<Event>();
      // srRec= new 
       smsHistoryList = new List<smagicinteract__smsMagic__c>();
       incomingList = new List<smagicinteract__Incoming_SMS__c>();
       wraplist = new List<wrapperClass>();
       opp= (opportunity)controller.getRecord();
       opId = opp.Id;
       if(opId == null){           
           opId = ApexPages.currentPage().getParameters().get('claimId');
           srId = ApexPages.currentPage().getParameters().get('serReqId');
       }
       
       opportunity oid = [select id, Name, Policyholder__c from Opportunity where id =: opId];
       conId = oid.Policyholder__c;
       claim = oid.Name;
       srList = [select id,  OwnerId, Owner.Name, Opportunity__c from ServiceRequest__c where Opportunity__c =: opId];         
       
       for(ServiceRequest__c  s : srList){
           srids.add(s.id);
       }
       
       smsHistoryList = [select id, Name, smagicinteract__SMSText__c, smagicinteract__Contact__c, LastModifiedDate, createdDate, OwnerId, Owner.Name from smagicinteract__smsMagic__c where smagicinteract__Contact__c =: conId ];
      
      incomingList = [select id, name, createdDate, OwnerId, smagicinteract__SMS_Text__c, Owner.Name, LastModifiedDate, smagicinteract__Contact__c from smagicinteract__Incoming_SMS__c where smagicinteract__Contact__c =: conId ];
           
       historyTasks();
      
    }
    /************************************* History Activities ************************************/
   
    
    
    
    
    
    Public void historyTasks(){
        wraplist = new List<wrapperClass>();
        taskList = new List<Task>();
        EventList = new List<Event>();
        notList = new List<Note>();
        
         Datetime dt = system.now();
         Date d = system.today();
         String TaskHistoryQuery = 'SELECT id, createdDate,Completed_Date__c, Owner_Role__c, Placement__c, Owner.profile.Name, Due_Time__c, Placement__r.Name, Subject, Status, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, Description, LastModifiedDate FROM Task where (whatId =: opId or whatId =: srids) And (isclosed = true) '; 
        
         String EventHistoryQuery = 'SELECT id, createdDate,Completed_Date__c, Owner_Role__c, Placement__c, Placement__r.Name, Owner.profile.Name, Subject, description, Sales_Task__c, OwnerId, type, Owner.Name, Who.Name, WhoId, What.Name, WhatId, ActivityDate, EndDateTime, LastModifiedDate FROM Event where (whatId =: opId or whatId =: srids) And ActivityDate<= : d '; 
         
         String NotesHistoryQuery = 'SELECT id, ParentID, LastModifiedDate, title,Parent.Name, Owner.Name, createdDate, Body FROM Note WHERE (ParentID =: opId or ParentID =: srids)';
         
         
        notList = database.query(NotesHistoryQuery);
        taskList = database.query(TaskHistoryQuery);
        System.debug(notList.size()+'*****'+NotesHistoryQuery);
        System.debug(taskList.size()+'*****'+TaskHistoryQuery);
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
                String s1 = String.valueof(t.WhatId);
                if(string.isNotBlank(s1) && s1.startsWith('006')){
                    w.origin = 'Claim';
                }
                if(s1 != null && s1.startsWith('a0P')){
                    w.origin = 'Service Request';
                }
                w.conName = t.WhoId;
                w.actDate = t.ActivityDate;
                w.createdDate = t.createdDate;
                w.cNumber = t.createdDate;
                w.assignedTo = t.OwnerId;
                w.completedDate = t.Completed_Date__c;
                w.comments = t.description;
                w.lastmodified = t.LastModifiedDate;
                w.lNumber = t.LastModifiedDate;
                w.isTask = true;
                w.isevent = false;
                w.isNote = false;
                w.smshis = false;
                w.incoming = false;
                wraplist.add(w);
            }
            
            for(event e : EventList)
            {
                wrapperclass w = new wrapperclass();
                w.eventinfo = e;
                w.subject = e.subject;
                String s1 = String.valueof(e.WhatId);
                if(s1.startsWith('006')){
                    w.origin = 'Claim';
                }
                if(s1.startsWith('a0P')){
                    w.origin = 'Service Request';
                }
                w.type = e.type;
                w.relateto = e.WhatId;
                w.conName = e.WhoId;
                w.placement = e.Placement__c;
                //w.duedate = e.ActivityDate;
                w.duetime = e.EndDateTime;
                w.dNumber = e.EndDateTime != null ? e.EndDateTime: e.EndDateTime;
                w.createdDate = e.createdDate;
                w.assignedTo = e.OwnerId;
                w.comments = e.description;
                w.lastmodified = e.LastModifiedDate;
                w.lNumber = e.LastModifiedDate;
                w.isTask = false;
                w.isevent = true;
                w.isNote = false;
                w.smshis = false;
                w.incoming = false;
                wraplist.add(w);
            }
            
            for(Note a : notList)
            {
                wrapperclass w = new wrapperclass();
                w.notinfo = a;
                w.parent = a.ParentId;
                w.notName = a.Title;
                w.notType = a.Body;
                String s1 = String.valueof(a.parentId);
                if(s1.startsWith('006')){
                    w.origin = 'Claim';
                }
                if(s1.startsWith('a0P')){
                    w.origin = 'Service Request';
                }
                w.createdDate = a.createdDate;
                w.cNumber = a.createdDate;
                w.assignedTo = a.OwnerId;
                w.lastmodified = a.LastModifiedDate;
                w.lNumber = a.LastModifiedDate;
                w.isTask = false;
                w.isevent = false;
                w.isNote = true;
                w.smshis = false;
                w.incoming = false;
                wraplist.add(w);
            }
            
            for(smagicinteract__Incoming_SMS__c insms : incomingList)
            {
                wrapperclass w = new wrapperclass();
                w.inInfo = insms;
                w.inName = insms.Name;
                w.createdDate = insms.createdDate;
                w.cNumber = insms.createdDate;
                String s1 = String.valueof(insms.id);
                if(s1.startsWith('a18')){
                    w.origin = 'Incoming SMS';
                }
                w.conName = insms.smagicinteract__Contact__c;
                w.comments  = insms.smagicinteract__SMS_Text__c;
                w.assignedTo = insms.OwnerId;
                w.lastmodified = insms.LastModifiedDate;
                w.lNumber = insms.LastModifiedDate;
                w.isTask = false;
                w.isevent = false;
                w.isNote = false;
                w.incoming = true;
                w.smshis = false;
                wraplist.add(w);
            }
            
            for(smagicinteract__smsMagic__c smsh : smsHistoryList)
            {
                wrapperclass w = new wrapperclass();
                w.smsInfo = smsh;
                w.inName = smsh.Name;
                w.createdDate = smsh.createdDate;
                w.cNumber = smsh.createdDate;
                String s1 = String.valueof(smsh.id);
                if(s1.startsWith('a1Q')){
                    w.origin = 'SMS History';
                }
                w.comments  = smsh.smagicinteract__SMSText__c;
                w.conName = smsh.smagicinteract__Contact__c;
                w.assignedTo = smsh.OwnerId;
                w.lastmodified = smsh.LastModifiedDate;
                w.lNumber = smsh.LastModifiedDate;
                w.isTask = false;
                w.isevent = false;
                w.isNote = false;
                w.incoming = false;
                w.smshis = true;
                wraplist.add(w);
            }
    }
    
    public class wrapperClass{
        public event eventinfo{get;set;}
        public task taskinfo{get;set;}
        public note notinfo{get;set;}
        Public String origin{get;set;}
        public smagicinteract__smsMagic__c smsInfo{get;set;}
        Public smagicinteract__Incoming_SMS__c inInfo{get;set;}
        Public Id conName{get;set;}
        public String inName{get;set;}
        public String notName{get;set;}
        public String notType{get;set;}
        Public Id parent{get;set;}
        public DateTime dNumber{get;set;}
        public DateTime cNumber{get;set;}
        public DateTime lNumber{get;set;}
        public boolean isTask{get;set;}
        public boolean isevent{get;set;}
        public boolean isNote{get;set;}
        public boolean incoming{get;set;}
        public boolean smshis{get;set;}
        public String subject{get;set;}
        public String type{get;set;}
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