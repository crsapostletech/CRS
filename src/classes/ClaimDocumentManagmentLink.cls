public with sharing class ClaimDocumentManagmentLink 
{
	String instanceName = Util.getInstanceName();

	public Opportunity claim { get; set; }

	public ClaimDocumentManagmentLink(ApexPages.StandardController controller) 
	{
		claim = (Opportunity)controller.getRecord();	
		
	}

	public String getInstanceName()
    {
    	return instanceName;   
    }

	public string getDocumentHash()
    {
        datetime currentDateTime = system.now();
        string orgId = UserInfo.getOrganizationId();
        string userId = UserInfo.getUserId();
        string currentDT = currentDateTime.format('yyyyMMddHHmmss');
        string hashSalt = '4$+O*gva-leG,^lDs9/m-f=s_x]}%)-z'; 
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(orgId + '-' + userId + '-' + hashSalt + '-' + currentDT));     
        String hexDigest = EncodingUtil.convertToHex(hash);
        string url = orgId + '&UserId=' + userId + '&Date=' + currentDT + '&Hash=' + hexDigest + '#!/documents';
        
        return url;
	}	
}