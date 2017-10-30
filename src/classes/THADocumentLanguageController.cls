/**************************************************************************************************
Created By: Chiru
Purpose: To allow the user to select English or Spanish language and method of send Email or Fax. Based on this
redirec to relevant page. Class calling from Page calling from Document Link on "Temporary Housing Agreement" task on Service Request
VF Page: THADocumentLanguagePage
Test class: THADocumentLanguageController_TC
**************************************************************************************************/
Public class THADocumentLanguageController{
    
    Public String selectedLanguageVersion {get;set;}
    Public String selectedMethod {get;set;}
    Set<ID> CliamId = new Set<ID>();
    String whatId;
    String taskId;
    Public Boolean ISCanada{get;set;} 
    Opportunity OppRecord{get;set;}
        
    Public THADocumentLanguageController(){
        selectedLanguageVersion = 'English';
        selectedMethod = 'Email';
        whatId = ApexPages.currentPage().getParameters().get('whatId');
        taskId = ApexPages.currentPage().getParameters().get('taskId');
        if(whatId <> null && whatId <> '') 
        CliamId.add(whatId); 
        OppRecord = [select id,name,Damaged_Property_Country__c from opportunity where id IN: CliamId];
        String Country =  OppRecord.Damaged_Property_Country__c.toUpperCase();
        if(OppRecord.Damaged_Property_Country__c!= null && Country.contains('CAN')){
             ISCanada = true;
             selectedLanguageVersion = 'Canada';
         }
    }
       
    Public PageReference redirectToEchosignPage(){
         if(selectedMethod == 'Email'){    
            if(OppRecord.Damaged_Property_Country__c!= null && OppRecord.Damaged_Property_Country__c.containsIgnoreCase('CAN')){
                     ISCanada = true;
                     return new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterid='+whatId+'&templateId='+Label.THA_Canada_Template_Id);
             }
            if(selectedLanguageVersion == 'English')
                return new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterid='+whatId+'&templateId='+Label.THA_English_Template_ID);
            else
                return new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterid='+whatId+'&templateId='+Label.THA_Spanish_Template_ID);   
         }
         else{
             
             return new PageReference('/apex/THADocumentPreviewPage?reqId='+whatId+'&taskId='+taskId+'&lang='+selectedLanguageVersion);                     
         }
         return null;
    }
    
    Public PageReference cancel(){
        return new PageReference('/'+taskId);
    }
    
}