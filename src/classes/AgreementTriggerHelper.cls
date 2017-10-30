/**********************************************************************************
Created By: Siva
Purpose: Helper class for AgreementTrigger,
 - To copy Opportunity id from package related field to custom lookup field
 - To auto complete "Send Temporary Housing Agreement(THA)" task when THA document sent out for Signature
 - To upload THA document to Mulligan database when it is signed
Test class: 
**********************************************************************************/
Public class AgreementTriggerHelper{
    
    Public static void copyOpportunityId(List<echosign_dev1__SIGN_Agreement__c> aggList){
        for(echosign_dev1__SIGN_Agreement__c agg : aggList){        
            if(agg.echosign_dev1__Opportunity__c != null && agg.Claim__c == null){
                agg.Claim__c = agg.echosign_dev1__Opportunity__c;
            }
            if(agg.echosign_dev1__Opportunity__c == null && agg.Claim__c != null){
                agg.echosign_dev1__Opportunity__c = agg.Claim__c;
            }
        }
    }
    
    // To auto complete "Send Temporary Housing Agreement(THA)" task when THA document sent out for Signature
    Public static void updateTHATask(List<echosign_dev1__SIGN_Agreement__c> aggList, Map<Id,echosign_dev1__SIGN_Agreement__c> oldMap, boolean isInsert){
    
        Set<Id> oppIds = new Set<Id>();
        
        for(echosign_dev1__SIGN_Agreement__c agg : aggList){
            system.debug(aggList+':::::aggList');
            system.debug(agg.echosign_dev1__Status__c+'#######status#######');
            system.debug(isInsert +'insert');
            if(agg.echosign_dev1__Status__c == 'Out for Signature' && (isInsert || (!isInsert && agg.echosign_dev1__Status__c != oldMap.get(agg.Id).echosign_dev1__Status__c))){
                oppIds.add(agg.Claim__c);                
                system.debug(oppIds+'*******');
            }
        }
        
        if(!oppIds.IsEmpty()){        
                         
            List<Task> TaskList = [Select Id,Subject,Status, whatId, Service_Request__c from Task where whatId in: oppIds AND (Subject = 'Temporary Housing Agreement' OR Subject = 'Send Temporary Housing Agreement(THA)')];
            system.debug(TaskList+'@@@@@');
            for(Task t : TaskList){
                t.Status = 'Completed'; 
            }            
               
            if(!TaskList.isEmpty())
                Database.update(TaskList, false);
           
        }
    }
    
    // To upload THA document to Mulligan database when it is signed
    Public static void uploadSignedTHAToMulliganDatabase(List<echosign_dev1__SIGN_Agreement__c> esgList, Map<Id,echosign_dev1__SIGN_Agreement__c> oldMap, boolean isInsert){
        for(echosign_dev1__SIGN_Agreement__c agg : esgList){
            if(agg.echosign_dev1__Status__c == 'Signed' && (isInsert || (!isInsert && agg.echosign_dev1__Status__c != oldMap.get(agg.Id).echosign_dev1__Status__c))){            
                //UploadingSignedTHAController.uploadSignedDocument(agg.Id);
                    /* Scheduling after 5 minutes*/
                    //*********************************************************************************************     
                    
                    Datetime destTime = Datetime.now().addMinutes(5);
                               
                    String year =  String.valueOf(destTime.year());   
                    String month =  String.valueOf(destTime.month());
                    String day =  String.valueOf(destTime.day());        
                    String hour = String.valueOf(destTime.hour());
                    String min = String.valueOf(destTime.minute()); 
                    String ss = String.valueOf(destTime.second());
                                        
                    //parse to cron expression
                    String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+ day + ' ' +month+ ' ? '+year;
                    
                    scheduledTHADocumentUpload schClsRef = new scheduledTHADocumentUpload(agg.Id);                    
                    System.schedule('THA Document Upload Scheduler - '+agg.Id, nextFireTime, schClsRef);
                    //********************************************************************************************* 
            } 
   
   /*         if(agg.echosign_dev1__Status__c == 'Signed' && agg.echosign_dev1__Status__c != oldMap.get(agg.Id).echosign_dev1__Status__c){            
                UploadingSignedTHAController.uploadSignedDocument(agg.Id);
            }    */
   
        }
    }
}