// public with sharing class HotelServiceRequestControllerExtension implements ObjectPaginatorListener{
public class HotelServiceRequestControllerExtension
{   
    String instanceName = Util.getInstanceName();
    String profileName = Util.getUserProfileName(); 
        
    private Placement__c placement;
    private Searches__c selectedHotelSearch;
    private Opportunity claim;
    private Hotel_Room__c cancellationHotelRoom; 
    private History placementHistory; 
    public ServiceRequest__c serviceRequest {get; set;}
    public Searches__c newHotelSearch {get; set;}
    public Hotel_Room__c newHotelRoom {get; set;}
    public Id accountId {get; set;}
    public Boolean SRBeingWorkedBy{get;set;}
                
    public Placement__c getPlacement() 
    { 
        if (this.placement == null)
        {
            this.placement = fetchRelatedPlacement();
        }
        
        return this.placement;
    }
        
    public void setPlacement(Placement__c placement) 
    { 
        this.placement = placement;
    }
    
    public Opportunity getClaim()
    {
        if (this.claim == null)
        {
            this.claim = fetchRelatedClaim();
        }
        return this.claim;
    }
    
    public History getHistory()
    {
        if (this.placement.Id != null)
        { 
        this.placementHistory = new History(this.placement);
        this.placementHistory.buildEntries();
        this.placementHistory.invertList();
        return this.placementHistory;
        }
        else
        {
            return null;
        }
    }
    
    public void setClaim(Opportunity claim)
    {
        this.claim = claim;
    }
    
    public Boolean getErrorsPresent()
    {
        return ApexPages.hasMessages(ApexPages.Severity.ERROR);
    }
    
    public Searches__c getSelectedHotelSearch()
    {
        return this.selectedHotelSearch;
    }
    
    public Boolean getHasSelectedHotelSearch()
    {
        internalSelectedSearch();
        
        if (this.selectedHotelSearch == null)
        {
            return false;
        }
        
        return true;
    }
    
    public void setHasSelectedHotelSearch(Boolean val) { /* sure, go ahead and set it... But I'm not going to do anything! */ }
    
    public Boolean getIsProductionOrg()
    {
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {   
            return true;
        }
        else
        {
            return false;   
        }
    }
        
    public void setIsProductionOrg(Boolean val) { /* sure, go ahead and set it... But I'm not going to do anything! */ }
    
    public String getInstanceName()
    {
        return instanceName;   
    }
        
    public void setInstanceName(String val) { /* sure, go ahead and set it... But I'm not going to do anything! */ }
    
    public List<Searches__c> getHotelSearches()
    {
        List<Searches__c> searches = new List<Searches__c>();
        
        if (serviceRequest.Id != null)
        {
            searches = [
                                    select Id, Hotel__c, Name, Hotel_Name__c, Email__c, Hotel_Phone__c,
                                    Selected__c, Distance_from_Damaged_Property__c, Sequence_Number__c
                                    from Searches__c 
                                    where Service_Request__c = :serviceRequest.Id 
                                    order by Sequence_Number__c];
        }
        return searches;
    }

     public string getHash()
    {
        datetime currentDateTime = system.now();
        string orgId = UserInfo.getOrganizationId();
        string userId = UserInfo.getUserId();
        string currentDT = currentDateTime.format('yyyyMMddHHmmss');
        string hashSalt = '4$+O*gva-leG,^lDs9/m-f=s_x]}%)-z'; 
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(orgId + '-' + userId + '-' + hashSalt + '-' + currentDT));     
        String hexDigest = EncodingUtil.convertToHex(hash);
        string url = orgId + '&UserId=' + userId + '&Date=' + currentDT + '&Hash=' + hexDigest + '#!/documents';
                
