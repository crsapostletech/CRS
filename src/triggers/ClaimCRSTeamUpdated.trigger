// Moved to Process Bulider 
trigger ClaimCRSTeamUpdated on Opportunity (after update) 
{
    Set<Id> claimIds = new Set<Id>();
    Map<Id, String> claimId_Regional_Manager_Email = new Map<Id, String>();
    Map<Id, String> claimId_Customer_Care_Specialist_Email  = new Map<Id, String>();
    Map<Id, String> claimId_Area_Specialist_Email = new Map<Id, String>();
    Map<Id, String> claimId_Housing_Coordinator_Email = new Map<Id, String>();
    Map<Id, String> claimId_Hotel_Customer_Care_Specialist_Email = new Map<Id, String>();
    integer i = 0; 
    
    for (opportunity claim : Trigger.new) 
    {
        if (Trigger.old[i].Regional_Manager__c != Trigger.new[i].Regional_Manager__c || 
            Trigger.old[i].Customer_Care_Specialist__c != Trigger.new[i].Customer_Care_Specialist__c ||
            Trigger.old[i].Area_Specialist__c != Trigger.new[i].Area_Specialist__c ||
            Trigger.old[i].Housing_Coordinator__c != Trigger.new[i].Housing_Coordinator__c ||
            Trigger.old[i].Hotel_Customer_Care_Specialist__c != Trigger.new[i].Hotel_Customer_Care_Specialist__c)
        {
            claimIds.add(claim.Id);
        }
        i++;
    }

    List<Opportunity> claims = [select Id,Regional_Manager__r.Email,Customer_Care_Specialist__r.Email,Area_Specialist__r.Email,Housing_Coordinator__r.Email,Hotel_Customer_Care_Specialist__r.Email from Opportunity where Id =: claimIds]; 

    for (Opportunity claim : claims)
    {
         claimId_Regional_Manager_Email.put(claim.Id,claim.Regional_Manager__r.Email);
         claimId_Customer_Care_Specialist_Email.put(claim.Id,claim.Customer_Care_Specialist__r.Email);
         claimId_Area_Specialist_Email.put(claim.Id,claim.Area_Specialist__r.Email);
         claimId_Housing_Coordinator_Email.put(claim.Id,claim.Housing_Coordinator__r.Email);
         claimId_Hotel_Customer_Care_Specialist_Email.put(claim.Id,claim.Hotel_Customer_Care_Specialist__r.Email);
    }

    List<ServiceRequest__c> serviceRequests = [select Id,Opportunity__c from ServiceRequest__c WHERE Opportunity__c =: claimIds];
    
    for (ServiceRequest__c serviceRequest : serviceRequests) 
    {
        serviceRequest.Regional_Manager_Email__c = claimId_Regional_Manager_Email.get(serviceRequest.Opportunity__c);
        serviceRequest.Customer_Care_Specialist_Email__c = claimId_Customer_Care_Specialist_Email.get(serviceRequest.Opportunity__c);
        serviceRequest.Area_Specialist_Email__c = claimId_Area_Specialist_Email.get(serviceRequest.Opportunity__c);
        serviceRequest.Housing_Coordinator_Email__c = claimId_Housing_Coordinator_Email.get(serviceRequest.Opportunity__c);
        serviceRequest.Hotel_Customer_Care_Specialist_Email__c = claimId_Hotel_Customer_Care_Specialist_Email.get(serviceRequest.Opportunity__c);
    }
   
    List<Placement__c> placements = [select Id,Opportunity__c from Placement__c WHERE Opportunity__c =: claimIds];
    
    for (Placement__c placement : placements) 
    {
        placement.Regional_Manager_Email__c = claimId_Regional_Manager_Email.get(placement.Opportunity__c);
        placement.Customer_Care_Specialist_Email__c = claimId_Customer_Care_Specialist_Email.get(placement.Opportunity__c);
        placement.Area_Specialist_Email__c = claimId_Area_Specialist_Email.get(placement.Opportunity__c);
        placement.Housing_Coordinator_Email__c = claimId_Housing_Coordinator_Email.get(placement.Opportunity__c);
        placement.Hotel_Customer_Care_Specialist_Email__c = claimId_Hotel_Customer_Care_Specialist_Email.get(placement.Opportunity__c);
    }
    update (serviceRequests);
    update (placements);
}