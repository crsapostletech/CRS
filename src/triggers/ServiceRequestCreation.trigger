trigger ServiceRequestCreation on ServiceRequest__c (before insert) 
{
    Set<Id> claimIds = new Set<Id>();
    
    for (ServiceRequest__c serviceRequest : Trigger.new) 
    {
        claimIds.add(ServiceRequest.Opportunity__c);
    }
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select Id,Customer_Care_Specialist__r.Email,Regional_Manager__r.Email,
                                                            Area_Specialist__r.Email,Housing_Coordinator__r.Email,
                                                            Hotel_Customer_Care_Specialist__r.Email from Opportunity 
                                                            where Id =: claimIds]);
    if(oppMap.size()>0)
    {
        for (ServiceRequest__c serviceRequest : Trigger.new) 
        {
            serviceRequest.Customer_Care_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Customer_Care_Specialist__r.Email;
            serviceRequest.Regional_Manager_Email__c = oppMap.get(serviceRequest.Opportunity__c).Regional_Manager__r.Email;
            serviceRequest.Area_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Area_Specialist__r.Email;
            serviceRequest.Housing_Coordinator_Email__c = oppMap.get(serviceRequest.Opportunity__c).Housing_Coordinator__r.Email;
            serviceRequest.Hotel_Customer_Care_Specialist_Email__c = oppMap.get(serviceRequest.Opportunity__c).Hotel_Customer_Care_Specialist__r.Email;
        }
    }
}