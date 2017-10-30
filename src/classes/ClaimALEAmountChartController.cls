public class ClaimALEAmountChartController 
{
    public String claimId {get;set;}
    public String colors = '';

    public ClaimALEAmountChartController(ApexPages.StandardController controller)
    {
        claimId = controller.getRecord().Id;
    }

    public List<PieWedgeData> getPieData() 
    {
        Opportunity claim = [Select ALE_Spent__c,ALE_Unbilled__c,ALE_Spent_Outside_Of_CRS__c,ALE_Limit_Amount__c from Opportunity where Id =: claimId];
        List<PieWedgeData> data = new List<PieWedgeData>();
   
        if (claim.ALE_Limit_Amount__c != 0 && claim.ALE_Limit_Amount__c != null)
        {

            if (claim.ALE_Spent__c == null)
            {
                claim.ALE_Spent__c = 0;
            }
            if (claim.ALE_Spent_Outside_Of_CRS__c == null)
            {
                claim.ALE_Spent_Outside_Of_CRS__c = 0;
            }
            if (claim.ALE_Unbilled__c == null)
            {
                claim.ALE_Unbilled__c = 0;
            }
            if (claim.ALE_Limit_Amount__c == null)
            {
                claim.ALE_Limit_Amount__c = 0;
            }
            
            if (claim.ALE_Spent__c + claim.ALE_Spent_Outside_Of_CRS__c != 0)
            {
                data.add(new PieWedgeData('Spent', integer.valueOf(claim.ALE_Spent__c + claim.ALE_Spent_Outside_Of_CRS__c))); 
                colors = 'Red';
            }
         
            if (claim.ALE_Unbilled__c != 0)
            {   
                data.add(new PieWedgeData('Unbilled', integer.valueOf(claim.ALE_Unbilled__c)));
                if (colors != '')
                {
                    colors += ',';    
                }
                colors += 'Orange';

            }
            if (claim.ALE_Limit_Amount__c != 0 && claim.ALE_Limit_Amount__c > claim.ALE_Spent__c + claim.ALE_Spent_Outside_Of_CRS__c + claim.ALE_Unbilled__c)
            {
                data.add(new PieWedgeData('Remaining', integer.valueOf(claim.ALE_Limit_Amount__c - (claim.ALE_Spent__c + claim.ALE_Spent_Outside_Of_CRS__c + claim.ALE_Unbilled__c))));
                if (colors != '')
                {
                    colors += ',';    
                }
                colors += 'Green';
            }
        }
        
        return data;
    }

    // Wrapper class
    public class PieWedgeData 
    {

        public String name { get; set; }
        public Integer data { get; set; }
       

        public PieWedgeData(String name, Integer data) 
        {
            this.name = name;
            this.data = data;
        }
    }

    public String getColors() 
    {
        return colors;
    }
}