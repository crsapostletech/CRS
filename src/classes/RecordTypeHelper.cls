public with sharing class RecordTypeHelper  
{
    private static String claim;
    private static String policyholderContact;
    private static String adjusterContact;
    private static String landlordContact;
    private static String hotelContact;
    private static String hotelServiceRequest;
    private static String housingServiceRequest;
    private static String frvServiceRequest;
    private static String findersFeesServiceRequest;
    private static String hotelPlacement;
    private static String housingPlacement;
    private static String hotelAccount;
    private static String insuranceCompanyAccount;
    private static String householdAccount;
    private static String landlordAccount;
    private static String hotelSearch;
    private static String housingSearch;
    private static String costCosts;
    private static String feeCosts;
    private static String depositCosts;
    private static String furnitureDepositCosts;
    private static String furnitureFeeCosts;
    private static String mulliganQuote;
    private static String unSentNTVTask;
    private static String closedNTVTask;
    private static String portalNotesTask;
    private static String portalNotesCompletedTask;
    private static String x72HourPHContactTask;
    private static String x72HourADJContactTask;
    private static String x24HourFollowUpTask;
    private static String newCase;
    private static String assignedCase;
    private static String AdjusterPortalConnection;
    
    public static String claimRT()
    {
        if (claim == null)
        {
            claim = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Claim').getRecordTypeId();
        }
        return claim;
    }

    public static String policyholderContactRT()
    {
        if (policyholderContact == null)
        {
            policyholderContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Policyholder').getRecordTypeId();
        }
        return policyholderContact;
    }
  
    public static String adjusterContactRT()
    {
        if (adjusterContact == null)
        {
            adjusterContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Adjuster').getRecordTypeId();
        
        }
        return adjusterContact;
    }
    
    public static String landlordContactRT()
    {
        if (landlordContact == null)
        {
            landlordContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Landlord').getRecordTypeId();
        }
        return landlordContact;
    }

    public static String hotelContactRT()
    {
        if (hotelContact == null)
        {
            hotelContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Hotel Contact').getRecordTypeId();
        }
        return hotelContact;
    }
  
    public static String hotelServiceRequestRT()
    {
        if (hotelServiceRequest == null)
        {
            hotelServiceRequest = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        }
        return hotelServiceRequest;
    }
  
    public static String housingServiceRequestRT()
    {
        if (housingServiceRequest == null)
        {
            housingServiceRequest = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Housing').getRecordTypeId();
        }
        return housingServiceRequest;
    }
    
    public static String frvServiceRequestRT()
    {
        if (frvServiceRequest == null)
        {
            frvServiceRequest = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('FRV').getRecordTypeId();
        }
        return frvServiceRequest;
    }
    
    public static String findersFeesServiceRequestRT()
    {
        if (findersFeesServiceRequest == null)
        {
            findersFeesServiceRequest = Schema.SObjectType.ServiceRequest__c.getRecordTypeInfosByName().get('Finders Fees').getRecordTypeId();
        }
        return findersFeesServiceRequest;
    }
  
    public static String hotelPlacementRT()
    {
        if (hotelPlacement == null)
        {
            hotelPlacement = Schema.SObjectType.Placement__c.getRecordTypeInfosByName().get('Hotel Placement').getRecordTypeId();
        }
        return hotelPlacement;
    }
    
    public static String housingPlacementRT()
    {
        if (housingPlacement == null)
        {
            housingPlacement = Schema.SObjectType.Placement__c.getRecordTypeInfosByName().get('Housing Placement').getRecordTypeId();
        }
        return housingPlacement;
    }
  
    public static String hotelAccountRT()
    {
        if (hotelAccount == null)
        {
            hotelAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Hotel Accounts').getRecordTypeId();
        }
        return hotelAccount;
    }
    
    public static String insuranceCompanyAccountRT()
    {
        if (insuranceCompanyAccount == null)
        {
            insuranceCompanyAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Insurance Companies').getRecordTypeId();
        }
        return insuranceCompanyAccount;
    }
    
    public static String householdAccountRT()
    {
        if (householdAccount == null)
        {
            householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Accounts').getRecordTypeId();
        }
        return householdAccount;
    }

    public static String landlordAccountRT()
    {
        if (landlordAccount == null)
        {
            landlordAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Landlord Accounts').getRecordTypeId();
        }
        return landlordAccount;
    }
    
    public static String hotelSearchRT() 
    {
        if (hotelSearch == null)
        {
            hotelSearch = Schema.SObjectType.Searches__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        }
        return hotelSearch;
    }
    
    public static String housingSearchRT()
    {
        if (housingSearch == null)
        {
            housingSearch = Schema.SObjectType.Searches__c.getRecordTypeInfosByName().get('Housing').getRecordTypeId();
        }
        return housingSearch;
    }
    
    public static String costCostsRT()
    {
        if (costCosts == null)
        {
            costCosts = Schema.SObjectType.Costs__c.getRecordTypeInfosByName().get('Cost').getRecordTypeId();
        }
        return costCosts;
    }
    
    public static String feeCostsRT()
    {
        if (feeCosts == null)
        {
            feeCosts = Schema.SObjectType.Costs__c.getRecordTypeInfosByName().get('Fee').getRecordTypeId();
        }
        return feeCosts;
    }
    
    public static String depositCostsRT()
    {
        if (depositCosts == null)
        {
            depositCosts = Schema.SObjectType.Costs__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
        }
        return depositCosts;
    }
    
    public static String furnitureDepositCostsRT()
    {
        if (furnitureDepositCosts == null)
        {
            furnitureDepositCosts = Schema.SObjectType.Costs__c.getRecordTypeInfosByName().get('Furniture Deposit').getRecordTypeId();
        }
        return furnitureDepositCosts;
    }
    
    public static String furnitureFeeCostsRT()
    {
        if (furnitureFeeCosts == null)
        {
            furnitureFeeCosts = Schema.SObjectType.Costs__c.getRecordTypeInfosByName().get('Furniture Fee').getRecordTypeId();
        }
        return furnitureFeeCosts; 
    }
        
    public static String mulliganQuoteRT()
    {
        if (mulliganQuote == null)
        {
            mulliganQuote = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('Mulligan Quote').getRecordTypeId();
        }
        return mulliganQuote;
    }

    public static String unsentNTVTaskRT()
    {
        if (unsentNTVTask == null)
        {
            unsentNTVTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('NTV Unsent').getRecordTypeId();
        }
        return unsentNTVTask;
    }

    public static String closedNTVTaskRT()
    {
        if (closedNTVTask == null)
        {
            closedNTVTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('NTV Closed').getRecordTypeId();
        }
        return closedNTVTask;
    }

    public static String portalNotesTaskRT()
    {
        if (portalNotesTask == null)
        {
            portalNotesTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Portal Notes').getRecordTypeId();
        }
        return portalNotesTask;
    }

    public static String portalNotesCompletedTaskRT()
    {
        if (portalNotesCompletedTask == null)
        {
            portalNotesCompletedTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Portal Notes Completed').getRecordTypeId();
        }
        return portalNotesCompletedTask;
    }

    public static String x72HourPHContactTaskRT()
    {
        if (x72HourPHContactTask == null)
        {
            x72HourPHContactTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('72 Hour PH Contact').getRecordTypeId();
        }
        return x72HourPHContactTask;
    }

    public static String x72HourADJContactTaskRT()
    {
        if (x72HourADJContactTask == null)
        {
            x72HourADJContactTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('72 Hour ADJ Contact').getRecordTypeId();
        }
        return x72HourADJContactTask;
    }

    public static String x24HourFollowUpTaskRT()
    {
        if (x24HourFollowUpTask == null)
        {
            x24HourFollowUpTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('24 Hour Follow Up').getRecordTypeId();
        }
        return x24HourFollowUpTask;
    }

    public static String newCaseRT()
    {
        if (newCase == null)
        {
            newCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Case').getRecordTypeId();
        }
        return newCase;
    }

    public static String assignedCaseRT()
    {
        if (assignedCase == null)
        {
            assignedCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Assigned Case').getRecordTypeId();
        }
        return assignedCase;
    }
    public static String AdjusterPortalConnectionRT()
    {
        if (AdjusterPortalConnection == null)
        {
            AdjusterPortalConnection = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Adjuster Portal Connection').getRecordTypeId();
        }
        return AdjusterPortalConnection;
    }
}