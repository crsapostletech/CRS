public with sharing class EntityFactory {
    
    Public static void createTriggerControlCustomSetting(String trigName){
        insert new TriggerControlSetting__c(Name=trigName,isActive__c=true,isBefore__c=true,isAfter__c=true,isInsert__c=true, isUpdate__c=true,isDelete__c=true); 
    }
    
    public static Opportunity createHousingClaim(string name) {
        return new Opportunity(Damaged_Property_Zip__c = '12345', 
                               Damaged_Property_Type__c = 'House',
                               Damaged_Property_State__c = 'AZ', 
                               Damaged_Property_Country__c = 'USA', 
                               Damaged_Property_City__c = 'Phoenixt',
                               Damaged_Property_Address__c = '100 Test St.', 
                               Policy_Type__c = 'Homeowner',
                               Type_of_Loss__c = 'Fire', 
                               StageName = 'Submitted', 
                               Initial_Service_Request__c = 'Housing', 
                               CloseDate = Date.today(),
                               Regional_Manager__c = userinfo.getuserid(),
                               Customer_Care_Specialist__c = userinfo.getuserid(),
                               Hotel_Customer_Care_Specialist__c = userinfo.getuserid());
    }

    public static Opportunity createHotelClaim(string name) {
        return new Opportunity(Damaged_Property_Zip__c = '12345', 
                               Damaged_Property_Type__c = 'House',
                               Damaged_Property_State__c = 'AZ', 
                               Damaged_Property_Country__c = 'USA',
                               Damaged_Property_City__c = 'Phoenixt',
                               Damaged_Property_Address__c = '100 Test St.', 
                               Policy_Type__c = 'Homeowner',
                               Type_of_Loss__c = 'Fire', 
                               StageName = 'Submitted', 
                               Initial_Service_Request__c = 'Hotel', 
                               CloseDate = Date.today(),
                               Regional_Manager__c = userinfo.getuserid(),
                               Customer_Care_Specialist__c = userinfo.getuserid(),
                               Hotel_Customer_Care_Specialist__c = userinfo.getuserid());
    }

    public static Opportunity createFRVClaim(string name) {
        return new Opportunity(Damaged_Property_Zip__c = '12345', 
                               Damaged_Property_Type__c = 'House',
                               Damaged_Property_State__c = 'AZ', 
                               Damaged_Property_Country__c = 'USA', 
                               Damaged_Property_City__c = 'Phoenixt',
                               Damaged_Property_Address__c = '100 Test St.', 
                               Policy_Type__c = 'Homeowner',
                               Type_of_Loss__c = 'Fire', 
                               StageName = 'Submitted', 
                               Initial_Service_Request__c = 'FRV', 
                               CloseDate = Date.today(),
                               Regional_Manager__c = userinfo.getuserid(),
                               Customer_Care_Specialist__c = userinfo.getuserid(),
                               Hotel_Customer_Care_Specialist__c = userinfo.getuserid());
    }

    public static Opportunity createFindersFeesClaim(string name) {
        return new Opportunity(Damaged_Property_Zip__c = '12345', 
                               Damaged_Property_Type__c = 'House',
                               Damaged_Property_State__c = 'AZ', 
                               Damaged_Property_Country__c = 'USA', 
                               Damaged_Property_City__c = 'Phoenixt',
                               Damaged_Property_Address__c = '100 Test St.', 
                               Policy_Type__c = 'Homeowner',
                               Type_of_Loss__c = 'Fire', 
                               StageName = 'Submitted', 
                               Initial_Service_Request__c = 'Finders Fees', 
                               CloseDate = Date.today(),
                               Regional_Manager__c = userinfo.getuserid(),
                               Customer_Care_Specialist__c = userinfo.getuserid(),
                               Hotel_Customer_Care_Specialist__c = userinfo.getuserid());
    }
    
    public static Account insertInsuranceCompany(string name) {
        Account account = new Account(Name = name, RecordTypeId = RecordTypeHelper.insuranceCompanyAccountRT(), Type = 'Insurance Company');
        insert account;
        return account;
    }
    
    public static Contact insertAdjuster(string firstName, string lastName, Account insuranceCompany) {
        Contact adjuster = new Contact(FirstName = firstName, LastName = lastName, RecordTypeId = RecordTypeHelper.adjusterContactRT(), AccountId = insuranceCompany.Id);
        insert adjuster;
        return adjuster;
    }
    
    public static Contact createPolicyholder(string policyholderFirstName, string policyholderLastName) {
        return new Contact(FirstName = policyholderFirstName, LastName = policyholderLastName, RecordTypeId = RecordTypeHelper.policyholderContactRT()); 
    }
    
    public static Lead createLead(string leadFirstName, string leadLastName, string leadCompanyName) {
        return new Lead(FirstName = leadFirstName, LastName = leadLastName, Company = leadCompanyName, LeadSource = 'Event' ); 
    }
}