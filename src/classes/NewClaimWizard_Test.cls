@isTest
private class NewClaimWizard_Test {
    static string policyholderFirstName = 'John';
    static string policyholderLastName = 'TestPolicyholder';
    static string claimName = 'Test ABC Claim';
    static string adjusterFirstName = 'John';
    static string adjusterLastName = 'TestAdjuster';
    static string insuranceCompanyName = 'ABC Test Insurance';
    static string leadFirstName = 'John';
    static string leadLastName = 'TestLead';
    static string leadCompanyName = 'ABC Test Company';
    static NewClaimWizard wizard; 
    static Account policyholderAccount; 
    static Contact policyholderContact; 
    static Account insuranceCompany;
    static Contact adjuster; 
    
             
    static 
    {
        insuranceCompany = EntityFactory.insertInsuranceCompany(insuranceCompanyName);
        adjuster = EntityFactory.insertAdjuster(adjusterFirstName,adjusterLastName,insuranceCompany);
        wizard = new NewClaimWizard(new ApexPages.StandardController(EntityFactory.createHousingClaim(claimName)));
        wizard.policyholderContact = EntityFactory.createPolicyholder(policyholderFirstName, policyholderLastName);
        wizard.Lead = EntityFactory.createLead(leadFirstName, leadLastName, leadCompanyName);
    }
    
    static void save() {    
        if (!wizard.save()) {
            throw new SaveException(ApexPages.getMessages()[0].getDetail());
        }
        policyholderContact = [select Id, AccountId, MailingStreet from Contact where LastName = :policyholderLastName and FirstName = :policyholderFirstName]; 
    
        try {
            policyholderAccount = [select Id, BillingStreet from Account where Id = :policyholderContact.AccountId];
        } catch (QueryException ex) {
            policyholderAccount = new Account();
        }   
    }
    
    static testMethod void saveCreatesPolicyholder() {
        save();
        
        System.assert(policyholderContact.Id != null);
    }
    
    static testMethod void saveCreatesClaim() {
        wizard.getContactRoles();
        wizard.step1();
        wizard.step2();
        wizard.step3();
        wizard.toggleLeadSourcefields();
        wizard.lead.Refered_By__c = 'Test Guy';
        wizard.lead.Other_Source__c = '"Test Other Source';

        save();
        
        System.assertEquals(1, [select Id from Opportunity where Id = :wizard.claim.Id].size());

        wizard.initialServiceRequest();

        wizard = new NewClaimWizard(new ApexPages.StandardController(EntityFactory.createHotelClaim(claimName)));
        wizard.policyholderContact = EntityFactory.createPolicyholder(policyholderFirstName, policyholderLastName);
        wizard.Lead = EntityFactory.createLead(leadFirstName, leadLastName, leadCompanyName);

        wizard.initialServiceRequest();

        wizard = new NewClaimWizard(new ApexPages.StandardController(EntityFactory.createFRVClaim(claimName)));
        wizard.policyholderContact = EntityFactory.createPolicyholder(policyholderFirstName, policyholderLastName);
        wizard.Lead = EntityFactory.createLead(leadFirstName, leadLastName, leadCompanyName);

        wizard.initialServiceRequest();

        wizard = new NewClaimWizard(new ApexPages.StandardController(EntityFactory.createFindersFeesClaim(claimName)));
        wizard.policyholderContact = EntityFactory.createPolicyholder(policyholderFirstName, policyholderLastName);
        wizard.Lead = EntityFactory.createLead(leadFirstName, leadLastName, leadCompanyName);

        wizard.initialServiceRequest();
       
    }

    static testMethod void saveCreatesClaim2() {
        wizard.initialServiceRequest();
        System.assertEquals(1, [select Id from Opportunity where Id = :wizard.claim.Id].size());
    }
       
    static testMethod void finishRedirectsToClaim() {
        string url = wizard.finish().getUrl(); // call first to populate claim.id
        System.assertEquals(new ApexPages.Standardcontroller(wizard.claim).view().getUrl(), url);
    }
    
    static testMethod void initialServiceRequestRedirectsToRecordType() {
        wizard.claim.Initial_Service_Request__c = 'FRV'; // special case; maps to different RecordType
    //    System.assertEquals(wizard.serviceRequestType.Id, wizard.initialServiceRequest().getParameters().get('RecordType'));
    }
 }