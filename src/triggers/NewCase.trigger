trigger NewCase on Case (before insert) 
{
    for (Case c : Trigger.new)
    {
        c.OwnerId = c.Case_Assigned_To__c;
        c.RecordTypeId = RecordTypeHelper.assignedCaseRT();
    }
}