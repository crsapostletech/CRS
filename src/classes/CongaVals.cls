public class CongaVals {

// set org type Production or Sandbox
public Boolean isProductionOrg;
  
    public CongaVals() 
    {
        if (UserInfo.getOrganizationId() == '00D70000000JTmAEAW')
        {   
            isProductionOrg = true;
        }
        else
        {
            isProductionOrg = false;    
        }
    }
  
    // cv.hSATemplateId | CRS HSA (PH)
    public string getHSATemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m49';
        }
        else
        {
            return 'a0C700000078m49';
        }
    }   

    // cv.hotelAuthTemplateId | CRS CC Auth (Hotel)
    public string gethotelAuthTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m2I';
        }
        else
        {
            return 'a0C700000078m2I';
        }
    }

    // cv.hotelAllstateAuthTemplateId | CRS CC Auth (Hotel--Allstate)
    public string gethotelAllstateAuthTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m3B';
        }
        else
        {
            return 'a0C700000078m3B';
        }
    }
    
    // cv.hSAQuery1 | Hotel Authorization - Service Request - PH and Hotel Account
    public string getHSAQuery1() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinP';
        }
        else
        {
            return 'a0D70000004TinP';
        }
    }
    
    // cv.hotelAuthQuery1 | Hotel Authorization - Service Request - PH and Hotel Account    
    public string getHotelAuthQuery1() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinP';
        }
        else
        {
            return 'a0D70000004TinP';
        }
    }
    
    // cv.hotelAuthQuery2 | Hotel Authorization - Service Request - Hotel Room  
    public string getHotelAuthQuery2() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinK';
        }
        else
        {
            return 'a0D70000004TinK';
        }
    }

    // cv.hotelAuthQuery3 | Hotel Authorization - Service Request - One Time Fees - Other   
    public string getHotelAuthQuery3() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinF';
        }
        else
        {
            return 'a0D70000004TinF';
        }
    }
    
    // cv.hotelAuthQuery4 | Hotel Authorization - Service Request - One Time Fees - Parking         
    public string getHotelAuthQuery4() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinU';
        }
        else
        {
            return 'a0D70000004TinU';
        }
    }
    
    // cv.hotelAuthQuery5 |Hotel Authorization - Service Request - One Time Fees - Pet      
    public string getHotelAuthQuery5() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000004TinZ';
        }
        else
        {
            return 'a0D70000004TinZ';
        }
    }
    
    // cv.hotelAuthQuery6 | Check Out Folio Request     
    public string getHotelAuthQuery6() 
    {
        if (isProductionOrg)
        {   
            return 'a0D70000006a3Oy';
        }
        else
        {
            return 'a0D70000006a3Oy';
        }
    }
    
    // cv.CRSHotelConfirmationAdjusterTemplateId | CRS Hotel Confirmation (Adjuster)
    public string getCRSHotelConfirmationAdjusterTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m4n';
        }
        else
        {
            return 'a0C700000078m4n';
        }
    }
            
    //cv.CRSCCAuthTemplateId | CRS HSA w/CC Auth (PH)
    public string getCRSCCAuthTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078pnC';
        }
        else
        {
            return 'a0C700000078pnC';
        }
    }
    
    //cv.CRSDirectBillExtAuthTemplateId | CRS Direct Bill Ext. Auth. (Hotel)
    public string getCRSDirectBillExtAuthTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m3f';
        }
        else
        {
            return 'a0C700000078m3f';
        }   
    }
        
    //cv.CRSCOFolioRequesthotelTemplateId | CRS CO/Folio Request
    public string getCRSCOFolioRequesthotelTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m11';
        }
        else
        {
            return 'a0C700000078m11';
        }   
    }

    //cv.VisaCardwithIDTemplateId | Visa Card with ID
    public string getVisaCardwithIDTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m57';
        }
        else
        {
            return 'a0C700000078m57';
        }   
    }
    
    //cv.MastercardwithIDTemplateId | Mastercard with ID
    public string getMastercardwithIDTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C7000000Ctnba';
        }
        else
        {
            return 'a0C7000000Ctnba';
        }   
    }
    
    //cv.ChaseVisawithIDTemplateId | Chase Visa with ID
    public string getChaseVisawithIDTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C7000000FOL4v';
        }
        else
        {
            return 'a0CQ000000FhG1E';
        }   
    }
    
    //cv.AmexEditableAuthTemplateId | Amex Editable Auth (Hotel)
    public string getAmexEditableAuthTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C700000078m3u';
        }
        else
        {
            return 'a0C700000078m3u';
        }   
    }
    
    //cv.AdjusterHousingAgreementTemplateId | Adjuster Housing Agreement - Visual Force
    public string getAdjusterHousingAgreementTemplateId() 
    {
        if (isProductionOrg)
        {   
            return 'a0C70000008vEnl';
        }
        else
        {
            return 'a0C70000008vEnl';
        }   
    }
}