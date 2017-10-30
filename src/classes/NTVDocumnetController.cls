Public class NTVDocumnetController{
    
    Public String toDay {get;set;}
    String servReqId;    
    Public Placement__c placementRecord {get;set;}
    Public ServiceRequest__c serviceReqRec {get;set;}
    
    Public String billingAddress {get;set;}    
    Public String placemnetTemporaryAddress {get;set;}
    Public String placementTemporaryState {get;set;}
    Public String moveOutDate {get;set;}
    
    Public NTVDocumnetController(){        
        
        DateTime dt = DateTime.newInstance(Date.toDay().year(), Date.toDay().month(), Date.toDay().day(), 0, 0, 0);
        toDay = dt.format('MMMMM') + ' ' + Date.toDay().day() +', '+ Date.toDay().year();

        servReqId = ApexPages.currentPage().getParameters().get('reqId');        
        placementRecord = new Placement__c();
        serviceReqRec = new ServiceRequest__c();
        billingAddress = '';
        placemnetTemporaryAddress = '';
        placementTemporaryState = '';
        moveOutDate = '';
        
        serviceReqRec = [Select Id, Opportunity__r.Name, Opportunity__r.Policyholder__r.Name, Opportunity__r.Customer_Care_Specialist__r.Name, Opportunity__r.Customer_Care_Specialist__r.Phone, Opportunity__r.Customer_Care_Specialist__r.Fax from ServiceRequest__c where Id =: servReqId];        
                
        List<Searches__c> searchList = [Select Id, Landlord__c, Temporary_Address__c, State__c from Searches__c where Service_Request__c =: servReqId AND Landlord__c != null];
        
        if(!searchList.isEmpty()){
            String tempAddrString = searchList[0].Temporary_Address__c;
            placemnetTemporaryAddress = searchList[0].Temporary_Address__c;
            if(tempAddrString != null && tempAddrString != '' && tempAddrString.contains(',')){
                
                tempAddrString = tempAddrString.subStringBeforeLast(',');
                
                String[] addArr = tempAddrString.split(',');
                placemnetTemporaryAddress = String.join(addArr, ', ');
                
            }            
            placementTemporaryState = searchList[0].State__c;
        }    
        
        
        List<Placement__c> placementList = [Select Id, Selected_Search__r.Days_Notice_Required__c, 
                                                       Selected_Search__r.NTV_Send_To__c,
                                                       Selected_Search__r.NTV_Send_To__r.Name,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingStreet,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingCity,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingState,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingCountry,
                                                       Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode,
                                                       Selected_Search__r.NTV_Send_To__r.Account.Name,
                                                       Selected_Search__r.NTV_Send_To__r.Account.Phone,
                                                       Selected_Search__r.NTV_Send_To__r.Account.Fax,
                                                       Selected_Search__r.NTV_Send_To__r.Account.Email__c,                                                       
                                                       Move_Out_Date__c
                                                        from Placement__c where ServiceRequest__c =: servReqId limit 1];
        
        if(!placementList.isEmpty())
            placementRecord = placementList[0]; 
            
        if(placementRecord.Move_Out_Date__c != null){            
            moveOutDate = placementRecord.Move_Out_Date__c.month() + '/' + placementRecord.Move_Out_Date__c.day() + '/' + placementRecord.Move_Out_Date__c.year();
        }  
            
        if(placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingStreet != null && placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingStreet != ''){
            billingAddress = placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingStreet;
        }
        if(placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCity != null && placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCity != ''){
            billingAddress = billingAddress + ', ' + placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCity; 
        }
        if(placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingState != null && placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingState != ''){
            billingAddress = billingAddress + ', ' + placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingState;
        }
        if(placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode != null && placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode != ''){
            billingAddress = billingAddress + ' ' + placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingPostalCode;
        } 
        if(placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCountry != null && placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCountry != ''){
            billingAddress = billingAddress + ', ' + placementRecord.Selected_Search__r.NTV_Send_To__r.Account.BillingCountry;
        }                              
        
    }
}