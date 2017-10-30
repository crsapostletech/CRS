/*************************************************************************************************************
Created by: Apostletech team
Purpose: Cannot Create morethan one recordtype for Default RM and TSM Records.
trigger calling class a ValidationSingleTSMandRM to validate the records
*************************************************************************************************************/

public class ValidationSingleTSMandRMhelperClass{
    
   public static void ValidateRecordType(List<Owner_Assignment_Map__c> ownerAssignmentRecords){
        Id defaultRecordTypeId = Schema.SObjectType.Owner_Assignment_Map__c.getRecordTypeInfosByName().get('Default RM').getRecordTypeId();
        Id TSMRecordTypeId = Schema.SObjectType.Owner_Assignment_Map__c.getRecordTypeInfosByName().get('TSM').getRecordTypeId();
       List<Owner_Assignment_Map__c> ownerDefaultAssignmentList = [select id from Owner_Assignment_Map__c where recordtype.Name= 'Default RM'];
       List<Owner_Assignment_Map__c> ownerTSMAssignmentList = [select id from Owner_Assignment_Map__c where recordtype.Name = 'TSM'];
       
           for(Owner_Assignment_Map__c am: ownerAssignmentRecords){
               if(ownerDefaultAssignmentList.size() > 0){
               for(Owner_Assignment_Map__c od : ownerDefaultAssignmentList){
                   if(am.recordTypeId == defaultRecordTypeId  && am.id != od.id){
                       am.addError('You cannot create more than one Default RM Owner Assignment Map record');
                       System.debug('****Hello****');
                   }
               }
               }
               if(ownerTSMAssignmentList.size() > 0){
               for(Owner_Assignment_Map__c ot : ownerTSMAssignmentList){
                   if(am.recordTypeId == TSMRecordTypeId && ot.id != am.id){
                       am.addError('You cannot create more than one TSM Owner Assignment Map record');
                   }
               }
               }
       }
   }
}