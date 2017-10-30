global with sharing class Util {
    
    private static string userProfileName;
    private static string currentInstanceName;
    private static string currentInstanceBaseURL;

    // Get all the IDs out of an array into a set.
    // Really useful for bulkifying triggers
    // @author cpeterson
    global static Set<id> getIds(sObject[] objList){
        Set<id> retval = new Set<id>();
        for(sobject thisObj: objList){
            retval.add(thisObj.id);
        }
        return retval;
    }
    

    // Get a string field from an array of objects, and return those fields in an array.
    //  @author cpeterson
    global static List<string> getStringFields(List<sObject> objectList, string fieldName){
        List<string> result = new List<string>();
        for(sObject thisObject:objectList){
            result.add(String.valueOf(thisObject.get(fieldName)));
        }       
        System.assertEquals(result.size(),objectList.size());
        return result;
    }

     // Wrapper around getStringFeilds, but returns an ID rather than a string
     // usefull for use in SOQL queries.
     // @author cpeterson
     global static List<Id> getIDFields(List<sObject> objectList, string fieldName){
        List<ID> idList = Util.getStringFields(objectList, fieldName);
        return idList;
     }
     
         
     // Trigger flags       
     private static boolean alreadyFiredAccount = false;
     private static boolean alreadyFiredClaim = false;
     private static boolean alreadyFiredContact = false;
     private static boolean alreadyFiredHotelRoom = false;
     private static boolean alreadyFiredFurnitureOrder = false;
     private static boolean alreadyFiredPlacement = false;
     private static boolean alreadyFiredNote = false;
     private static boolean alreadyFiredSearch = false;
     private static boolean alreadyFiredTask = false;
     private static boolean alreadyFiredUser = false;
     
     // Check to see if a trigger has already fired for a particular object
     public static boolean hasAlreadyFired(string objectType)
     { 
        if (objectType.toLowerCase() == 'account')
        {
           return alreadyFiredAccount; 
        }
        else
        {
           if (objectType.toLowerCase() == 'claim')
           {
              return alreadyFiredClaim;     
           }
           else
           {
              if (objectType.toLowerCase() == 'contact')
              {
                 return alreadyFiredContact;    
              }
              else
              {
                 if (objectType.toLowerCase() == 'hotel_room__c')
                 {
                    return alreadyFiredHotelRoom;
                 }
                 else
                 {
                    if (objectType.toLowerCase() == 'furniture_order__c')
                    {
                        return alreadyFiredFurnitureOrder;
                    }
                    else
                    {
                        if (objectType.toLowerCase() == 'placement__c')
                        {
                            return alreadyFiredPlacement;
                        }
                        else
                        {
                            if (objectType.toLowerCase() == 'note')
                            {
                                return alreadyFiredNote;
                            }
                            else
                            {
                                if (objectType.toLowerCase() == 'searches__c')
                                {
                                    return alreadyFiredSearch;
                                }
                                else
                                {
                                    
                                    if (objectType.toLowerCase() == 'task')
                                    {
                                        return alreadyFiredTask;
                                    }
                                    else
                                    {
                                        if (objectType.toLowerCase() == 'user')
                                        {
                                            return alreadyFiredUser;
                                        }
                                    }
                                }
                            }
                        }
                    }
                 }
              }
           }    
        }
        return false;       
     }
     
     // Set trigger flag to true for given object
     public static void setAlreadyFired(string objectType) 
     {
        if (objectType.toLowerCase() == 'account')
        {
            alreadyFiredAccount = true; 
        }
        else
        {
            if (objectType.toLowerCase() == 'claim')
            {
                alreadyFiredClaim = true;   
            }
            else
            {
                if (objectType.toLowerCase() == 'contact')
                {
                    alreadyFiredContact = true; 
                }
                else
                {
                    if (objectType.toLowerCase() == 'hotel_room__c')
                    {
                        alreadyFiredHotelRoom = true;
                    }
                    else
                    {
                        if (objectType.toLowerCase() == 'furniture_order__c')
                        {
                            alreadyFiredFurnitureOrder = true;
                        }
                        else
                        {
                            if (objectType.toLowerCase() == 'placement__c')
                            {
                                alreadyFiredPlacement = true;
                            }
                            else
                            {
                                if (objectType.toLowerCase() == 'note')
                                {
                                    alreadyFiredNote = true;
                                }
                                else
                                {
                                    if (objectType.toLowerCase() == 'searches__c')
                                    {
                                        alreadyFiredSearch = true;
                                    }
                                    else
                                    {
                                        if (objectType.toLowerCase() == 'task')
                                        {
                                            alreadyFiredSearch = true;
                                        }
                                        else
                                        {
                                            if (objectType.toLowerCase() == 'user')
                                            {
                                                alreadyFiredUser = true;
                                            }
                                        }   
                                    }
                                }
                            }
                        }
                    }
                }
            }   
        }
     }
    
     // Set trigger flag to false for given object
     public static void unsetAlreadyFired(string objectType) 
     {
        if (objectType.toLowerCase() == 'account')
        {
            alreadyFiredAccount = false;    
        }
        else
        {
            if (objectType.toLowerCase() == 'claim')
            {
                alreadyFiredClaim = false;  
            }
            else
            {
                if (objectType.toLowerCase() == 'contact')
                {
                    alreadyFiredContact = false;    
                }
                else
                {
                    if (objectType.toLowerCase() == 'hotel_room__c')
                    {
                        alreadyFiredHotelRoom = false;
                    }
                    else
                    {
                        if (objectType.toLowerCase() == 'furniture_order__c')
                        {
                            alreadyFiredHotelRoom = false;
                        }
                        else
                        {
                            if (objectType.toLowerCase() == 'placement__c')
                            {
                                alreadyFiredPlacement = false;
                            }
                            else
                            {
                                if (objectType.toLowerCase() == 'note')
                                {
                                    alreadyFiredNote = false;
                                }
                                else
                                {
                                    if (objectType.toLowerCase() == 'searches__c')
                                    {
                                        alreadyFiredSearch = false;
                                    }
                                    else
                                    {
                                        if (objectType.toLowerCase() == 'task')
                                        {
                                            alreadyFiredSearch = false;
                                        }
                                        else
                                        {
                                            if (objectType.toLowerCase() == 'user')
                                            {
                                                alreadyFiredUser = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }   
        }
    }
    
    public static void sendErrorEmail(string subject, string body)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'mbodde@crsth.com'};
        String[] ccAddresses = new String[] {'skonemann@crsth.com','vbenyshek@crsth.com'};
        mail.setToAddresses(toAddresses); 
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {
           // production org so add cc's
           mail.setCcAddresses(ccAddresses);
        }
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'sfdcadmin@crsth.com'];
        if (owea.size() > 0)  
        {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
             
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static string getInstanceName()
    {
        if (currentInstanceName == null)
        {
        
            string userName = UserInfo.getUserName();
            if (userName.substring(userName.lastIndexOf('.') + 1) == 'stage')
            {
            currentInstanceName = 'staging';
            }
            else
            {
                if (userName.substring(userName.lastIndexOf('.') + 1) == 'dev')
                {
                    currentInstanceName = 'finalforce';
                }
                else
                {
                    if (userName.substring(userName.lastIndexOf('.') + 1) == 'training')
                    {
                        currentInstanceName = 'training';
                    }
                    else
                    {
                        if (userName.substring(userName.lastIndexOf('.') + 1) == 'sandboxtle')
                        {
                            currentInstanceName = 'sandboxtle';
                        }
                        else
                        {
                            if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
                            {
                                currentInstanceName = 'production';
                            }
                        }
                    }    
                }
            }
        }
        
        return currentInstanceName;
    }


     public static string getInstanceBaseURL()
    {
        if (currentInstanceBaseURL == null)
        {
        
            if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
            {
                currentInstanceBaseURL = 'https://login.salesforce.com';
            }
            else
            {
                currentInstanceBaseURL = 'https://test.salesforce.com';
            }
            
        }
        
        return currentInstanceBaseURL;
    }

    
    public static string getUserProfileName()
    {
        if (userProfileName == null)
        {
            try
            {
                userProfileName = [Select p.Name From Profile p where p.Id=:UserInfo.getProfileId()].Name;
            }
            catch (QueryException e)
            {               
            }
        }
        
        return userProfileName; 
    }

    public static Datetime getNTVTaskDueDate(Date dateToSendNTV, String ntvSendVia)   // Get due date for NTV task
    {
        DateTime dueDate = DateTime.newInstance(dateToSendNTV, Time.newInstance(12,0,0,0));

        if (dueDate.format('u') == '6')
        {
            dueDate = dueDate.AddDays(-1);
        }
        else
        {
            if (dueDate.format('u') == '7')
            {
                dueDate = dueDate.AddDays(-2);
            }
        }

        if (ntvSendVia == 'Certified Mail' || ntvSendVia == 'Insured')
        {
            if (dueDate.format('u') == '1' || dueDate.format('u') == '2' || dueDate.format('u') == '3')
            {
                dueDate = dueDate.AddDays(-5);  
            }
            else
            {
                dueDate = dueDate.AddDays(-3);
            }
        }

        return dueDate;
    }

    public static DateTime getMinNTVDate(String ntvSendVia)  // Get minimum date to create NTV task
    {
        
        DateTime minNTVDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));  

           
        if (ntvSendVia == 'Email' || ntvSendVia == 'Fax')
        {
            // Get Min Date To Send NTV for creating Email and Fax tasks

           if (minNTVDate.format('u') != '6' || minNTVDate.format('u') != '7')
           {
               minNTVDate = minNTVDate.AddDays(7);
           }
           else
           {
               if (minNTVDate.format('u') != '6')
               {
                   minNTVDate = minNTVDate.AddDays(6);
               }
               else
               {
                   minNTVDate = minNTVDate.AddDays(5);
               }
           }
        }
        else
        {
            if (ntvSendVia == 'Certified Mail' || ntvSendVia == 'Insured')
            {
                // Get Min  Date To Send NTV for creating Mail and Insured tasks
        
                if (minNTVDate.format('u') != '6' || minNTVDate.format('u') != '7')
                {
                    minNTVDate = minNTVDate.AddDays(7);
                }
                else
                {
                    if (minNTVDate.format('u') != '6')
                    {
                        minNTVDate = minNTVDate.AddDays(6);
                    }
                    else
                    {
                        minNTVDate = minNTVDate.AddDays(5);
                    }
                }
            }
        }

        return minNTVDate;  
    }

    public static DateTime getMaxNTVDate(String ntvSendVia)  // Get maximum date to create NTV task
    {
        
        DateTime maxNTVDate = DateTime.newInstance(System.today(), Time.newInstance(12,0,0,0));  

           
        if (ntvSendVia == 'Email' || ntvSendVia == 'Fax')
        {
            // Get Min Date To Send NTV for creating Email and Fax tasks

           if (maxNTVDate.format('u') == '5')
           {
               maxNTVDate = maxNTVDate.AddDays(9);
           }
           else
           {
               maxNTVDate = maxNTVDate.AddDays(7);
           }
        }
        else
        {
            if (ntvSendVia == 'Certified Mail' || ntvSendVia == 'Insured')
            {
                // Get Min  Date To Send NTV for creating Mail and Insured tasks
        
               if (maxNTVDate.format('u') == '5')
               {
                   maxNTVDate = maxNTVDate.AddDays(9);
               }
               else
               {
                   maxNTVDate = maxNTVDate.AddDays(7);
               }
            }
        }

        return maxNTVDate;  
    }

    public static string getHash()
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
}