/**********************************************************************************************************
Created By: Apostletech
Purpose: To call pardot prospect with out Adjuster record type Confirmation api call to get data and delete all non adjusrter records. 
Test class: PardotMockHttpResponseGeneratorTC 
***********************************************************************************************************/

Public Class PardotQueryProspectApi{
    
    @Future(callout=true)
    Public Static void queryProspectAPI(Integer offset){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(10000);
        req.setMethod('GET'); 
        String API_Key = PardotAPIAuthentication.PardotAPIAuthenticationCall();        
        String User_key = Label.Pardot_User_Key; 
        String url = 'https://pi.pardot.com/api/prospect/version/4/do/query?'+'api_key='+API_Key +'&user_key='+User_key+'&updated_after=yesterday'+'&offset='+offset;
        //String url = 'https://pi.pardot.com/api/prospect/version/4/do/query?'+'api_key='+API_Key +'&user_key='+User_key+'&offset='+offset;
        req.setEndpoint(url);        
        HttpResponse response = http.send(req);
                
        List<Prospect> prospectList = new List<Prospect>();
        list<String> ProspectFid = new List<String>();
        //list<String> DeleteProspectlist = new list<String>();
        //DeleteProspectlist.add('00370000023f5GbAAI');
        boolean isHaveRecords = false;
                
        if(response.getStatusCode() == 200){   
          
            Dom.Document docx = new Dom.Document();
            docx.load(response.getBody());
            dom.XmlNode xroot = docx.getrootelement();
            dom.XmlNode [] xrec = xroot.getchildelements();
            
            for(Dom.XMLNode child1 : xrec){
                
                dom.XmlNode [] xrecChild = child1.getchildelements();
                
                for(Dom.XMLNode child2 : xrecChild){
                    
                     dom.XmlNode [] xrecChild1 = child2.getchildelements();
                     
                     Prospect P = new Prospect();
                     
                     for(Dom.XMLNode awr : xrecChild1){
                         
                           if(awr.getname() == 'id') {
                                system.debug('Id' + awr.gettext());
                                P.Id = awr.gettext();
                                isHaveRecords = true;
                           } 
                           if(awr.getname() == 'first_name') {
                                system.debug('Id' + awr.gettext());
                                P.first_name = awr.gettext();
                           } 
                           if(awr.getname() == 'RecordType') {
                                system.debug('Id' + awr.gettext());
                                P.recordType = awr.gettext();
                           }
                           if(awr.getname() == 'Status') {
                                system.debug('Id' + awr.gettext());
                                P.status= awr.gettext();
                           }  
                           
                           if(awr.getname() == 'crm_contact_fid') {
                                system.debug('Id' + awr.gettext());
                                P.fid= awr.gettext();
                           }                                  
                     }
                     
                     if(P.Id != null && P.Id != '' && p.recordType != 'Adjuster' && p.recordType  != 'Landlord' && p.recordType  != '' && p.recordType  != null){
                         prospectList.add(P);
                         ProspectFid.add(p.Id);
                         //system.debug('@@@@@@'+prospectList.size());
                     }
                }
            
            }
            System.debug('Query REST response is :: '+response.getBody());
            System.debug(ProspectFid.size() +'@@@@@@@/// prospectList::'+ProspectFid);  
            
            if(!ProspectFid.isEmpty()){
                
                //Database.executeBatch(new PardotProspectDeleteBacth(ProspectFid), 20);            
                //Database.executeBatch(new PardotProspectDeleteBacth(DeleteProspectlist), 1);
                
                Datetime destTime = Datetime.now().addMinutes(1);       
                String year =  String.valueOf(destTime.year());   
                String month =  String.valueOf(destTime.month());
                String day =  String.valueOf(destTime.day());        
                String hour = String.valueOf(destTime.hour());
                String min = String.valueOf(destTime.minute()); 
                String ss = String.valueOf(destTime.second());
                String randomNumb = ''+ Math.random();
                String randomNumb1 = ''+ Math.random();
                
                //parse to cron expression
                String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+ day + ' ' +month+ ' ? '+year;
                PardotProspectDeleteBacthScheduler sNTVpre = new PardotProspectDeleteBacthScheduler(ProspectFid);                    
                System.schedule('Non adjuster prospects delete - '+offset+' '+ randomNumb + randomNumb1, nextFireTime, sNTVpre);
                
            }
        
            if(ProspectFid.isEmpty()){
                offset = offset + 200;        
            } 
        }
        
        // Scheduling after 3 minutes
        //*********************************************************************************************             
        if(offset < 50000 && isHaveRecords){
        
            Datetime destTime = Datetime.now().addMinutes(3);           
            String year =  String.valueOf(destTime.year());   
            String month =  String.valueOf(destTime.month());
            String day =  String.valueOf(destTime.day());        
            String hour = String.valueOf(destTime.hour());
            String min = String.valueOf(destTime.minute()); 
            String ss = String.valueOf(destTime.second());
            String randomNumb = ''+ Math.random();
            String randomNumb1 = ''+ Math.random();
            
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+ day + ' ' +month+ ' ? '+year;
            
            PardotQueryProspectApiScheduler sNTVpre = new PardotQueryProspectApiScheduler(offset);                    
            System.schedule('Non adjuster prospects query - '+offset+' '+ randomNumb + randomNumb1, nextFireTime, sNTVpre);
            //*********************************************************************************************   
        }
        
    }
    
    public Class Prospect{
        String Id;
        String first_name;
        String recordType;
        String Status;
        String fid;        
    }
}