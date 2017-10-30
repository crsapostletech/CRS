@isTest
public class ValidationSingleTSMandRMhelperClass_TC{
    public static testMethod void InsertRecords(){
        TriggerControlSetting__c tg = new TriggerControlSetting__c(name = 'ValidationSingleTSMandRM', IsActive__c = true, IsBefore__c = true, IsAfter__c = true, IsInsert__c = true, IsUpdate__c = true);
             insert tg; 
         RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='Owner_Assignment_Map__c' AND Name='RM'];
         RecordType rt4 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='Owner_Assignment_Map__c' AND Name='Default RM'];
         RecordType rt5 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='Owner_Assignment_Map__c' AND Name='TSM'];    
         Owner_Assignment_Map__c oa = new Owner_Assignment_Map__c();
         oa.Name = 'test';
         oa.recordtypeId = rt3.id;
         insert oa;
         
         Owner_Assignment_Map__c oa1 = new Owner_Assignment_Map__c();
         oa1.Name = 'test';
         oa1.recordtypeId = rt4.id;
         insert oa1;
         
         Owner_Assignment_Map__c oa2 = new Owner_Assignment_Map__c();
         oa2.Name = 'test';
         oa2.recordtypeId = rt5.id;
         insert oa2;
         
        
     }
}