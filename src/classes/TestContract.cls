/*
File..................: Test class - TestContract 
Object................: Contract
Created by............: M.Bodde
Created Date..........: 9-29-2010
Description...........: Test class for contract object

Last Modified by......: 
Last Modified Date....: 
Last Modified Reason..: 
*/

@isTest
private class TestContract {

    static testMethod void testPushContractInformationToHouston() 
    {
    	RecordType accountRT = [Select Id from RecordType where sobjecttype='Account' and Name = 'Insurance Companies'];
        // Insert Account
        Account account = new Account
                    (
                      RecordTypeId = accountRT.Id,
                      name='testAccount',
                      Active__c=True,
                      BillingState='CT',
                      BillingStreet='134 Laurel',
                      BillingCity='Mineola',
                      BillingPostalCode='11501',
                      BillingCountry='USA',
                      ShippingState = 'CT',
                      ShippingCountry = 'USA',
                      ShippingPostalCode = '11501',
                      ShippingCity = 'Mineola',
                      ShippingStreet = '134 Laurel'
                    );
        insert account;
        
        RecordType contractRT = [Select Id from RecordType where sobjecttype='Contract' and Name = 'Insurance Contracts'];
        // Insert Contract
        Contract contract = new Contract
                    (
                      RecordTypeId = contractRT.Id,
                      AccountId = account.Id,
                      StartDate = Date.newInstance(2010,12,10),
                      ContractTerm = 12,
                      Payment_Terms__c = '20'
                    );
        insert contract;
        
        Contract insertedContract = [SELECT Id FROM Contract WHERE id =: contract.Id];
      
        insertedContract.Payment_Terms__c = '30';
        
        update insertedContract;    
    }
}