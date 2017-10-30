public with sharing class HousingServiceRequestControllerExtension 
{   
    String instanceName = Util.getInstanceName();
    String profileName = Util.getUserProfileName();
        
    private Placement__c placement;
    private Searches__c selectedHousingSearch; 
    private Opportunity claim;
    private History placementHistory;
    public ServiceRequest__c serviceRequest {get; set;}
    public Searches__c housingSearch {get; set;}
    public Costs__c cost {get; set;}
    public Furniture_Order__c furnitureOrder {get; set;}
    public Quote__c quote {get; set;}
    public Boolean pageRefresh {get; set;}  

    public ApexPages.StandardController stdController;
         
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

    public Searches__c getSelectedHousingSearch()
    {
        return this.selectedHousingSearch;
    }  
    
    public Boolean getHasSelectedHousingSearch()
    {
        internalSelectedSearch();
        
        if (this.selectedHousingSearch == null)
        {
            return false;
        }
        return true;
    }
    
 //   public void setHasSelectedHousingSearch(Boolean val) {}
    
    public string getSelectedHousingSearchFurnitureOption()
    {
        internalSelectedSearch();
        
        if (this.selectedHousingSearch == null)
        {
            return '';
        }
        return this.selectedHousingSearch.Furniture_Option__c;
    }
    
//    public void setSelectedHousingSearchFurnitureOption(string val) {}
    
    public Boolean getSelectedHousingSearchForeclosureCheck()
    {
        internalSelectedSearch();
        
        if (this.selectedHousingSearch == null)
        {
            return false;
        }
        return this.selectedHousingSearch.Foreclosure__c;
    }
     
//    public void setSelectedHousingSearchForeclosureCheck(Boolean val) {}
    
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
        
//    public void setIsProductionOrg(Boolean val) {}
    
    public String getInstanceName()
    {
        return instanceName;   
    }
        
//    public void setInstanceName(String val) {}
    
    public string getFullFurniturePickupURL()
    {
        string ffpURL;
        string ffpBaseURL;
              
        if (getIsProductionOrg())
        {
            ffpBaseURL = 'https://www.placetrakforce.com/vss/production/';
        }
        else
        {
            ffpBaseURL = 'https://www.placetrakforce.com/vss/staging/';
        } 
        String serviceRequestName = EncodingUtil.urlEncode(serviceRequest.Name, 'UTF-8');
    
        ffpURL = ffpBaseURL + 'public/fullfurniturepickuprequest.aspx?id=' + serviceRequestName + '&User=' + UserInfo.getUserEmail();
               
        return ffpURL;
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
        string url = orgId + '&UserId=' + userId + '&Date=' + currentDT + '&Hash=' + hexDigest;
                
        return url;
    }

    public string getDocumentHash()
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
    
    public string getCostRecordTypeName() 
    {
        if (this.cost.RecordTypeId != null)
        {
            string rtName = [select Name from RecordType where id =: this.cost.RecordTypeId].Name;
        
            return rtName;
        }
        else
        {
            return '';
        }
    }
      
    public boolean getIsFirstPropertyPresentedSet()
    {
        try
        {
            ServiceRequest__c  serviceRequest = [Select First_Property_Presented__c From ServiceRequest__c where Opportunity__c = :this.claim.Id and RecordTypeId =:RecordTypeHelper.housingServiceRequestRT() and First_Property_Presented__c <> null limit 1];
        }
        catch (Exception e)
        {
            return false;
        }    
        if (serviceRequest.First_Property_Presented__c != null)
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
 
    public boolean get()
    {
        if (this.placement.Id == null)
        {
            return false;
        }
        return true;
    }
    
    public boolean getHasFurnitureOrder() 
    {
        List<Furniture_Order__c> furnitureOrders = new List<Furniture_Order__c>();
        furnitureOrders = getFurnitureOrders();
        if (furnitureOrders.isEmpty())
        {
            return false;
        }
        else
        {
            return true;
        }   
    }
    
    public boolean getHasFurnitureOrderCost()
    {
        Furniture_Order__c furnitureOrder = new Furniture_Order__c();
        furnitureOrder = fetchActiveFurnitureOrder(this.placement.Id);
        if (furnitureOrder.Cost__c == null && furnitureOrder.Furniture_Cost__c == null && furnitureOrder.Appliance_Cost__c == null
            && furnitureOrder.Electronics_Cost__c == null && furnitureOrder.Kitchen_Housewares_Cost__c == null 
            && furnitureOrder.BedBath_Housewares_Cost__c == null && furnitureOrder.Other_Housewares_Cost__c == null)
        {
            return false;
        }
        else
        {
            return true;
        }   
    }
     
    public string getActiveFurnitureOrderStatus()
    {
        Furniture_Order__c furnitureOrder = new Furniture_Order__c();
        furnitureOrder = fetchActiveFurnitureOrder(this.placement.Id);
        if (furnitureOrder.Id == null)
        {
            return '';
        }
        else
        {
            return furnitureOrder.Status__c;
        }   
    }
  
    public boolean getHasQuote()
    {
        List<Quote__c> quotes = new List<Quote__c>();
        quotes = getQuotes();
        if (quotes.isEmpty())
        {
            return false;
        }
        else
        {
            return true;
        }   
    }
  
    public string getQuoteStatus()
    {
        List<Quote__c> quotes = new List<Quote__c>();
        quotes = getQuotes();
        if (quotes.isEmpty())
        {
            return '';
        }
        else
        {
            return quotes[0].Status__c;
        }   
    }
  
    public boolean getHasActiveQuote()
    {
        Quote__c quote = new Quote__c();
        quote = fetchActiveQuote(this.placement.Id);
        if (quote.Id == null)
        {
            return false;
        }
        else
        {
            return true;
        }   
    }

    public Quote__c getActiveQuote()
    {
        Quote__c quote = new Quote__c();
        quote = fetchActiveQuote(this.placement.Id);
        if (quote.Id == null)
        {
            return null;
        }
        else
        {
            return quote;
        }   
    }
  
    public boolean getIsPlacementMovedOut()
    {
        if (this.placement.Status__c == 'Moved-Out' || this.placement.Status__c == 'Closed')
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
  
    public boolean getIsPlacementCancelled()
    {
        try
        {
            string status = [Select p.Status__c From Placement__c p where p.Id=:this.placement.Id].Status__c;
        
            if (status == 'Cancelled' && this.placement.Status__c != 'Cancelled')
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
      
    public boolean getPlacementHasNewATD()
    {
        try
        {
            Date approvedThroughDate = [Select p.Approved_Through_Date__c From Placement__c p where p.Id=:this.placement.Id].Approved_Through_Date__c;
        
            if (approvedThroughDate != this.placement.Approved_Through_Date__c && approvedThroughDate != null)
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

    public boolean getSROnHold()
    {
        Boolean srOnHold = [select Hold__c from ServiceRequest__c where Id =: this.serviceRequest.Id].Hold__c;
        if (srOnHold ==  True)
        {
            return true;
        }
        else
        {
            return false;   
        }       
    }
      
       
    public List<Searches__c> getHousingSearches() 
    {
        List<Searches__c> searches = new List<Searches__c>();
        
        if (serviceRequest.Id != null)
        {
            searches = [select Id, Presented_Date__c, Name, Email__c, 
                               Selected__c, Distance_from_Damaged_Property__c,Landlord__c,Landlord_Status__c,
                               Street_Addr1__c, Street_Addr2__c, City__c, State__c, Zip__c, ForeClosure__c, Property_Description__c, 
                               Days_Notice_Required__c, Bedrooms__c, Initial_Check_Delivery_Method__c, Initial_Payment_Type__c,Rent_Costs__c,
                               Property_Type__c,Furniture_Option__c,Temporary_Address__c,Country__c,Service_Request__r.Name,Placement__r.Name,
                               Recurring_Payment_Type__c,Name_of_Complex__c,Unit__c,Initial_Contact_Name__c,Initial_Contact_Number__c,Bathrooms__c,Square_Feet__c,
                               Pets_Allowed__c,Wood_Floors__c,Elevator_Reservation_Required__c,Extension_Increment_Days__c,NTV_Send_Via__c,Send_Copy_of_Check__c,
                               Send_Copy_of_Tracking_Information__c,Total_Costs__c,Security_Deposit__c,Has_Rent__c,Has_Policyholder_Rent__c,
                               Has_Policyholder_Abatement__c,Has_Utilities__c,Original_Selected_Date__c,Sequence_Number__c,Policyholder_Accepted_Property_Date__c,
                               Policyholder_Declined_Property_Date__c,Policyholder_Declined_Property_Reason__c,Has_Payable_Landlord_Cost__c,PH_Viewed__c,Floor__c,Over_5_Mile_Reason__c,Lease_Term_Approved_By_Adjuster__c,
                               First_Available_Move_In_Date__c,Tentative_Move_Out_Date__c,Rent_Frequency__c,First_Month_Pro_Rated_Rent_Amount_Due__c,What_Is_Included_In_The_Prorated_Rent__c,
                               RSD__c,Pet_RSD__c,Responsible_Party_For_RSD__c,Sure_Deposit__c,Application_Fee__c,Tax__c,Total_Pet_Fees__c,Cleaning_Fee__c,Amenity_Fee__c,Administration_Fee__c,Re_Keying_Fee__c,
                               Break_Lease_Fee__c,Garage_Remote_Fee__c,Fencing_Fee__c,Renters_Insurance_Required__c,Declaration_Page_Sufficient__c,RM_Updated__c,
                               Rental_Application_Required__c,Processing_Time_For_Application__c,Requirements_For_Qualification__c,Utilities_Included_In_Rent__c,
                               How_Utilities_Are_To_Be_Established__c,Utilities_PH_Is_Responsible_For__c,Landscaping_Snow_Removal_HOA_Included__c,
                               Appliances_Present_In_Rental_Property__c,Appliances_CRS_Needs_To_Provide__c,Appliance_Hook_Up_Gas_Electric__c,Window_Coverings_Present__c,
                               Pictures_Allowed_On_Walls__c,Number_Of_Pets_Allowed__c,Fenced_Yard__c,Utility_Set_Up_Fee__c,Broker_Fee__c,Window_Covering_Fee__c,
                               Certificate_Of_Occupancy_Required__c,Certificate_Of_Occupancy_Fee__c,Parking_Fee__c,Other_Non_Refundable_Fee__c,PH_Abatement_Amount__c,
                               Start_Date_For_PH_Abatement__c,Responsible_Party_For_Vendor_Entry__c,Phone_Number_To_Confirm_Vendor_Entry__c,
                               Days_Notice_Required_After_ILT__c,Presented_To_Adjuster__c,Rent__c,What_Utilities_Are_Included_In_Rent__c,Rent_Increase_After_ILT__c,Rent_Increase_To_After_ILT__c,NTV_Send_To__c
                               from Searches__c 
                               where Service_Request__c = :serviceRequest.Id 
                               order by Sequence_Number__c];
        }
        return searches;
    }
    
    public List<Quote__c> getQuotes()
    {
        List<Quote__c> quotes = new List<Quote__c>();
        
        try 
        {
            quotes = [select Id,Name,Status__c,Searches__c,Property_Type_New__c,Temporary_Address_New__c,Quote_Document_Recieved__c
                      from Quote__c 
                      where RecordTypeId =: RecordTypeHelper.mulliganQuoteRT() and Placement_Lookup__c =: placement.Id 
                      order by CreatedDate DESC,Name];
        }
        catch (QueryException e)
        {
           quotes = new List<Quote__c>();   
        }
        
        return quotes;
    }
    
    public List<Costs__c> getQuoteCosts()
    {
        List<Costs__c> costs = new List<Costs__c>();    
        
        if (selectedHousingSearch != null)
        {
            try 
            {
                costs = [select Name,RecordTypeId,Start_Date__c,End_Date__c,Amount__c,Type__c,Type_Description__c,Billable_Party__c,Payable_Party__c, 
                                Prorate_Type__c,Searches__c
                                from Costs__c 
                                where Searches__c = :selectedHousingSearch.Id 
                                order by CreatedDate];
            }
            catch (QueryException e)
            {
               costs = new List<Costs__c>();   
            }
            
            furnitureOrder = fetchCompletedFurnitureOrder(placement.Id); 
            
            if (furnitureOrder.Id != null)
            {
                //Add furniture cost    
                 
                

                if (furnitureOrder.Cost__c != null)
                {
                    
                    Costs__c cost = new Costs__c();
                    cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                    cost.Type__c = 'Furniture';
                    cost.Amount__c = furnitureOrder.Cost__c;
                    cost.Prorate_Type__c = 'Monthly';
                    if (furnitureOrder.Billable_Party_Cost__c == 'Adjuster')
                    {
                        cost.Billable_Party__c = this.claim.Adjuster__c;
                    }
                    else
                    {                       
                        cost.Billable_Party__c = this.claim.Policyholder__c; 
                    }
                    cost.Searches__c = selectedHousingSearch.Id;

                    costs.add(cost);
                }
                else
                {
                    if (furnitureOrder.Furniture_Cost__c != null)
                    {
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                        cost.Type__c = 'Furniture';
                        cost.Amount__c = furnitureOrder.Furniture_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_Furniture_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }   

                    if (furnitureOrder.Appliance_Cost__c != null)
                    {
                        
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                        cost.Type__c = 'Appliance';
                        cost.Amount__c = furnitureOrder.Appliance_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_Appliance_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }    

                    if (furnitureOrder.Electronics_Cost__c != null)
                    {
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                        cost.Type__c = 'Electronics';
                        cost.Amount__c = furnitureOrder.Electronics_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_Electronics_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }  

                    if (furnitureOrder.Kitchen_Housewares_Cost__c != null)
                    {
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                        cost.Type__c = 'Kitchen Housewares';
                        cost.Amount__c = furnitureOrder.Kitchen_Housewares_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_Kitchen_Housewares_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }

                    if (furnitureOrder.BedBath_Housewares_Cost__c != null)
                    {
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT(); 
                        cost.Type__c = 'Bed Bath Housewares';
                        cost.Amount__c = furnitureOrder.BedBath_Housewares_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_BedBath_Housewares_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }   

                    if (furnitureOrder.Other_Housewares_Cost__c != null)
                    {
                        Costs__c cost = new Costs__c();
                        cost.RecordTypeId = RecordTypeHelper.costCostsRT();

                        cost.Type__c = 'Other Housewares';
                        cost.Amount__c = furnitureOrder.Other_Housewares_Cost__c;
                        cost.Prorate_Type__c = 'Monthly';
                        if (furnitureOrder.Billable_Party_Other_Housewares_Cost__c == 'Adjuster')
                        {
                            cost.Billable_Party__c = this.claim.Adjuster__c;
                        }
                        else
                        {
                            cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }
                        cost.Searches__c = selectedHousingSearch.Id;

                        costs.add(cost);
                    }                        
                }
                        
                                
                if (furnitureOrder.Deposit__c != null)
                {
                    //Add furniture deposit 
                    cost = new Costs__c();
                    cost.RecordTypeId = RecordTypeHelper.furnitureDepositCostsRT();
                    cost.Type__c = 'Furniture Deposit';
                    cost.Amount__c = furnitureOrder.Deposit__c;
                    if (furnitureOrder.Billable_Party_Deposit__c == 'Adjuster')
                    {
                        cost.Billable_Party__c = this.claim.Adjuster__c;
                    }
                    else
                    {
                        cost.Billable_Party__c = this.claim.Policyholder__c; 
                    }
                    cost.Searches__c = selectedHousingSearch.Id;
                
                costs.add(cost);
                }
                
                if (furnitureOrder.Delivery_Fee__c != null)
                {
                    //Add furniture fee
                    cost = new Costs__c();
                    cost.RecordTypeId = RecordTypeHelper.furnitureFeeCostsRT();
                    cost.Type__c = 'Furniture Delivery Fee';
                    cost.Amount__c = furnitureOrder.Delivery_Fee__c;
                    if (furnitureOrder.Billable_Party_Delivery_Fee__c == 'Adjuster')
                    {
                        cost.Billable_Party__c = this.claim.Adjuster__c;
                    }
                    else
                    {
                        cost.Billable_Party__c = this.claim.Policyholder__c; 
                    }
                    cost.Searches__c = selectedHousingSearch.Id;
                
                costs.add(cost);
                }
                
                if (furnitureOrder.Pet_Fee__c != null)
                {
                    //Add furniture fee 
                    cost = new Costs__c();
                    cost.RecordTypeId = RecordTypeHelper.furnitureFeeCostsRT();
                    cost.Type__c = 'Furniture Pet Fee';
                    cost.Amount__c = furnitureOrder.Pet_Fee__c;
                    if (furnitureOrder.Billable_Party_Pet_Fee__c == 'Adjuster')
                    {
                        cost.Billable_Party__c = this.claim.Adjuster__c;
                    }
                    else
                    {
                        cost.Billable_Party__c = this.claim.Policyholder__c;
                    }
                    cost.Searches__c = selectedHousingSearch.Id;
                
                costs.add(cost);
                }
                
                if (furnitureOrder.Setup_Fee__c != null)
                {
                    //Add furniture fee
                    cost = new Costs__c();
                    cost.RecordTypeId = RecordTypeHelper.furnitureFeeCostsRT();
                    cost.Type__c = 'Furniture Setup Fee';
                    cost.Amount__c = furnitureOrder.Setup_Fee__c;
                    if (furnitureOrder.Billable_Party_Setup_Fee__c == 'Adjuster')
                    {
                        cost.Billable_Party__c = this.claim.Adjuster__c;
                    }
                    else
                    {
                        cost.Billable_Party__c = this.claim.Policyholder__c; 
                    }
                    cost.Searches__c = selectedHousingSearch.Id;
                
                costs.add(cost);
                }
            }
        }  
        return costs; 
    }
    
    public List<Furniture_Order__c> getFurnitureOrders()
    {
        List<Furniture_Order__c> furnitureOrders = new List<Furniture_Order__c>();
        
        if (serviceRequest.Id != null)
        {
            furnitureOrders = [select Id, Name, Status__c, Searches__c, Requested_Furniture_Delivery_Date__c, Created_After_Move_in__c
                               from Furniture_Order__c 
                               where Service_Request__c = :serviceRequest.Id 
                               order by CreatedDate];
        }
        return furnitureOrders;
    }
    
    public List<Extension__c> getHousingExtensions()
    {
        List<Extension__c> housingExtensions = new List<Extension__c>();
        
        
        housingExtensions = [select Name, Extend_To_Date__c, CreatedDate, Extension_Created_By__c
                           from Extension__c 
                           where Placement__c =: placement.Id 
                           order by CreatedDate];
        
        return housingExtensions;
    }

    public String getUndeclinedSearchNames()
    {
        List<String> undeclinedSearchNames = new List<String>();
        List<Searches__c> searches = getHousingSearches();
        for (Searches__c s : searches)
        {
            if (s.Furniture_Option__c != 'Furniture Only' && s.Policyholder_Declined_Property_Date__c == null)
            {
                undeclinedSearchNames.add(s.Name);          
            }
        }
        return JSON.serialize(undeclinedSearchNames);
    }

    public HousingServiceRequestControllerExtension(ApexPages.StandardController stdController)
    {
        serviceRequest = (ServiceRequest__c)stdController.getRecord();
        this.housingSearch = new Searches__c();
        this.cost = new Costs__c();
        this.furnitureOrder = new Furniture_Order__c();
        this.quote = new Quote__c();
        this.placement = this.getPlacement();
       
        internalSelectedSearch();
    }
 
    public PageReference saveServiceRequest()
    {
       
        system.debug(serviceRequest.DWO_Reason_Code__c);
        system.debug(serviceRequest.Hold__c);
        system.debug(serviceRequest.Status__c);
        if (getSROnHold() && serviceRequest.DWO_Reason_Code__c != null)
        {
            pageRefresh = true; 
        }
        else
        {
            pageRefresh = false; 
        } 


        if (serviceRequest.DWO_Reason_Code__c != null && (this.placement.Status__c == 'Searching' || this.placement.Status__c == 'Viewing') && pageRefresh == false)
        {
            serviceRequest.Status__c = 'Lost Opportunity';
            placement.Status__c = 'Lost Opportunity'; 
            upsert placement;
        }
        
        if (pageRefresh == false)
        {    
            upsert serviceRequest;
        }

        if (serviceRequest.Status__c == 'Lost Opportunity' && pageRefresh == false)
        {
            serviceRequest.DWO_Date__c = [Select DWO_Date__c from ServiceRequest__c where Id =: serviceRequest.Id].DWO_Date__c;
        }
       
        return null;
    }
    
    public PageReference updatePlacement()
    {
        if (getHasSelectedHousingSearch() == false && this.placement.Status__c != 'Searching' && this.placement.Status__c != 'Viewing' && this.placement.Status__c != 'Lost Opportunity' || getHasActiveQuote() && this.placement.Status__c == 'Pending Confirmation')
        {
            pageRefresh = true; 
        }
        else
        {
            if (getPlacementHasNewATD() && (this.placement.Status__c == 'Moved-In' || this.placement.Status__c == 'Moved-Out'))
            {
                pageRefresh = true; 
            }
            else
            {
                if (getIsPlacementCancelled()) 
                {
                    pageRefresh = true;
                }
                else
                {    
                    pageRefresh = false;    
                    if (!getIsPlacementCancelled())
                    {
                        if (placement.Selected_Search__r != null)
                        {
                            try
                            {
                                upsert placement.Selected_Search__r;
                            }
                            catch (Exception ex)
                            {
                                return null;
                            }           
                        }
                        if (placement.Disposition_Completed__c && placement.Status__c == 'Moved-Out')
                        {
                            placement.Status__c = 'Closed';
                        }
                        else
                        {
                            if (placement.Disposition_Completed__c == false && placement.Status__c == 'Closed')
                            {
                                placement.Status__c = 'Moved-Out';
                            }
                        }

                        if (placement.Rent_Hold__c == false)
                        {
                            placement.Rent_Hold_Reason__c = '';
                        }

                        if (placement.Invoice_Hold__c == false)
                        {
                            placement.Invoice_Hold_Reason__c = '';
                        }

                        if (placement.Selected_Search__r.Days_Notice_Required__c == null)
                        {
                            placement.Date_To_Send_NTV__c = placement.Approved_Through_Date__c;
                        }
                        else
                        {
                            placement.Date_To_Send_NTV__c = placement.Approved_Through_Date__c - placement.Selected_Search__r.Days_Notice_Required__c.intValue();    
                        }
                                           
                        upsert placement;
                    }
                }
            }
            this.placement = fetchRelatedPlacement();
        }
                      
        return null;
    }
    
    public PageReference updatePlacementStatus()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
         
        placement.Status__c = parseStringParam('placementStatus', pageParams);
        upsert placement;
        this.placement = fetchRelatedPlacement();
        
        return null;
    }

      
    // *********** Housing Search section *************
    
    public PageReference editHousingSearch()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
    
        Id housingSearchId = params.get('housingSearchId');
        this.housingSearch = fetchHousingSearch(housingSearchId);
        return null;
    }
    
    public PageReference saveHousingSearch()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
              
        boolean isNewHousingSearch = true;
        boolean updateServiceRequest = false;
        if (pageParams.containsKey('housingSearchId') )
        {   
            string hsId = pageParams.get('housingSearchId');
            
            if (hsId.length() > 0)
            {
                Id housingSearchId = pageParams.get('housingSearchId');
                housingSearch = fetchHousingSearch(housingSearchId);
                isNewHousingSearch = false;
            }
        }
               
        if (isNewHousingSearch)
        {
            housingSearch.Service_Request__c = serviceRequest.Id;
            housingSearch.Placement__c = this.placement.Id;
        }
            
        housingSearch.Property_Type__c = pageParams.get('housingSearchPropertyType');
        housingSearch.Furniture_Option__c = pageParams.get('housingSearchFurnitureOption');
        housingSearch.Presented_Date__c = parseDateTimeParam('housingSearchPresentedDateTime',pageParams);
        if (pageParams.get('housingSearchLandlord').length() > 0 && pageParams.get('housingSearchLandlord') != '000000000000000')
        {
            housingSearch.Landlord__c = pageParams.get('housingSearchLandlord');
        }
        else
        {
            housingSearch.Landlord__c = null;
        }
        housingSearch.Street_Addr1__c = pageParams.get('housingSearchStreetAddress1');
        housingSearch.Street_Addr2__c = pageParams.get('housingSearchStreetAddress2');
        housingSearch.City__c = pageParams.get('housingSearchCity');
        housingSearch.State__c = pageParams.get('housingSearchState');
        housingSearch.Zip__c = pageParams.get('housingSearchZip');
        string country = pageParams.get('housingSearchCountry');
        if (!country.equals('USA') && country.toLowerCase() == 'usa')
        {
            country = 'USA';
        }
        else
        {
            if (!country.equals('Canada') && country.toLowerCase() == 'canada')
            {
                country = 'Canada';
            }
        }
        housingSearch.Country__c = country;
        housingSearch.Distance_from_Damaged_Property__c = parseDecimalParam('housingSearchDistanceFromDamagedProp', pageParams);
      
        housingSearch.Property_Description__c = pageParams.get('housingSearchPropertyDescription'); 
        housingSearch.THC_Comments__c = pageParams.get('housingSearchTHCComments'); 
        housingSearch.Days_Notice_Required__c = parseDecimalParam('housingSearchDaysNoticeRequired',pageParams);  
        housingSearch.Initial_Check_Delivery_Method__c = pageParams.get('housingSearchInitialCheckDeliveryMethod');
        

         
    
        try 
        {
            housingSearch.Send_Copy_of_Check__c = Boolean.valueOf(pageParams.get('housingSearchSendCopyOfCheck'));
        }
        catch (Exception ex) {}

        try 
        {
            housingSearch.Send_Copy_of_Tracking_Information__c = Boolean.valueOf(pageParams.get('housingSearchSendCopyOfTrackingInformation'));    
        }
        catch (Exception ex) {}
       

        housingSearch.Initial_Payment_Type__c = pageParams.get('housingSearchInitialPaymentType');
        housingSearch.Bedrooms__c = pageParams.get('housingSearchBedrooms');
        
        housingSearch.Name_of_Complex__c = pageParams.get('housingSearchNameOfComplex');
        housingSearch.Unit__c = pageParams.get('housingSearchUnit');
        housingSearch.Initial_Contact_Name__c = pageParams.get('housingSearchInitialContactName');
        housingSearch.Initial_Contact_Number__c = pageParams.get('housingSearchInitialContactNumber');
        housingSearch.Bathrooms__c = pageParams.get('housingSearchBathrooms');
        housingSearch.Square_Feet__c = parseDecimalParam('housingSearchSquareFeet', pageParams);
     
        
        try 
        {
            housingSearch.Pets_Allowed__c = Boolean.valueOf(pageParams.get('housingSearchPetsAllowed'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Wood_Floors__c = Boolean.valueOf(pageParams.get('housingSearchWoodFloors'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Elevator_Reservation_Required__c = Boolean.valueOf(pageParams.get('housingSearchElevatorReservationRequired'));
        }
        catch (Exception ex) {}

        housingSearch.Extension_Increment_Days__c = parseDecimalParam('housingSearchExtensionIncrementDays', pageParams);
        housingSearch.Recurring_Payment_Type__c = pageParams.get('housingSearchRecurringPaymentType');
        housingSearch.NTV_Send_Via__c = pageParams.get('housingSearchNTVSendVia');
        if (pageParams.get('housingSearchNTVSendTo').length() > 0 && pageParams.get('housingSearchNTVSendTo') != '000000000000000' && housingSearch.Landlord__c != null)
        {
            housingSearch.NTV_Send_To__c = pageParams.get('housingSearchNTVSendTo');
        }
        else
        {
            housingSearch.NTV_Send_To__c = null;
        }
        housingSearch.Policyholder_Accepted_Property_Date__c = parseDateTimeParam('housingSearchPolicyholderAcceptedPropertyDate',pageParams);
        housingSearch.Policyholder_Declined_Property_Date__c = parseDateTimeParam('housingSearchPolicyholderDeclinedPropertyDate',pageParams);
        housingSearch.Policyholder_Declined_Property_Reason__c = pageParams.get('housingSearchPolicyholderDeclinedPropertyReason');
        housingSearch.Over_5_Mile_Reason__c = pageParams.get('housingSearchOver5milesReason');
        housingSearch.First_Available_Move_In_Date__c = parseDateParam('housingSearchFirstAvailableMoveInDate',pageParams);
        housingSearch.Tentative_Move_Out_Date__c = parseDateParam('housingSearchTentativeMoveOutDate',pageParams);
        housingSearch.First_Month_Pro_Rated_Rent_Amount_Due__c = parseDecimalParam('housingSearchFirstMonthProratedRentAmountDue', pageParams);
        housingSearch.What_Is_Included_In_The_Prorated_Rent__c = pageParams.get('housingSearchWhatIsIncludedInTheProratedRent');
        housingSearch.Responsible_Party_For_RSD__c = pageParams.get('housingSearchResponsiblePartyForRSD');
        
        if (housingSearch.Presented_to_Adjuster__c == false)
        {
            
            try 
            {
               housingSearch.Foreclosure__c = Boolean.valueOf(pageParams.get('housingSearchForecloserCheck'));
            }
            catch (Exception ex) {}
            housingSearch.Lease_Term_Approved_By_Adjuster__c = pageParams.get('housingSearchLeaseTermApproveByAdj');
            housingSearch.RSD__c = parseDecimalParam('housingSearchRSD', pageParams);
            housingSearch.Rent_Frequency__c = pageParams.get('housingSearchRentFrequency');

            housingSearch.Sure_Deposit__c = parseDecimalParam('housingSearchSureDeposit', pageParams);
            housingSearch.Application_Fee__c = parseDecimalParam('housingSearchApplicationFee', pageParams);
            housingSearch.Tax__c = parseDecimalParam('housingSearchTax', pageParams);
            housingSearch.Cleaning_Fee__c = parseDecimalParam('housingSearchCleaningFee', pageParams);
            housingSearch.Amenity_Fee__c = parseDecimalParam('housingSearchAmenityFee', pageParams);
            housingSearch.Administration_Fee__c = parseDecimalParam('housingSearchAdministrationFee', pageParams);
            housingSearch.Re_Keying_Fee__c = parseDecimalParam('housingSearchReKeyingFee', pageParams);
            housingSearch.Break_Lease_Fee__c = parseDecimalParam('housingSearchBreakLeaseFee', pageParams);
            housingSearch.Garage_Remote_Fee__c = parseDecimalParam('housingSearchGarageRemoteFee', pageParams);
            housingSearch.Fencing_Fee__c = parseDecimalParam('housingSearchFencingFee', pageParams);
            housingSearch.Total_Pet_Fees__c = parseDecimalParam('housingSearchTotalPetFees', pageParams);
            housingSearch.Pet_RSD__c = parseDecimalParam('housingSearchPetRSD', pageParams);

            housingSearch.Utility_Set_Up_Fee__c = parseDecimalParam('housingSearchUtilitySetUpFee', pageParams);
            housingSearch.Broker_Fee__c = parseDecimalParam('housingSearchBrokerFee', pageParams);
            housingSearch.Window_Covering_Fee__c = parseDecimalParam('housingSearchWindowCoveringFee', pageParams);
            housingSearch.Parking_Fee__c = parseDecimalParam('housingSearchParkingFee', pageParams);
            housingSearch.Other_Non_Refundable_Fee__c = parseDecimalParam('housingSearchOtherNonRefundableFee', pageParams);
            housingSearch.Certificate_Of_Occupancy_Fee__c = parseDecimalParam('housingSearchCertificateOfOccupancyFee', pageParams);
            housingSearch.Rent__c = parseDecimalParam('housingSearchRent', pageParams);

        }
 
        housingSearch.Number_Of_Pets_Allowed__c = pageParams.get('housingSearchNumberOfPetsAllowed');
        housingSearch.Days_Notice_Required_After_ILT__c = parseDecimalParam('housingSearchDaysNoticeRequiredAfterILT', pageParams);
        try 
        {
           housingSearch.Rent_Increase_After_ILT__c = Boolean.valueOf(pageParams.get('housingSearchRentIncreaseAfterILT'));
        }
        catch (Exception ex) {}



        housingSearch.Rent_Increase_To_After_ILT__c = pageParams.get('housingSearchRentIncreaseToAfterILT');
        housingSearch.Processing_Time_For_Application__c = pageParams.get('housingSearchProcessingTimeForApplication');
        housingSearch.Requirements_For_Qualification__c = pageParams.get('housingSearchRequirementsForQualification');
        housingSearch.Utilities_PH_Is_Responsible_For__c = pageParams.get('housingSearchUtilitiesPHIsResponsibleFor');
        housingSearch.Appliances_CRS_Needs_To_Provide__c = pageParams.get('housingSearchAppliancesCRSNeedsToProvide');
        housingSearch.Appliance_Hook_Up_Gas_Electric__c = pageParams.get('housingSearchApplianceHookUpGasElectric');
        housingSearch.PH_Abatement_Amount__c = parseDecimalParam('housingSearchPHAbatementAmount', pageParams);
        housingSearch.Start_Date_For_PH_Abatement__c = parseDateParam('housingSearchStartDateForPHAbatement',pageParams);
        housingSearch.Responsible_Party_For_Vendor_Entry__c = pageParams.get('housingSearchResponsiblePartyForVendorEntry');
        housingSearch.Phone_Number_To_Confirm_Vendor_Entry__c = pageParams.get('housingSearchPhoneNumberToConfirmVendorEntry');
        try 
        {
            housingSearch.PH_Viewed__c = Boolean.valueOf(pageParams.get('housingSearchPHViewed'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Renters_Insurance_Required__c = Boolean.valueOf(pageParams.get('housingSearchRentersInsuranceRequired'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Declaration_Page_Sufficient__c = Boolean.valueOf(pageParams.get('housingSearchDeclarationPageSufficient'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.RM_Updated__c = Boolean.valueOf(pageParams.get('housingSearchRMUpdated'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Rental_Application_Required__c = Boolean.valueOf(pageParams.get('housingSearchRentalApplicationRequired'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Utilities_Included_In_Rent__c = Boolean.valueOf(pageParams.get('housingSearchUtilitiesIncludedInRent'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Landscaping_Snow_Removal_HOA_Included__c = Boolean.valueOf(pageParams.get('housingSearchLandscapingSnowRemovalHOAIncluded'));
        }
        catch (Exception ex) {}
          try 
        {
            housingSearch.Appliances_Present_In_Rental_Property__c = Boolean.valueOf(pageParams.get('housingSearchAppliancesPresentInRentalProperty'));
        }
        catch (Exception ex) {}
        try 
        {
           housingSearch.Window_Coverings_Present__c = Boolean.valueOf(pageParams.get('housingSearchWindowCoveringsPresent'));
        }
        catch (Exception ex) {}
        try 
        {
           housingSearch.Pictures_Allowed_On_Walls__c = Boolean.valueOf(pageParams.get('housingSearchPicturesAllowedOnWalls'));
        }
        catch (Exception ex) {}
        try 
        {
            housingSearch.Fenced_Yard__c = Boolean.valueOf(pageParams.get('housingSearchFencedYard'));
        }
        catch (Exception ex) {}
        try 
        {
           housingSearch.Certificate_Of_Occupancy_Required__c = Boolean.valueOf(pageParams.get('housingSearchCertificateOfOccupancyRequired'));
        }
        catch (Exception ex) {}

        housingSearch.How_Utilities_Are_To_Be_Established__c = pageParams.get('housingSearchHowUtilitiesAreToBeEstablished');
        housingSearch.Floor__c = pageParams.get('housingSearchFloorNumber');
        housingSearch.What_Utilities_Are_Included_In_Rent__c = pageParams.get('housingSearchWhatUtilitiesIncludedInRent');
        
        try
        {
            upsert housingSearch;
        }
        catch (Exception ex)
        {
            return null;        
        }
        
        if (serviceRequest.First_Property_Presented__c == null || serviceRequest.First_Property_Presented__c > housingSearch.Presented_Date__c)
        {
            serviceRequest.First_Property_Presented__c = housingSearch.Presented_Date__c;
            updateServiceRequest = true;
        }
        if (serviceRequest.Status__c != 'Active')
        {
            serviceRequest.Status__c = 'Active';
            updateServiceRequest = true;    
        }
        if (updateServiceRequest)
        {
            upsert serviceRequest;
        }
      
        this.housingSearch = fetchHousingSearch(housingSearch.Id);

        string undeclinedSearches = getUndeclinedSearchNames();
        
        if (undeclinedSearches.length() > 2 && this.placement.Status__c != 'Viewing')
        {
           this.placement.Status__c = 'Viewing'; 
           update this.placement;
        }
        if (undeclinedSearches.length() <= 2 && this.placement.Status__c != 'Searching')
        {
            this.placement.Status__c = 'Searching';
            update this.placement;
        }

        return null;
    }
  
    public PageReference clearHousingSearch()
    {
        if (getSROnHold())
        {
           pageRefresh = true; 
        }
        else
        {
           pageRefresh = false;    
 
           this.housingSearch = new Searches__c();
           this.housingSearch.RecordTypeId = RecordTypeHelper.housingSearchRT();
        }
        return null;        
    }
    
    
    public PageReference saveFurnitureOnlySearch()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
              
        boolean isNewHousingSearch = true;
        boolean updateServiceRequest = false;
        if (pageParams.containsKey('furnitureOnlyId') )
        {   
            string hsId = pageParams.get('furnitureOnlyId');
            
            if (hsId.length() > 0)
            {
                Id housingSearchId = pageParams.get('furnitureOnlyId');
                housingSearch = fetchHousingSearch(housingSearchId);
                isNewHousingSearch = false;
            }
        }
               
        if (isNewHousingSearch)
        {
            housingSearch.Service_Request__c = serviceRequest.Id;
            housingSearch.Placement__c = this.placement.Id;
        }
            
        housingSearch.Property_Type__c = pageParams.get('furnitureOnlyPropertyType');
        housingSearch.Presented_Date__c = parseDateTimeParam('furnitureOnlyPresentedDateTime',pageParams);
        housingSearch.Street_Addr1__c = pageParams.get('furnitureOnlyStreetAddress1');
        housingSearch.Street_Addr2__c = pageParams.get('furnitureOnlyStreetAddress2');
        housingSearch.City__c = pageParams.get('furnitureOnlyCity');
        housingSearch.State__c = pageParams.get('furnitureOnlyState');
        housingSearch.Zip__c = pageParams.get('furnitureOnlyZip');
        string country = pageParams.get('furnitureOnlyCountry');
        if (!country.equals('USA') && country.toLowerCase() == 'usa')
        {
            country = 'USA';
        }
        else
        {
            if (!country.equals('Canada') && country.toLowerCase() == 'canada')
            {
                country = 'Canada';
            }
        }
        housingSearch.Country__c = country;
        housingSearch.Distance_from_Damaged_Property__c = parseDecimalParam('furnitureOnlyDistanceFromDamagedProp', pageParams);
        housingSearch.Property_Description__c = pageParams.get('furnitureOnlyPropertyDescription'); 
        housingSearch.Days_Notice_Required__c = parseDecimalParam('furnitureOnlyDaysNoticeRequired',pageParams);  
        housingSearch.Bedrooms__c = pageParams.get('furnitureOnlyBedrooms');
        
        housingSearch.Name_of_Complex__c = pageParams.get('furnitureOnlyNameOfComplex');
        housingSearch.Unit__c = pageParams.get('furnitureOnlyUnit');
        housingSearch.Bathrooms__c = pageParams.get('furnitureOnlyBathrooms');
        housingSearch.Square_Feet__c = parseDecimalParam('furnitureOnlySquareFeet', pageParams);
       
        string woodFloors = pageParams.get('furnitureOnlyWoodFloors');
        if (woodFloors == '1')
        {
            housingSearch.Wood_Floors__c = true;
        }
        else
        {
            housingSearch.Wood_Floors__c = false;
        }
        string elevatorReservationRequired = pageParams.get('furnitureOnlyElevatorReservationRequired');
        if (elevatorReservationRequired == '1')
        {
            housingSearch.Elevator_Reservation_Required__c = true;
        }
        else
        {
            housingSearch.Elevator_Reservation_Required__c = false;
        }      
        housingSearch.Extension_Increment_Days__c = parseDecimalParam('furnitureOnlyExtensionIncrementDays', pageParams);
                
        upsert housingSearch;
                
        if (serviceRequest.First_Property_Presented__c == null || serviceRequest.First_Property_Presented__c > housingSearch.Presented_Date__c)
        {
            serviceRequest.First_Property_Presented__c = housingSearch.Presented_Date__c;
            updateServiceRequest = true;
        }
        if (serviceRequest.Status__c != 'Active')
        {
            serviceRequest.Status__c = 'Active';
            updateServiceRequest = true;    
        }
        if (updateServiceRequest)
        {
            upsert serviceRequest;
        }
              
        return null;
    }
    
    public PageReference clearFurnitureOnlySearch()
    {
        if (getSROnHold())
        {
           pageRefresh = true; 
        }
        else
        {
           pageRefresh = false;    
        
            this.housingSearch = new Searches__c();
            this.housingSearch.RecordTypeId = RecordTypeHelper.housingSearchRT();
            this.housingSearch.Furniture_Option__c = 'Furniture Only';
        }
        return null;        
    }

    public PageReference updateHousingSearch()
    {
    
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
      
        String housingSearchId = pageParams.get('housingSearchId');
       // String presentedToAdjuster = pageParams.get('presentedToAdjuster');
        
        Searches__c housingSearch = [select Id from Searches__c where Id =: housingSearchId];
        try 
        {
            housingSearch.Presented_to_Adjuster__c = Boolean.valueOf(pageParams.get('presentedToAdjuster'));
        }
        catch (Exception ex) {}
          
        update housingSearch;
                             
        return null;
    }
  
    public PageReference updateSelectedHousingSearch() 
    {
        Id housingSearchId = null;
                
        Map<string, string> params = ApexPages.currentPage().getParameters();
        
        if (params.containsKey('housingSearchId') && params.get('housingSearchId').length() > 0)
        {
            housingSearchId = params.get('housingSearchId');
        }
      
        string housingSearchLandlordStatus = params.get('housingSearchLandlordStatus');
         
        if (housingSearchId == null)
        {
            if (getHasSelectedHousingSearch() == false || getHasActiveQuote())
            {
                pageRefresh = true; 
            }
            else
            {
                pageRefresh = false;    
                                
                internalSelectedSearch();
                            
                this.selectedHousingSearch.Selected__c = false;
                
                if (this.selectedHousingSearch.Landlord_Status__c != 'Active' && this.selectedHousingSearch.Landlord_Status__c != null)
                {
                    this.selectedHousingSearch.Landlord__c = null;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'The inactive Landlord has been removed from search ' + this.selectedHousingSearch.name + '. You should select a new landlord before reselecting');
                    ApexPages.addmessage(myMsg);    
                }
               
                
                // clear the selected housing search on the service request
                this.serviceRequest.Selected_Search__c = null;
                
                upsert this.serviceRequest;
                
                // clear the selected housing search on the placement  
                this.placement.Selected_Search__c = null;
                this.placement.THC_Signed_Date__c = null;
                this.placement.Prorate__c = null;
                this.placement.Prorate_Adjustment__c = null;
                

                string undeclinedSearches = getUndeclinedSearchNames();
        
                if (undeclinedSearches.length() > 2 && this.placement.Status__c != 'Viewing')
                {
                   this.placement.Status__c = 'Viewing'; 
                }

                if (undeclinedSearches.length() <= 2 && this.placement.Status__c != 'Searching')
                {
                    this.placement.Status__c = 'Searching';
                }
                        
                upsert this.placement; 

                update this.selectedHousingSearch;
                this.selectedHousingSearch = null;
                
                this.placement = fetchRelatedPlacement();
            }
        }
        else
        { 
            if (getHasSelectedHousingSearch() || getSROnHold())
            {
                pageRefresh = true; 
            }
            else
            {
                pageRefresh = false;    
                string housingSearchFurnitureOption = params.get('housingSearchFurnitureOption');
                
                this.selectedHousingSearch = fetchHousingSearchToBeSelected(housingSearchId);
                                                
                if (this.selectedHousingSearch.Landlord_Status__c != 'Active' && this.selectedHousingSearch.Landlord_Status__c != null)
                {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot select a search with an inactive Landlord');
                   ApexPages.addmessage(myMsg);
                   this.selectedHousingSearch = null;
                   return null;             
                }
                           
                // Check all costs records to make sure all billable and payable parties are active
                Set<Id> contactIds = new Set<Id>();
                List<Costs__c> costs = [select Billable_Party__c,Payable_Party__c from Costs__c where Searches__c =: housingSearchId];
                for (Costs__c cost : costs)
                {
                    // add billable and payable contact ids to contactIds
                    contactIds.add(cost.Billable_Party__c);
                    contactIds.add(cost.Payable_Party__c);
                }   
                
                List<Contact> contacts = [select status__c from contact where id =: contactIds];
                for (Contact contact : contacts)
                {
                    if (contact.status__c != 'Active')
                    {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot select a search with costs that have inactive payable or billable parties');
                       ApexPages.addmessage(myMsg);
                       this.selectedHousingSearch = null;
                       return null;      
                    }
                }

                if (this.housingSearch.Has_Policyholder_Rent__c >= 1 && this.housingSearch.Has_Policyholder_Abatement__c == 0)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot select a search with a Policyholder Rent cost and no PH Abatement cost');
                    ApexPages.addmessage(myMsg);
                    this.selectedHousingSearch = null;
                    return null;      
                }

                Decimal prorate = 0;
                if (housingSearchFurnitureOption != 'Furniture Only')
                {
                    // go get the prorate amount from the billing system
                    prorate = CallOutsToMulligan.getProrateAmount(this.placement.Id, housingSearchId);
                    
                    if (prorate == -1)
                    {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot currently get the prorate for this placement from the billing system.  Please try selecting a search later');
                       ApexPages.addmessage(myMsg);
                       return null;             
                    }
                } 
                
                this.selectedHousingSearch.Selected__c = true;
                if (this.selectedHousingSearch.Original_Selected_Date__c == null)
                {
                   this.selectedHousingSearch.Original_Selected_Date__c = system.now();
                }
                update this.selectedHousingSearch;    
                
                // set the selected housing search on the service request
                this.serviceRequest.Selected_Search__c = housingSearchId;
                
                upsert serviceRequest;
                           
                           
                // set the selected housing search on the placement               
                this.placement.Prorate__c = prorate;
                this.placement.Selected_Search__c = housingSearchId;
                this.placement.Status__c = 'Pending Confirmation';
                
                upsert this.placement;
                
                Furniture_Order__c furnitureOrder = fetchActiveFurnitureOrder(this.placement.Id);
                if (furnitureOrder.Id != null)
                {
                    furnitureOrder.Searches__c = this.selectedHousingSearch.Id;
                    update furnitureOrder;
                }
                
                internalSelectedSearch();
                
                this.placement = fetchRelatedPlacement();
            }
        }
              
        return null;
    }
    
    // *********** Cost section *************
    
    public PageReference editCost()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
        
        Id costId = params.get('costId');
        this.cost = fetchCost(costId);
        return null;
    }
    
    public PageReference deleteCost()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
        
        Id costId = params.get('costId');
        this.cost = fetchCost(costId);
        Id currentSearch = this.cost.Searches__c;
        
        delete this.cost;
        
        this.housingSearch = fetchHousingSearch(currentSearch);
        return null;
    }
        
    public PageReference saveCost()
    {
        this.housingSearch = fetchHousingSearch(cost.Searches__c);
               
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
              
        cost.Amount__c = parseDecimalParam('costAmount',pageParams);
        cost.Type__c = pageParams.get('costType');
        cost.Type_Description__c = pageParams.get('costTypeDescription');
        if (pageParams.get('costBillableParty').length() > 0 && pageParams.get('costBillableParty') != '000000000000000')
        {
           cost.Billable_Party__c = pageParams.get('costBillableParty');
        }
        else
        {
            cost.Billable_Party__c = null;
        }
        if (pageParams.get('costPayableParty').length() > 0 && pageParams.get('costPayableParty') != '000000000000000')
        {
            cost.Payable_Party__c = pageParams.get('costPayableParty');
        }
        else
        {
            cost.Payable_Party__c = null;
        }
       
        cost.Prorate_Type__c = pageParams.get('costProrateType');
        
        if ((this.housingSearch.Has_Rent__c >= 1 && cost.Type__c == 'Rent'  || this.housingSearch.Has_Policyholder_Rent__c >= 1 && cost.Type__c == 'Policyholder Rent' || 
            this.housingSearch.Has_Policyholder_Abatement__c >= 1 && cost.Type__c == 'PH Abatement' || this.housingSearch.Has_Utilities__c >= 1 && cost.Type__c == 'Utilities') && cost.Id == null )
        {
            pageRefresh = true;
        }
        else
        {
            pageRefresh = false;
            try
            {
                
                upsert cost;
            }
            catch (Exception ex)
            {
                return null; 
            }
        }
         
        this.housingSearch = fetchHousingSearch(cost.Searches__c);
        
        return null;
    }
    
    public PageReference clearCost()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
        
        string costType = pageParams.get('costType');
        this.cost = new Costs__c();
        this.cost.Searches__c = this.housingSearch.Id;
        this.cost.Payable_Party__c = this.housingSearch.Landlord__c;
        if (costType == 'cost')
        {
            this.cost.RecordTypeId = RecordTypeHelper.costCostsRT();
            this.cost.Billable_Party__c = this.claim.Adjuster__c;
            this.cost.Prorate_Type__c = 'Monthly';
            if (this.housingSearch.Has_Rent__c == null || this.housingSearch.Has_Rent__c == 0)
            {
                this.cost.type__c = 'Rent';
            }
        }
        else
        {
            if (costType == 'fee')
            {
                this.cost.RecordTypeId = RecordTypeHelper.feeCostsRT();
                if (serviceRequest.Adjuster_to_Pay__c == 'Deposits and Fees' || serviceRequest.Adjuster_to_Pay__c == 'Fees')
                {
                    this.cost.Billable_Party__c = this.claim.Adjuster__c;   
                }
                 else
                {
                    if (serviceRequest.Policyholder_To_Pay__c == 'Deposits and Fees' || serviceRequest.Policyholder_To_Pay__c == 'Fees')
                    {
                        this.cost.Billable_Party__c = this.claim.Policyholder__c;  
                    }       
                }
                        
            }
            else
            {
                if (costType == 'deposit')
                {
                    this.cost.RecordTypeId = RecordTypeHelper.depositCostsRT();
                    if (serviceRequest.Adjuster_to_Pay__c == 'Deposits and Fees' || serviceRequest.Adjuster_to_Pay__c == 'Deposits')
                    {
                        this.cost.Billable_Party__c = this.claim.Adjuster__c;   
                    }
                    else
                    {
                        if (serviceRequest.Policyholder_To_Pay__c == 'Deposits and Fees' || serviceRequest.Policyholder_To_Pay__c == 'Deposits')
                        {
                            this.cost.Billable_Party__c = this.claim.Policyholder__c; 
                        }       
                    }       
                }
            }   
        }
        return null;        
    }
    
    // *********** Furniture Order section *************
    
    public PageReference editFurnitureOrder()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
    
        Id furnitureOrderId = params.get('furnitureOrderId');
        this.furnitureOrder = fetchFurnitureOrder(furnitureOrderId);
        return null;
    }
    
    public PageReference saveFurnitureOrder()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
              
        boolean isNewFurnitureOrder = true;
        if (pageParams.containsKey('furnitureOrderId') )
        {   
            string foId = pageParams.get('furnitureOrderId');
            
            if (foId.length() > 0)
            {
                Id furnitureOrderId = pageParams.get('furnitureOrderId');
                furnitureOrder = fetchFurnitureOrder(furnitureOrderId);
                isNewFurnitureOrder = false;
            }
        }
               
        if (isNewFurnitureOrder)
        {
            if (this.selectedHousingSearch != null)
            {
                this.furnitureOrder.Searches__c = this.selectedHousingSearch.Id;
            }
            furnitureOrder.Service_Request__c = serviceRequest.Id;
            furnitureOrder.Placement__c = this.placement.Id;
            if (this.placement.Status__c == 'Moved-In')
            {
                furnitureOrder.Created_After_Move_in__c = true;
            }
        }
                
        furnitureOrder.Status__c = pageParams.get('furnitureOrderStatus');
        furnitureOrder.Cost__c = parseDecimalParam('furnitureOrderCost',pageParams);
        furnitureOrder.Billable_Party_Cost__c = pageParams.get('furnitureOrderBillablePartyCost');

        furnitureOrder.Furniture_Cost__c = parseDecimalParam('furnitureOrderFurnitureCost',pageParams);
        furnitureOrder.Billable_Party_Furniture_Cost__c = pageParams.get('furnitureOrderBillablePartyFurnitureCost');
        furnitureOrder.Appliance_Cost__c = parseDecimalParam('furnitureOrderApplianceCost',pageParams);
        furnitureOrder.Billable_Party_Appliance_Cost__c = pageParams.get('furnitureOrderBillablePartyApplianceCost');
        furnitureOrder.Electronics_Cost__c = parseDecimalParam('furnitureOrderElectronicsCost',pageParams);
        furnitureOrder.Billable_Party_Electronics_Cost__c = pageParams.get('furnitureOrderBillablePartyElectronicsCost');
        furnitureOrder.Kitchen_Housewares_Cost__c = parseDecimalParam('furnitureOrderKitchenHousewaresCost',pageParams);
        furnitureOrder.Billable_Party_Kitchen_Housewares_Cost__c = pageParams.get('furnitureOrderBillablePartyKitchenHousewaresCost');
        furnitureOrder.BedBath_Housewares_Cost__c = parseDecimalParam('furnitureOrderBedBathHousewaresCost',pageParams);
        furnitureOrder.Billable_Party_BedBath_Housewares_Cost__c = pageParams.get('furnitureOrderBillablePartyBedBathHousewaresCost');
        furnitureOrder.Other_Housewares_Cost__c = parseDecimalParam('furnitureOrderOtherHousewaresCost',pageParams);
        furnitureOrder.Billable_Party_Other_Housewares_Cost__c = pageParams.get('furnitureOrderBillablePartyOtherHousewaresCost');

        furnitureOrder.Deposit__c = parseDecimalParam('furnitureOrderDeposit',pageParams);
        furnitureOrder.Billable_Party_Deposit__c = pageParams.get('furnitureOrderBillablePartyDeposit');
        furnitureOrder.Setup_Fee__c = parseDecimalParam('furnitureOrderSetupFee',pageParams);
        furnitureOrder.Billable_Party_Setup_Fee__c = pageParams.get('furnitureOrderBillablePartySetupFee');
        furnitureOrder.Pet_Fee__c = parseDecimalParam('furnitureOrderPetFee',pageParams);
        furnitureOrder.Billable_Party_Pet_Fee__c = pageParams.get('furnitureOrderBillablePartyPetFee');
        furnitureOrder.Delivery_Fee__c = parseDecimalParam('furnitureOrderDeliveryFee',pageParams);
        furnitureOrder.Billable_Party_Delivery_Fee__c = pageParams.get('furnitureOrderBillablePartyDeliveryFee');
                      
        if (furnitureOrder.Status__c == 'Working' || furnitureOrder.Status__c == 'Completed' && furnitureOrder.Ready_For_VSS__c == false)
        {
            furnitureOrder.Requested_Furniture_Delivery_Date__c = parseDateParam('furnitureOrderRequestedDeliveryDate',pageParams);
            furnitureOrder.Is_partial_order__c = pageParams.get('furnitureOrderIsPartial');
            furnitureOrder.Furniture_Comments__c = pageParams.get('furnitureOrderComments');
            string furnitureOrderIncludePictures = pageParams.get('furnitureOrderIncludePictures');
            if (furnitureOrderIncludePictures == '1')
            {
                furnitureOrder.Include_Pictures__c = true; 
            }
            else
            {
                furnitureOrder.Include_Pictures__c = false;
            }
            
            furnitureOrder.Furniture_Level__c = pageParams.get('furnitureOrderLevel');
            furnitureOrder.Master_Bedroom__c = pageParams.get('furnitureOrderMasterBedroom');
            furnitureOrder.Additional_Bedroom_1__c = pageParams.get('furnitureOrderAdditionalBedroom1');
            furnitureOrder.Additional_Bedroom_2__c = pageParams.get('furnitureOrderAdditionalBedroom2');
            furnitureOrder.Additional_Bedroom_3__c = pageParams.get('furnitureOrderAdditionalBedroom3');
            furnitureOrder.Additional_Bedroom_4__c = pageParams.get('furnitureOrderAdditionalBedroom4');
            furnitureOrder.Additional_Bedroom_5__c = pageParams.get('furnitureOrderAdditionalBedroom5');
            furnitureOrder.Additional_Bedroom_6__c = pageParams.get('furnitureOrderAdditionalBedroom6');
            furnitureOrder.Additional_Bedroom_7__c = pageParams.get('furnitureOrderAdditionalBedroom7');
            furnitureOrder.Additional_Bedroom_8__c = pageParams.get('furnitureOrderAdditionalBedroom8');
            furnitureOrder.Additional_Bedroom_9__c = pageParams.get('furnitureOrderAdditionalBedroom9');
            furnitureOrder.Additional_Bedroom_10__c = pageParams.get('furnitureOrderAdditionalBedroom10');
            furnitureOrder.Living_Room__c = pageParams.get('furnitureOrderLivingRoom');
            furnitureOrder.Additional_Living_Room__c = pageParams.get('furnitureOrderAdditionalLivingRoom');
            furnitureOrder.Dining_Room__c = pageParams.get('furnitureOrderDiningRoom');
            furnitureOrder.Additional_Dining_Room__c = pageParams.get('furnitureOrderAdditionalDiningRoom');
            furnitureOrder.Appliances__c = pageParams.get('furnitureOrderAppliances');
            furnitureOrder.Refrigerator__c = pageParams.get('furnitureOrderRefrigerator');
            furnitureOrder.Microwave__c = pageParams.get('furnitureOrderMicrowave');
            furnitureOrder.Clothes_Washer__c = pageParams.get('furnitureOrderClothesWasher');
            furnitureOrder.Clothes_Dryer__c = pageParams.get('furnitureOrderClothesDryer');
            furnitureOrder.Dryer_Type__c = pageParams.get('furnitureOrderDryerType');
            furnitureOrder.Range__c = pageParams.get('furnitureOrderRange');
            furnitureOrder.Range_Type__c = pageParams.get('furnitureOrderRangeType');
            furnitureOrder.Housewares__c = pageParams.get('furnitureOrderHousewares');
            furnitureOrder.Bedrooms_Needing_Housewares__c = pageParams.get('furnitureOrderBedroomsNeedingHousewares');
            furnitureOrder.Bathrooms_Needing_Housewares__c = pageParams.get('furnitureOrderBathroomsNeedingHousewares');
        }
        
        if (furnitureOrder.Status__c == 'Completed')
        {
            furnitureOrder.Ready_For_VSS__c = true;
        }
      
        upsert furnitureOrder;
         
        return null;
    }
    
    public PageReference clearFurnitureOrder()
    {
        if (getSROnHold())
        {
            pageRefresh = true; 
        }
        else
        {
            pageRefresh = false;    

            this.furnitureOrder = new Furniture_Order__c();
            this.furnitureOrder.Status__c = 'Working';
            this.furnitureOrder.Include_Pictures__c = true;
            if (this.placement.Status__c != 'Moved-In')
            {
                
                this.furnitureOrder.Deposit__c = 1000;
                
                try
                {
                    if (claim.Account.Parent.Name == 'Farmers Insurance Group Headquarters')
                    {
                        this.furnitureOrder.Deposit__c = 0;
                    }
                    else
                    {
                        if (claim.Account.Parent.Name == 'Liberty Mutual Insurance Headquarters' || claim.Account.Parent.Name == 'Safeco Insurance Company Headquarters') 
                        {
                            this.furnitureOrder.Deposit__c = 500;
                        }   
                        else
                        {
                            if (claim.Account.Parent.Parent.Name == 'Allstate Headquarters')
                            {
                                this.furnitureOrder.Deposit__c = 500;    
                            }
                        }
                    }
                }
                catch(NullPointerException ex)
                {}
              
                if (serviceRequest.Adjuster_to_Pay__c == 'Deposits and Fees' || serviceRequest.Adjuster_to_Pay__c == 'Deposits')
                {
                    this.furnitureOrder.Billable_Party_Deposit__c = 'Adjuster'; 
                }
                else
                {
                    if (serviceRequest.Policyholder_To_Pay__c == 'Deposits and Fees' || serviceRequest.Policyholder_To_Pay__c == 'Deposits')
                    {
                        this.furnitureOrder.Billable_Party_Deposit__c = 'Policyholder'; 
                    }
                }           
            }
            else
            {
                this.furnitureOrder.Created_After_Move_In__c = true;
            }
        }       
   
        return null;        
    }
    
    // *********** Quote section *************
    
    public PageReference editQuote()
    {
        Map<string, string> params = ApexPages.currentPage().getParameters();
    
        Id quoteId = params.get('quoteId');
        this.quote = fetchQuote(quoteId);
        return null;
    }
        
    public PageReference buildQuote() 
    {
        if (getHasSelectedHousingSearch() == false || getHasActiveQuote())
        {
            pageRefresh = true; 
        }
        else
        {
            pageRefresh = false;    
                
            Map<string, string> params = ApexPages.currentPage().getParameters();
            
            string selectedHousingSearchFurnitureOption = params.get('selectedHousingSearchFurnitureOption');
                        
            Decimal markup;
            string contractNumber = '0';
            try
            {
                contractNumber = [select Markup_Rule__c from Contact where Id =: this.claim.Adjuster__c and Markup_Rule__c <> null limit 1].Markup_Rule__c;
            }
            catch (QueryException e1) 
            {
                try
                {
                    contractNumber = [select Markup_Rule__c from Account where Id =: this.claim.Account.Id and Markup_Rule__c <> null limit 1].Markup_Rule__c;
                }
                catch (QueryException e2) 
                {
                    Id parentId = this.claim.Account.ParentId;
                    while (parentId != null)
                    {
                        try 
                        {
                            Account parentAccount = [select Id,ParentId,Markup_Rule__c from Account where Id =: parentId limit 1];
                            
                            if (parentAccount.Markup_Rule__c != null)
                            {
                                contractNumber = parentAccount.Markup_Rule__c;
                                parentId = null;
                            }
                            else
                            {
                                if (parentAccount.ParentId != null)
                                {
                                    parentId = parentAccount.ParentId;
                                }
                                else
                                {
                                    parentId = null;
                                }
                            }   
                        }
                        catch (QueryException e3)
                        {
                            
                        }
                    }
                }
            }
                    
            // go get the markup amount from the billing system
            markup = CallOutsToMulligan.getMarkupAmount(this.placement.Id, this.selectedHousingSearch.Id, contractNumber, this.selectedHousingSearch.Furniture_Option__c);
        
            if (markup == -1)
            {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot currently get the markup for this quote from the billing system.  Please try creating a quote later');
               ApexPages.addmessage(myMsg);
               return null;             
            }
                    
            furnitureOrder = fetchCompletedFurnitureOrder(placement.Id); 
            
            this.quote = new Quote__c();
            this.quote.RecordTypeId = RecordTypeHelper.mulliganQuoteRT();
            this.quote.Status__c = 'Submitted';
            this.quote.Placement_Lookup__c = this.placement.Id;
            this.quote.Claim_Name__c = this.claim.Name;
            this.quote.Claim_Entity__c = this.claim.Entity__c;
            this.quote.Searches__c = this.selectedHousingSearch.Id;
            this.quote.Contract_Number__c = contractNumber;
                
            this.quote.Move_In_Date__c = this.placement.Move_In_Date__c;
            this.quote.Approved_Through_Date__c = this.placement.Approved_Through_Date__c;
            this.quote.Claim_Team_Number__c = this.claim.Reports_TeamNumber__c;
                     
            if (this.selectedHousingSearch.Street_Addr1__c != null)
            {
                this.quote.Temporary_Address_New__c = this.selectedHousingSearch.Street_Addr1__c;
            }
            if (this.selectedHousingSearch.Street_Addr2__c != null)
            {
                this.quote.Temporary_Address_New__c += ' ' + this.selectedHousingSearch.Street_Addr2__c + ',';
            }
            else
            {
                if (this.selectedHousingSearch.Street_Addr1__c != '' && !this.selectedHousingSearch.Street_Addr1__c.EndsWith(','))
                {
                    this.quote.Temporary_Address_New__c += ',';
                }
            }
            if (this.selectedHousingSearch.City__c != null)
            {
                this.quote.Temporary_Address_New__c += ' ' + this.selectedHousingSearch.City__c + ', ' + this.selectedHousingSearch.State__c + ' ' + this.selectedHousingSearch.Zip__c + ', ' + this.selectedHousingSearch.Country__c;
            }
            else
            {
                this.quote.Temporary_Address_New__c += ' ' + this.selectedHousingSearch.State__c + ' ' + this.selectedHousingSearch.Zip__c + ', ' + this.selectedHousingSearch.Country__c;
            }
            
            this.quote.Markup__c = markup;
            this.quote.Markup_Total__c = this.quote.Markup__c;
            this.quote.Billing_Preference__c = 'Standard';
            if (selectedHousingSearchFurnitureOption != 'Furniture Only')
            {
                this.quote.Prorate__c = this.placement.Prorate__c;
                this.quote.Prorate_Adjustment__c = this.placement.Prorate_Adjustment__c;
                this.quote.Prorate_Total__c = this.placement.Prorate_Total__c;
            }
            else
            {
                this.quote.Prorate__c = 0;
                this.quote.Prorate_Adjustment__c = 0;
                this.quote.Prorate_Total__c = 0;
            }
                
      
            if (furnitureOrder.Housewares__c == null)
            {
                this.quote.Housewares_Provided_New__c = 'None';
            }
            else
            {
                this.quote.Housewares_Provided_New__c = furnitureOrder.Housewares__c;
            }
            if (furnitureOrder.Appliances__c == null)
            {
                this.quote.Appliances_Provided_New__c = 'None';
            }
            else
            {
                this.quote.Appliances_Provided_New__c = furnitureOrder.Appliances__c;
            }
       
            
            this.quote.Bedrooms_New__c = this.selectedHousingSearch.Bedrooms__c;
            this.quote.Number_Of_Children_New__c = this.claim.Number_Of_Children__c;
            this.quote.Number_Of_Adults_New__c = this.claim.Number_Of_Adults__c;
            
        
            this.quote.Adjuster__c = this.claim.Adjuster__c;
            this.quote.Adjuster_Name__c = this.claim.Adjuster__r.FirstName + ' ' + this.claim.Adjuster__r.LastName;
            this.quote.Adjuster_Account_Name__c = this.claim.Adjuster__r.Account.Name;
            this.quote.Adjuster_Phone__c = this.claim.Adjuster__r.Phone;
            this.quote.Adjuster_Fax__c = this.claim.Adjuster__r.Fax;
            this.quote.Policyholder__c = this.claim.Policyholder__c; 
            this.quote.Policyholder_Name__c = this.claim.Policyholder__r.FirstName + ' ' + this.claim.Policyholder__r.LastName; 
            this.quote.Claim_Number_New__c = this.claim.Claim__c;
            this.quote.Property_Type_New__c = this.selectedHousingSearch.Property_Type__c;
            this.quote.Landlord__c = this.selectedHousingSearch.Landlord__c;
            this.quote.Adjuster_To_Pay__c = serviceRequest.Adjuster_to_Pay__c;
            this.quote.Return_Deposit_To_New__c = this.placement.Return_Deposit_To__c;
            this.quote.Claim_Owner__c = this.claim.Owner.Id;
            this.quote.Claim_Owner_Name__c = this.claim.Owner.Name;
            this.quote.Days_Notice_Required_New__c = this.selectedHousingSearch.Days_Notice_Required__c;
            this.quote.Furniture_Option__c = this.selectedHousingSearch.Furniture_Option__c;
            this.quote.Initial_Check_Delivery_Method__c = this.selectedHousingSearch.Initial_Check_Delivery_Method__c;
            this.quote.Initial_Payment_Type__c = this.selectedHousingSearch.Initial_Payment_Type__c;
                   
            string tempAddress;
        
            tempAddress = this.quote.Temporary_Address_New__c.left(this.quote.Temporary_Address_New__c.lastIndexOf(','));

              
            if (this.selectedHousingSearch.Furniture_Option__c != 'Furniture Only')
            {
                this.quote.Special_Instructions_New__c = 'The policyholder has selected a ' + this.quote.Bedrooms_New__c + ' bedroom ' + this.quote.Property_Type_New__c.toLowerCase() + ' located at ' + tempAddress + '.';
        
                this.quote.Special_Instructions_New__c += ' The ' + this.selectedHousingSearch.Property_Type__c.toLowerCase() + ' is approximately ' + this.selectedHousingSearch.Distance_from_Damaged_Property__c + ' miles from the damaged residence.';
                
                if (this.quote.Days_Notice_Required_New__c != 30)
                {
                    this.quote.Special_Instructions_New__c += ' The property requires a ' + this.quote.Days_Notice_Required_New__c + ' day notice to vacate.';
                }
                
                if (furnitureOrder.Appliances__c == 'Yes' || furnitureOrder.Id != null || furnitureOrder.Housewares__c == 'Yes')
                {
                    this.quote.Special_Instructions_New__c += ' The ' + this.selectedHousingSearch.Property_Type__c.toLowerCase() + ' comes with';
                    string additionalItems = '';
                    
                    if (furnitureOrder.Appliances__c == 'Yes')
                    {
                        additionalItems += ' appliances';   
                    }
                    if (furnitureOrder != null) 
                    {
                        if (additionalItems == '')
                        {
                            additionalItems += ' furniture';
                        }
                        else
                        {
                            if (furnitureOrder.Housewares__c == 'Yes') 
                            {
                                additionalItems += ', furniture';
                            }
                            else
                            {
                                additionalItems += ' and furniture';
                            }
                        }
                    }
                    if (furnitureOrder.Housewares__c == 'Yes') 
                    {
                        if (additionalItems == '')
                        {
                            additionalItems += ' housewares';
                        }
                        else
                        {
                            additionalItems += ' and housewares';
                        }
                    }
                    this.quote.Special_Instructions_New__c += additionalItems + '.';
                }
            }
            else
            {
                this.quote.Special_Instructions_New__c = 'The policyholder has selected a ' + this.quote.Bedrooms_New__c + ' bedroom ' + this.quote.Property_Type_New__c.toLowerCase() + ' located at ' + tempAddress + ' to be furnished by CRS.'; 
                this.quote.Special_Instructions_New__c += ' The ' + this.selectedHousingSearch.Property_Type__c.toLowerCase() + ' is approximately ' + this.selectedHousingSearch.Distance_from_Damaged_Property__c + ' miles from the damaged residence.';
                this.quote.Special_Instructions_New__c += ' This quote reflects pricing for temporary furnishings only.';
            }
                      
           
            if (this.claim.Number_of_Pets__c != null)
            {
                this.quote.Number_Of_Pets_New__c = this.claim.Number_of_Pets__c;    
            }
            else
            {
                this.quote.Number_Of_Pets_New__c = 0;   
            }
           
            this.quote.Damaged_Property_State__c = this.claim.Damaged_Property_State__c;
            this.quote.Damaged_Property_Zip__c = this.claim.Damaged_Property_Zip__c;
        }
           
        return null;        
    }
    
    public PageReference saveQuote()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
              
        boolean isNewQuote = true;
        if (pageParams.containsKey('quoteId'))
        {   
            string qId = pageParams.get('quoteId');
            
            if (qId.length() > 0)
            {
                Id quoteId = pageParams.get('quoteId');
                quote = fetchQuote(quoteId);
                isNewQuote = false;
            }
        }
        
        if (isNewQuote && getQuoteStatus() != 'Rejected' && getQuoteStatus() != '' || !isNewQuote && getQuoteStatus() != 'Submitted')
        {
            pageRefresh = true; 
        }
        else
        {
            pageRefresh = false;
            if (isNewQuote)
            {
                quote.Billing_Preference__c = pageParams.get('quoteBillingPreferences');
                quote.Markup_Adjustment__c = parseDecimalParam('quoteMarkupAdjustment',pageParams);
                quote.Markup_Adjustment_Reason__c = pageParams.get('quoteMarkupAdjustmentReason');
                
                if (quote.Markup_Adjustment__c != null)
                {
                    quote.Markup_Total__c = quote.Markup__c + quote.Markup_Adjustment__c;
                }
                else
                {
                    quote.Markup_Total__c = quote.Markup__c;
                }
                if (pageParams.get('quoteMarkupAuthorizedBy').length() > 0 && pageParams.get('quoteMarkupAuthorizedBy') != '000000000000000')
                {
                    quote.Markup_Authorized_By__c = pageParams.get('quoteMarkupAuthorizedBy');
                }
                else
                {
                    quote.Markup_Authorized_By__c = null;
                }
                quote.Special_Instructions_New__c = pageParams.get('quoteSpecialInstructions');
            }
            else
            {
                quote.Status__c = pageParams.get('quoteStatus');
                
                if (quote.Status__c == 'Rejected' || quote.Status__c == 'Approved') 
                {
                    // push new quote status up to the billing system
                    boolean isUpdateSuccess = CallOutsToMulligan.pushUpdatedQuoteInformation(quote.Id, quote.Status__c);
                    if (quote.Status__c == 'Approved' && !isUpdateSuccess)
                    {
                        quote.Status__c = 'Failed Approval';
                    }
                    else
                    {
                        if (quote.Status__c == 'Approved')
                        {
                            this.placement.Status__c = 'Moved-In';
                            if (this.placement.Date_Moved_In__c == null)
                            {
                                this.placement.Date_Moved_In__c = DateTime.now();
                            }
                            this.placement.Approved_Quote__c = quote.id;
                            this.placement.Original_Approved_Through_Date__c = this.placement.Approved_Through_Date__c;
                            if (this.placement.Selected_Search__r.Days_Notice_Required__c == null)
                            {
                                this.placement.Date_To_Send_NTV__c = this.placement.Approved_Through_Date__c;
                            }
                            else
                            {
                                this.placement.Date_To_Send_NTV__c = this.placement.Approved_Through_Date__c - this.placement.Selected_Search__r.Days_Notice_Required__c.intValue();    
                            }
                            upsert this.placement;
                        }
                        else
                        {
                            if (quote.Status__c == 'Rejected')
                            {
                                this.placement.Lease_Required__c = false;
                                upsert this.placement;
                            }
                        }
                    }
                }        
            }
               
            upsert quote;
            
            if (isNewQuote)
            {
                List<Costs__c> costs = getQuoteCosts();
                
                List<RecordType> costRecordTypes = [select Id,Name from RecordType where SobjectType = 'Costs__c'];
                Map<Id,String> costRecordTypeMap = new Map<Id,String>();
                for (RecordType costRT : costRecordTypes)
                {
                    costRecordTypeMap.put(costRT.Id,costRT.Name);
                }           
                
                List<Quote_Costs__c> quoteCosts = new  List<Quote_Costs__c>();
                            
                for (Costs__c cost : costs)
                {
                    Quote_Costs__c quoteCost = new Quote_Costs__c();
                    quoteCost.Quote__c = quote.Id;
                    quoteCost.Record_Type_Name__c = costRecordTypeMap.get(cost.RecordTypeId);
                    quoteCost.Type__c = cost.Type__c;
                    quoteCost.Type_Description__c = cost.Type_Description__c;
                    quoteCost.Amount__c = cost.Amount__c;
                    if (quoteCost.Record_Type_Name__c == 'Cost' && (quoteCost.Type__c == 'Furniture' || quoteCost.Type__c == 'Appliance'
                        || quoteCost.Type__c == 'Electronics' || quoteCost.Type__c == 'Kitchen Housewares' || quoteCost.Type__c == 'Bed Bath Housewares'
                        || quoteCost.Type__c == 'Other Housewares'))
                    {
                        quoteCost.Start_Date__c = this.placement.Move_In_Date__c;
                        quoteCost.End_Date__c = this.placement.Approved_Through_Date__c;
                    }
                    else
                    {
                        if (quoteCost.Record_Type_Name__c == 'Furniture Deposit' || quoteCost.Record_Type_Name__c == 'Furniture Fee')
                        {
                            quoteCost.Start_Date__c = this.placement.Move_In_Date__c;
                            quoteCost.End_Date__c = this.placement.Move_In_Date__c;
                        }
                        else
                        {
                            quoteCost.Start_Date__c = cost.Start_Date__c;
                            quoteCost.End_Date__c = cost.End_Date__c;   
                        }
                    }
                                
                    quoteCost.Prorate_Type__c = cost.Prorate_Type__c;
                    quoteCost.Billable_Party__c = cost.Billable_Party__c;
                    quoteCost.Payable_Party__c = cost.Payable_Party__c;
                    quoteCost.Searches__c = cost.Searches__c;
                    quoteCosts.add(quoteCost);
                }
                insert quoteCosts;
            }
            
            if (this.placement.Status__c <> 'Moved-In')
            {
                if (getHasActiveQuote())
                {
                    this.placement.Status__c = 'Quote';
                }
                else
                {
                    this.placement.Status__c = 'Pending Confirmation';
                }
                   
                upsert this.placement;
            }
        }
        
        this.placement = fetchRelatedPlacement();
            
        return null;
    }

    public PageReference getNewCreditCard()
    {
        Map<string, string> pageParams = ApexPages.currentPage().getParameters();
        string placementPaymentType = pageParams.get('placementPaymentType');
        
        if (placementPaymentType == 'PayNet')
        {
            string actionType = 'New';
            string ccEndDate = '';
            string ccAcctCIDExp = PayNetConnectCallOuts.setupCCRequest(actionType, placement.RecordType.Name, claim.Name, serviceRequest.Name, placement.Id, placement.Name, ccEndDate); 
        
            
            if (ccAcctCIDExp != null && ccAcctCIDExp != '')
            { 
                placement.Credit_Card_Type__c = 'PayNet';
                List<String> ccInfo = ccAcctCIDExp.split(',',3);
                placement.Credit_Card_Number__c = ccInfo[0];
                placement.Credit_Card_CID__c = ccInfo[1];
                placement.Credit_Card_Expiration__c = ccInfo[2];
                placement.Using_Backup_Card__c = false;
                
            }
            else
            {
                placement.Credit_Card_Type__c = 'PayNet';
                placement.Credit_Card_Number__c = '5552160161062875';
                placement.Credit_Card_CID__c = '350';
                placement.Credit_Card_Expiration__c = '01/2019';
                placement.Using_Backup_Card__c = true;
          
               
            } 
        }
        else
        {
            if (placementPaymentType == 'PayNet ID Copy')
            {
                placement.Credit_Card_Type__c = 'PayNet ID Copy';
                placement.Credit_Card_Number__c = '5552160296082418';
                placement.Credit_Card_CID__c = '352';
                placement.Credit_Card_Expiration__c = '10/2019';
                placement.Using_Backup_Card__c = true;
                   
            }
        }

        update placement;
                
        return null;
    }
   
    // fetch housing search to be selected
    private Searches__c fetchHousingSearchToBeSelected(Id housingSearchID)
    {
        List<Searches__c> searches = getHousingSearches();
        for (Searches__c s : searches)
        {
            if (s.Id == housingSearchID)
            {
                selectedHousingSearch = s;
            }
        }
        return selectedHousingSearch;
    }
        
    private void internalSelectedSearch()
    {
        this.selectedHousingSearch = null;
        for (Searches__c s : getHousingSearches())
        {
            if (s.Selected__c == true)
            {
                this.selectedHousingSearch = s;
            }
        }
    }
    
   // returns housing search
    private Searches__c fetchHousingSearch(Id housingSearchId)
    {
        Searches__c housingSearch;
        try
        {
            housingSearch = [select Id, Presented_Date__c, Name, Email__c, Selected__c, Distance_from_Damaged_Property__c,
                                    Landlord__c,Landlord_Status__c,Landlord__r.Name,Service_Request__r.Opportunity__r.Policyholder__c,
                                    Service_Request__r.Opportunity__r.Policyholder__r.Name,Service_Request__r.Opportunity__r.Adjuster__c,
                                    Service_Request__r.Opportunity__r.Adjuster__r.Name,
                                    Street_Addr1__c, Street_Addr2__c, City__c, State__c, Zip__c, Foreclosure__c, Property_Description__c,
                                    Days_Notice_Required__c, Bedrooms__c, Initial_Check_Delivery_Method__c, Initial_Payment_Type__c,Rent_Costs__c,
                                    Property_Type__c,Furniture_Option__c,Country__c,Name_of_Complex__c,Unit__c,Initial_Contact_Name__c,Initial_Contact_Number__c,
                                    Bathrooms__c,Square_Feet__c,Pets_Allowed__c,Wood_Floors__c,Elevator_Reservation_Required__c,Extension_Increment_Days__c,
                                    Recurring_Payment_Type__c,NTV_Send_Via__c,Send_Copy_of_Check__c,Send_Copy_of_Tracking_Information__c,Has_Rent__c,
                                    Has_Policyholder_Rent__c,Has_Policyholder_Abatement__c,Has_Utilities__c,THC_Comments__c,CreatedDate,Sequence_Number__c,Policyholder_Accepted_Property_Date__c,
                                    Policyholder_Declined_Property_Date__c,Policyholder_Declined_Property_Reason__c,Has_Payable_Landlord_Cost__c,PH_Viewed__c,Floor__c,Over_5_Mile_Reason__c,Lease_Term_Approved_By_Adjuster__c,
                                    First_Available_Move_In_Date__c,Tentative_Move_Out_Date__c,Rent_Frequency__c,First_Month_Pro_Rated_Rent_Amount_Due__c,What_Is_Included_In_The_Prorated_Rent__c,
                                    RSD__c,Pet_RSD__c,Responsible_Party_For_RSD__c,Sure_Deposit__c,Application_Fee__c,Tax__c,Total_Pet_Fees__c,Cleaning_Fee__c,Amenity_Fee__c,Administration_Fee__c,Re_Keying_Fee__c,
                                    Break_Lease_Fee__c,Garage_Remote_Fee__c,Fencing_Fee__c,Renters_Insurance_Required__c,Declaration_Page_Sufficient__c,RM_Updated__c, 
                                    Rental_Application_Required__c,Processing_Time_For_Application__c,Requirements_For_Qualification__c,Utilities_Included_In_Rent__c,
                                    How_Utilities_Are_To_Be_Established__c,Utilities_PH_Is_Responsible_For__c,Landscaping_Snow_Removal_HOA_Included__c,
                                    Appliances_Present_In_Rental_Property__c,Appliances_CRS_Needs_To_Provide__c,Appliance_Hook_Up_Gas_Electric__c,Window_Coverings_Present__c,
                                    Pictures_Allowed_On_Walls__c,Number_Of_Pets_Allowed__c,Fenced_Yard__c,Utility_Set_Up_Fee__c,Broker_Fee__c,Window_Covering_Fee__c,
                                    Certificate_Of_Occupancy_Required__c,Certificate_Of_Occupancy_Fee__c,Parking_Fee__c,Other_Non_Refundable_Fee__c,PH_Abatement_Amount__c,
                                    Start_Date_For_PH_Abatement__c,Responsible_Party_For_Vendor_Entry__c,Phone_Number_To_Confirm_Vendor_Entry__c,Days_Notice_Required_After_ILT__c,Presented_To_Adjuster__c,Rent__c,
                                    What_Utilities_Are_Included_In_Rent__c,Rent_Increase_After_ILT__c,Rent_Increase_To_After_ILT__c,NTV_Send_To__c,
                                    (select Id, Name, RecordTypeId, Start_Date__c, End_Date__c, Amount__c, Type__c, Type_Description__c, Billable_Party__c, Payable_Party__c, 
                                            Prorate_Type__c from Costs__r order by CreatedDate, Name)
                                    from Searches__c 
                                    where Id = :housingSearchId limit 1];
        }
        catch (QueryException e)
        {
            housingSearch = new Searches__c();
        }
        return housingSearch;
    }
    
    // returns cost
    private Costs__c fetchCost(Id costId)
    {
        Costs__c cost;
        try
        {
            cost = [select Id, RecordTypeId, Start_Date__c, End_Date__c, Amount__c, Type__c, Type_Description__c, Billable_Party__c, Payable_Party__c, 
                           Prorate_Type__c, Searches__c, Searches__r.Landlord_Status__c,searches__r.Landlord__c
                    from Costs__c 
                    where Id = :costId];
        }
        catch (QueryException e)
        {
            cost = new Costs__c();
        } 
        
        return cost;             
    }
    
    // returns furniture order
    private Furniture_Order__c fetchFurnitureOrder(Id furnitureOrderId)
    {
        Furniture_Order__c furnitureOrder;
        try
        {
            furnitureOrder = [select Id, Name, Status__c, Requested_Furniture_Delivery_Date__c, Is_partial_order__c, Furniture_Level__c, 
                                     Furniture_Comments__c, Include_Pictures__c, Master_Bedroom__c, Living_Room__c , Additional_Living_Room__c, Dining_Room__c,
                                     Additional_Dining_Room__c, Additional_Bedroom_1__c, Additional_Bedroom_2__c, Additional_Bedroom_3__c, Additional_Bedroom_4__c,
                                     Additional_Bedroom_5__c, Additional_Bedroom_6__c, Additional_Bedroom_7__c, Additional_Bedroom_8__c, Additional_Bedroom_9__c,
                                     Additional_Bedroom_10__c, Appliances__c, Refrigerator__c, Clothes_Washer__c, Microwave__c, Clothes_Dryer__c,
                                     Range__c, Dryer_Type__c, Range_Type__c, Housewares__c, Bedrooms_Needing_Housewares__c, Bathrooms_Needing_Housewares__c,
                                     Cost__c,Furniture_Cost__c,Appliance_Cost__c,Electronics_Cost__c,Kitchen_Housewares_Cost__c,BedBath_Housewares_Cost__c,
                                     Other_Housewares_Cost__c,Deposit__c,Setup_Fee__c,Pet_Fee__c,Delivery_Fee__c,Billable_Party_Cost__c,
                                     Billable_Party_Furniture_Cost__c,Billable_Party_Appliance_Cost__c,Billable_Party_Electronics_Cost__c,
                                     Billable_Party_Kitchen_Housewares_Cost__c,Billable_Party_BedBath_Housewares_Cost__c,
                                     Billable_Party_Other_Housewares_Cost__c,Billable_Party_Deposit__c,Billable_Party_Delivery_Fee__c,
                                     Billable_Party_Setup_Fee__c,Billable_Party_Pet_Fee__c,Ready_For_VSS__c,Created_After_Move_In__c
                              from Furniture_Order__c 
                              where Id = :furnitureOrderId];
        }
        catch (QueryException e)
        {
            furnitureOrder = new Furniture_Order__c();
        } 
        
        return furnitureOrder;             
    }
    
    // returns working or completed furniture order
    private Furniture_Order__c fetchActiveFurnitureOrder(Id placementId)
    {
        Furniture_Order__c furnitureOrder;
        try
        {
            furnitureOrder = [select Id,Status__c,Cost__c,Furniture_Cost__c,Appliance_Cost__c,Electronics_Cost__c,Kitchen_Housewares_Cost__c,
                                     BedBath_Housewares_Cost__c,Other_Housewares_Cost__c                                
                              from Furniture_Order__c 
                              where Status__c <> 'Cancelled' and Placement__c =: placementId limit 1];
        }
        catch (QueryException e)
        {
            furnitureOrder = new Furniture_Order__c();
        } 
        
        return furnitureOrder;             
    }
    
    // returns completed furniture order
    private Furniture_Order__c fetchCompletedFurnitureOrder(Id placementId)
    {
        Furniture_Order__c furnitureOrder;
        try
        {
            furnitureOrder = [select Id, Name, Status__c, Requested_Furniture_Delivery_Date__c, Is_partial_order__c, Furniture_Level__c, 
                                     Furniture_Comments__c, Include_Pictures__c, Master_Bedroom__c, Living_Room__c , Additional_Living_Room__c, Dining_Room__c,
                                     Additional_Dining_Room__c, Additional_Bedroom_1__c, Additional_Bedroom_2__c, Additional_Bedroom_3__c, Additional_Bedroom_4__c,
                                     Additional_Bedroom_5__c, Additional_Bedroom_6__c, Additional_Bedroom_7__c, Additional_Bedroom_8__c, Additional_Bedroom_9__c,
                                     Additional_Bedroom_10__c, Appliances__c, Refrigerator__c, Clothes_Washer__c, Microwave__c, Clothes_Dryer__c,
                                     Range__c, Dryer_Type__c, Range_Type__c, Housewares__c, Bedrooms_Needing_Housewares__c, Bathrooms_Needing_Housewares__c,
                                     Cost__c,Furniture_Cost__c,Appliance_Cost__c,Electronics_Cost__c,Kitchen_Housewares_Cost__c,BedBath_Housewares_Cost__c,
                                     Other_Housewares_Cost__c,Deposit__c,Setup_Fee__c,Pet_Fee__c,Delivery_Fee__c,Billable_Party_Cost__c,Billable_Party_Furniture_Cost__c,
                                     Billable_Party_Appliance_Cost__c,Billable_Party_Electronics_Cost__c,Billable_Party_Kitchen_Housewares_Cost__c,
                                     Billable_Party_BedBath_Housewares_Cost__c,Billable_Party_Other_Housewares_Cost__c,Billable_Party_Deposit__c,
                                     Billable_Party_Delivery_Fee__c,Billable_Party_Setup_Fee__c,Billable_Party_Pet_Fee__c,Ready_For_VSS__c,Created_After_Move_In__c
                              from Furniture_Order__c 
                              where Status__c = 'Completed' and Placement__c =: placementId limit 1];
        }
        catch (QueryException e)
        {
            furnitureOrder = new Furniture_Order__c();
        } 
        
        return furnitureOrder;             
    }
    
    // returns quote
    private Quote__c fetchQuote(Id quoteId)
    {
        Quote__c quote;
        try
        {
            quote = [select Id,Name,Status__c,Placement_Lookup__c,Claim_Name__c,Claim_Entity__c,Contract_Number__c,Move_In_Date__c,Approved_Through_Date__c,
                            Claim_Team_Number__c,Temporary_Address_New__c,Markup__c,Markup_Adjustment__c,Markup_Authorized_By__c,Markup_Total__c,
                            Prorate__c,Prorate_Adjustment__c,Prorate_Total__c,Billing_Preference__c,Housewares_Provided_New__c,Appliances_Provided_New__c,
                            Days_Notice_Required_New__c,Bedrooms_New__c,Number_Of_Children_New__c,Number_Of_Adults_New__c,Number_Of_Pets_New__c,
                            Initial_Check_Delivery_Method__c,Initial_Payment_Type__c,Adjuster__c,Claim_Number_New__c,Property_Type_New__c,
                            Landlord__c,Adjuster_To_Pay__c,Return_Deposit_To_New__c,Claim_Owner__c,Claim_Owner_Name__c,Special_Instructions_New__c,
                            Damaged_Property_State__c,Damaged_Property_Zip__c,Searches__c,Markup_Adjustment_Reason__c,Furniture_Option__c,
                            Quote_Document_Recieved__c,Furniture_Costs__c,CRS_Add_On__c,
                            (select Id,Name,Record_Type_Name__c,Start_Date__c,End_Date__c,Amount__c,Type__c,Type_Description__c,Billable_Party__c,Payable_Party__c, 
                                    Prorate_Type__c 
                             from Quote_Costs__r order by CreatedDate, Name)
                     from Quote__c 
                     where Id = :quoteId];
        }
        catch (QueryException e)
        {
            quote = new Quote__c();
        } 
        
        return quote;             
    }
    
    // returns active quote
    private Quote__c fetchActiveQuote(Id placementId)
    {
        Quote__c quote;
        try
        {
            quote = [select Id from Quote__c where Status__c <> 'Rejected' and Placement_Lookup__c =: placementId limit 1];
        }
        catch (QueryException e)
        {
            quote = new Quote__c();
        } 
        
        return quote;             
    }
    
    // returns related placement, or a new placement based on serviceRequest.Id
    private Placement__c fetchRelatedPlacement()
    {
        Placement__c relatedPlacement;
        
        if (serviceRequest == null || serviceRequest.Id == null)
        {
            relatedPlacement = new Placement__c();
            relatedPlacement.RecordTypeId = RecordTypeHelper.housingPlacementRT();
            relatedPlacement.ServiceRequest__c = serviceRequest.Id;
            relatedPlacement.Opportunity__c = serviceRequest.Claim__c;
        }   
        else
        {
            try
            {
               relatedPlacement = [select Id,RecordTypeId,Name,Opportunity__c,Hotel_Account_Lookup__c,Credit_Card_Type__c,Credit_Card_Number__c,
                                          Credit_Card_Expiration__c,Status__c,ServiceRequest__c,MHS_Booking__c,Special_Instructions__c,
                                          Check_In_Date__c,Check_Out_Date__c,Move_Out_Date__c,Invoice_From_Folio__c,Payment_Type__c,Estimated_Check_Out_Date__c,
                                          Accounting_Instructions__c,IATA_Number_Provided__c,IATA_Commission_Paid__c,ServiceRequest__r.Opportunity__r.ALE_Limit_Amount__c,
                                          isDeleted,Credit_Card_CID__c,Selected_Search__c,THA_Signed_Date__c,THC_Signed_Date__c,Move_In_Date__c,Approved_Through_Date__c,
                                          Prorate__c,Prorate_Adjustment__c,Prorate_Total__c,Placement_Team__c,ServiceRequest__r.Opportunity__r.Account.Name,
                                          ServiceRequest__r.Opportunity__r.Adjuster__r.Name,ServiceRequest__r.Opportunity__r.Policyholder__r.Name,Rent_Hold__c,Days_to_Vacate_Notice__c,
                                          Selected_Search__r.Temporary_Address__c,Original_Approved_Through_Date__c,Monthly_Follow_Up_Call__c,Monthly_Billing__c,Security_Deposit__c,
                                          Property_Rent__c,CRS_Add_On__c,FHA_Billing__c,ServiceRequest__r.Opportunity__r.Deposit_Responsible_Party__c,
                                          Approved_Quote__r.Return_Deposit_To_New__c,Selected_Search__r.Days_Notice_Required__c,Selected_Search__r.Date_To_Send_NTV__c,
                                          Selected_Search__r.NTV_Send_Via__c,Selected_Search__r.Landlord_Status__c,Disposition_Completed__c,Selected_Search__r.Recurring_Payment_Type__c,
                                          Selected_Search__r.Extension_Increment_Days__c,Selected_Search__r.Landlord__c,Approved_Quote__r.Markup_Total__c,Return_Deposit_To__c,
                                          AR_Pending__c,Failure_to_Vacate__c,Lease_Required__c,Invoice_Hold__c,Invoice_Hold_Reason__c,Rent_Hold_Reason__c,Selected_Search__r.NTV_Send_To__c,
                                          Move_In_Docs_Missing__c,RecordType.Name
                                   from Placement__c 
                                   where ServiceRequest__c = :serviceRequest.Id limit 1];
            }
            catch (QueryException e)
            {
                relatedPlacement = new Placement__c();
                relatedPlacement.RecordTypeId = RecordTypeHelper.housingPlacementRT();
                relatedPlacement.ServiceRequest__c = serviceRequest.Id;
                relatedPlacement.Opportunity__c = serviceRequest.Opportunity__c;
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
            opp = [select Id,Name,Policyholder__r.FirstName,Policyholder__r.LastName,Adjuster__c,Policyholder__c,Policy_Type__c, 
                          Account.Id,Account.ParentId,Reports_TeamNumber__c,Number_of_Children__c,
                          Number_of_Adults__c,Number_Of_Pets__c,Claim__c,Owner.Id,Owner.Name,Damaged_Property_State__c,Damaged_Property_Zip__c,
                          ALE_Limit_Amount__c,ALE_Limit_Time__c,Monthly_ALE_Billing__c,Monthly_Rental_Amount__c,Pet_Type_and_Breed__c,
                          Damaged_Property_Full_Address__c,Home_Insured_For__c,Est_Length_of_Stay_Months__c,Deposit_Responsible_Party__c,
                          Return_Deposit_To__c,Adjuster__r.FirstName,Adjuster__r.LastName,Adjuster__r.Phone,Adjuster__r.Fax,Adjuster__r.Account.Name,
                          Number_of_Bedrooms__c,Number_of_Bathrooms__c,Entity__c,Account.Parent.Name,Account.Parent.Parent.Name,Alerts__c
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
    
    private Boolean parseBooleanParam(string paramKey, map<string, string> params)
    {
        Boolean retval = null;
        
        if (params.containsKey(paramKey))
        {
            string d = params.get(paramKey);
            
            if (d.trim().length() > 0)
            {
                try 
                {
                    Boolean bool = Boolean.valueOf(d.replace(',',''));
                    retval = bool;
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