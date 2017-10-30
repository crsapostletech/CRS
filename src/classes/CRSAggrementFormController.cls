Public class CRSAggrementFormController{
    
    Public Opportunity claimRec {get;set;}
    Public CRSAggrementFormController(){
        
        claimRec = new Opportunity();
        claimRec = [Select Id, Name, Policyholder__r.Name,Policyholder__r.Fax,Policyholder__r.Claims_Document_Fax__c from Opportunity where Id =: ApexPages.currentPage().getParameters().get('claimId') limit 1];
    }

}