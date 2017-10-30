trigger UpdateAutoNumber on Contact (before insert, before update,after insert) {
Map<Id, Contact> PLAC = new Map<Id, Contact>();
for (Integer i = 0; i < Trigger.new.size(); i++) {
    if (System.Trigger.isInsert) {
        PLAC.put(Trigger.new[i].Id,Trigger.new[i]); 
    }
    else if(System.Trigger.isUpdate){
        PLAC.put(Trigger.old[i].Id,Trigger.new[i]);  
    }
}
//New List view 

List<Contact> contoUpdte = new List<Contact>();
List<Contact> contoUpdte2 = new List<Contact>();
for(Contact con: trigger.new){
if(con.Migration_VendorID__c == null && System.Trigger.isUpdate && con.RecordTypeId==RecordTypeHelper.landlordContactRT()){
    con.Migration_VendorID__c = con.Z_Number__c;
}

    contoUpdte.add(con);
}

if(System.Trigger.isInsert){  
for (Contact c : [SELECT Id,Z_Number__c,RecordTypeId,Migration_VendorID__c FROM Contact WHERE Id in :PLAC.keySet()]) {
        Contact parentAccount = PLAC.get(c.id);
        if(c.RecordTypeId==RecordTypeHelper.landlordContactRT()){
c.Migration_VendorID__c = parentAccount.Z_Number__c;
}
       contoUpdte2.add(c);
}
update contoUpdte2;
}    

   
}