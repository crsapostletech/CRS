@RestResource(urlMapping='/Claim/UpdateClaimALE/*')
global with sharing class RESTUpdateClaimALE 
{
    @HttpPatch
    global static String updateClaimALE(String claimId,Double claimALESpent,Double claimALEUnbilled)   
    { 
        try
        {
              Opportunity claim = [SELECT Id,ALE_Spent__c,ALE_Unbilled__c from Opportunity WHERE Id =: claimId]; 
              claim.ALE_Spent__c = claimALESpent;
              claim.ALE_Unbilled__c = claimALEUnbilled; 
              update claim;
              return 'ALE updated for claim id ' + claimId;
        }
        catch (Exception e)
        {
           Util.sendErrorEmail('Claim ALE Update error','ERROR: ' + e + ' returned updating the claim ALE on claim ' + claimId);       
           return 'ALE update failed for claim id ' + claimId;
        }
    }
}