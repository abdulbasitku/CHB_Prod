public class UpdateDataFromInfor {
    
    public void UpdateInforAccountsData(List<InforAccount> inforAccounts, Map<string,Account> allAccountsMapWithExternalId, Set<string> ignoreInforList){
        
        system.debug('Method --> UpdateInforAccountsData --> Start');
        
        system.debug('Method --> UpdateInforAccountsData --> Accounts to update = ' + String.valueOf(inforAccounts.size()));
        
        system.debug('Method --> UpdateInforAccountsData --> SF with EID Accounts = ' + String.valueOf(allAccountsMapWithExternalId.size()));
        
        system.debug('Method --> UpdateInforAccountsData --> IgnoreList = ' + String.valueOf(ignoreInforList.size()));
        
        ResultObject result = new ResultObject();
        result.STATUS = ResultObject.StatusCode.SUCCESS;
        
        try
        {            
            Set<Account> acctsToUpdate = new Set<Account> ();
            //integer i = 200;
            for(InforAccount inforAccount : inforAccounts){
                //i = i + 1 ;              
                //string accountId= String.valueOf(inforAccount.accountId) + String.valueOf(i);
                string accountId= String.valueOf(inforAccount.accountId);
                string accountName=inforAccount.accountName; 
                string accountType=inforAccount.accountType;
                string parentAccountId=inforAccount.parentAccountId;
                string webURL=inforAccount.webURL;
                string phoneNumber=inforAccount.phoneNumber;
                string customerID=inforAccount.customerId;
                string billingStreet=inforAccount.billingAddress;
                string billingCity=inforAccount.billingCity;
                string billingStateProvince=inforAccount.billingStateProvince;
                string billingPostal=inforAccount.billingPostal;
                string billingCountry=inforAccount.billingCountry;
                String status = inforAccount.status;
                String clientCode = inforAccount.clientCode;
                String statusAndType = inforAccount.statusAndType;
                String mappedType = inforAccount.mappedType;
                
                if(accountId == null || accountName == null || ignoreInforList.contains(accountId)){
                    continue;
                }
                
                Account acct = new Account();
                
                if(allAccountsMapWithExternalId.containsKey(accountId))
                {
                    acct = allAccountsMapWithExternalId.get(accountId);
                }
                
                if(string.isEmpty(acct.Number_of_Homes__c))
                {
                    acct.Number_of_Homes__c = 'Unknown';
                }
                
                if(string.isEmpty(acct.External_ID__c))
                {
                    acct.External_ID__c = accountId;
                }
                
                if(accountName != null && string.isNotEmpty(accountName) && string.isEmpty(acct.Name)){
                    acct.Name = accountName;
                }
                
                /*if(accountType != null && string.isNotEmpty(accountType)){
acct.Type = accountType;
}*/
                
                if(parentAccountId != null && string.isNotEmpty(parentAccountId) && string.isEmpty(acct.ParentId)){
                    
                    if(allAccountsMapWithExternalId.containsKey(parentAccountId))
                    {
                        Account parentAccount = allAccountsMapWithExternalId.get(parentAccountId);
                        acct.ParentId = parentAccount.Id;                    
                    }                    
                }
                
                if(webURL != null && string.isNotEmpty(webURL) && string.isEmpty(acct.Website)){
                    acct.Website = webURL;
                }
                
                if(phoneNumber != null && string.isNotEmpty(phoneNumber) && string.isEmpty(acct.Phone)){
                    acct.Phone = phoneNumber;
                }
                
                if(customerID != null && string.isNotEmpty(customerID) && string.isEmpty(acct.Infor_Customer_ID__c)){
                    acct.Infor_Customer_ID__c = customerID;
                }
                
                if(billingStreet != null && string.isNotEmpty(billingStreet)){
                    acct.BillingStreet = billingStreet;
                }
                
                if(billingCity != null && string.isNotEmpty(billingCity) /*&& string.isEmpty(acct.BillingCity)*/){
                    acct.BillingCity = billingCity;
                }
                
                if(billingStateProvince != null && string.isNotEmpty(billingStateProvince) /*&& string.isEmpty(acct.BillingState)*/){
                    acct.BillingState = billingStateProvince;
                }
                
                if(billingPostal != null && string.isNotEmpty(billingPostal) /*&& string.isEmpty(acct.BillingPostalCode)*/){
                    acct.BillingPostalCode = billingPostal;
                }
                
                if(billingCountry != null && string.isNotEmpty(billingCountry) /*&& string.isEmpty(acct.BillingCountry)*/){
                    acct.BillingCountry = billingCountry;
                }
                
                if(clientCode != null && string.isNotEmpty(clientCode) && string.isEmpty(acct.GP_Code__c)){
                    acct.GP_Code__c = clientCode;
                }
                
                if(mappedType != null && string.isNotEmpty(mappedType)){
                    //string acctType = GetAccountTypeMapValue(statusAndType);
                    //if(acctType != null && string.isNotEmpty(acctType)){
                    acct.Type = mappedType;
                    //}
                }
                
                system.debug('Method --> UpdateInforAccountsData --> Item Added In List= ' + accountId + ' - ' + accountName);
                acctsToUpdate.Add(acct);
            }
            
            try
            {
                system.debug('Method --> UpdateInforAccountsData --> Starting Upsert On List Size= ' + String.valueOf(acctsToUpdate.size()));
                
                Schema.SObjectField field = Account.Fields.External_ID__c;
                Database.UpsertResult[] upsertResult = Database.upsert(new List<Account>(acctsToUpdate), field, false);
                
                system.debug('Method --> UpdateInforAccountsData --> Insert Result = ' + String.valueOf(upsertResult.size()));
            }
            catch (DMLException e) 
            {
                system.debug('Method --> UpdateInforAccountsData --> DML Exception Occured');
                system.debug(e); 
            }
        }
        catch (Exception e) 
        {
            system.debug('Method --> UpdateInforAccountsData --> Exception Occured');
            system.debug(e); 
        }
        
        system.debug('Method --> UpdateInforAccountsData --> End');
    }
    
    public void UpdateInforContactsData(List<InforContact> inforContacts, Map<string,Account> allAccountsMap, Map<string,Contact> allContactsMap, Map<string,Contact> allContactsMapWithEId){
        
        system.debug('Method --> UpdateInforContactsData --> Start');
        
        system.debug('Method --> UpdateInforContactsData --> Contacts to update = ' + String.valueOf(inforContacts.size()));
        
        system.debug('Method --> UpdateInforContactsData --> Related Accounts = ' + String.valueOf(allAccountsMap.size()));
        
        system.debug('Method --> UpdateInforContactsData --> Contacts Maps = ' + String.valueOf(allContactsMap.size()));
        
        system.debug('Method --> UpdateInforContactsData --> Contacts Maps EID = ' + String.valueOf(allContactsMapWithEId.size()));
        
        ResultObject result = new ResultObject();
        result.STATUS = ResultObject.StatusCode.SUCCESS;
        Map<string, Id> allUpsertedContactMap = new Map<string, Id>();
        try
        {
            List<Contact> contactsToUpdate = new List<Contact> ();
            List<Contact> contactsToUpdateOnly = new List<Contact> ();
            List<NpsScore__c> npsScores = new List<NpsScore__c>();
            
            //Integer i = 200;
            for(InforContact inforContact : inforContacts){
                //i = i + 1 ;
                Contact contact = new Contact();
                
                //string contactId=inforContact.contactId + String.valueOf(i);
                string contactId=inforContact.contactId;
                string firstName=inforContact.firstName; 
                string lastName=inforContact.lastName;        
                string accountId=inforContact.accountId;
                string title=inforContact.title;
                string email=inforContact.email; 
                string fax=inforContact.fax;
                string phoneNumber=inforContact.phoneNumber;
                string mobileNumber=inforContact.mobileNumber;
                //string mailingAddress=req.params.get('mailingAddress');
                string mailingStreet=inforContact.mailingStreet;
                string mailingCity=inforContact.mailingCity;
                string mailingStateProvince=inforContact.mailingStateProvince;
                string mailingPostal=inforContact.mailingPostal;
                string mailingCountry=inforContact.mailingCountry;
                string emailOptOutComb = inforContact.emailOptOutComb;
                boolean doNotEmail = inforContact.doNotEmail;
                string status = inforContact.status;
                boolean isPrimary = inforContact.isPrimary;
                boolean noLongerThere = inforContact.noLongerThere;
                
                if(contactId == null || lastName == null || accountId == null || title == null){
                    Continue;
                }
                
                if(allContactsMapWithEId.containsKey(contactId))
                {
                    contact = allContactsMapWithEId.get(contactId);
                    //system.debug('Method --> UpdateInforContactsData --> Contact EID = ' + contactId + ' - ' + firstName );
                }
                else
                {
                    if(allContactsMap.containsKey(firstName + '|' + lastName + '|' + email))
                    {                  
                        contact = allContactsMap.get(firstName + '|' + lastName + '|' + email);
                        //system.debug('Method --> UpdateInforContactsData --> Contact without EID = ' + contactId + ' - ' + firstName );
                    }
                }
                
                if(string.isEmpty(contact.External_ID__c))
                {
                    contact.External_ID__c = contactId;
                    //system.debug('Method --> UpdateInforContactsData --> EID is empty on SF = ' + contactId + ' - ' + firstName );
                }
                
                if(string.isEmpty(contact.Business_Function__c))
                {
                    contact.Business_Function__c = 'Other';
                }
                
                if(string.isEmpty(contact.LastName))
                {
                    contact.LastName = lastName;
                }
                
                if(accountId != null && string.isNotEmpty(accountId)){
                    
                    if(allAccountsMap.containsKey(accountId))
                    {
                        Account account = allAccountsMap.get(accountId);
                        contact.AccountId = account.Id;                    
                    }                    
                }
                
                if(title != null && string.isNotEmpty(title) /*&& string.isEmpty(contact.Title)*/){
                    contact.Title = title;
                }
                if(firstName != null && string.isNotEmpty(firstName) && string.isEmpty(contact.FirstName)){
                    contact.FirstName = firstName;
                }
                if(email != null && string.isNotEmpty(email) /*&& string.isEmpty(contact.Email)*/){
                    contact.Email = email;
                }
                if(fax != null && string.isNotEmpty(fax) && string.isEmpty(contact.Fax)){
                    contact.Fax = fax;
                }
                if(phoneNumber != null && string.isNotEmpty(phoneNumber) /*&& string.isEmpty(contact.Phone)*/){
                    contact.Phone = phoneNumber;
                }
                if(mobileNumber != null && string.isNotEmpty(mobileNumber) /*&& string.isEmpty(contact.MobilePhone)*/){
                    contact.MobilePhone	 = mobileNumber;
                }
                if(mailingStreet != null && string.isNotEmpty(mailingStreet) && string.isEmpty(contact.MailingStreet)){
                    contact.MailingStreet = mailingStreet;
                }
                if(mailingCity != null && string.isNotEmpty(mailingCity) && string.isEmpty(contact.MailingCity)){
                    contact.MailingCity = mailingCity;
                }
                if( mailingStateProvince != null && string.isNotEmpty(mailingStateProvince) && string.isEmpty(contact.MailingState)){
                    contact.MailingState = mailingStateProvince;
                }
                if(mailingPostal != null && string.isNotEmpty(mailingPostal) && string.isEmpty(contact.MailingPostalCode)){
                    contact.MailingPostalCode = mailingPostal;
                }
                if(mailingCountry != null && string.isNotEmpty(mailingCountry) && string.isEmpty(contact.MailingCountry)){
                    contact.MailingCountry = mailingCountry;
                }
                
                if(isPrimary){
                    contact.Primary_Contact__c = isPrimary;
                }
                
                if(noLongerThere){
                    contact.No_Longer_There__c = noLongerThere;
                }
                
                if(!contact.HasOptedOutOfEmail){
                    if(doNotEmail)
                    {
                        contact.HasOptedOutOfEmail = doNotEmail;
                    }
                    else
                    {
                        if(status != null && string.isNotEmpty(status)){
                            contact.HasOptedOutOfEmail = GetContactEmailOptOutMapValueByStatus(status, emailOptOutComb);
                        }
                    }
                }
                
                if(allContactsMap.containsKey(firstName + '|' + lastName + '|' + email))
                {
                    contactsToUpdateOnly.Add(contact);
                }
                else
                {
                    contactsToUpdate.Add(contact);
                }
                
                //Write NPS Scores
                for(InforNpsScore inforNpsScore : inforContact.inforNpsScores)
                {
                    //make list
                    
                    NpsScore__c npsScore = new NpsScore__c();
                    npsScore.Infor_NPS_Id__c = inforNpsScore.npsId;
                    npsScore.Date__c = DateTime.parse(inforNpsScore.npsDate);
                    npsScore.Infor_Contact_Id__c = inforNpsScore.contactId;
                    npsScore.Reference__c = inforNpsScore.reference;
                    npsScore.Score__c = double.valueOf(inforNpsScore.score);
                    npsScore.Source__c = inforNpsScore.source;
                                        
                    npsScores.add(npsScore);
                }
            }
            
            try
            {
                system.debug('Method --> UpdateInforContactsData --> Starting Upsert On List Size= ' + String.valueOf(contactsToUpdate.size()));
                
                Schema.SObjectField field = Contact.Fields.External_ID__c;
                Database.UpsertResult[] upsertResult = Database.upsert(contactsToUpdate, field, false);
                
                system.debug('Method --> UpdateInforContactsData --> Insert Result = ' + String.valueOf(upsertResult.size()));
                
                for(Integer index = 0, size = upsertResult.size(); index < size; index++) 
                {
                    if(upsertResult[index].isSuccess())
                    {
                        Database.UpsertResult ur = upsertResult[index];
                        contact ct = contactsToUpdate[index];
                        allUpsertedContactMap.put(ct.External_Id__c, ur.getId());
                        /*if(upsertResult[index].isCreated()) 
                        {
                            
                            System.debug(contactsToUpdate[index].External_Id__c +' was created');
                        }
                        else 
                        {
                            System.debug(contactsToUpdate[index].External_Id__c +' was updated');
                        }*/
                    }
                    else
                    {
                        //System.debug(upsertResult[index].getErrors() + ' - Error');
                    }
                }
                
                system.debug('Method --> UpdateInforContactsData --> Starting Update On List Size= ' + String.valueOf(contactsToUpdateOnly.size()));
                
                Database.SaveResult[]  updateResult = Database.update(contactsToUpdateOnly, false);
                
                system.debug('Method --> UpdateInforContactsData --> Update Result = ' + String.valueOf(updateResult.size()));
                
                for(Integer index = 0, size = updateResult.size(); index < size; index++) 
                {
                    if(updateResult[index].isSuccess())
                    {
                        Database.SaveResult upR = updateResult[index];
                        contact ct = contactsToUpdateOnly[index];
                        allUpsertedContactMap.put(ct.External_Id__c, upR.getId());                       
                    }
                    else
                    {
                        System.debug(updateResult[index].getErrors() + ' - Error');
                    }
                }
                
                for(NpsScore__c npsScore : npsScores)
                {
                    //add contact id using infor contact id
                    npsScore.Contact__c = allUpsertedContactMap.get(npsScore.Infor_Contact_Id__c);
                }
                
                Schema.SObjectField npsExternalField = NpsScore__c.Fields.Infor_NPS_Id__c;
                Database.UpsertResult[] npsUpsertResult = Database.upsert(npsScores, npsExternalField, false);
                
                system.debug('Method --> UpdateInforContactsData --> Upsert NPS Result = ' + String.valueOf(npsUpsertResult.size()));
                
            }
            catch (DMLException e) 
            {
                system.debug('Method --> UpdateInforContactsData --> DML Exception Occured');
                system.debug(e); 
            }
        }
        catch (Exception e) 
        {
            system.debug('Method --> UpdateInforContactsData --> Exception Occured');
            system.debug(e); 
        }
        
        system.debug('Method --> UpdateInforContactsData --> End');
    }
    
    public void UpdateInforProductsData(List<InforProduct> inforProducts, Map<string,Product2> allProductsMap){
        system.debug('Method --> UpdateInforProductsData --> Start');
        
        system.debug('Method --> UpdateInforProductsData --> Products to update = ' + String.valueOf(inforProducts.size()));
        
        ResultObject result = new ResultObject();
        result.STATUS = ResultObject.StatusCode.SUCCESS;
        
        try
        {
            List<Product2> productsToUpdate = new List<Product2> ();
            //Integer i =200;
            for(InforProduct inforProduct : inforProducts){
                
                Product2 product = new Product2();
                string productId=inforProduct.productId;
                
                if(allProductsMap.containsKey(productId))
                {
                    product = allProductsMap.get(productId);
                }
                
                string productName=inforProduct.productName;                
                boolean isActive = inforProduct.isActive;
                
                if(productId == null || productName == null){
                    Continue;
                }
                
                if(productName != null && string.isNotEmpty(productName) && string.isEmpty(product.Name)){
                    product.Name = productName;
                }
                if(productId != null && string.isNotEmpty(productId) && string.isEmpty(product.External_ID__c)){
                    product.External_ID__c = productId;
                }
                product.IsActive = isActive;
                
                productsToUpdate.Add(product);                
            }
            
            try
            {
                system.debug('Method --> UpdateInforProductsData --> Starting Upsert On List Size= ' + String.valueOf(productsToUpdate.size()));
                
                Schema.SObjectField field = Product2.Fields.External_ID__c;
                Database.UpsertResult[] upsertResult = Database.upsert(productsToUpdate, field, false);
                
                system.debug('Method --> UpdateInforProductsData --> Insert Result = ' + String.valueOf(upsertResult.size()));
            }
            catch (DMLException e) 
            {
                system.debug('Method --> UpdateInforProductsData --> DML Exception Occured');
                system.debug(e); 
            }
        }
        catch (Exception e) 
        {
            system.debug('Method --> UpdateInforProductsData --> Exception Occured');
            system.debug(e); 
        }
        
        system.debug('Method --> UpdateInforProductsData --> End');
    }
    
    public void UpdateInforAccountProductsData(List<InforAccountProduct> inforAccountProducts, Map<string,Account> allAccountsMap, Map<string,Product2> allProductsMap, Map<string,Account_Product__c> allAccountProductMaps){
        
        system.debug('Method --> UpdateInforAccountProductsData --> Start');
        
        system.debug('Method --> UpdateInforAccountProductsData --> [Account - Products] to update = ' + String.valueOf(inforAccountProducts.size()));
        
        ResultObject result = new ResultObject();
        result.STATUS = ResultObject.StatusCode.SUCCESS;
        
        try
        {
            List<Account_Product__c> accountProductsToUpdate = new List<Account_Product__c> ();
            //Integer i =200;
            for(InforAccountProduct inforAccountProduct : inforAccountProducts){
                
                Account_Product__c accountProduct = new Account_Product__c();
                //i=i+1;
                //string productId = inforAccountProduct.ProductId + String.valueOf(i);
                //string accountId = inforAccountProduct.AccountId + String.valueOf(i);
                string productId = inforAccountProduct.ProductId;
                string accountId = inforAccountProduct.AccountId;
                
                string accountProductId = inforAccountProduct.accountProductId;                
                Decimal quantity = inforAccountProduct.Quantity;
                
                if(productId == null || accountId == null){
                    Continue;
                }
                
                Boolean accountExistSF = allAccountsMap.containsKey(accountId);
                Boolean productExistSF = allProductsMap.containsKey(productId);
                
                if(accountExistSF && productExistSF){
                    if(!allAccountProductMaps.containsKey(accountProductId))
                    {
                        
                        accountProduct.Account__c = allAccountsMap.get(accountId).Id; 
                        
                        accountProduct.Product__c = allProductsMap.get(productId).Id; 
                        
                        accountProduct.Quantity__c = quantity;
                        
                        accountProduct.External_ID_Infor__c = accountProductId; 
                        
                        accountProductsToUpdate.Add(accountProduct); 
                    }
                    else
                    {
                        system.debug('Method --> UpdateInforAccountProductsData --> AccountProduct already Exists = ' + allAccountsMap.get(accountId).Name + ' - ' + allProductsMap.get(productId).Name);                        
                    }
                }
                else
                {
                    if(!accountExistSF)
                    {
                        system.debug('Method --> UpdateInforAccountProductsData --> Account Id = ' + accountId + ' - Not Available in SF');
                    }
                    if(!productExistSF)
                    {
                        system.debug('Method --> UpdateInforAccountProductsData --> Product Id = ' + productId + ' - Not Available in SF');
                    }
                }
            }
            
            try
            {
                system.debug('Method --> UpdateInforAccountProductsData --> Starting Upsert On List Size= ' + String.valueOf(accountProductsToUpdate.size()));
                
                Schema.SObjectField field = Account_Product__C.Fields.External_ID_Infor__c;
                Database.UpsertResult[] upsertResult = Database.upsert(accountProductsToUpdate, field, false);
                
                system.debug('Method --> UpdateInforAccountProductsData --> Insert Result = ' + String.valueOf(upsertResult.size()));
            }
            catch (DMLException e) 
            {
                system.debug('Method --> UpdateInforAccountProductsData --> DML Exception Occured');
                system.debug(e); 
            }
        }
        catch (Exception e) 
        {
            system.debug('Method --> UpdateInforAccountProductsData --> Exception Occured');
            system.debug(e); 
        }
        
        system.debug('Method --> UpdateInforAccountProductsData --> End');
    }
    
    private string GetAccountTypeMapValue(string statusAndType){
        string accountType='';
        if(statusAndType == 'Active--Customer' || statusAndType == 'No Helpdesk--Customer' || statusAndType == 'ON HOLD--Customer' 
           || statusAndType == 'Pending Termination--Customer')
        {
            accountType = 'Customer';
        }    
        
        if(statusAndType == 'A Prospect--Former B360 Client' || statusAndType == 'Acquired--Former 1440 Client' || statusAndType == 'Acquired--Former BSFT Client'
           || statusAndType == 'Acquired--Former Customer' || statusAndType == 'Acquired--Former HomeDev Client' || statusAndType == 'Acquired--Former Newstar Client'
           || statusAndType == 'Active--Former 1440 Client' || statusAndType == 'Active--Former BSFT Client' || statusAndType == 'Active--Former BT Client'
           || statusAndType == 'Active--Former Customer' || statusAndType == 'Active--Former FAST Client' || statusAndType == 'Active--Former HomeDev Client'
           || statusAndType == 'Active--Former Newstar Client' || statusAndType == 'Archive--Former' || statusAndType == 'Customer'
           || statusAndType == 'Archive License--Former Customer' || statusAndType == 'Bankrupt--Former 1440 Client' || statusAndType == 'Bankrupt--Former B360 Client'
           || statusAndType == 'Bankrupt--Former BSFT Client' || statusAndType == 'Bankrupt--Former BT Client' || statusAndType == 'Bankrupt--Former CRM Client'
           || statusAndType == 'Bankrupt--Former Customer' || statusAndType == 'Bankrupt--Former FAST Client' || statusAndType == 'Bankrupt--Former Newstar Client'
           || statusAndType == 'Cancelled--Former BT Client' || statusAndType == 'Closed--Former Customer' || statusAndType == 'Ex-Customer--Former Newstar Client'
           || statusAndType == 'Fair--Former BSFT Client' || statusAndType == 'Former CRM Client--Former CRM Client' || statusAndType == 'Green--Former BT Client'
           || statusAndType == 'Inactive--Customer' || statusAndType == 'Inactive--Former 1440 Client' || statusAndType == 'Inactive--Former B360 Client'
           || statusAndType == 'Inactive--Former Blend Client' || statusAndType == 'Inactive--Former BSFT Client' || statusAndType == 'Inactive--Former BT Client'
           || statusAndType == 'Inactive--Former CRM Client' || statusAndType == 'Inactive--Former Customer' || statusAndType == 'Inactive--Former FAST Client'
           || statusAndType == 'Inactive--Former HomeDev Client' || statusAndType == 'Inactive--Former Newstar Client' || statusAndType == 'Merged--Former BSFT Client'
           || statusAndType == 'Merged--Former BT Client' || statusAndType == 'Merged--Former CRM Client' || statusAndType == 'Merged--Former Newstar Client'
           || statusAndType == 'No Helpdesk--Former Customer' || statusAndType == '--Former BSFT Client' || statusAndType == 'ON HOLD--Former 1440 Client'
           || statusAndType == 'ON HOLD--Former B360 Client' || statusAndType == 'ON HOLD--Former BSFT Client' || statusAndType == 'ON HOLD--Former BT Client'
           || statusAndType == 'ON HOLD--Former Customer' || statusAndType == 'ON HOLD--Former FAST Client' || statusAndType == 'ON HOLD--Former HomeDev Client'
           || statusAndType == 'Pending Termination--Former Customer' || statusAndType == 'Pending Termination--Former HomeDev Client'
           || statusAndType == 'Terminated--Acquistion' || statusAndType == 'Terminated--Customer' || statusAndType == 'Terminated--Former 1440 Client'
           || statusAndType == 'Terminated--Former B360 Client' || statusAndType == 'Terminated--Former BSFT Client' || statusAndType == 'Terminated--Former BT Client'
           || statusAndType == 'Terminated--Former CRM Client' || statusAndType == 'Terminated--Former Customer' || statusAndType == 'Terminated--Former FAST Client'
           || statusAndType == 'Terminated--Former HomeDev Client' || statusAndType == 'Terminated--Former NE Client' || statusAndType == 'Terminated--Former Newstar Client')
        {            
            accountType = 'Former Customer';
        } 
        if(statusAndType == 'Active--Lead' || statusAndType == '--Lead')
        {
            accountType = 'Prospect';
        }  
        return accountType;
    }
    
    private boolean GetContactEmailOptOutMapValueByStatus(string status, string emailOptOutComb)
    {
        boolean hasEmailOptOut = false;
        if(status == 'Deceased' || status =='DELETE' || status =='Inactive' || status =='Duplicate' || status =='No Longer There' || status =='Purge' || status =='Retired' || status =='To Be Deleted')
        {
            hasEmailOptOut = true;
        }
        
        if(!hasEmailOptOut)
        {
            if(emailOptOutComb == 'true--false--false' || emailOptOutComb =='true--true--false' || emailOptOutComb =='true--false--true' || emailOptOutComb =='false--true--true' || emailOptOutComb =='true--true--true' || emailOptOutComb =='false--false--true')
            {
                hasEmailOptOut = true;
            }
        }
        return hasEmailOptOut;
    }
}