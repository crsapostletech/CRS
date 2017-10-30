trigger SetAssignedDates on Opportunity (before insert, before update) 
{
    if (Trigger.isInsert) 
    {
    for (Opportunity o : Trigger.new) 
    {
        if (o.Regional_Manager__c != null) 
        {
            o.Regional_Manager_Assigned__c = DateTime.now();        
        }
        if (o.Customer_Care_Specialist__c != null) 
        {
            o.Customer_Care_Specialist_Assigned__c = DateTime.now();        
        }
        if (o.Area_Specialist__c != null) 
        {
            o.Area_Specialist_Assigned__c = DateTime.now();        
        }
        if (o.Housing_Coordinator__c != null) 
        {
            o.Housing_Coordinator_Assigned__c = DateTime.now();        
        }
      if (o.Hotel_Customer_Care_Specialist__c != null) 
      {
        o.Hotel_Customer_Care_Specialist_Assigned__c = DateTime.now();        
      }
    }
  }   
  else if (Trigger.isUpdate) 
  {
    for (integer i = 0; i < Trigger.new.size(); i++) 
    {
        if (Trigger.new[i].Regional_Manager__c != Trigger.old[i].Regional_Manager__c) 
        {
            if (Trigger.new[i].Regional_Manager__c != null)
        {
          Trigger.new[i].Regional_Manager_Assigned__c = DateTime.now();
        }
        else
        {
          Trigger.new[i].Regional_Manager_Assigned__c = null; 
        }  
        }
        if (Trigger.new[i].Customer_Care_Specialist__c != Trigger.old[i].Customer_Care_Specialist__c ) 
        {
            if (Trigger.new[i].Customer_Care_Specialist__c != null)
        {
          Trigger.new[i].Customer_Care_Specialist_Assigned__c = DateTime.now();
        }
        else
        {
          Trigger.new[i].Customer_Care_Specialist_Assigned__c  = null; 
        }    
        }
        if (Trigger.new[i].Area_Specialist__c != Trigger.old[i].Area_Specialist__c) 
        {
            if (Trigger.new[i].Area_Specialist__c != null)
        {
          Trigger.new[i].Area_Specialist_Assigned__c = DateTime.now();
        }
        else
        {
          Trigger.new[i].Area_Specialist_Assigned__c  = null; 
        }    
        }
        if (Trigger.new[i].Housing_Coordinator__c != Trigger.old[i].Housing_Coordinator__c) 
        {
            if (Trigger.new[i].Housing_Coordinator__c != null)
        {
          Trigger.new[i].Housing_Coordinator_Assigned__c = DateTime.now();
        }
        else
        {
          Trigger.new[i].Housing_Coordinator_Assigned__c  = null; 
        }    
        }
      if (Trigger.new[i].Hotel_Customer_Care_Specialist__c != Trigger.old[i].Hotel_Customer_Care_Specialist__c) 
      {
        if (Trigger.new[i].Hotel_Customer_Care_Specialist__c != null)
        {
          Trigger.new[i].Hotel_Customer_Care_Specialist_Assigned__c = DateTime.now();
        }
        else
        {
          Trigger.new[i].Hotel_Customer_Care_Specialist_Assigned__c  = null; 
        }    
      }
    }
  }
}