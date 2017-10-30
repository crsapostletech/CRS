/*
    class name : claimSubmissionController
    Created By : Bharat
    Description : Used to convert the case into opportunity with respect to some field mapping and tags the case to the opportunity
*/
global class claimSubmissionController
{
    webservice static string caseToClaim(Id caseId)
    { 
         Case case_info = [select id,contact.LastName,contactId,ownerid,Claim__c from case where id =: caseId];
         
         
         opportunity opp_info = new opportunity();
         opp_info.ownerId = userInfo.getUserId();
         opp_info.Policyholder__c = case_info.contactid;
         opp_info.Regional_Manager__c  = userinfo.getuserId();
         opp_info.Customer_Care_Specialist__c = userinfo.getuserId();
         opp_info.Hotel_Customer_Care_Specialist__c = userinfo.getuserId();
         opp_info.StageName = 'Submitted';
         opp_info.closedate = system.today();
         opp_info.Name = 'Temp';
         insert opp_info;
         
         case_info.Claim__c = opp_info.id;
         update case_info;
         return null;
    }
}