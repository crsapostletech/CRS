public class SubmitCaseController {

@AuraEnabled public static userWrap getUserInfo(){
    
    list<user> userList = [select id,firstName,Lastname, Email, name,ContactId from User Where id=: userInfo.getUserId() Limit 1];
    user usr = userList.size()>0 ? userList[0] : new user();
    
    list<contact> conList = [select id,name,firstName,LastName,Email,Account.name, AccountId from 
                            Contact WHERE id=:usr.ContactId Limit 1];
    contact cnt = conList.size()>0 ? conList[0] : new contact();
    
    userWrap usrWrap = new userWrap ();
    usrWrap.usr = usr;
    usrWrap.usrContact = cnt;
    usrWrap.accountName= cnt.Account.Name;
    usrWrap.accountId = cnt.AccountId;
    
    return usrWrap;
}
@AuraEnabled public static void insertCaseRec(case caseobj, string usrInfoWrap){
    userWrap usrWrap = (SubmitCaseController.userWrap)JSON.deserialize(usrInfoWrap, SubmitCaseController.userWrap.class);
    caseobj.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Claim Submission').getRecordTypeId();
    caseobj.ContactId= usrWrap.usrContact.Id;
    caseobj.AccountId= usrWrap.accountId;
    caseobj.Case_Assigned_To__c = usrWrap.usr.id;
    
    system.debug('--caseobj- '+caseobj);
    insert caseobj;
    
}


public class userWrap { 

    @AuraEnabled Public String accountName;
    
    @AuraEnabled Public String accountId;
    
    @AuraEnabled public contact usrContact;
    
    @AuraEnabled public user usr;
    
    public userWrap(){
        accountName = '';
        usrContact = new contact();
        usr = new user();
    }


}

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