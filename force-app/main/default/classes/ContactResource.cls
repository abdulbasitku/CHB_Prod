@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactResource {
    
    /*@HttpGet
    global static Contact doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact result = [SELECT Id, Name, Phone,Email FROM Contact WHERE Id = :contactId];
        return result;
    }
    
    @HttpPost 
    global static void doPost() {
        ApiResponse result = new ApiResponse();
        result.ResponseCode = -1;
        result.ResponseMessage = 'Failed';
        
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        
        string contactId=req.params.get('contactId');
        string firstName=req.params.get('firstName'); 
        string lastName=req.params.get('lastName');        
        string accountId=req.params.get('accountId');
        string title=req.params.get('title');
        string email=req.params.get('email'); 
        string fax=req.params.get('fax');
        string phoneNumber=req.params.get('phoneNumber');
        string mobileNumber=req.params.get('mobileNumber');
        //string mailingAddress=req.params.get('mailingAddress');
        string mailingStreet=req.params.get('mailingStreet');
        string mailingCity=req.params.get('mailingCity');
        string mailingStateProvince=req.params.get('mailingStateProvince');
        string mailingPostal=req.params.get('mailingPostal');
        string mailingCountry=req.params.get('mailingCountry');
        
        if(contactId == null){
            result.ResponseMessage = 'Contact Id is required';            
            resp.addHeader('Content-Type', 'application/json');
            resp.responseBody = Blob.valueOf(JSON.serialize(result));
            return;
        }
        
        Contact contact;
        List<Contact> contacts  = [SELECT Id, FirstName, LastName,AccountId, Title, Email, Phone, MobilePhone, MailingAddress, MailingStreet, MailingCity, MailingState, MailingPostalCode,
                                   MailingCountry,External_ID__c FROM Contact WHERE External_ID__c = :contactId limit 1];
        
        if(contacts.isEmpty())
        {
            if(lastName == null || accountId == null || title == null){
                result.ResponseMessage = 'Last Name, Title and Account Id are required';            
                resp.addHeader('Content-Type', 'application/json');
                resp.responseBody = Blob.valueOf(JSON.serialize(result));
                return;
            }
            contact = new Contact();
            contact.External_ID__c = contactId;
        }
        else
        {
            contact = contacts[0];
        }
        
        contact.LastName = lastName;
        if(accountId != null && string.isNotEmpty(accountId)){
            List<Account> accts  = [SELECT Id, Name,External_ID__c FROM Account WHERE External_ID__c = :accountId limit 1];
            if(accts.isEmpty())
            {
                result.ResponseMessage = 'Related Account not found';            
                resp.addHeader('Content-Type', 'application/json');
                resp.responseBody = Blob.valueOf(JSON.serialize(result));
                return;
            }
            else
            {
                Account acct = accts[0];
                contact.AccountId = acct.Id;
            }
        }
        if(title != null && string.isNotEmpty(title)){
            contact.Title = title;
        }
        if(firstName != null && string.isNotEmpty(firstName)){
            contact.FirstName = firstName;
        }
        if(email != null && string.isNotEmpty(email)){
            contact.Email = email;
        }
        if(fax != null && string.isNotEmpty(fax)){
            contact.Fax = fax;
        }
        if(phoneNumber != null && string.isNotEmpty(phoneNumber)){
            contact.Phone = phoneNumber;
        }
        if(mobileNumber != null && string.isNotEmpty(mobileNumber)){
            contact.MobilePhone	 = mobileNumber;
        }
        if(mailingStreet != null && string.isNotEmpty(mailingStreet)){
            contact.mailingStreet = mailingStreet;
        }
        if(mailingCity != null && string.isNotEmpty(mailingCity)){
            contact.mailingCity = mailingCity;
        }
        if( mailingStateProvince != null && string.isNotEmpty(mailingStateProvince)){
            contact.mailingState = mailingStateProvince;
        }
        if(mailingPostal != null && string.isNotEmpty(mailingPostal)){
            contact.mailingPostalCode = mailingPostal;
        }
        if(mailingCountry != null && string.isNotEmpty(mailingCountry)){
            contact.mailingCountry = mailingCountry;
        }
        
        upsert contact;
        
        result.ResponseCode = 1;
        result.ResponseMessage = 'Successfully created/updated contact record';
        
        resp.addHeader('Content-Type', 'application/json');
        resp.responseBody = Blob.valueOf(JSON.serialize(result));
    }*/
    
}