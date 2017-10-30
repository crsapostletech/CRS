public class AELinesItem {
    public Placement__c placement { get; private set;} 
    public Adjustment__c[] adjLineItems { get; private set; }
    string htl;

    private ApexPages.StandardController controller;
    
    void queryAELines(id id) { 
    placement = [Select p.id,  
                        (Select Name, RecordTypeId, Rent_Adjustment__c, 
                        Billing_Adjustment__c, Fee_Frequency__c, Hotel_Rate_Adjustment__c, 
                        Housing_Fee_Type__c, Hotel_Fee_Type__c, Trailer_Mobile_Home__c, 
                        Placement_Lookup__c, Other_Description__c, Housing_Fee_Effective_Date__c, 
                        Hotel_Fee_Effective_Date__c, Housing_Adjustment_Fee__c, 
                        Hotel_Adjustment_Fee__c, Hotel_Room_Lookup__c,Housing_Credit_Proposed_Amount__c, 
                        Other_Fee_Description__c, Adjustment_Effective_Date__c,Rate_Adjustment_Effective_Date__c,
                        Rent_Adjustment_Effective_Date__c, Adjustment_Description__c From Adjustments__r )
                        From Placement__c p
                where p.id = :id limit 1];  
            
            
    adjLineItems = placement.Adjustments__r; 
    for ( Adjustment__c ql : adjLineItems ) 
    { 
        htl = ql.Hotel_Room_Lookup__c;
    }

}
public pagereference CopyOperation() { 
       
        string reloadQuote = ApexPages.CurrentPage().getParameters().get('reloadQuote');
        
        return null;
    } 

    public AELinesItem() {
        placementid = ApexPages.CurrentPage().getParameters().get('id');
        init(); 
    }
    public AELinesItem(ApexPages.StandardController c) {
        controller = c;
        placementid = c.getRecord().id;
        init();
    } 
	public pagereference recalc() {
         
        for ( Adjustment__c hr : adjLineItems ) { 
        }

        return null;
    }
      id placementid;  
    
	void init() { 
        queryAELines(placementid);
        if(adjLineItems.size()==0){
           add();
        }   
	}
    
         
    PageReference placementPR() { return new pagereference('/'+placement.id); }
    public list<Adjustment__c> todelete = new list<Adjustment__c>();

        
    public PageReference save() { 
        try { 
            
            upsert adjLineItems;
            if ( todelete.size() > 0 ) {            
                delete todelete;    
            }
            queryAELines(placement.id);
        } 
        catch ( DmlException exc) { 
             ApexPages.addMessages(exc); 
             return null;
        }       
        
        return placementPR(); 
    }
        
    public PageReference add() { 
        // insert a new line
        //Adjustment__c h =  new Adjustment__c(Placement_Lookup__c = placement.id,
        //                                    Hotel_Room_Lookup__c = htl) ;
        Adjustment__c h =  new Adjustment__c(Placement_Lookup__c = placement.id) ;
        adjLineItems.add ( h );
        
        
        return null; 
    }
     
    public PageReference reset() { 
        queryAELines(placement.id);
        return null;
    } 
/* Test Method for this Controller Starts Here From Zishan R./Enterprise Tech Consultants Inc.*/    
    static testMethod void testAELinesItem() {
/*CREATE NEW ACCOUNT*/
    RecordType rta = [Select Id, Name from RecordType where sobjecttype='Account' 
    and Name like 'Hotel%' limit 1];

        Account a = new Account
                    (
                      RecordTypeId = rta.Id,
                      name='zishanabc',
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

        // Insert Users
        Profile profile = [SELECT Id FROM Profile WHERE Name='Operations User']; 
        User user1 = new User
                (   
                    Alias = 'opsusr',
                    Email='operationsuser@testorg.com', 
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing', 
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = profile.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    UserName='operationsuser@crstemphousing.com');
        insert user1;     
       
        //Insert an Opportunity 
        Opportunity o = new Opportunity
                (
                    StageName = 'Submitted',
                    name='test11',
                    Initial_Service_Request__c='Hotel',   
                    CloseDate = Date.newInstance(2010,12,10),
                    Type_of_Loss__c = 'Mold',
                    Damaged_Property_Type__c = 'Apartment',
                    Damaged_Property_Address__c = '134 Laurel',
                    Damaged_Property_City__c = 'Mineola',
                    Damaged_Property_State__c = 'CT',
                    Damaged_Property_Zip__c = '11501',
                    Damaged_Property_Country__c = 'USA',
                    Regional_Manager__c = user1.Id,
                    Customer_Care_Specialist__c = user1.Id,
                    Hotel_Customer_Care_Specialist__c = user1.Id);
        insert o;


        RecordType rtpl = [
                    Select Id, Name from 
                    RecordType where sobjecttype='Placement__c' 
                    and Name Like 'Hotel Placement' limit 1
                    ];
        
        Placement__c p = new Placement__c(
                    RecordTypeId=rtpl.Id,
                    Name='ZishanPlacement',
                    opportunity__c=o.id, 
                    Status__c='Moved-In', 
                    Hotel_Account_Lookup__c=a.id);
        insert p;
        
         Hotel_Room__c hotelRoom = new Hotel_Room__c(
                    placement__c = p.Id, 
                    Room_Type__c = 'Standard Double',
                    Parking_Fee_Type__c = 'False',
                    Pet_Fee_Type__c = 'False',
                    Check_In__c = Date.newInstance(2009,09,09),
                    Checkout__c = Date.newInstance(2009,09,11));
        insert hotelRoom;
                     

        PageReference pageRefa = new PageReference('/apex/editAdjustments?id=' + p.id);
        Test.setCurrentPage(pageRefa);
        system.debug( 'placement id is '+p.id);
        
        ApexPages.currentPage().getParameters().put('id', p.id);
        
        AELinesItem s = new AELinesItem();
        ApexPages.currentPage().getParameters().put('reloadQuote','1');
        Adjustment__c aa = new Adjustment__c(
                        Adjustment_Effective_Date__c=Date.newInstance(2010,12,10),
                        Placement_Lookup__c=p.id, 
                        Hotel_Fee_Effective_Date__c=Date.newInstance(2010,12,10),
                        Hotel_Fee_Type__c='Parking Fee', 
                        Fee_Frequency__c='Daily', 
                        Other_Fee_Description__c='blah', 
                        Hotel_Rate_Adjustment__c=25.00,
                        Hotel_Room_Lookup__c=hotelRoom.Id, 
                        Rate_Adjustment_Effective_Date__c=Date.newInstance(2010,12,10));
        insert aa;           

        s.CopyOperation(); 
       
        s.save() ;

        
        s.adjLineItems = Database.query(
                        'Select Name, RecordTypeId, Rent_Adjustment__c, '+ 
                        'Billing_Adjustment__c, Fee_Frequency__c, Hotel_Rate_Adjustment__c, '+ 
                        'Housing_Fee_Type__c, Hotel_Fee_Type__c, Trailer_Mobile_Home__c, '+ 
                        'Placement_Lookup__c, Other_Description__c, Housing_Fee_Effective_Date__c, '+ 
                        'Hotel_Fee_Effective_Date__c, Housing_Adjustment_Fee__c, '+ 
                        'Hotel_Adjustment_Fee__c, Hotel_Room_Lookup__c,Housing_Credit_Proposed_Amount__c, '+ 
                        'Other_Fee_Description__c, Adjustment_Effective_Date__c, '+
                        'Rate_Adjustment_Effective_Date__c, '+
                        'Rent_Adjustment_Effective_Date__c, Adjustment_Description__c From Adjustment__c  '+
                        'where Placement_Lookup__c = \''+ p.Id+'\' ');
        s.recalc();    
            
        ApexPages.currentPage().getParameters().put('reloadQuote','1');

        ApexPages.currentPage().getParameters().put('reloadOpp','1');
        s.CopyOperation(); 
        
        ApexPages.currentPage().getParameters().put('delname', s.adjLineItems[0].name );
        s.add();
        s.save(); 
        s.reset();
       
        ApexPages.CurrentPage().getParameters().put('reloadOpp',null );
        ApexPages.CurrentPage().getParameters().put('reloadQuote',null );
        AELinesItem s3 = new AELinesItem();
        system.assertEquals( null, s3.CopyOperation() ); 

    }       


}