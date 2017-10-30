public with sharing class ServiceRequestDispatcherExtension 
{
  public ServiceRequestDispatcherExtension(ApexPages.StandardController stdController)
  {
    ServiceRequest__c serviceRequest = (ServiceRequest__c)stdController.getRecord(); 
  }
  
  public PageReference getViewServiceRequest()
  {
    Id id = ApexPages.currentPage().getParameters().get('id'); 
    ServiceRequest__c serviceRequest = [select Id, RecordTypeId, Opportunity__c from ServiceRequest__c where Id = :id];
   
    PageReference newPage;
    
    if (serviceRequest.RecordTypeId == RecordTypeHelper.hotelServiceRequestRT())
    {
        newPage = Page.HotelEntry; 
    }
    else
    {   
        if (serviceRequest.RecordTypeId == RecordTypeHelper.housingServiceRequestRT())
        {
             newPage = Page.HousingEntry;
        }
        else
        {
             newPage = new PageReference('/' + id);
             newPage.getParameters().put('nooverride', '1');
             return newPage.setRedirect(true);
        }
    }
    newPage.getParameters().put('id', id);
    return newPage.setRedirect(true);
  }
  
  public PageReference getNewServiceRequest()
  {
    this.logParams();
    Id rtId = ApexPages.currentPage().getParameters().get('RecordType');
     
    PageReference newPage;
    string claimParam = ApexPages.currentPage().getParameters().get('retURL').replace('/', ''); 
    
    if (rtId == RecordTypeHelper.hotelServiceRequestRT())
    {
        newPage = Page.HotelEntry;
 
        ServiceRequest__c serviceRequest = new ServiceRequest__c();
        serviceRequest.RecordTypeId = RecordTypeHelper.hotelServiceRequestRT();
        system.debug(claimParam);
        if (claimParam != 'a0Po' && claimParam.substring(0,3) != 'a0P')
        {
            
            serviceRequest.Opportunity__c = claimParam.substring(0,15);
            serviceRequest.Initial_Call_Date__c = Datetime.now();
            serviceRequest.Initial_Contact_Date__c = Datetime.now();
        }
                         
        upsert serviceRequest;
        newPage.getParameters().put('id', serviceRequest.id);
    }
    else
    {
        if (rtId == RecordTypeHelper.housingServiceRequestRT())
        {
            newPage = Page.HousingEntry;
     
            ServiceRequest__c serviceRequest = new ServiceRequest__c();
            serviceRequest.RecordTypeId = rtId;
            system.debug(claimParam);
            if (claimParam != 'a0Po' && claimParam.substring(0,3) != 'a0P')
            {
                try
                {
                    serviceRequest.Opportunity__c = claimParam.substring(0,15);
                }
                catch (exception e)
                {
                }
            }

            upsert serviceRequest;
                             
            Double seqNumber;
            try
            {
                seqNumber = [select Sequence_Number__c From Placement__c where Opportunity__c =:serviceRequest.Opportunity__c and RecordTypeId =: RecordTypeHelper.housingPlacementRT() and Sequence_Number__c <> null order by Sequence_Number__c desc limit 1].Sequence_Number__c;
                seqNumber ++;
            }
            catch (exception e)
            {
                seqNumber = 1;
            }
            
            Placement__c relatedPlacement = new Placement__c();
            relatedPlacement.RecordTypeId = RecordTypeHelper.housingPlacementRT();
            relatedPlacement.ServiceRequest__c = serviceRequest.Id;
            relatedPlacement.Opportunity__c = serviceRequest.Opportunity__c;
            Opportunity claim = [select name, Policyholder__r.Name,Customer_Care_Specialist__r.Email,Regional_Manager__r.Email,Area_Specialist__r.Email,Housing_Coordinator__r.Email,Hotel_Customer_Care_Specialist__r.Email from Opportunity where Id =:serviceRequest.Opportunity__c]; 
            relatedPlacement.Name = claim.Name + ' - ' + claim.Policyholder__r.Name + ' #' + seqNumber.intValue();
            relatedPlacement.Sequence_Number__c = seqNumber;
            relatedPlacement.Customer_Care_Specialist_Email__c = claim.Customer_Care_Specialist__r.Email;
            relatedPlacement.Regional_Manager_Email__c = claim.Regional_Manager__r.Email;
            relatedPlacement.Area_Specialist_Email__c = claim.Area_Specialist__r.Email;
            relatedPlacement.Housing_Coordinator_Email__c = claim.Housing_Coordinator__r.Email;
            relatedPlacement.Hotel_Customer_Care_Specialist_Email__c = claim.Hotel_Customer_Care_Specialist__r.Email;
                        
            upsert relatedPlacement;
            newPage.getParameters().put('id', serviceRequest.id);
        }
        else
        {
            String prefix = ServiceRequest__c.SObjectType.getDescribe().getKeyPrefix();
             
            newPage = new PageReference('/' + prefix + '/e');
            newPage.getParameters().put('nooverride', '1');
            newPage = getParameters(newPage); 
                  
            // set _lkid val if it is in the params
            Map<String, String> params = ApexPages.currentPage().getParameters();
            Set<String> keys = params.keySet();
                 
            string lookupId = '';
                
            for(String key : keys)
            {
                if (key.endsWith('_lkid'))
                {
                    newPage.getParameters().put(key, params.get(key));
                    lookupId = key.replace('_lkid', '');
                }
            }
            
            if (lookupId.length() > 0)
            {
                newPage.getParameters().put(lookupId, params.get(lookupId));
            }  
        }   
    }  
    return newPage.setRedirect(true);  
  }
    
  public PageReference getEditServiceRequest()
  {
    Id id = ApexPages.currentPage().getParameters().get('id'); 
    ServiceRequest__c serviceRequest = [select Id, RecordTypeId from ServiceRequest__c where Id = :id];
        
    PageReference newPage;
    
    if (serviceRequest.RecordTypeId == RecordTypeHelper.hotelServiceRequestRT())
    {
        newPage = Page.HotelEntry;
    }
    else
    {
        if (serviceRequest.RecordTypeId == RecordTypeHelper.housingServiceRequestRT())
        {
            newPage = Page.HousingEntry;    
        }
        else
        {
            newPage = new PageReference('/' + id + '/e');
            newPage.getParameters().put('retURL',id);
            newPage.getParameters().put('nooverride', '1');
            return newPage.setRedirect(true);
        }
    }
    newPage.getParameters().put('id', id);
    return newPage.setRedirect(true);
  }
 
  private PageReference getParameters(PageReference page)
  {
    
    Map<String, String> params = ApexPages.currentPage().getParameters();
    String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL'};
    
    for(String s : keys)
    {
      if (params.containsKey(s)) 
      {
        page.getParameters().put(s, params.get(s));
      }
    }
    
    return page;
  }
  
  private void logParams()
  {
    Map<String, String> params = ApexPages.currentPage().getParameters();
    Set<String> keys = params.keySet();
    
    for(String s : keys)
    {
        // s, params.get(s)
        System.debug(LoggingLevel.INFO, 'Page Param => key:' + s + ', val:' + params.get(s));
            
    }
    
  }

}