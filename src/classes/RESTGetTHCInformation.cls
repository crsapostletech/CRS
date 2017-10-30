@RestResource(urlMapping='/Searches/GetTHCInformation/*')
global with sharing class RESTGetTHCInformation 
{
	@HttpGet
	global static string doGetTHCInformation(RestRequest req)
	{
		boolean hasCosts = true;
		string searchId = req.RequestURI.substring(req.requestURI.lastIndexOf('/')+1);
		system.debug(searchId);
		system.debug(req.RequestURI.substring(req.requestURI.lastIndexOf('/')+1));
		Searches__c search = [select Service_Request__r.Opportunity__r.Policyholder__r.Name,Temporary_Address_With_Unit__c,Service_Request__r.Opportunity__r.Name,
		    				  Days_Notice_Required__c,Landlord__r.Name,Extension_Increment_Days__c,Bedrooms__c,Bathrooms__c,Placement__r.Prorate_Total__c,
		 					  THC_Comments__c,Landlord__r.Account.Name,Landlord__r.Account.BillingStreet,Landlord__r.Account.BillingCity,Landlord__r.Account.BillingState,
		 					  Landlord__r.Account.BillingPostalCode,Landlord__r.Account.BillingCountry,Landlord__r.Account.Fax,Landlord__r.Account.Email__c,Placement__r.Move_In_Date__c,
		 					  Placement__r.Approved_Through_Date__c,NTV_Send_Via__c,Unit__c from Searches__c where Id =: searchId ];
        
        List<Costs__c> costs = new List<Costs__c>();
        
        costs = [select RecordTypeName__c, Type__c, Type_Description__c, Amount__c, Prorate_Type__c from Costs__c 
        		 where Payable_Party_is_Landlord__c = true and searches__r.Id =: searchId];
               
        if (search.Service_Request__r.Opportunity__r.Name == null){search.Service_Request__r.Opportunity__r.Name = '';}
        if (search.THC_Comments__c == null){search.THC_Comments__c = '';}
        if (search.Landlord__r.Account.Name == null){search.Landlord__r.Account.Name = '';}
        if (search.Landlord__r.Account.BillingStreet == null){search.Landlord__r.Account.BillingStreet = '';}
        if (search.Landlord__r.Account.BillingCity == null){search.Landlord__r.Account.BillingCity = '';}
        if (search.Landlord__r.Account.BillingState == null){search.Landlord__r.Account.BillingState = '';}
        if (search.Landlord__r.Account.BillingPostalCode == null){search.Landlord__r.Account.BillingPostalCode = '';}
        if (search.Landlord__r.Account.BillingCountry == null){search.Landlord__r.Account.BillingCountry = '';}
        if (search.Landlord__r.Account.Email__c == null){search.Landlord__r.Account.Email__c = '';}
        if (search.Landlord__r.Account.Fax == null){search.Landlord__r.Account.Fax = '';}
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        
        gen.writeStringField('PolicyholderName', search.Service_Request__r.Opportunity__r.Policyholder__r.Name);
        gen.writeStringField('TemporaryAddress', search.Temporary_Address_With_Unit__c);
        gen.writeStringField('ClaimName', search.Service_Request__r.Opportunity__r.Name);
        gen.writeNumberField('DaysNoticeRequired', search.Days_Notice_Required__c);
        gen.writeStringField('LandlordName', search.Landlord__r.Name);
        gen.writeNumberField('ExtensionIncrementDays', search.Extension_Increment_Days__c);
        gen.writeStringField('Bedrooms', search.Bedrooms__c);
        gen.writeStringField('Bathrooms', search.Bathrooms__c);
        gen.writeNumberField('ProrateTotal', search.Placement__r.Prorate_Total__c);
        gen.writeDateField('MoveInDate', search.Placement__r.Move_In_Date__c);
        gen.writeDateField('ApprovedThroughDate', search.Placement__r.Approved_Through_Date__c);
        gen.writeStringField('NTVSendVia', search.NTV_Send_Via__c);
       	gen.writeStringField('THCComments', search.THC_Comments__c);
        gen.writeStringField('LandlordAccountName', search.Landlord__r.Account.Name);
        gen.writeStringField('LandlordAccountMailingSteet', search.Landlord__r.Account.BillingStreet);
        gen.writeStringField('LandlordAccountMailingCity', search.Landlord__r.Account.BillingCity);
        gen.writeStringField('LandlordAccountMailingState', search.Landlord__r.Account.BillingState);
        gen.writeStringField('LandlordAccountMailingPostalCode', search.Landlord__r.Account.BillingPostalCode);
        gen.writeStringField('LandlordAccountMailingCountry', search.Landlord__r.Account.BillingCountry);
        gen.writeStringField('LandlordAccountEmail', search.Landlord__r.Account.Email__c);
        gen.writeStringField('LandlordAccountFax', search.Landlord__r.Account.Fax);
                              
       	gen.writeObjectField('cost', costs);
                         
        gen.writeEndObject();
        
        String JSONString = gen.getAsString();
        
        // modify JSON string for mulligan 
        JSONString = JSONString.replaceAll('\n','');
              	
      	system.debug(JSONString);
      	                       
        return JSONString;
	}
}