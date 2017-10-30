trigger UpdateCostsandFurnitureOnATPorPTPChange on ServiceRequest__c (after update) 
{
    Set<Id> serviceRequestIds = new Set<Id>();
    integer i = 0; 
    
    for (ServiceRequest__c ServiceRequest : Trigger.New)    
    {
        if (Trigger.old[i].Adjuster_to_Pay__c != Trigger.new[i].Adjuster_to_Pay__c && Trigger.new[i].Adjuster_to_Pay__c != 'Will not Pay' ||
            Trigger.old[i].Policyholder_to_Pay__c != Trigger.new[i].Policyholder_to_Pay__c && (Trigger.new[i].Policyholder_to_Pay__c != 'Will not Pay' || Trigger.new[i].Policyholder_to_Pay__c != '')                                                                                                                          )
        {
            // 
            serviceRequestIds.add(ServiceRequest.Id);
        }
        i++;
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