public with sharing class ClaimALETimeGaugeController {
	
	public String claimId {get;set;}
    public Integer daysRemaining {get;set;}
    public Boolean displayDays;
    public Opportunity claim;
    
   
    public ClaimALETimeGaugeController(ApexPages.StandardController controller)
    {
        claimId = controller.getRecord().Id;
        claim = [Select CreatedDate,ALE_Limit_Time__c,Date_of_Loss__c from Opportunity where Id =: claimId];
    }

    public List<gaugeData> getGaugeData() 
    {
       List<gaugeData> data = new List<gaugeData>();
    
       if (claim.ALE_Limit_Time__c != 0 && claim.ALE_Limit_Time__c != null)
       {
           Date currentDate = Date.today();
           Date endDateALE;
                      
           if (claim.Date_of_Loss__c != null)
           {
                endDateALE = claim.Date_of_Loss__c.addMonths(Integer.valueOf(claim.ALE_Limit_Time__c));
           }
           else
           {
                endDateALE = claim.CreatedDate.date().addMonths(Integer.valueOf(claim.ALE_Limit_Time__c));
           }
           
           Integer monthsBetween = currentDate.monthsBetween(endDateALE);
           if (monthsBetween > 0)
           {
               monthsBetween --;
               if (monthsBetween > 24)
               {
                  monthsBetween = 24;
               }
           }
           if (monthsBetween < 0)
           {
               monthsBetween = 0;
           }
           daysRemaining = currentDate.daysBetween(endDateALE);
           if (daysRemaining < 0)
           {
               daysRemaining = 0;
           }
        
           data.add(new gaugeData('Remaining',Integer.valueOf(monthsBetween)));
       }
      
       return data;
    }

    // Wrapper class
    public class GaugeData 
    {
        public String name { get; set; }
        public Integer data { get; set; }
       

        public GaugeData(String name, Integer data) 
        {
            this.name = name;
            this.data = data;
        }
    }

    public Boolean getDisplayDays() 
    {
       if (claim.ALE_Limit_Time__c != 0 && claim.ALE_Limit_Time__c != null)
       {
           displayDays = true;
       }
       else
       {
           displayDays = false;
       }

       return displayDays;
    }
}