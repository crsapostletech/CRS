trigger PopulateDocumentDates on Task (after insert) 
{
    Date cutOffDate = date.valueOf('10/28/2015');//Date.newInstance(2015,10,28);
    Set<ID> TaskID = new Set<ID>();
    for(Task task : Trigger.New){
        string whatIdVal = task.whatId;
        if(whatIdVal.startsWith('a0P'))
            TaskID.add(task.WhatId);
    }
    Map<Id,ServiceRequest__c> SrMap = New Map<Id,ServiceRequest__c>([select id,CRS_Hotel_Confirmation_Created_Date__c,Cost_Benefit_Analysis_Created_Date__c,Move_In_Confirmation_Created_Date__c,CreatedDate from serviceRequest__c where Id IN: TaskID]);
    for (Task task : Trigger.New)    
    {
        if (task.subject == 'HotelConfirmation Generated')
        {
            //ServiceRequest__c serviceRequest = [select CRS_Hotel_Confirmation_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
            //if (serviceRequest.CRS_Hotel_Confirmation_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
            if (SrMap.get(task.whatid).CRS_Hotel_Confirmation_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
            {
                SrMap.get(task.whatid).CRS_Hotel_Confirmation_Created_Date__c = Datetime.now();
                //update serviceRequest; 
            }
        }
        else if (task.subject == 'Liberty Mutual Cost Benefit Analysis')
        {
            //ServiceRequest__c serviceRequest = [select Cost_Benefit_Analysis_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
            //if (serviceRequest.Cost_Benefit_Analysis_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
            if(SrMap.get(task.whatid).Cost_Benefit_Analysis_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
            {
                SrMap.get(task.whatid).Cost_Benefit_Analysis_Created_Date__c = Datetime.now();
            }
        }
        else if (task.subject == 'MoveInConfirmation Generated')
        {
            //ServiceRequest__c serviceRequest = [select Cost_Benefit_Analysis_Created_Date__c,CreatedDate from serviceRequest__c where Id =: task.WhatId];
            //if (serviceRequest.Cost_Benefit_Analysis_Created_Date__c == null && Date.newInstance(serviceRequest.CreatedDate.year(), serviceRequest.CreatedDate.month(), serviceRequest.CreatedDate.day()) >= cutOffDate)
            if(SrMap.get(task.whatid).Move_In_Confirmation_Created_Date__c == null && SrMap.get(task.whatid).CreatedDate >= cutOffDate)
            {
                SrMap.get(task.whatid).Move_In_Confirmation_Created_Date__c = Datetime.now();
            }
        }
    }  
    if(SrMap.size()>0)
        update SrMap.values();
}