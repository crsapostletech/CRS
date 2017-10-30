public class pickListEntryController
{
    @AuraEnabled 
    public static List<picklistEntry> getPicklistValues(String fieldName,String sObjectName)
    {
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);         
        Schema.DescribeSObjectResult r = t.getDescribe();
        Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = f.getPicklistValues();
        List<picklistEntry> entryList = new List<picklistEntry>();
        for(Schema.PicklistEntry p : ple){
            picklistEntry pl = new picklistEntry();
            pl.pvalue = p.getValue();
            pl.label = p.getLabel();
            entryList.add(pl);
        }
        return entryList;
    }
    
    //picklistValues
    public class picklistEntry
    {
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string pvalue{get;set;}
    }
}