        return url;
    }
    
           
    public HotelServiceRequestControllerExtension(ApexPages.StandardController stdController)
    {
        serviceRequest = (ServiceRequest__c)stdController.getRecord();
        
        SRBeingWorkedBy = False;            
        if(serviceRequest.Initial_SR_being_worked_by__c != null){               
           SRBeingWorkedBy = true;              
        }
        
        this.newHotelSearch = new Searches__c();
        this.newHotelRoom = new Hotel_Room__c();
        this.cancellationHotelRoom = new Hotel_Room__c();
        this.placement = this.getPlacement();
        internalSelectedSearch();
    }
    
    Public PageReference currentUserUpdateOnSRWorkedBy(){               
                        
         serviceRequest.Initial_SR_being_worked_by__c = Userinfo.getUserId();                       
         saveServiceRequest();              
         return null;               
    }
 
    public PageReference saveServiceRequest()
    {
        if(!serviceRequest.Hold__c)             
            serviceRequest.Hold_Follow_Up_Date__c  = null;              
                        
                        
        if(serviceRequest.Initial_SR_being_worked_by__c != null){               
             SRBeingWorkedBy = true;                
        }        
        
        if (serviceRequest.DWO_Reason_Code__c != null && (serviceRequest.Status__c == 'Request' || serviceRequest.Status__c == 'Searching'))
        {
            serviceRequest.Status__c = 'Lost Opportunity';
            if (placement.Id != null)
            {
                placement.Status__c = 'Lost Opportunity';
                upsert placement;
            }
        }
        
        upsert serviceRequest;

        if (serviceRequest.Status__c == 'Lost Opportunity')
        {
            serviceRequest.DWO_Date__c = [Select DWO_Date__c from ServiceRequest__c where Id =: serviceRequest.Id].DWO_Date__c;
        }
                                
        this.claim = fetchRelatedClaim();
                                        
        return null;
    }
    
    public PageReference updatePlacement()
    {
        if (getHasPlacement())
        {
            Map<string, string> pageParams = ApexPages.currentPage().getParameters();
            string placementIATANumberProvided = pageParams.get('placementIATANumberProvided');
            string placementIATACommissionPaid = pageParams.get('placementIATACommissionPaid');
            string placementIATAClosed = pageParams.get('placementIATAClosed');
            
            if (placementIATANumberProvided == '1')
            {
                placement.IATA_Number_Provided__c = true;
            }
            else
            {
                placement.IATA_Number_Provided__c = false;
            }
            if (placementIATACommissionPaid == '1')
            {
                placement.IATA_Commission_Paid__c = true;
            }
            else
            {
                placement.IATA_Commission_Paid__c = false;
            }
            if (getIsManagerOrDirector())
            {
                if (placementIATAClosed == '1')
                {
                    placement.IATA_Closed__c = true;
                }
                else
                {
                    placement.IATA_Closed__c = false;
                }
                placement.IATA_Closed_Notes__c =  pageParams.get('placementIATAClosedNotes');
            }
            placement.HSA_Signed__c = parseDateTimeParam('placementHSASigned', pageParams);
            placement.Special_Instructions__c = pageParams.get('placementSpecialInstructions');
            placement.Accounting_Instructions__c = pageParams.get('placementAccountingInstructions');
            placement.Reason_For_Leaving__c = pageParams.get('placementReasonForLeaving');
                            
            upsert placement;
        }
        return null;
    }
  
    public PageReference saveNewHotelSearch()
    {
    
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
      
        string hotelSearchName = pageParams.get('selectedHotelName');
        serviceRequest.First_Property_Presented__c = parseDateTimeParam('firstPropertyPresented', pageParams);
        
        serviceRequest.Status__c = 'Searching';
        serviceRequest.DWO_Reason_Code__c = '';
        upsert serviceRequest;
        
        newHotelSearch.Service_Request__c = serviceRequest.Id;
             
        newHotelSearch.Hotel_Name__c = hotelSearchName;
        newHotelSearch.Distance_from_Damaged_Property__c = parseDecimalParam('selectedDistance', pageParams);

        insert newHotelSearch;
        
        //this.hotelSearches.add(newHotelSearch);
        
        
        newHotelSearch = new Searches__c();
        
        return null;
    }
    
    
    public PageReference updateSearchDistanceToDamagedProp()
    {
    
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
      
        string hotelSearchId = pageParams.get('hotelSearchId');
        
        Searches__c hotelSearch = [select Id from Searches__c where Id =: hotelSearchId];
        hotelSearch.Distance_from_Damaged_Property__c =  parseDecimalParam('hotelsearchDistance', pageParams);
        update hotelSearch;
                
        return null;
    }
  
  
    public PageReference clearHotelSearch()
    {
        this.newHotelSearch = new Searches__c();
        this.newHotelSearch.RecordTypeId = RecordTypeHelper.hotelSearchRT();
        return null;        
    }
  
    public PageReference updateSelectedHotelInfo()
    {
        String acctId = ApexPages.currentPage().getParameters().get('accountId');
    
        try
            {
                Account ha = [select Id, Front_Desk_Email__c, Fax, Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode
                                        from Account 
                                  where Id = :acctId];
        
                newHotelSearch.Hotel__c = ha.Id;
                newHotelSearch.Street_Addr1__c = ha.BillingStreet;
                newHotelSearch.Street_Addr2__c = null;
                newHotelSearch.City__c = ha.BillingCity; 
                newHotelSearch.State__c = ha.BillingState;
                newHotelSearch.Zip__c = ha.BillingPostalCode;
                newHotelSearch.Email__c = ha.Front_Desk_Email__c;
                newHotelSearch.Fax__c = ha.Fax;
                newHotelSearch.Hotel_Name__c = ha.Name;
                newHotelSearch.Phone__c = ha.Phone;
            }
            catch (QueryException e)
            {
                this.newHotelSearch = new Searches__c();
            }  
        
        return null;
    }
  
    public PageReference updateSelectedHotelSearch()
    {
        Id hotelSearchId = null;
        String placementPaymentType = '';
        String ccNumber = '';
            
        Map<string, string> params = ApexPages.currentPage().getParameters();
        
        if (params.containsKey('hotelSearchId') && params.get('hotelSearchId').length() > 0)
        {
            hotelSearchId = params.get('hotelSearchId');
        }
        if (params.containsKey('placementPaymentType') && params.get('placementPaymentType').length() > 0)
        {
            placementPaymentType = params.get('placementPaymentType');
        }
        
        // set to selected hotel search hotelId
        if (hotelSearchId == null && this.placement.Id != null)
        {
            if (placementPaymentType == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875')
            {
                deleteCreditCard();
            }
            delete this.placement;
            this.placement = new Placement__c();
            this.placement.RecordTypeId = RecordTypeHelper.hotelPlacementRT();
            serviceRequest.Status__c = 'Searching';
            serviceRequest.DWO_Reason_Code__c = '';
            serviceRequest.Selected_Search__c = null;
            update serviceRequest;
            fetchSelectedHotelSearch(hotelSearchId); 
         }
        else
        {   
            fetchSelectedHotelSearch(hotelSearchId); 
            this.placement.Opportunity__c = serviceRequest.Opportunity__c;
            this.placement.Hotel_Account_Lookup__c = this.selectedHotelSearch.Hotel__c;
            this.placement.Credit_Card_Type__c = placementPaymentType; 
                
            this.placement.ServiceRequest__c = serviceRequest.Id;
            Integer placementCount = this.fetchPlacementCount();
            
            if (placement.Id == null)
            {
                placementCount += 1; 
            }

            claim = getClaim();
                            
            string policyHolderLastName = claim.Policyholder__r.LastName; 
            string placeTrakId = claim.Name;
            
            string hotelName = '';
            if (this.selectedHotelSearch != null)
            {
                hotelName = this.selectedHotelSearch.Hotel_Name__c;
                serviceRequest.Status__c = 'Checked-In/Closed';
                serviceRequest.Selected_Search__c = hotelSearchId;
            }
            else
            {
                serviceRequest.Status__c = 'Searching';
                serviceRequest.Selected_Search__c = null;
            }
            serviceRequest.DWO_Reason_Code__c = '';
            
            this.placement.Name = placeTrakId + ' - ' + policyHolderLastName + ', ' + hotelName + ' #' + placementCount;
            this.placement.Status__c = 'Pending Check-In';
            this.placement.Selected_Search__c = hotelSearchId;
            this.placement.Regional_Manager_Email__c = claim.Regional_Manager__r.Email;
            this.placement.Customer_Care_Specialist_Email__c = claim.Customer_Care_Specialist__r.Email;
            this.placement.Area_Specialist_Email__c = claim.Area_Specialist__r.Email;
            this.placement.Housing_Coordinator_Email__c = claim.Housing_Coordinator__r.Email;
            this.placement.Hotel_Customer_Care_Specialist_Email__c = claim.Hotel_Customer_Care_Specialist__r.Email;

                       
            upsert this.placement;
            update serviceRequest;

            this.selectedHotelSearch.placement__c = this.placement.Id;
            
            update selectedHotelSearch;
            
            internalSelectedSearch();
            
            this.placement = fetchRelatedPlacement();
        } 
              
        return null;
    }
    
    public PageReference getNewCreditCard()
    {
        if (placement.Credit_Card_Type__c == 'PayNet' && placement.IsDeleted == false)
        {
        //    if (placement.Credit_Card_Number__c == null || placement.Credit_Card_Number__c == '' || placement.Credit_Card_Number__c == '5567080010661391' || placement.Credit_Card_Number__c == '4864623313547230' || placement.Credit_Card_Number__c == '4864623955177759')
       //     {
                string actionType = 'New';
                string ccEndDate = '';
                string ccAcctCIDExp = PayNetConnectCallOuts.setupCCRequest(actionType, placement.RecordType.Name, claim.Name, serviceRequest.Name, placement.Id, placement.Name, ccEndDate); 
            
                if (ccAcctCIDExp != null && ccAcctCIDExp != '')
                { 
                    List<String> ccInfo = ccAcctCIDExp.split(',',3);
                    placement.Credit_Card_Number__c = ccInfo[0];
                    placement.Credit_Card_CID__c = ccInfo[1];
                    placement.Credit_Card_Expiration__c = ccInfo[2];
                    placement.Using_Backup_Card__c = false;
                    update placement;
                }
                else
                {
                    placement.Credit_Card_Type__c = 'PayNet';
                    placement.Credit_Card_Number__c = '5552160161062875';
                    placement.Credit_Card_CID__c = '350';
                    placement.Credit_Card_Expiration__c = '01/2019';
                    placement.Using_Backup_Card__c = true;
              
                    update placement;
                } 
        //    }
        }
        else
        {
            if (placement.Credit_Card_Type__c == 'Mastercard')
            {
                placement.Credit_Card_Number__c = '5567080010661391';
                placement.Credit_Card_CID__c = '474';
                placement.Credit_Card_Expiration__c = '02/2015';
                placement.Using_Backup_Card__c = false;
                update placement;
            }
            else
            {
                if (placement.Credit_Card_Type__c == 'PayNet ID Copy')
                {
                    placement.Credit_Card_Number__c = '5552160296082418';
                    placement.Credit_Card_CID__c = '352';
                    placement.Credit_Card_Expiration__c = '10/2019';
                    placement.Using_Backup_Card__c = true;
                    update placement;       
                }
                else
                {
                    if (placement.Credit_Card_Type__c == 'Check')
                
                    placement.Credit_Card_Number__c = '';
                    placement.Credit_Card_CID__c = '';
                    placement.Credit_Card_Expiration__c = '';
                    placement.Using_Backup_Card__c = false;
                    update placement;       
                    
                }
            }
        }
                
        return null;
    }
    
    public void deleteCreditCard()
    {
        string actionType = 'Delete';
        string ccEndDate = '';
        
        string requestStatus = PayNetConnectCallOuts.setupCCRequest(actionType, placement.RecordType.Name, claim.Name, serviceRequest.Name, placement.Id, Placement.Name, ccEndDate); 
    }
    
    public void updateVPayCreditCard()
    {
        string actionType = 'Update';
        string fullPlacementId = this.placement.Id;
        string placementIdFirst15 = fullPlacementId.substring(0,15);
        string placementIdLast3 = fullPlacementId.substring(15,18);
        string cardNumber = placement.Credit_Card_Number__c;
        string ccEndDate = String.valueOf(placement.Estimated_Check_Out_Date__c);
        string requestStatus = VPayConnectCallOuts.setupCCRequest(actionType, placementIdFirst15, serviceRequest.Name, placementIdLast3, cardNumber, ccEndDate);
    }           
    
    public void updatePayNetCreditCard()
    {
        string actionType = 'Update';
        string ccEndDate = String.valueOf(placement.Estimated_Check_Out_Date__c);
        string requestStatus = PayNetConnectCallOuts.setupCCRequest(actionType, placement.RecordType.Name, claim.Name, serviceRequest.Name, placement.Id, placement.Name, ccEndDate);
    }          
   
    public PageReference editHotelRoom()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
    
        Id roomId = params.get('hotelRoomId');
        this.newHotelRoom = fetchHotelRoom(roomId);     
        return null;
    }
  
    public PageReference cloneHotelRoom()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
    
        Id roomId = params.get('hotelRoomId');
        this.newHotelRoom = fetchHotelRoom(roomId);  
        
        Hotel_Room__c hr = new Hotel_Room__c();
        hr.Placement__c = this.newHotelRoom.Placement__c;
        hr.Service_Request__c = this.newHotelRoom.Service_Request__c;
        
        hr.Kitchen_Features__c = this.newHotelRoom.Kitchen_Features__c;
        hr.Room_Type__c = this.newHotelRoom.Room_Type__c;
        hr.Confirmation__c = this.newHotelRoom.Confirmation__c;
        hr.Cancellation_del__c = this.newHotelRoom.Cancellation_del__c;
        hr.Parking_Fee_Type__c = this.newHotelRoom.Parking_Fee_Type__c;
        hr.Pet_Fee_Type__c = this.newHotelRoom.Pet_Fee_Type__c;
        hr.Other_Fee_Type__c = this.newHotelRoom.Other_Fee_Type__c;
        hr.Other_Fee_Description__c = this.newHotelRoom.Other_Fee_Description__c;
            
        hr.Check_In__c = this.newHotelRoom.Check_In__c;
        hr.Estimated_Check_Out_Date__c = this.newHotelRoom.Estimated_Check_Out_Date__c;
        hr.CheckOut__c = this.newHotelRoom.CheckOut__c;
        
        hr.Hotel_Nightly_Rate__c = this.newHotelRoom.Hotel_Nightly_Rate__c;
        hr.Itemized_Tax__c = this.newHotelRoom.Itemized_Tax__c;
        hr.One_Time_Pet_Fees_Taxable__c = this.newHotelRoom.One_Time_Pet_Fees_Taxable__c;
        hr.One_Time_Parking_Fees_Taxable__c = this.newHotelRoom.One_Time_Parking_Fees_Taxable__c;
        hr.One_Time_Other_Fees_Taxable__c = this.newHotelRoom.One_Time_Other_Fees_Taxable__c;
        hr.Parking_Fee_Amount__c = this.newHotelRoom.Parking_Fee_Amount__c;
        hr.Pet_Fee_Amount__c = this.newHotelRoom.Pet_Fee_Amount__c;
        hr.Other_Fee_Amount__c = this.newHotelRoom.Other_Fee_Amount__c;
            
        hr.Parking_Fee_cb__c = this.newHotelRoom.Parking_Fee_cb__c;
        hr.Pet_Fee_cb__c = this.newHotelRoom.Pet_Fee_cb__c;
        hr.Other_Fee_cb__c = this.newHotelRoom.Other_Fee_cb__c;
              
        upsert hr;
        
        this.fetchRelatedPlacement();
            
        return null;
    }
  
    public PageReference clearHotelRoom()
    {
        this.newHotelRoom = new Hotel_Room__c();
        this.newHotelRoom.Send_Text_Email_Notifications__c = true;
        return null;        
    }
  
    public PageReference saveHotelRoom()
    {
        if (getHasPlacement())
        {
                
            Map<string, string> params = ApexPages.currentPage().getParameters();
              
            Hotel_Room__c hr = new Hotel_Room__c();
            boolean newRoom = true;
            if (params.containsKey('hotelRoomId') )
            {   
                string sri = params.get('hotelRoomId');
                
                if (sri.length() > 0)
                {
                    Id roomId = params.get('hotelRoomId');
                    hr = fetchHotelRoom(roomId);
                    newRoom = false;
                    System.debug('RoomId =' + roomId);
                }
            }
            
            hr.Placement__c = this.fetchRelatedPlacement().Id;
            hr.Service_Request__c = this.serviceRequest.Id;
            
            hr.Room_Type__c = params.get('roomType');
            hr.Room_Number__c = params.get('roomNumber');
            hr.Kitchen_Features__c = params.get('kitchenFeatures');
            hr.Confirmation__c = params.get('confirmation');
            hr.Cancellation_del__c = params.get('cancellation');
                      
            hr.Check_In__c = parseDateParam('checkIn', params);
            hr.Estimated_Check_Out_Date__c = parseDateParam('EstimatedCheckOut', params);
            hr.CheckOut__c = parseDateParam('checkOut', params);
              
            hr.Billed_Through_Date__c = parseDateParam('billedThroughDate', params);
            hr.Hotel_Discount_Used__c = params.get('hoteldiscountUsed');

            try 
            {
                hr.Send_Text_Email_Notifications__c = Boolean.valueOf(params.get('sendTextEmailNotifications'));
            }
            catch (Exception ex) {}

            if (newRoom)
            { 
                // Only need to update these fields if this is a new room
                hr.Hotel_Nightly_Rate__c = parseDecimalParam('nightlyRate', params);
                hr.Itemized_Tax__c = parseDecimalParam('itemizedTax', params);
                hr.BAR_Rate__c = parseDecimalParam('barRate', params);
                hr.Parking_Fee_Type__c = params.get('parkingFeeType');
                hr.Pet_Fee_Type__c = params.get('petFeeType');
                hr.Other_Fee_Type__c = params.get('otherFeeType');
                hr.Other_Fee_Description__c = params.get('otherFeeDesc');
                hr.Parking_Fee_Amount__c = parseDecimalParam('parkingFeeAmount', params);
                hr.Pet_Fee_Amount__c = parseDecimalParam('petFeeAmount', params);
                hr.Other_Fee_Amount__c = parseDecimalParam('otherFeeAmount', params);
                hr.Policyholder__c = this.fetchRelatedClaim().Policyholder__c;
           
                string oneTimePetFeesTaxable = params.get('oneTimePetFeesTaxable');
                if (oneTimePetFeesTaxable == '1')
                {
                    hr.One_Time_Pet_Fees_Taxable__c = true;
                }
                else
                {
                    hr.One_Time_Pet_Fees_Taxable__c = false;
                }
                
                string oneTimeParkingFeesTaxable = params.get('oneTimeParkingFeesTaxable');
                if (oneTimeParkingFeesTaxable == '1')
                {
                    hr.One_Time_Parking_Fees_Taxable__c = true;
                }
                else
                {
                    hr.One_Time_Parking_Fees_Taxable__c = false;
                }
                
                string oneTimeOtherFeesTaxable = params.get('oneTimeOtherFeesTaxable');
                if (oneTimeOtherFeesTaxable == '1')
                {
                    hr.One_Time_Other_Fees_Taxable__c = true;
                }
                else
                {
                    hr.One_Time_Other_Fees_Taxable__c = false;
                }
                
                if (hr.Parking_Fee_Amount__c != null || hr.Parking_Fee_Type__c != '')
                {
                    hr.Parking_Fee_cb__c = true;
                }
                else
                {
                    hr.Parking_Fee_cb__c = false;   
                }
                
                if (hr.Pet_Fee_Amount__c != null || hr.Pet_Fee_Type__c != '')
                {
                    hr.Pet_Fee_cb__c = true;
                }
                else
                {
                    hr.Pet_Fee_cb__c = false;   
                }
                
                if (hr.Other_Fee_Amount__c != null || hr.Other_Fee_Type__c != '') 
                {
                    hr.Other_Fee_cb__c = true;
                }
                else
                {
                    hr.Other_Fee_cb__c = false; 
                }
            }
            
            if (hr.Estimated_Check_Out_Date__c > placement.Estimated_Check_Out_Date__c && hr.Cancellation_del__c == '' && hr.CheckOut__c == null && placement.Credit_Card_Type__c == 'vPay' && placement.Credit_Card_Number__c != '370268023665727' || 
            placement.Estimated_Check_Out_Date__c == null && hr.Cancellation_del__c == '' && hr.CheckOut__c == null && placement.Credit_Card_Type__c == 'vPay' && placement.Credit_Card_Number__c != '370268023665727')
            {
                placement.Estimated_Check_Out_Date__c = hr.Estimated_Check_Out_Date__c.addYears(1);
                updateVPayCreditCard();
                update placement;
            }
            else
            if (hr.Estimated_Check_Out_Date__c > placement.Estimated_Check_Out_Date__c && hr.Cancellation_del__c == '' && hr.CheckOut__c == null && placement.Credit_Card_Type__c == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875' || 
            placement.Estimated_Check_Out_Date__c == null && hr.Cancellation_del__c == '' && hr.CheckOut__c == null && placement.Credit_Card_Type__c == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875')
            {
                placement.Estimated_Check_Out_Date__c = hr.Estimated_Check_Out_Date__c.addYears(1);
                updatePayNetCreditCard();
                update placement;
            }
                          
            upsert hr;
        }
        
        this.fetchRelatedPlacement();
        
        return null;
    }
    
    
    public PageReference updateHotelRoomBARRate()
    {
    
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
      
        string hotelRoomId = pageParams.get('hotelRoomId');
        
        Hotel_Room__c hotelRoom = [select Id from Hotel_Room__c where Id =: hotelRoomId];
        hotelRoom.BAR_Rate__c =  parseDecimalParam('hotelRoomBARRate', pageParams);
        update hotelRoom;

        refreshHotelRooms();
                     
        return null;
    }
    
    public PageReference refreshHotelRooms()
    {
        this.fetchRelatedPlacement();
        
        return null;
    }
  
    public PageReference setBillingCompleted()
    {
        this.placement.Billing_Completed__c = true;
        if (this.placement.Date_Billing_Completed__c == null)
        {
            this.placement.Date_Billing_Completed__c = DateTime.now();
        }
        this.placement.Using_Backup_Card__c = false;
        upsert this.placement;
        return null;
    }
    
    public PageReference undoBillingCompleted()
    {
        this.placement.Billing_Completed__c = false;
        upsert this.placement;
        return null;
    }
  
    public boolean getIsBillingSpecialist()
    {
        if (profileName == 'CRS Billing Specialist' || profileName == 'System Administrator' || profileName == 'Accounting Manager' )
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
  
    public void setIsBillingSpecialist(boolean val){ /* don't do anything */ }
    
    public boolean getIsAccountingManager()
    {
        if (profileName == 'Accounting Manager' || profileName == 'System Administrator' )
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
    
    public boolean getIsManagerOrDirector()
    {
        if (profileName == 'Operations Manager' || profileName == 'Operations Director' || profileName == 'Accounting Manager' || profileName == 'System Administrator' )
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
    
    public void setIsManagerOrDirector(boolean val){}
    
    public boolean getIsOperationsDirector()
    {
        if (profileName == 'Operations Director' || profileName == 'System Administrator')
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
    
    public void setIsOperationsDirector(boolean val){} 
    
    public string getRateCalendarURL()
    {
        string rcBaseURL;
                      
        rcBaseURL = 'https://www.placetrakforce.com/ratecalendar/' + getInstanceName() + '/';
       
        string rcURL = rcBaseURL + 'Rooms/RoomDetails.aspx?Room_Id=' + newHotelRoom.Id + '&UserID=' + UserInfo.getUserId() + '&DisplayMode=1';
            
        if (profileName == 'CRS Billing Specialist' || profileName == 'System Administrator' || profileName == 'Accounting Manager' )
        {
            rcURL = rcBaseURL + 'Rooms/RoomDetails.aspx?Room_Id=' + newHotelRoom.Id + '&UserID=' + UserInfo.getUserId() + '&DisplayMode=3'; 
        }   
               
        return rcURL;
    }
  
    public void setRateCalendarURL(string val){ /* don't do anything */ }
  
    public void setIsAccountingManager(boolean val){ /* don't do anything */ }
  
    public boolean getIsBillingCompleted()
    {
        if (this.placement.Id != null)
        {
            try
            {
                boolean isBillingCompleted = [Select p.Billing_Completed__c From Placement__c p where p.Id=:this.placement.Id].Billing_Completed__c;
            
                if (isBillingCompleted)
                {
                    return true;
                }
                else
                {
                    return false;   
                }
            }
            catch (QueryException e)
            {
                return false;
            }       
        }
        else
        {
            return false;   
        }
    }
  
    public void setIsBillingCompleted(boolean val){ /* don't do anything */ }
    
    public boolean getHasHotelRooms()
    {
        Integer count = 0;
        
        if (serviceRequest.Id != null)
            {
            count = [select count() from Hotel_Room__c where Service_Request__c = :serviceRequest.Id];
            }
        
        if (count > 0) { return true;}
        return false;
    }
  
    public void setHasHotelRooms(boolean val){ /* don't do anything */ }
  
    public boolean getHasUnbilledRooms()
    {
        if (this.placement.Id != null)
        {
            Integer unbilledCount = 0;
            Integer totalCount = 0;
            
            totalCount = [select count() from Hotel_Room__c where Placement__c = : this.placement.Id];
            unbilledCount = [select count() from Hotel_Room__c where Placement__c = : this.placement.Id and Billing_Complete__c = 'FALSE'];
            
            if (totalCount == 0 || unbilledCount > 0)
            {
                return true;
            }
            else
            {
                return false;   
            }       
        }
        else
        {
            return true;    
        }
    }
  
    public void setHasUnbilledRooms(boolean val){ /* don't do anything */ }
    
    
    public boolean getHasRelatedPlacement()
    {
        if (this.placement.Id == null)
        {
            return false;
        }
        return true;
    }
  
    public boolean getHasCompletedClaim()
    {
        if (this.claim.Adjuster__c != null && this.claim.Policyholder__c != null) 
        {
            return true;
        }   
        else
        {
            return false;
        }
    }
  
    public void setHasCompletedClaim(boolean val){ /* don't do anything */ }
 
    public boolean getHasPlacement()
    {
        this.placement = fetchRelatedPlacement();
        if (this.placement.Id == null)
        {
            return false;
        }
        return true;
    }
  
    public void setHasPlacement(boolean val){ /* don't do anything */ }
  
    public boolean getIsPlacementCheckedOut()
    {
        if (this.placement.Id != null && this.placement.Check_Out_Date__c != null)
        {
            try
            {
                Placement__History placementHistory = [Select NewValue,CreatedDate From Placement__History where ParentId=:this.placement.Id and Field = 'Check_Out_Date__c' order by CreatedDate DESC limit 1];
                 string newValue = string.valueOf(placementHistory.get('NewValue'));
                date dateChanged = date.newInstance(placementHistory.CreatedDate.year(), placementHistory.CreatedDate.month(), placementHistory.CreatedDate.day());
                date today = date.newInstance(Date.today().year(),Date.today().month(),Date.today().day());
            
                if (newValue != null && dateChanged != today && !getIsBillingSpecialist())
                {
                    return true;
                }
                else
                {
                    return false;   
                }       
            }
            catch (QueryException e)
            {
                return true;
            }
        }
        else
        {
            return false;   
        }
    }
  
    public void setIsPlacementCheckedOut(boolean val){ /* don't do anything */ }
    
    // return selected hotel search (or null) from list of hotel searches
    private Searches__c fetchSelectedHotelSearch(Id hotelSearchId)
    {
        if (hotelSearchId == null)
        {
            this.selectedHotelSearch = null;
        }
        
        List<Searches__c> searches = getHotelSearches();
        //Searches__c selectedSearch = null;
        for (Searches__c s : searches)
        {
            if (s.Id == hotelSearchId)
            {
                s.Selected__c = true;       
                
                this.selectedHotelSearch = s;
            }
            else
            {
                s.Selected__c = false;
            }
        }
        update searches;
        return selectedHotelSearch;
    }
    
    
    private void internalSelectedSearch()
    {
        for (Searches__c s : getHotelSearches())
        {
            if (s.Selected__c == true)
            {
                this.selectedHotelSearch = s;
            }
        }
    }
    
  
    // returns related placement, or a new placement based on serviceRequest.Id
    private Placement__c fetchRelatedPlacement()
    {
        Placement__c relatedPlacement;
        
        if (serviceRequest == null || serviceRequest.Id == null)
        {
            relatedPlacement = new Placement__c();
            relatedPlacement.RecordTypeId = RecordTypeHelper.hotelPlacementRT();
            relatedPlacement.ServiceRequest__c = serviceRequest.Id;
        }   
        else
        {
            
            try
            {
               relatedPlacement = [select Id,  RecordTypeId, Name, Opportunity__c, Hotel_Account_Lookup__c, Credit_Card_Type__c, Credit_Card_Number__c, Credit_Card_Expiration__c, HSA_Signed__c, Status__c, ServiceRequest__c, MHS_Booking__c, 
                                                            Special_Instructions__c, Check_In_Date__c,Check_Out_Date__c,Invoice_From_Folio__c,Payment_Type__c,Estimated_Check_Out_Date__c,Accounting_Instructions__c,IATA_Number_Provided__c,IATA_Commission_Paid__c,
                                                            IATA_Closed__c,IATA_Closed_Notes__c,serviceRequest__r.opportunity__r.ALE_Limit_Amount__c,isDeleted,Credit_Card_CID__c,Reason_For_Leaving__c,Date_Billing_Completed__c,Move_In_Docs_Missing__c,RecordType.Name,
                                                            (select Id, Name, CRS_Room_Rate__c, Cancellation_del__c, Checkout__c, Estimated_Check_Out_Date__c, Check_In__c, Confirmation__c, 
                                                                    Hotel_Nightly_Rate__c, Itemized_Tax__c, Pet_Fee_Amount__c, Pet_Fee_Type__c, Parking_Fee_Amount__c, Parking_Fee_Type__c, Other_Fee_Amount__c, Other_Fee_Type__c, Billed_Through_Date__c, One_Time_Pet_Fees_Taxable__c,
                                                                    One_Time_Parking_Fees_Taxable__c,One_Time_Other_Fees_Taxable__c,Avg_Price_Rate__c,Avg_Cost_Rate__c,Total_Unbilled__c,CRS_Room_Rate_Price__c,Kitchen_Features__c,Nights_In_Room__c,Other_Fee_Description__c,Room_Number__c,
                                                                    BAR_Rate__c,Send_Text_Email_Notifications__c
                                                            from Hotel_Rooms__r
                                                            order by CreatedDate)
                                                            from Placement__c 
                                                            where ServiceRequest__c = :serviceRequest.Id 
                                                            limit 1];
            }
            catch (QueryException e)
            {
                relatedPlacement = new Placement__c();
                relatedPlacement.RecordTypeId = RecordTypeHelper.hotelPlacementRT();
                
            }
        }
    
        this.placement = relatedPlacement;
        return this.placement;
    }
     
    public Integer fetchPlacementCount()
    {
        Integer retval = 0;
        
        if (serviceRequest == null || serviceRequest.Opportunity__c == null)
        {
            return retval;
        }   
        else
        {
            
            try
            {
                Integer c = [Select count() from Placement__c where Opportunity__c = :serviceRequest.Opportunity__c ];
                retval = c;
            }
            catch (QueryException e)
            {
                return retval;
            }
        }
        
        return retval;
    }
  
    private Opportunity fetchRelatedClaim()
    {
        Opportunity opp;
        try 
        {
            opp = [select Id, Name, Policyholder__r.FirstName, Policyholder__r.LastName, Adjuster__c,
                          Policyholder__c, Policy_Type__c,Damaged_Property_Full_Address__c,
                          Regional_Manager__r.Email,Customer_Care_Specialist__r.Email,Area_Specialist__r.Email,
                          Housing_Coordinator__r.Email,Hotel_Customer_Care_Specialist__r.Email
                   from Opportunity
                   where id = :serviceRequest.Opportunity__c];  
        }
        catch (QueryException e)
        {
            opp = new Opportunity();
        }
        
        this.claim = opp;
        return this.claim;
    }
  
    private Hotel_Room__c fetchHotelRoom(Id hotelRoomId)
    {
        System.debug('RoomId =' + hotelRoomId);
        
         Hotel_Room__c hr = [select Id, Placement__c, Service_Request__c, Name, 
                                    Room_Type__c, Confirmation__c, Cancellation_del__c, 
                                    Parking_Fee_Type__c, Pet_Fee_Type__c, Other_Fee_Type__c, Other_Fee_Description__c, 
                                    Check_In__c, Estimated_Check_Out_Date__c, CheckOut__c, Hotel_Nightly_Rate__c, Itemized_Tax__c, 
                                    Parking_Fee_Amount__c, Pet_Fee_Amount__c, Other_Fee_Amount__c, 
                                    Parking_Fee_cb__c, Pet_Fee_cb__c, Other_Fee_cb__c,Billed_Through_Date__c, One_Time_Pet_Fees_Taxable__c,
                                    One_Time_Parking_Fees_Taxable__c,One_Time_Other_Fees_Taxable__c,Avg_Price_Rate__c,Avg_Cost_Rate__c,
                                    Total_Unbilled__c,CRS_Room_Rate_Price__c,Kitchen_Features__c,Nights_In_Room__c,BAR_Rate__c,Room_Number__c,
                                    Hotel_Discount_Used__c,Send_Text_Email_Notifications__c
                        from Hotel_Room__c
                        where Id = :hotelRoomId
                    ];
        
        return hr;
    }
  
    private String parseStringParam(string paramKey, map<string, string> params)
    {
        String retval = null;
        
        if (params.containsKey(paramKey))
        {
            string d = params.get(paramKey);
            
            if (d.trim().length() > 0)
            {
                return d;   
            }   
        }
        return retval;
    }
    
    private Date parseDateParam(string paramKey, map<string, string> params)
    {
        Date retval = null;
        
        if (params.containsKey(paramKey))
        {
            string d = params.get(paramKey);
            
            if (d.trim().length() > 0)
            {
                try
                {
                    Date dt = Date.parse(d);
                    return dt;
                }
                catch(System.TypeException ex)
                {
                    return retval;
                }
                
            }
        }
    
        return retval;
    }
  
    private Datetime parseDateTimeParam(string paramKey, map<string, string> params)
    {
        Datetime retval = null;
        
        if (params.containsKey(paramKey))
        {
            string d = params.get(paramKey);
            
            if (d.trim().length() > 0)
            {
                try
                {
                    Datetime dt = Datetime.parse(d.replace(',',''));
                    return dt;
                }
                catch(System.TypeException ex)
                {
                    return retval;
                }
                
            }
        }
        
        return retval;
    }
    
    @TestVisible
    private Decimal parseDecimalParam(string paramKey, map<string, string> params)
    {
        Decimal retval = null;
        
        if (params.containsKey(paramKey))
        {
            string d = params.get(paramKey);
            
            if (d.trim().length() > 0)
            {
                try 
                {
                    Decimal dec = Decimal.valueOf(d.replace(',',''));
                    retval = dec;
                }
                catch(System.TypeException ex)
                {
                    return retval;
                }
            }
        }
        return retval;
    }
}