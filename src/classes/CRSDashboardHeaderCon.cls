public class CRSDashboardHeaderCon 
{
	@AuraEnabled
    public static void saveCase(Case c1,String recordType)
    {
        Case c = new Case();
        c = c1;
        c.RecordTypeId = recordType;
        insert c;
    }
}