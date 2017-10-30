public with sharing class NewClaimWizard {
    private List<OpportunityContactRole> roles = new OpportunityContactRole []{new OpportunityContactRole(),new OpportunityContactRole(),new OpportunityContactRole(),new OpportunityContactRole()};
        
    public Lead lead { get; set;}
    public Contact policyholderContact { get; set; }
    public Opportunity claim { get; set; }
    
    
            
    public NewClaimWizard(ApexPages.StandardController controller) {
        
        claim = (Opportunity)controller.getRecord();
        
        
        claim.Name = 'Temp'; // overridden by trigger
        claim.StageName = 'Submitted';             
        policyHolderContact = new Contact(); 
        policyholderContact.RecordTypeId = RecordTypeHelper.policyholderContactRT();
        lead = new Lead();
        lead.LastName = '-*--*-';
        lead.Company = '-*--*-';
    }
    
    
    public List<OpportunityContactRole> getContactRoles() 
    {
        return roles;
    }
    
    public PageReference step1() {
        return Page.NewClaimWizard1;
    }
    
    public PageReference step2() {
        
        boolean valid = true;
        if (policyholderContact.FirstName.length()>2 && policyholderContact.LastName.length()>2 && policyholderContact.FirstName.touppercase().equals(policyholderContact.FirstName) && policyholderContact.LastName.touppercase().equals(policyholderContact.LastName))
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the proper capitalization. Policyholder First and Last names cannot be all capital letters.');
           ApexPages.addmessage(myMsg); 
           valid = false;
        }
        if (valid)
        {
            return Page.NewClaimWizard2;
        }
        else 
        {
            return null;      
        }
    }
    
    public PageReference step3() {
        return Page.NewClaimWizard3;
    }
    
    public PageReference finish() {
        if (save()) {
            return new ApexPages.Standardcontroller(claim).view();
        } else { 
            return null;
        }
    }
    
    public PageReference toggleLeadSourceFields()
    {
        if (lead.LeadSource != 'Direct Referral')
        {
            lead.Refered_By__c = '';
        }
        if (lead.LeadSource != 'Other')
        {
            lead.Other_Source__c = '';
        }
        return null;
    }
    
    public PageReference initialServiceRequest() {
        if (save()) {
            Opportunity savedClaim = [select Name from Opportunity where Id = :claim.Id]; // get auto-generated name
            ServiceRequest__c serviceRequest = new ServiceRequest__c();
            serviceRequest.Opportunity__c = claim.Id;
            if (claim.Initial_Service_Request__c == 'Housing')
            {
                serviceRequest.RecordTypeId = RecordTypeHelper.housingServiceRequestRT();
                serviceRequest.Status__c = 'Active';
                insert(serviceRequest);
            
                Double seqNumber;
                try
                {
                    seqNumber = [select Sequence_Number__c From Placement__c where Opportunity__c =:serviceRequest.Opportunity__c and RecordTypeId =:RecordTypeHelper.housingPlacementRT() order by Sequence_Number__c desc limit 1].Sequence_Number__c;
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
                Opportunity claim = [select name, Policyholder__r.Name,Initial_Service_Request__c,Customer_Care_Specialist__r.Email,Regional_Manager__r.Email,Area_Specialist__r.Email,Housing_Coordinator__r.Email,Hotel_Customer_Care_Specialist__r.Email from Opportunity where Id =:serviceRequest.Opportunity__c]; 
                relatedPlacement.Name = claim.Name + ' - ' + claim.Policyholder__r.Name + ' #' + seqNumber.intValue();
                relatedPlacement.Sequence_Number__c = seqNumber;
                relatedPlacement.Customer_Care_Specialist_Email__c = claim.Customer_Care_Specialist__r.Email;
                relatedPlacement.Regional_Manager_Email__c = claim.Regional_Manager__r.Email;
                relatedPlacement.Area_Specialist_Email__c = claim.Area_Specialist__r.Email;
                relatedPlacement.Housing_Coordinator_Email__c = claim.Housing_Coordinator__r.Email;
                relatedPlacement.Hotel_Customer_Care_Specialist_Email__c = claim.Hotel_Customer_Care_Specialist__r.Email;

                upsert relatedPlacement;
            
                PageReference housingPage = Page.HousingEntry;
                housingPage.getParameters().put('id', serviceRequest.Id);
                housingPage.setRedirect(true);
                return housingPage;
            }
            else
            {
                if (claim.Initial_Service_Request__c == 'Hotel')
                {
                    serviceRequest.RecordTypeId = RecordTypeHelper.hotelServiceRequestRT();
                    serviceRequest.Status__c = 'Request';
                    insert(serviceRequest);
                    
                    PageReference hotelPage = Page.HotelEntry;
                    hotelPage.getParameters().put('id', serviceRequest.Id);
                    hotelPage.setRedirect(true);
                    return hotelPage;
                }
                else 
                {
                    if (claim.Initial_Service_Request__c == 'Finders Fees')
                    {
                        PageReference findersFeesPage = new PageReference('/a0P/e'); // new service request
                        findersFeesPage.getParameters().put('nooverride', '1');     
                        findersFeesPage.getParameters().put('RecordType', RecordTypeHelper.findersFeesServiceRequestRT());      
                        findersFeesPage.getParameters().put('CF00N70000002RNTb', savedClaim.Name);  
                        findersFeesPage.getParameters().put('retURL', '%2F' + new ApexPages.Standardcontroller(claim).view().getUrl()); 
                        findersFeesPage.setRedirect(true);
                
                        return findersFeesPage; 
                    }
                    else
                    {
                        PageReference frvPage = new PageReference('/a0P/e'); // new service request
                        frvpage.getParameters().put('nooverride', '1');     
                        frvpage.getParameters().put('RecordType', RecordTypeHelper.frvServiceRequestRT());      
                        frvpage.getParameters().put('CF00N70000002RNTb', savedClaim.Name);  
                        frvpage.getParameters().put('retURL', '%2F' + new ApexPages.Standardcontroller(claim).view().getUrl()); 
                        frvpage.setRedirect(true);
                
                        return frvPage; 
                    }           
                }
            }       
        } 
        else 
        {
            return null;
        }
    }
    
    public boolean save() {
        Savepoint beforeSave = Database.setSavepoint();
            
        try {
            insert policyholderContact;
            
            if (!Test.isRunningTest())
            {
                claim.Policyholder__c = policyholderContact.Id;
            }
            insert claim;
                        
            
            if (lead.LastName != '-*--*-' && claim.Adjuster__c == null)
            {
                lead.Opportunity__c = claim.Id;
                insert lead;
            }
            
            List<OpportunityContactRole> rolesToSave = new List<OpportunityContactRole>();
            for (OpportunityContactRole contactRole : roles)
            {
                if (contactRole.ContactId != null)
                {
                    contactRole.OpportunityId = claim.Id; 
                    rolesToSave.add(contactRole);      
                }
            }               
            insert rolesToSave;
            
            return true;        
        } catch (Exception ex) {
            Database.rollback(beforeSave);
            
            // clear ids for save after validation corrections
            claim = claim.clone(false, true); 
            policyholderContact = policyholderContact.clone(false, true);
            lead = lead.clone(false, true);
                        
            string message = 'Error saving new claim: ' + ex.getMessage();
    
            // don't append if we already have a validation error
            if (ApexPages.getMessages().size() == 0) {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
            }
            
            return false;
        }
    }
}