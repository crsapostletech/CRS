/*TestClass For PardotAPIAuthentication,PardotProspectCustomIterable,PardotProspectDeleteBacth,PardotProspectDeleteBacthScheduler,PardotProspectDleteiterable,PardotQueryProspectApi,PardotQueryProspectApiScheduler*/

@isTest
global class PardotMockHttpResponseGeneratorTC implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        if(req.getEndpoint() == 'https://pi.pardot.com/api/login/version/4?email=label.Pardot_Email&password=label.Pardot_Password&user_key=label.Pardot_User_Key'){
            //res.setHeader('Content-Type', 'application/json');
            res.setBody('{<rsp stat="ok" version="1.0"><api_key>c05693e3b123046eeb23bc95d670f0f5</api_key><version>4</version></rsp>}');
            res.setStatusCode(200);
            return res;
            }
        else
            {
            //(req.getEndpoint() == 'https://pi.pardot.com/api/prospect/version/4/do/query?'+'api_key=c05693e3b123046eeb23bc95d670f0f5&user_key=22c9c69ca534deceffa5f51862da3d6c&created_after=yesterday')
            String resBody = '<?xml version="1.0" encoding="UTF-8"?>'+
             '<rsp stat="ok" version="1.0">'+
             '<result>'+
             '<total_results>11161</total_results>'+
             '<prospect>'+
             '<id>40308</id>'+
             '<campaign_id>250</campaign_id>'+
             '<salutation/>'+
             '<first_name>Don</first_name>'+
             '<last_name>Chubb</last_name>'+
             '<email>donald.chubb@erieinsurance.com</email>'+
             '<password/>'+
             '<company>Erie Insurance</company>'+
             '<website/>'+
             '<job_title>Property Specialist</job_title>'+
             '<department/>'+
             '<country>USA</country>'+
             '<address_one>4901 Louise Drive</address_one>'+
             '<address_two></address_two>'+
             '<city>Mechanicsburg</city>'+
             '<state>PA</state>'+
             '<territory/>'+
             '<zip>17055</zip>'+
             '<phone>(717) 764-0330</phone>'+
             '<fax>(717) 795-2315</fax>'+
             '<source/>'+
             '<annual_revenue/>'+
             '<employees/>'+
             '<industry/>'+
             '<years_in_business/>'+
             '<comments/>'+
             '<notes/>'+
             '<score>0</score>'+
             '<grade/>'+
             '<last_activity_at/>'+
             '<recent_interaction>Never active</recent_interaction>'+
             '<crm_lead_fid/>'+
             '<crm_contact_fid>0037000000YiV1PAAV</crm_contact_fid>'+
             '<crm_owner_fid>00570000003VkNvAAK</crm_owner_fid>'+
             '<crm_account_fid/>'+
             '<salesforce_fid>0037000000YiV1PAAV</salesforce_fid>'+
             '<crm_last_sync>2016-11-23 03:58:46</crm_last_sync>'+
             '<crm_url>https://na5.salesforce.com/0037000000YiV1PAAV</crm_url>'+
             '<is_do_not_email></is_do_not_email>'+
             '<is_do_not_call></is_do_not_call>'+
             '<opted_out></opted_out>'+
             '<is_reviewed>1</is_reviewed>'+
             '<is_starred></is_starred>'+
             '<created_at>2016-11-23 03:45:04</created_at>'+
             '<updated_at>2017-05-11 02:29:26</updated_at>'+
         '<campaign>'+
            '<id>250</id>'+
            '<name>Active Adjusters Campaign</name>'+
         '</campaign>'+
         '<assigned_to>'+
            '<user>'+
               '<id>9885241</id>'+
               '<email>nbeno@crsth.com</email>'+
               '<first_name>Nancie</first_name>'+
               '<last_name>Beno</last_name>'+
               '<job_title>Relationship Manager</job_title>'+
               '<role>Sales</role>'+
               '<account>274362</account>'+
               '<created_at>2017-06-08 07:38:16</created_at>'+
               '<updated_at>2017-06-10 17:46:42</updated_at>'+
            '</user>'+
         '</assigned_to>'+
             '<Collateral_Not_Accepted_by_Contact>false</Collateral_Not_Accepted_by_Contact>'+
             '<Do_Not_Call_Contact>false</Do_Not_Call_Contact>'+
             '<Do_Not_Email_Contact>false</Do_Not_Email_Contact>'+
             '<Do_Not_Mail_Contact>false</Do_Not_Mail_Contact>'+
             '<Food_Not_Accepted_by_Contact>false</Food_Not_Accepted_by_Contact>'+
             '<Gifts_Not_Accepted_by_Contact>false</Gifts_Not_Accepted_by_Contact>'+
             '<Last_Deal1>Yes</Last_Deal1>'+
             '<Other_City>Mechanicsburg</Other_City>'+
             '<Other_State>PA</Other_State>'+
             '<Other_Street>4901 Louise Drive</Other_Street>'+
             '<Other_Zip>17055</Other_Zip>'+
             '<RecordType>Policyholder</RecordType>'+
             '<Status>Active</Status>'+
             '<Type>Company</Type>'+
            '<Type_of_Claim_Handled>HomeOwners</Type_of_Claim_Handled>'+
            '<prospect_account_id>8692</prospect_account_id>'+
            '</prospect>'+
            '</result>'+
            '</rsp>';
            res.setBody(resBody);
            res.setStatusCode(200);
            return res;
        }
    }
}