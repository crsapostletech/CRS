/**********************************************************************************************************
Created By: Apostletech
Purpose: To call pardot prospect with out Adjuster record type Confirmation api call to get data and delete all non adjusrter records. 
Test class: PardotMockHttpResponseGeneratorTC,PardotServicesCalloutClassTest_TC 
***********************************************************************************************************/
global class PardotProspectCustomIterable implements Iterator<String>{ 

   List<String> prospectIdlist{get; set;} 
   Integer i {get; set;} 

   public pardotProspectCustomIterable(list<String> ProspectId){ 
    prospectIdlist = ProspectId;
    i=0;
   }   

   global boolean hasNext(){ 
       if(i >= prospectIdlist.size()) {
           return false; 
       } else {
           return true; 
       }
   }  
   global String next(){ 
       if(i == prospectIdlist.size()){return null;} 
       i++; 
       return prospectIdlist[i-1];
       }  

}