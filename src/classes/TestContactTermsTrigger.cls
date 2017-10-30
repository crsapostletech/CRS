@isTest
public class TestContactTermsTrigger 

{

    static testMethod void myShareTest()

    {

    

   /*Zishan Comment out this section Bad Code

        Contact c = new Contact();

        c.FirstName = 'Darren';

        c.LastName = 'Kemp';

        c.Payment_Terms__c = '45';

        c.AccountID = '0017000000Q4aAtAAJ';  */

/*Zishan Added in this code to make this class correct   */     

Account a = new Account

                    (
                      National_Account__c = 'Yes',
                      name='Allstate',

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

        insert a;              


      

        Contact c = new Contact();


                    c.LastName='xxxxxx';

                    c.AccountId=a.id;

                    c.Status__c='Active';

                    c.MailingCountry='USA';

                    c.MailingState='CT';

                    c.MailingStreet='134 Laurel';

                    c.MailingCity='Mineola';

                    c.MailingPostalCode='11501';

                    c.Payment_Terms__c = '45';

        

           insert c;

           
            
            System.assertEquals(c.Payment_Terms__c, '45');       

 

    }



}