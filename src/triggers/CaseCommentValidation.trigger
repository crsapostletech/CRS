trigger CaseCommentValidation on CaseComment (before insert,before update,before delete) 
{
	String profileName = Util.getUserProfileName();
	Set<Id> caseIds = new Set<Id>();
	Map<Id, String> caseId_Status = new Map<Id, String>();
	integer i = 0; 
	for (CaseComment caseCmt : Trigger.new) 
	{
		caseIds.add(caseCmt.ParentID);
	}

	List<Case> cases = [select Id,Status from Case where Id =: caseIds]; 

	for (Case c : cases)
	{
		caseId_Status.put(c.Id,c.Status);
	}

	for (CaseComment caseCmt : Trigger.new) 
	{
		if (caseId_Status.get(caseCmt.ParentId) == 'Closed')
		{
			if (Trigger.isInsert && profileName != 'Operations Manager' && profileName != 'Operations Director' && profileName != 'System Administrator' )
			{
				caseCmt.addError('You do not have permission to insert a comment on a closed case');
			}
			else
			if (Trigger.isUpdate)
			{
				caseCmt.addError('You cannot edit a comment on a closed case');
			}
			else
			{
				if (Trigger.isDelete)
				{
					caseCmt.addError('You cannot delete a comment on a closed case');
				}
			}
		}
	}
}