@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountResource {
    
    /*global class InforAccount {
        
        global String string1;
        global String string2 { get; set; }
    }*/
    
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        return result;
    }
    
    @HttpPost 
    global static void doPost() {
        ApiResponse result = new ApiResponse();
        result.ResponseCode = -1;
        result.ResponseMessage = 'Failed';
        
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        
        string accountId=req.params.get('accountId');
        string accountName=req.params.get('accountName'); 
        string accountType=req.params.get('accountType');
        string parentAccountId=req.params.get('parentAccountId');
        string webURL=req.params.get('webURL');
        string phoneNumber=req.params.get('phoneNumber');
        string customerID=req.params.get('customerID');
        //string billingAddress=req.params.get('billingAddress');
        string billingStreet=req.params.get('billingStreet');
        string billingCity=req.params.get('billingCity');
        string billingStateProvince=req.params.get('billingStateProvince');
        string billingPostal=req.params.get('billingPostal');
        string billingCountry=req.params.get('billingCountry');
        
        if(accountId == null){
            result.ResponseMessage = 'Account Id is required';            
            resp.addHeader('Content-Type', 'application/json');
            resp.responseBody = Blob.valueOf(JSON.serialize(result));
            return;
        }
        Account acct;
        List<Account> accts  = [SELECT Id, Name, Type,ParentId, Website,Phone, Infor_Customer_ID__c, BillingAddress, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                BillingCountry, External_ID__c FROM Account WHERE External_ID__c = :accountId limit 1];
        
        if(accts.isEmpty())
        {
            if(accountName == null || parentAccountId == null){
                result.ResponseMessage = 'Account Name & Parent Account Id are required';            
                resp.addHeader('Content-Type', 'application/json');
                resp.responseBody = Blob.valueOf(JSON.serialize(result));
                return;
            }            
            acct = new Account();
            acct.Number_of_Homes__c = 'Unknown';
            acct.External_ID__c = accountId;
        }
        else
        {
            acct = accts[0];
        }
        
        acct.Name = accountName;
        if(accountType != null && string.isNotEmpty(accountType)){
            acct.Type = accountType;
        }
        if(parentAccountId != null && string.isNotEmpty(parentAccountId)){
            List<Account> pAccts  = [SELECT Id, Name, ParentId, External_ID__c FROM Account WHERE External_ID__c = :parentAccountId limit 1];
            if(pAccts.isEmpty())
            {
                result.ResponseMessage = 'Parent Account not found';            
                resp.addHeader('Content-Type', 'application/json');
                resp.responseBody = Blob.valueOf(JSON.serialize(result));
                return;
            }
            else
            {
                Account pAcct = pAccts[0];
                acct.ParentId = pAcct.Id;
            }
        }
        if(webURL != null && string.isNotEmpty(webURL)){
            acct.Website = webURL;
        }
        if(phoneNumber != null && string.isNotEmpty(phoneNumber)){
            acct.Phone = phoneNumber;
        }
        if(customerID != null && string.isNotEmpty(customerID)){
            acct.Infor_Customer_ID__c = customerID;
        }
        if(billingStreet != null && string.isNotEmpty(billingStreet)){
            acct.BillingStreet = billingStreet;
        }
        if(billingCity != null && string.isNotEmpty(billingCity)){
            acct.BillingCity = billingCity;
        }
        if(billingStateProvince != null && string.isNotEmpty(billingStateProvince)){
            acct.BillingState = billingStateProvince;
        }
        if(billingPostal != null && string.isNotEmpty(billingPostal)){
            acct.BillingPostalCode = billingPostal;
        }
        if(billingCountry != null && string.isNotEmpty(billingCountry)){
            acct.BillingCountry = billingCountry;
        }
        
        upsert acct;
        
        result.ResponseCode = 1;
        result.ResponseMessage = 'Successfully created/updated account record';
        
        resp.addHeader('Content-Type', 'application/json');
        resp.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
}