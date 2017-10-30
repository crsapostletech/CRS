/*******************************************************************************************
Developed by: Apostletech team
Purpose: Helper class for trigger on ServiceRequest__c object to, 
1. To update First Service Request ID field in Opportunity(Claim)
2. To Update Hotel Options and Book Hotel tasks status to "Deferred" when the hold check is selected
3. To create or Update Hotel Options and Book Hotel tasks status to "In Progress" when the hold checkbox is unchecked
4. To delete Tasks when Service Request status is "Lost Opportunity"
5. To assign open activities to new user selected in "Initial_SR_being_worked_by__c" field in Service Request

Test class: ServiceRequestTrigger_TC
*******************************************************************************************/
Public class ServiceRequestTriggerHelper{
    
    // To update First Service Request ID field in Opportunity(Claim)
    // ************************************* START *****************************************************************
    Public static void updateFirstServiceRequestIDInClaim(List<ServiceRequest__c> serviceRequestList){
        
        Set<Id> claimIds = new Set<Id>();
        Id hotelRecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        
        for(ServiceRequest__c S : serviceRequestList){
            if(S.Opportunity__c != null && S.recordTypeId == hotelRecordTypeId){
                claimIds.add(S.Opportunity__c);
            }
        }
        
        if(!claimIds.isEmpty()){
            
            List<Opportunity> oppList = [Select Id, First_Service_Request_ID__c from Opportunity where Id in: claimIds];
            List<ServiceRequest__c> existSerReqList = [Select Id, Opportunity__c from ServiceRequest__c where Opportunity__c in: claimIds AND Opportunity__r.Initial_Service_Request__c = 'Hotel' AND RecordType.name = 'Hotel' order by CreatedDate ASC];
            
            List<Opportunity> oppUpdateList = new List<Opportunity>();
            
            for(Opportunity opp : oppList){
                for(ServiceRequest__c S : existSerReqList){
                    if(opp.Id == S.Opportunity__c){
                        if(opp.First_Service_Request_ID__c != S.Id){     
                            opp.First_Service_Request_ID__c = S.Id;
                            oppUpdateList.add(opp);
                        }    
                        break;
                    }
                }
            }
            
            if(!oppUpdateList.isEmpty()){
                update oppUpdateList;
            }
            
        }
        
    }
    // ************************************* END *****************************************************************
    
    
    // To create or update Hotel Options and Book Hotel tasks when unhold Service Request
    // To Change Hotel Options and Book Hotel tasks status to Deferred when hold Service Request
    // To create "Hotel Needed-Hold Follow Up Call to PH" task when Service Request Hold
    // To update "Hotel Needed-Hold Follow Up Call to PH" task Due Date and Due time when Hold Followup Date changed on Hold Service request
    Public static void updateTaskStatusOnHoldChange(List<ServiceRequest__c> serviceRequestList, Map<Id,ServiceRequest__c> sReqOldMap, boolean isInsert){
        
        Set<id> serviceRequestHoldIds = new Set<id>();  // To store Hold service request ids 
        Set<id> serviceRequestUnHoldIds = new Set<id>(); // To store UnHold service request ids
        Set<Id> oppIds = new Set<Id>();
        Set<Id> serviceRequestHoldFollowDateChangedIds = new Set<Id>();
        Id hotelRecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();          
        
        for(ServiceRequest__c servicerequest : serviceRequestList){
            
            if(servicerequest.recordTypeId == hotelRecordTypeId && servicerequest.Status__c != 'Lost Opportunity' && (isInsert || (!isInsert && servicerequest.Hold__c != sReqOldMap.get(servicerequest.Id).Hold__c || servicerequest.Initial_Contact_Date__c != sReqOldMap.get(servicerequest.Id).Initial_Contact_Date__c))){
                
                // When service request hold
                if(servicerequest.Hold__c == true){
                    serviceRequestHoldIds.add(servicerequest.id);
                    oppIds.add(servicerequest.Opportunity__c);
                }          
                
                // When service request unhold
                if(servicerequest.Hold__c == false){
                    serviceRequestUnHoldIds.add(servicerequest.id);
                    if(servicerequest.Opportunity__c != null) 
                        oppIds.add(servicerequest.Opportunity__c);
                }
            }  
            
            // When HoldfollowDate changed on Hold service request
            if(!isInsert && servicerequest.Hold__c && servicerequest.Status__c != 'Lost Opportunity' && servicerequest.Hold__c == sReqOldMap.get(servicerequest.Id).Hold__c && servicerequest.Hold_Follow_Up_Date__c != null && servicerequest.Hold_Follow_Up_Date__c != sReqOldMap.get(servicerequest.Id).Hold_Follow_Up_Date__c){
                serviceRequestHoldFollowDateChangedIds.add(servicerequest.id);
                oppIds.add(servicerequest.Opportunity__c);
            } 
        }
        
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id, Initial_Service_Request__c, Customer_Care_Specialist__c,Hotel_Customer_Care_Specialist__c, Policyholder__c, First_Service_Request_ID__c from Opportunity where Id in: oppIds]);  
        
        // When service request unhold
        if(!serviceRequestUnHoldIds.isEmpty()){           
            
            
            list<task> taskrecords = [select id, Status, Subject, WhatId, activityDate, Due_Time__c from Task where WhatId in: serviceRequestUnHoldIds AND (Subject = 'Hotel Options' OR Subject = 'Book Hotel')];    
            
            for(ServiceRequest__c servicerequest : serviceRequestList){
                
                if(servicerequest.recordTypeId == hotelRecordTypeId && servicerequest.Status__c != 'Lost Opportunity' && servicerequest.Opportunity__c != null && oppMap.get(servicerequest.Opportunity__c) != null && oppMap.get(servicerequest.Opportunity__c).First_Service_Request_ID__c == servicerequest.Id && servicerequest.Hold__c == false && (isInsert || (!isInsert && (servicerequest.Hold__c != sReqOldMap.get(servicerequest.Id).Hold__c || servicerequest.Initial_Contact_Date__c != sReqOldMap.get(servicerequest.Id).Initial_Contact_Date__c )))){
                    
                    if(servicerequest.Opportunity__c != null && oppMap.get(servicerequest.Opportunity__c).Initial_Service_Request__c == 'Hotel' && oppMap.get(servicerequest.Opportunity__c).Hotel_Customer_Care_Specialist__c != null){ 
                        
                        boolean isFoundHotelOptionTask = false;
                        boolean isFoundBookHotelTask = false;
                        
                        if(!isInsert){    
                            for(Task t: taskrecords){ 
                                if(servicerequest.Id == t.whatId){
                                    
                                    if(!isInsert && servicerequest.Hold__c != sReqOldMap.get(servicerequest.Id).Hold__c && t.Status != 'Completed'){                                             
                                        
                                        t.Status = 'In Progress';
                                        Integer currentHour = System.now().hour();
                                        Date activityDate;                                           
                                        if(currentHour < 17){
                                            activityDate = Date.toDay();        
                                        }
                                        else{
                                            activityDate = Date.toDay().addDays(1);
                                        }
                                        
                                        t.activityDate = activityDate;
                                        t.Due_Time__c = DateTime.newInstance(activityDate.year(), activityDate.month(), activityDate.day(), 17, 0, 0);
                                    }
                                    
                                    if(t.Subject == 'Hotel Options'){
                                        isFoundHotelOptionTask = true;
                                    }                                               
                                    if(t.Subject == 'Book Hotel'){
                                        isFoundBookHotelTask = true;
                                    }    
                                }    
                            }
                        }
                        
                        System.debug(isFoundHotelOptionTask+' ///////// ********** '+isFoundBookHotelTask);
                        
                        if(!isFoundHotelOptionTask){
                            
                            Task tRec = new Task();
                            tRec.ActivityDate = Date.toDay();
                            tRec.Due_Time__c = System.now().addHours(1);
                            if(servicerequest.Initial_SR_being_worked_by__c != null)
                                tRec.OwnerId = servicerequest.Initial_SR_being_worked_by__c;
                            else
                                tRec.OwnerId = oppMap.get(servicerequest.Opportunity__c).Hotel_Customer_Care_Specialist__c;
                            tRec.Priority = 'Normal';
                            tRec.Service_Request__c = servicerequest.Id;
                            tRec.WhatID = servicerequest.Id;
                            tRec.Status = 'Not Started';
                            tRec.Subject = 'Hotel Options';                                       
                            tRec.Type = 'Placement';
                            trec.WhoId = oppMap.get(servicerequest.Opportunity__c).Policyholder__c;
                            
                            taskrecords.add(trec);                                   
                        }
                        if(!isFoundBookHotelTask && servicerequest.Initial_Contact_Date__c != null){
                            
                            Task tRec = new Task();
                            tRec.ActivityDate = Date.toDay();
                            //tRec.Due_Time__c = servicerequest.Initial_Contact_Date__c.addHours(2);// Commented by vinod
                            tRec.Due_Time__c = servicerequest.createddate.addHours(1);
                            if(servicerequest.Initial_SR_being_worked_by__c != null)
                                tRec.OwnerId = servicerequest.Initial_SR_being_worked_by__c;
                            else
                                tRec.OwnerId = oppMap.get(servicerequest.Opportunity__c).Hotel_Customer_Care_Specialist__c;                                       
                            tRec.Priority = 'Normal';
                            tRec.Service_Request__c = servicerequest.Id;
                            tRec.WhatID = servicerequest.Id;
                            tRec.Status = 'Not Started';
                            tRec.Subject = 'Book Hotel';                                       
                            tRec.Type = 'Placement';
                            trec.WhoId = oppMap.get(servicerequest.Opportunity__c).Policyholder__c;
                            
                            taskrecords.add(trec);                                   
                        }
                    }       
                }    
            }
            
            if(!taskrecords.isEmpty())
                upsert taskrecords ;
            
        }
        
        // When service request is hold
        if(Trigger.isUpdate && !serviceRequestHoldIds.isEmpty()){
            
            list<task> taskrecords = [select id, Status from Task where WhatId in: serviceRequestHoldIds AND (Subject = 'Hotel Options' OR Subject = 'Book Hotel') AND Status != 'Completed'];
            
            for(Task t: taskrecords){
                
                t.Status = 'Deferred';              
            }
            if(!taskrecords.isEmpty()) 
                update taskrecords;
        } 
        
        // To create "Hotel Needed-Hold Follow Up Call to PH" task when Service request on hold
        List<Task> callPHTaskINsertList = new List<Task>();
        
        if(!serviceRequestHoldIds.isEmpty()){
            for(ServiceRequest__c servicerequest : serviceRequestList){
                
                if(servicerequest.recordTypeId == hotelRecordTypeId && servicerequest.Status__c != 'Lost Opportunity' && servicerequest.Opportunity__c != null && oppMap.get(servicerequest.Opportunity__c) != null && oppMap.get(servicerequest.Opportunity__c).First_Service_Request_ID__c == servicerequest.Id  && servicerequest.Hold__c == true && servicerequest.Hold_Follow_Up_Date__c != null && (isInsert || (!isInsert && servicerequest.Hold__c != sReqOldMap.get(servicerequest.Id).Hold__c))){
                    if(servicerequest.Opportunity__c != null && oppMap.get(servicerequest.Opportunity__c).Initial_Service_Request__c == 'Hotel'){
                        
                        Task tRec = new Task();                               
                        
                        Integer currentHour = System.now().hour();
                        if(currentHour < 17){
                            tRec.ActivityDate = servicerequest.Hold_Follow_Up_Date__c;                                   
                            tRec.Due_Time__c = DateTime.newInstance(servicerequest.Hold_Follow_Up_Date__c.year(), servicerequest.Hold_Follow_Up_Date__c.month(), servicerequest.Hold_Follow_Up_Date__c.day(), 17, 0, 0);                                   
                        }
                        else{
                            Date nextDayDate = servicerequest.Hold_Follow_Up_Date__c.addDays(1);
                            DateTime dueDateTime = DateTime.newInstance(nextDayDate.year(), nextDayDate.month(), nextDayDate.day(), 17, 0, 0);                                   
                            
                            tRec.ActivityDate = servicerequest.Hold_Follow_Up_Date__c.addDays(1);
                            tRec.Due_Time__c = dueDateTime;
                        }                               
                        if(servicerequest.Initial_SR_being_worked_by__c != null)
                            tRec.OwnerId = servicerequest.Initial_SR_being_worked_by__c;
                        else
                            tRec.OwnerId = oppMap.get(servicerequest.Opportunity__c).Hotel_Customer_Care_Specialist__c;
                        tRec.Priority = 'Normal';
                        tRec.Service_Request__c = servicerequest.Id;
                        tRec.WhatID = servicerequest.Id;
                        tRec.Status = 'Not Started';
                        tRec.Subject = 'Hotel Needed-Hold Follow Up Call to PH';                               
                        tRec.Type = 'Hold Follow Up';
                        trec.WhoId = oppMap.get(servicerequest.Opportunity__c).Policyholder__c;                               
                        
                        callPHTaskINsertList.add(trec);    
                    }
                }
            }
            
            if(!callPHTaskINsertList.isEmpty())
                insert callPHTaskINsertList;
            
        }
        
        
        // To update Tasks due date due time when Hold followup date changed on Service Request
        if(!serviceRequestHoldFollowDateChangedIds.isEmpty()){
            
            List<Task> holdTaskList = [Select Id, whatId, ActivityDate, Due_Time__c from Task where whatId in: serviceRequestHoldFollowDateChangedIds AND Subject = 'Hotel Needed-Hold Follow Up Call to PH' order by CreatedDate DESC ];
            if(!holdTaskList.isEmpty()){
                
                for(ServiceRequest__c servicerequest : serviceRequestList){
                    if(servicerequest.recordTypeId == hotelRecordTypeId && servicerequest.Status__c != 'Lost Opportunity' && servicerequest.Opportunity__c != null && oppMap.get(servicerequest.Opportunity__c) != null && oppMap.get(servicerequest.Opportunity__c).First_Service_Request_ID__c == servicerequest.Id  && !isInsert && servicerequest.Hold__c && servicerequest.Hold__c == sReqOldMap.get(servicerequest.Id).Hold__c && servicerequest.Hold_Follow_Up_Date__c != null && servicerequest.Hold_Follow_Up_Date__c != sReqOldMap.get(servicerequest.Id).Hold_Follow_Up_Date__c){
                        
                        Integer currentHour = System.now().hour();
                        Date activityDate; 
                        
                        if(currentHour < 17){
                            activityDate = servicerequest.Hold_Follow_Up_Date__c;
                        }
                        else{
                            activityDate = servicerequest.Hold_Follow_Up_Date__c.addDays(1);
                        }
                        
                        for(Task T : holdTaskList){
                            if(servicerequest.Id == T.whatId){
                                T.ActivityDate = activityDate;
                                T.Due_Time__c = DateTime.newInstance(activityDate.year(), activityDate.month(), activityDate.day(), 17, 0, 0);
                                break;
                            }
                        }
                        
                        update holdTaskList;
                    }
                }
            }
        }
        
    }// method end
    
    //To delete Tasks when Service Request status is "Lost Opportunity"
    Public static void deleteTasksWhenStatusLost(List<ServiceRequest__c> serviceRequestList, Map<Id,ServiceRequest__c> sReqOldMap){
        
        Set<Id> serviceReqIds = new Set<Id>();
        Id hotelRecordTypeId = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        
        for(ServiceRequest__c S : serviceRequestList){
            if(S.Status__c == 'Lost Opportunity' && S.Status__c != sReqOldMap.get(S.Id).Status__c && S.recordTypeId == hotelRecordTypeId){
                serviceReqIds.add(S.Id);
            }
        }
        
        if(!serviceReqIds.isEmpty()){
            List<Task> deleteTaskList = [Select Id from Task where WhatId in: serviceReqIds AND Status != 'Completed'];
            if(!deleteTaskList.isEmpty())
                delete deleteTaskList;
        }
        
    }
    
    // To assign open activities to new user selected in "Initial_SR_being_worked_by__c" field in Service Request
    Public static void reassignOpenTasksToInitialSRBeingWorked(List<ServiceRequest__c> serviceRequestList, Map<Id,ServiceRequest__c> sReqOldMap){
        
        Set<Id> servReqIds = new Set<Id>();
        
        for(ServiceRequest__c S : serviceRequestList){
            if(S.Initial_SR_being_worked_by__c != sReqOldMap.get(S.Id).Initial_SR_being_worked_by__c && S.Initial_SR_being_worked_by__c != null){
                servReqIds.add(S.Id);
            }
        }   
        
        if(!servReqIds.isEmpty()){                
            List<Task> taskRecordsList = [Select Id, whatId, OwnerId from Task where whatId in: servReqIds AND Status != 'Completed' AND (Subject = 'Hotel Options' OR Subject = 'Book Hotel' OR Subject = 'Hotel Needed-Hold Follow Up Call to PH' OR Subject = 'Send Temporary Housing Agreement(THA)' OR Subject = 'Send Credit Card Authorization (CCA)' OR Subject = 'Send Adjuster Confirmation' OR Subject LIKE '%Call Attempt%' OR Subject LIKE '%Hotel IC Attempt%' OR Subject = 'Confirm Receipt of CCA') ];
            
            for(ServiceRequest__c S : serviceRequestList){
                if(S.Initial_SR_being_worked_by__c != sReqOldMap.get(S.Id).Initial_SR_being_worked_by__c && S.Initial_SR_being_worked_by__c != null){
                    for(Task t : taskRecordsList){
                        if(S.Id == t.whatId){
                            t.OwnerId = S.Initial_SR_being_worked_by__c;
                        }
                    }
                }
            }
            
            if(!taskRecordsList.isEmpty()){
                update taskRecordsList;
            }
            
        }            
    }
    // To Create ServiceRequest (Before Insert)
    Public static void ServiceRequestCreation(list<ServiceRequest__c> serviceRequestRecordsList)
    {
        Set<Id> claimIds = new Set<Id>();
        
        for (ServiceRequest__c serviceRequest : serviceRequestRecordsList) 
        {
            claimIds.add(ServiceRequest.Opportunity__c);
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select Id,Customer_Care_Specialist__r.Email,Regional_Manager__r.Email,
                                                              Area_Specialist__r.Email,Housing_Coordinator__r.Email,
                                                              Hotel_Customer_Care_Specialist__r.Email from Opportunity 
                                                              where Id =: claimIds]);
        if(oppMap.size()>0)
        {
            for (ServiceRequest__c serviceRequest : serviceRequestRecordsList) 
            {
                serviceRequest.Customer_Care_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Customer_Care_Specialist__r.Email;
                serviceRequest.Regional_Manager_Email__c = oppMap.get(serviceRequest.Opportunity__c).Regional_Manager__r.Email;
                serviceRequest.Area_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Area_Specialist__r.Email;
                serviceRequest.Housing_Coordinator_Email__c = oppMap.get(serviceRequest.Opportunity__c).Housing_Coordinator__r.Email;
                serviceRequest.Hotel_Customer_Care_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Hotel_Customer_Care_Specialist__r.Email;
            }
        }
    } 
    // We have moved this class from UpdateCostsandFurnitureOnATPorPTPChange After Update
    Public Static void UpdateCostsandFurnitureOnATPorPTPChange(list<ServiceRequest__c> serviceRequestRecordsList,Map<Id,ServiceRequest__c> sReqOldMap)
    {
        Set<Id> serviceRequestIds = new Set<Id>();
        
        for (ServiceRequest__c ServiceRequest : serviceRequestRecordsList)    
        {
            if(sReqOldMap <> null)
            if (sReqOldMap.get(ServiceRequest.id).Adjuster_to_Pay__c != ServiceRequest.Adjuster_to_Pay__c && ServiceRequest.Adjuster_to_Pay__c != 'Will not Pay' ||
                sReqOldMap.get(ServiceRequest.id).Policyholder_to_Pay__c != ServiceRequest.Policyholder_to_Pay__c && (ServiceRequest.Policyholder_to_Pay__c != 'Will not Pay' || ServiceRequest.Policyholder_to_Pay__c != '')                                                                                                                          )
            {
                
                serviceRequestIds.add(ServiceRequest.Id);
            }
            
        }
        Costs__c [] costs = [select Id,RecordType.Name,Searches__r.Service_Request__r.Adjuster_to_Pay__c,Searches__r.Service_Request__r.Policyholder_to_Pay__c,Searches__r.Service_Request__r.Opportunity__r.Adjuster__c,Searches__r.Service_Request__r.Opportunity__r.Policyholder__c,Billable_Party__c from costs__c where Searches__r.Service_Request__c = : serviceRequestIds and Searches__r.Placement__r.Status__c in ('Searching','Viewing','Pending Confirmation')];
        for (costs__c cost : costs)
        {
            if (cost.RecordType.Name == 'Deposit')
            {
                if (cost.Searches__r.Service_Request__r.Adjuster_to_Pay__c == 'Deposits and Fees' || cost.Searches__r.Service_Request__r.Adjuster_to_Pay__c == 'Deposits')
                {
                    if (cost.Billable_Party__c == cost.Searches__r.Service_Request__r.Opportunity__r.Policyholder__c)
                    {
                        cost.Billable_Party__c = cost.Searches__r.Service_Request__r.Opportunity__r.Adjuster__c;
                        
                    }
                }
                else
                {
                    if (cost.Searches__r.Service_Request__r.Policyholder_to_Pay__c == 'Deposits and Fees' || cost.Searches__r.Service_Request__r.Policyholder_to_Pay__c == 'Deposits')
                    {
                        if (cost.Billable_Party__c == cost.Searches__r.Service_Request__r.Opportunity__r.Adjuster__c)
                        {
                            cost.Billable_Party__c = cost.Searches__r.Service_Request__r.Opportunity__r.Policyholder__c;
                            
                        }
                    }
                }
            }
            else
            {
                if (cost.RecordType.Name == 'Fee')
                {
                    if (cost.Searches__r.Service_Request__r.Adjuster_to_Pay__c == 'Deposits and Fees' || cost.Searches__r.Service_Request__r.Adjuster_to_Pay__c == 'Fees')
                    {
                        if (cost.Billable_Party__c == cost.Searches__r.Service_Request__r.Opportunity__r.Policyholder__c)
                        {
                            cost.Billable_Party__c = cost.Searches__r.Service_Request__r.Opportunity__r.Adjuster__c;
                            
                        }
                    }
                    else
                    {
                        if (cost.Searches__r.Service_Request__r.Policyholder_to_Pay__c == 'Deposits and Fees' || cost.Searches__r.Service_Request__r.Policyholder_to_Pay__c == 'Fees')
                        {
                            if (cost.Billable_Party__c == cost.Searches__r.Service_Request__r.Opportunity__r.Adjuster__c)
                            {
                                cost.Billable_Party__c = cost.Searches__r.Service_Request__r.Opportunity__r.Policyholder__c;
                                
                            }
                        }
                    }
                }
            }
        }
        update(costs);
        
        Furniture_Order__c [] furnitureOrders = [select Id,Service_Request__r.Adjuster_to_Pay__c,Service_Request__r.Policyholder_to_Pay__c,Billable_Party_Deposit__c,Billable_Party_Delivery_Fee__c,Billable_Party_Setup_Fee__c,Billable_Party_Pet_Fee__c from Furniture_Order__c where Service_Request__c =: serviceRequestIds and Placement__r.Status__c in ('Searching','Viewing','Pending Confirmation')];  
        
        for (Furniture_Order__c furnitureOrder : furnitureOrders)
        {
            if (furnitureOrder.Service_Request__r.Adjuster_to_Pay__c == 'Deposits and Fees' || furnitureOrder.Service_Request__r.Adjuster_to_Pay__c == 'Deposits')
            {
                if (furnitureOrder.Billable_Party_Deposit__c == 'PolicyHolder')
                {
                    furnitureOrder.Billable_Party_Deposit__c = 'Adjuster';
                }
            }
            else
            {
                if (furnitureOrder.Service_Request__r.Policyholder_to_Pay__c == 'Deposits and Fees' || furnitureOrder.Service_Request__r.Policyholder_to_Pay__c == 'Deposits')
                {
                    if (furnitureOrder.Billable_Party_Deposit__c == 'Adjuster')
                    {
                        furnitureOrder.Billable_Party_Deposit__c = 'Policyholder';
                    }
                }
            }
            
            if (furnitureOrder.Service_Request__r.Adjuster_to_Pay__c == 'Deposits and Fees' || furnitureOrder.Service_Request__r.Adjuster_to_Pay__c == 'Fees')
            {
                if (furnitureOrder.Billable_Party_Delivery_Fee__c == 'PolicyHolder')
                {
                    furnitureOrder.Billable_Party_Delivery_Fee__c = 'Adjuster';
                }
                
                if (furnitureOrder.Billable_Party_Setup_Fee__c == 'PolicyHolder')
                {
                    furnitureOrder.Billable_Party_Setup_Fee__c = 'Adjuster';
                }
                
                if (furnitureOrder.Billable_Party_Pet_Fee__c == 'PolicyHolder')
                {
                    furnitureOrder.Billable_Party_Pet_Fee__c = 'Adjuster';
                }
            }
            else
            {
                if (furnitureOrder.Service_Request__r.Policyholder_to_Pay__c == 'Deposits and Fees' || furnitureOrder.Service_Request__r.Policyholder_to_Pay__c == 'Fees')
                {
                    if (furnitureOrder.Billable_Party_Delivery_Fee__c == 'Adjuster')
                    {
                        furnitureOrder.Billable_Party_Delivery_Fee__c = 'PolicyHolder';
                    }
                    
                    if (furnitureOrder.Billable_Party_Setup_Fee__c == 'Adjuster')
                    {
                        furnitureOrder.Billable_Party_Setup_Fee__c = 'PolicyHolder';
                    }
                    
                    if (furnitureOrder.Billable_Party_Pet_Fee__c == 'Adjuster')
                    {
                        furnitureOrder.Billable_Party_Pet_Fee__c = 'PolicyHolder';
                    }
                }
            }
        }
         update(furnitureOrders);
    } 
    
}