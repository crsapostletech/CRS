global class OpportunityMapCon
{
    public OpportunityMapCon()
    {
        
    }
    @RemoteAction
    global static List<Opportunity> getOpportunities()
    {
        return [Select Id,Damaged_Property_Full_Address__c from Opportunity];
    }
}