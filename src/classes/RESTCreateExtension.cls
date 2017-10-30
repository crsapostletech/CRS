@RestResource(urlMapping='/Placement/CreateExtension/*')
global with sharing class RESTCreateExtension 
{
    @HttpPost
    global static void insertExtension(String placementId, String userId, String approvedThroughDate, Boolean createNTVTask) 
    { 
         try
        {
            Placement__c placement = [select Approved_Through_Date__c,Status__c from Placement__c where Id =: placementId];
            placement.Approved_Through_Date__c = date.valueOf(approvedThroughDate);
            if (placement.Status__c == 'Moved-Out' && placement.Approved_Through_Date__c >= system.Today())
            {   
                // If the placement is moved out and extended into the future it goes back to moved in status
                placement.Status__c = 'Moved-In';
                placement.Monthly_Billing__c = null;
                placement.Property_Rent__c = null;
                placement.FHA_Billing__c = null;
                placement.Markup__c = null;
                placement.CRS_Add_On__c = null;
                placement.Security_Deposit__c = null;
            }
            else
            {   
                placement.Create_NTV_Task__c = createNTVTask;
                if (placement.Status__c == 'Moved-In' && placement.Approved_Through_Date__c < system.Today())
                {   
                    // If the placement is moved in and extended into the past it goes to moved out status
                    placement.Status__c = 'Moved-Out';
                }
            }
            update placement;
        }
        catch (Exception e)
        {
             Util.sendErrorEmail('Unable to update the Approved Through Date on Placement','ERROR: ' + e + ' returned updating placement Id ' + placementId);       
        }
        
        try
        {
            Extension__c extension = new Extension__c(); 
            extension.Placement__c = placementId;
            extension.Extend_To_Date__c = date.valueOf(approvedThroughDate);
            
            User user = new User();
            try
            {
                user = [select FirstName,LastName from User where id =: userId];
            }
            catch (Exception e)
            {
                user.FirstName = 'Unknown';
                user.LastName = 'User';
            }
        
            extension.Extension_Created_By__c = (user.FirstName + ' ' + user.LastName);
            
            insert extension;       
            
        }
        catch (Exception e)
        {
             Util.sendErrorEmail('Unable to create Extension for Placement','ERROR: ' + e + ' returned creating extension for placement Id ' + placementId);        
        }
        
        
    }   
}