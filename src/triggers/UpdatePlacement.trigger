trigger UpdatePlacement on Hotel_Room__c (after insert, after update) 
{
    Set<Id> placementIds = new Set<Id>();
    Map<Id, Boolean> placementId_updateCheckInDate = new Map<Id, Boolean>();
    Map<Id, Boolean> placementId_updateCheckOutDate = new Map<Id, Boolean>();
    Map<Id, Boolean> placementId_cancelPlacement = new Map<Id, Boolean>();
    Map<Id, Date> placementId_minCheckInDate = new Map<Id, Date>();
    Map<Id, Date> placementId_maxCheckOutDate = new Map<Id, Date>();
    Map<Id, Double> placementId_totalUnbilled = new Map<Id, Double>();
    Map<Id, Id> placementId_LastModifiedById = new Map<Id, Id>();
    Map<Id, Id> placementId_RCLastModifiedById = new Map<Id, Id>();

    Date currentDate = Date.today();
    Date minDate = Date.parse('1/1/1900');
    Integer lastDayOfMonth = (currentDate.addMonths(1) - currentDate.day()).day();
       
    for(Hotel_Room__c hotelRoom : Trigger.new)
    {
        if (!placementIds.contains(hotelRoom.Placement__c) && hotelRoom.Placement__c != null)
        {   
            // add related placement id to set
            placementIds.add(hotelRoom.Placement__c);
            
            // set flags and dates for related placement
            placementId_updateCheckInDate.put(hotelRoom.Placement__c,true);
                        
            if (hotelRoom.CheckOut__c != null || hotelRoom.Cancellation_del__c != null)
            {
                placementId_updateCheckOutDate.put(hotelRoom.Placement__c,true);
            }
            else
            {
                system.debug(hotelRoom.CheckOut__c);
                system.debug(hotelRoom.Cancellation_del__c);
                placementId_updateCheckOutDate.put(hotelRoom.Placement__c,false);
            }
            if (hotelRoom.Cancellation_del__c != null)
            {
                placementId_cancelPlacement.put(hotelRoom.Placement__c,true);
                placementId_minCheckInDate.put(hotelRoom.Placement__c,hotelRoom.Check_In__c);
                placementId_maxCheckOutDate.put(hotelRoom.Placement__c,minDate);
            }
            else
            {
                placementId_cancelPlacement.put(hotelRoom.Placement__c,false);
                placementId_minCheckInDate.put(hotelRoom.Placement__c,hotelRoom.Check_In__c);
                placementId_maxCheckOutDate.put(hotelRoom.Placement__c,hotelRoom.CheckOut__c);
            }

            placementId_LastModifiedById.put(hotelRoom.Placement__c,hotelRoom.LastModifiedById);
            placementId_RCLastModifiedById.put(hotelRoom.Placement__c,hotelRoom.RC_Last_Modified_By_Id__c);

        }
    }


    // get all hotel rooms that have a related placement id that is in the placementIds set
     List<Hotel_Room__c> hotelRooms = [SELECT Check_In__c,CheckOut__c,Cancellation_del__c,Placement__c,CRS_Room_Rate__c,Billed_Through_Date__c,Total_Unbilled__c FROM Hotel_Room__c WHERE Placement__c = : placementIds];
    
    // loop through all the hotel rooms to check and see if flags and or dates need to be updated
    for(Hotel_Room__c additionalHotelRoom : hotelrooms)
    {
        if(additionalHotelRoom.Cancellation_del__c == null)
        {
            
            if (placementId_cancelPlacement.get(additionalHotelRoom.Placement__c))
            {
                placementId_cancelPlacement.put(additionalHotelRoom.Placement__c,false);
                placementId_minCheckInDate.put(additionalHotelRoom.Placement__c,additionalHotelRoom.Check_In__c);
            }
            else
            {
                if(additionalHotelRoom.Check_In__c < placementId_minCheckInDate.get(additionalHotelRoom.Placement__c)) 
                {
                    placementId_minCheckInDate.put(additionalHotelRoom.Placement__c,additionalHotelRoom.Check_In__c);
                }
            }
                
            if(additionalHotelRoom.CheckOut__c > placementId_maxCheckOutDate.get(additionalHotelRoom.Placement__c))
            {
                placementId_maxCheckOutDate.put(additionalHotelRoom.Placement__c,additionalHotelRoom.CheckOut__c);
            }
            else
            {
                if (additionalHotelRoom.CheckOut__c == null && additionalHotelRoom.Cancellation_del__c == null)
                {
                    system.debug(additionalHotelRoom.CheckOut__c);
                    system.debug(additionalHotelRoom.Cancellation_del__c);
                    placementId_updateCheckOutDate.put(additionalHotelRoom.Placement__c,false);
                }
            }
        }
        else
        {
            if (placementId_cancelPlacement.get(additionalHotelRoom.Placement__c))
            {
                if(additionalHotelRoom.Check_In__c < placementId_minCheckInDate.get(additionalHotelRoom.Placement__c)) 
                {
                    placementId_minCheckInDate.put(additionalHotelRoom.Placement__c,additionalHotelRoom.Check_In__c);
                }
            }
        }
        
        // add room unbilled amount to placement total unbilled amount
        Double totalUnbilled = 0;
        
        if (placementId_totalUnbilled.get(additionalHotelRoom.Placement__c) <> null)
        {
            totalUnbilled = placementId_totalUnbilled.get(additionalHotelRoom.Placement__c);    
        }
        
        if (additionalHotelRoom.Total_Unbilled__c <> null)
        {
            placementId_totalUnbilled.put(additionalHotelRoom.Placement__c,totalUnbilled + additionalHotelRoom.Total_Unbilled__c);
        }
    }
    
    // get all placements that have an id that is in the placmentIds set
    List<Placement__c> placements = [SELECT Id,Name,Check_In_Date__c,Check_Out_Date__c,Status__c,Credit_Card_Type__c,Credit_Card_Number__c,Opportunity__r.Name,
                                            ServiceRequest__c,ServiceRequest__r.Name,Estimated_Check_Out_Date__c,Total_Unbilled__c,Reason_For_Leaving__c,
                                            Total_Credit_Needed__c,Opportunity__r.Policyholder__c,Opportunity__r.Hotel_Customer_Care_Specialist__c
                                            FROM Placement__c WHERE Id = : placementIds];
    List<Placement__c> changedPlacements = new List<Placement__c>();


    // loop through all the placements and update dates and or status based on flags being true or false
    for(Placement__c placement : placements)
    {        
        Boolean hasChanged = false;

        system.debug(placementId_cancelPlacement.get(placement.Id));
        system.debug(placementId_updateCheckOutDate.get(placement.Id));
        system.debug(placementId_updateCheckInDate.get(placement.Id));
        system.debug(placementId_totalUnbilled.get(placement.Id));
        system.debug(placement.Total_Unbilled__c);
        system.debug(placementId_minCheckInDate.get(placement.Id));
        system.debug(placement.Check_In_Date__c);
        system.debug(hasChanged);
        system.debug(placement.Id);
        


        if (placementId_cancelPlacement.get(placement.Id))
        {
            if (placementId_updateCheckInDate.get(placement.Id))
            {
                if (placement.Check_In_Date__c != placementId_minCheckInDate.get(placement.Id))
                {
                    placement.Check_In_Date__c = placementId_minCheckInDate.get(placement.Id);
                    hasChanged = true;
                }
            }
            
            if (placementId_updateCheckOutDate.get(placement.Id))
            {
                system.debug(String.valueof(placementId_maxCheckOutDate.get(placement.Id)));
                if (placementId_maxCheckOutDate.get(placement.Id) != minDate)
                {
                    if ( placement.Check_Out_Date__c != placementId_maxCheckOutDate.get(placement.Id))
                    { 
                        placement.Check_Out_Date__c = placementId_maxCheckOutDate.get(placement.Id);
                        hasChanged = true;
                    }
                }
                else
                {
                    if (placement.Check_Out_Date__c != null)
                    {
                        placement.Check_Out_Date__c = null;
                        hasChanged = true;
                    }
                }
                
            }      
            
            if (placement.Status__c != 'Cancelled')
            {
                placement.Status__c = 'Cancelled';
                placement.Date_Set_To_Cancelled__c = Date.today();
                hasChanged = true;
                
                if(placement.Reason_For_Leaving__c != null)
                {
                   placement.Reason_For_Leaving__c = null;
                   hasChanged = true; 
                }
                 
    /*          if (placement.Credit_Card_Type__c == 'vPay' && placement.Credit_Card_Number__c != '370268023665727')
                {
                    string actionType = 'Update'; 
                    string fullPlacementId = placement.Id;
                    string placementIdFirst15 = fullPlacementId.substring(0,15);
                    string placementIdLast3 = fullPlacementId.substring(15,18);
                    string cardNumber = placement.Credit_Card_Number__c;
                    string ccEndDate = String.valueOf(Date.today());
                    if (Datetime.now().hour() >= 21)
                    {
                        ccEndDate = String.valueOf(Date.today().addDays(1));    
                    }
                    VPayConnectCallOuts.setupCCRequestAsync(actionType,placementIdFirst15,placement.ServiceRequest__r.Name,placementIdLast3,cardNumber,ccEndDate);
                    placement.Estimated_Check_Out_Date__c = null;
                    hasChanged = true;
                }
                else
                {
    */
                    // Placement is cancelled so if credit card is PayNet and not the backup card then update credit card end date

                    if (placement.Credit_Card_Type__c == 'Visa PayNet' && placement.Credit_Card_Number__c != '4864623444887042' && placement.Credit_Card_Number__c != '4864623313547230' || 
                        placement.Credit_Card_Type__c == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875')
                    {
                        string actionType = 'Update';
                        string ccEndDate = String.valueOf(Date.today().addDays(1));  
                        PayNetConnectCallOuts.setupCCRequestAsync(actionType,placement.RecordType.Name,placement.Opportunity__r.Name,placement.ServiceRequest__r.Name,placement.Id,placement.Name,ccEndDate,'');
                        placement.Estimated_Check_Out_Date__c = null;
                        hasChanged = true;
                    }
                }
                system.debug(hasChanged);
    //        }
        }
        else
        {
            if (placementId_updateCheckInDate.get(placement.Id))
            {
                if (placement.Check_In_Date__c != placementId_minCheckInDate.get(placement.Id))
                {
                    placement.Check_In_Date__c = placementId_minCheckInDate.get(placement.Id);
                    hasChanged = true;
                }
            }

            system.debug(hasChanged);
            
            if (placementId_updateCheckOutDate.get(placement.Id))
            {
                boolean updateCard = false;
                
                if (placement.Check_Out_Date__c == null || placement.Check_Out_Date__c != placementId_maxCheckOutDate.get(placement.Id) && placement.Check_Out_Date__c.addDays(14) > Date.today())
                {
                    updateCard = true;
                    hasChanged = true;
                } 

                system.debug(hasChanged); 
                system.debug(updateCard);
                
                if (placement.Check_Out_Date__c != placementId_maxCheckOutDate.get(placement.Id))
                {
                    placement.Check_Out_Date__c = placementId_maxCheckOutDate.get(placement.Id);
                    hasChanged = true;
                }

                if (placement.Status__c != 'Checked-Out')
                {            
                    placement.Status__c = 'Checked-Out';
                    placement.Date_Set_To_Checked_Out__c = Date.today();
                    hasChanged = true;
                }

                system.debug(hasChanged); 
                    
                if (updateCard)
                {         
                    // If credit card is vPay and not the backup card then update credit card end date
                    
    /*                if (placement.Credit_Card_Type__c == 'vPay' && placement.Credit_Card_Number__c != '370268023665727')
                    {
                        string actionType = 'Update'; 
                        string fullPlacementId = placement.Id;
                        string placementIdFirst15 = fullPlacementId.substring(0,15);
                        string placementIdLast3 = fullPlacementId.substring(15,18);
                        string cardNumber = placement.Credit_Card_Number__c;
                        string ccEndDate = '';
                        if (placement.Check_Out_Date__c.addDays(14) < Date.today())
                        {
                            ccEndDate = String.valueOf(Date.today());
                            if (Datetime.now().hour() >= 21)
                            {
                                ccEndDate = String.valueOf(Date.today().addDays(1));    
                            }
                        }
                        else
                        {
                            ccEndDate = String.valueOf(placement.Check_Out_Date__c.addDays(14));
                        }
                        VPayConnectCallOuts.setupCCRequestAsync(actionType,placementIdFirst15,placement.ServiceRequest__r.Name,placementIdLast3,cardNumber,ccEndDate);
                        placement.Estimated_Check_Out_Date__c = null;
                    } 
                    else
                    {
    */
                    
                        // If credit card is PayNet and not the backup card then update credit card end date
                        
                        if (placement.Credit_Card_Type__c == 'Visa PayNet' && placement.Credit_Card_Number__c != '4864623444887042' && placement.Credit_Card_Number__c != '4864623313547230' || 
                        placement.Credit_Card_Type__c == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875')
                        {
                            string actionType = 'Update'; 
                            string ccEndDate = '';
                            if (placement.Check_Out_Date__c.addDays(14) <= Date.today()) 
                            {
                                ccEndDate = String.valueOf(Date.today().addDays(1));
                                if (Datetime.now().hour() >= 21)
                                {
                                    ccEndDate = String.valueOf(Date.today().addDays(2));    
                                }
                            }
                            else
                            {
                                ccEndDate = String.valueOf(placement.Check_Out_Date__c.addDays(14));
                            }
                            PayNetConnectCallOuts.setupCCRequestAsync(actionType,placement.RecordType.Name,placement.Opportunity__r.Name,placement.ServiceRequest__r.Name,placement.Id,placement.Name,ccEndDate,'');
                            placement.Estimated_Check_Out_Date__c = null;
                        }
    //                }
                }
            }
            else
            {
                if (placement.Check_Out_Date__c != null)
                {
                    placement.Check_Out_Date__c = null;
                    hasChanged = true;
                }
                if (placement.Status__c != 'Checked-In')
                {
                    placement.Status__c = 'Checked-In';
                    hasChanged = true;
                }
                if(placement.Reason_For_Leaving__c != null)
                {
                   placement.Reason_For_Leaving__c = null;
                   hasChanged = true; 
                }
                system.debug(hasChanged);
            }
        }
       
        if (placement.Total_Unbilled__c != placementId_totalUnbilled.get(placement.Id))
        {
            placement.Total_Unbilled__c = placementId_totalUnbilled.get(placement.Id);
            hasChanged = true;
        }

        system.debug(placementId_totalUnbilled.get(placement.Id));
        system.debug(placement.Total_Unbilled__c);
        system.debug(hasChanged);

        try
        {
            AggregateResult ar = [select sum(Total_Credit_Needed__c) tcn from Hotel_Room__c where Placement__c =: placement.Id];
            Integer totalCreditNeeded = Integer.valueOf(ar.get('tcn'));
            String assignTasksTo;
           
            // Increase total credit needed by 400%
            totalCreditNeeded = totalCreditNeeded * 3;

            if (totalCreditNeeded != placement.Total_Credit_Needed__c && trigger.isUpdate && placement.Status__c != 'Checked-Out' && placementId_LastModifiedById.get(placement.Id) == '00570000001AcGt')
            {
                List<Task> sendDocTaskList = new List<Task>();
                
                List<Task> activeCCAuths = [select id from task where whatid =: placement.ServiceRequest__c and Subject = 'Send Credit Card Authorization (CCA)' and Status != 'Completed'];
                List<Task> activeAdjConfirmations = [select id from task where whatid =: placement.ServiceRequest__c and Subject = 'Send Adjuster Confirmation' and Status != 'Completed'];

                
                System.debug(placementId_RCLastModifiedById.get(placement.Id)); 

                assignTasksTo = placementId_RCLastModifiedById.get(placement.Id);
                if (assignTasksTo == null || assignTasksTo == '00570000001AcGt')
                {
                    // If RC last modified user is not found or is External API calls then assign the tasks to the Hotel Specialist
                    assignTasksTo = placement.Opportunity__r.Hotel_Customer_Care_Specialist__c; 
                }   

                if (activeCCAuths.IsEmpty())
                {
                    sendDocTaskList.add(TaskBuilder.ccAuth(placement.Id,placement.ServiceRequest__c,placement.Opportunity__r.Policyholder__c,assignTasksTo));
                }
                if (activeAdjConfirmations.IsEmpty())
                {
                    sendDocTaskList.add(TaskBuilder.adjConfirmation(placement.Id,placement.ServiceRequest__c,placement.Opportunity__r.Policyholder__c,assignTasksTo));
                }
                if(!sendDocTaskList.isEmpty()){
                    insert sendDocTaskList;
                }

                if (placement.Credit_Card_Type__c == 'PayNet' && placement.Credit_Card_Number__c != '5552160161062875')
                {
                    // Ccredit card is PayNet and not the backup card update credit card end date
                    string actionType = 'Update'; 
                    PayNetConnectCallOuts.setupCCRequestAsync(actionType,placement.RecordType.Name,placement.Opportunity__r.Name,placement.ServiceRequest__r.Name,placement.Id,placement.Name,'', string.valueOf(totalCreditNeeded));
                }
        
                placement.Total_Credit_Needed__c = totalCreditNeeded;
                hasChanged = true;
            }
       
        }
        catch(Exception ex) {}

        if (hasChanged)
        {
            changedPlacements.add(placement);
        }
    }
    // update any placments that have changed
    update (changedPlacements);
}